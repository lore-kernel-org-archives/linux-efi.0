From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/9] efi: Add an EFI signature blob parser
Date: Wed, 16 Nov 2016 18:11:35 +0000
Message-ID: <147931989504.16460.12600922180901894184.stgit@warthog.procyon.org.uk>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Dave Howells <dhowells@redhat.com>

Add a function to parse an EFI signature blob looking for elements of
interest.  A list is made up of a series of sublists, where all the
elements in a sublist are of the same type, but sublists can be of
different types.

For each sublist encountered, the function pointed to by the
get_handler_for_guid argument is called with the type specifier GUID and
returns either a pointer to a function to handle elements of that type or
NULL if the type is not of interest.

If the sublist is of interest, each element is passed to the handler
function in turn.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 certs/Kconfig       |    8 ++++
 certs/Makefile      |    1 
 certs/efi_parser.c  |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h |    9 ++++
 4 files changed, 130 insertions(+)
 create mode 100644 certs/efi_parser.c

diff --git a/certs/Kconfig b/certs/Kconfig
index 6ce51ede9e9b..630ae09bbea2 100644
--- a/certs/Kconfig
+++ b/certs/Kconfig
@@ -82,4 +82,12 @@ config SYSTEM_BLACKLIST_HASH_LIST
 	  wrapper to incorporate the list into the kernel.  Each <hash> should
 	  be a string of hex digits.
 
+config EFI_SIGNATURE_LIST_PARSER
+	bool "EFI signature list parser"
+	depends on EFI
+	select X509_CERTIFICATE_PARSER
+	help
+	  This option provides support for parsing EFI signature lists for
+	  X.509 certificates and turning them into keys.
+
 endmenu
diff --git a/certs/Makefile b/certs/Makefile
index 4119bb376ea1..738151ac76af 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_hashes.o
 else
 obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_nohashes.o
 endif
+obj-$(CONFIG_EFI_SIGNATURE_LIST_PARSER) += efi_parser.o
 
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
 
diff --git a/certs/efi_parser.c b/certs/efi_parser.c
new file mode 100644
index 000000000000..4e396f98f5c7
--- /dev/null
+++ b/certs/efi_parser.c
@@ -0,0 +1,112 @@
+/* EFI signature/key/certificate list parser
+ *
+ * Copyright (C) 2012, 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "EFI: "fmt
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/err.h>
+#include <linux/efi.h>
+
+/**
+ * parse_efi_signature_list - Parse an EFI signature list for certificates
+ * @source: The source of the key
+ * @data: The data blob to parse
+ * @size: The size of the data blob
+ * @get_handler_for_guid: Get the handler func for the sig type (or NULL)
+ *
+ * Parse an EFI signature list looking for elements of interest.  A list is
+ * made up of a series of sublists, where all the elements in a sublist are of
+ * the same type, but sublists can be of different types.
+ *
+ * For each sublist encountered, the @get_handler_for_guid function is called
+ * with the type specifier GUID and returns either a pointer to a function to
+ * handle elements of that type or NULL if the type is not of interest.
+ *
+ * If the sublist is of interest, each element is passed to the handler
+ * function in turn.
+ *
+ * Error EBADMSG is returned if the list doesn't parse correctly and 0 is
+ * returned if the list was parsed correctly.  No error can be returned from
+ * the @get_handler_for_guid function or the element handler function it
+ * returns.
+ */
+int __init parse_efi_signature_list(
+	const char *source,
+	const void *data, size_t size,
+	efi_element_handler_t (*get_handler_for_guid)(const efi_guid_t *))
+{
+	efi_element_handler_t handler;
+	unsigned offs = 0;
+
+	pr_devel("-->%s(,%zu)\n", __func__, size);
+
+	while (size > 0) {
+		const efi_signature_data_t *elem;
+		efi_signature_list_t list;
+		size_t lsize, esize, hsize, elsize;
+
+		if (size < sizeof(list))
+			return -EBADMSG;
+
+		memcpy(&list, data, sizeof(list));
+		pr_devel("LIST[%04x] guid=%pUl ls=%x hs=%x ss=%x\n",
+			 offs,
+			 list.signature_type.b, list.signature_list_size,
+			 list.signature_header_size, list.signature_size);
+
+		lsize = list.signature_list_size;
+		hsize = list.signature_header_size;
+		esize = list.signature_size;
+		elsize = lsize - sizeof(list) - hsize;
+
+		if (lsize > size) {
+			pr_devel("<--%s() = -EBADMSG [overrun @%x]\n",
+				 __func__, offs);
+			return -EBADMSG;
+		}
+
+		if (lsize < sizeof(list) ||
+		    lsize - sizeof(list) < hsize ||
+		    esize < sizeof(*elem) ||
+		    elsize < esize ||
+		    elsize % esize != 0) {
+			pr_devel("- bad size combo @%x\n", offs);
+			return -EBADMSG;
+		}
+
+		handler = get_handler_for_guid(&list.signature_type);
+		if (!handler) {
+			data += lsize;
+			size -= lsize;
+			offs += lsize;
+			continue;
+		}
+
+		data += sizeof(list) + hsize;
+		size -= sizeof(list) + hsize;
+		offs += sizeof(list) + hsize;
+
+		for (; elsize > 0; elsize -= esize) {
+			elem = data;
+
+			pr_devel("ELEM[%04x]\n", offs);
+			handler(source,
+				&elem->signature_data,
+				esize - sizeof(*elem));
+
+			data += esize;
+			size -= esize;
+			offs += esize;
+		}
+	}
+
+	return 0;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6fb50bafedc7..11372fb8784c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1032,6 +1032,15 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 char * __init efi_md_typeattr_format(char *buf, size_t size,
 				     const efi_memory_desc_t *md);
 
+
+typedef void (*efi_element_handler_t)(const char *source,
+				      const void *element_data,
+				      size_t element_size);
+extern int __init parse_efi_signature_list(
+	const char *source,
+	const void *data, size_t size,
+	efi_element_handler_t (*get_handler_for_guid)(const efi_guid_t *));
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address

