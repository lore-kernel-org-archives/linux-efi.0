From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/9] KEYS: Add a system blacklist keyring
Date: Wed, 16 Nov 2016 18:10:52 +0000
Message-ID: <147931985230.16460.13945858707013323506.stgit@warthog.procyon.org.uk>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Add the following:

 (1) A new system keyring that is used to store information about
     blacklisted certificates and signatures.

 (2) A new key type (called 'blacklist') that is used to store a
     blacklisted hash in its description as a hex string.  The key accepts
     no payload.

 (3) The ability to configure a list of blacklisted hashes into the kernel
     at build time.  This is done by setting
     CONFIG_SYSTEM_BLACKLIST_HASH_LIST to the filename of a list of hashes
     that are in the form:

	"<hash>", "<hash>", ..., "<hash>"

     where each <hash> is a hex string representation of the hash and must
     include all necessary leading zeros to pad the hash to the right size.

The above are enabled with CONFIG_SYSTEM_BLACKLIST_KEYRING.

Once the kernel is booted, the blacklist keyring can be listed:

	root@andromeda ~]# keyctl show %:.blacklist
	Keyring
	 723359729 ---lswrv      0     0  keyring: .blacklist
	 676257228 ---lswrv      0     0   \_ blacklist: 123412341234c55c1dcc601ab8e172917706aa32fb5eaf826813547fdf02dd46

The blacklist cannot currently be modified by userspace, but it will be
possible to load it, for example, from the UEFI blacklist database.

A later commit will make it possible to load blacklisted asymmetric keys in
here too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 certs/Kconfig                 |   18 ++++
 certs/Makefile                |    6 +
 certs/blacklist.c             |  174 +++++++++++++++++++++++++++++++++++++++++
 certs/blacklist.h             |    3 +
 certs/blacklist_hashes.c      |    6 +
 certs/blacklist_nohashes.c    |    5 +
 include/keys/system_keyring.h |   12 +++
 7 files changed, 224 insertions(+)
 create mode 100644 certs/blacklist.c
 create mode 100644 certs/blacklist.h
 create mode 100644 certs/blacklist_hashes.c
 create mode 100644 certs/blacklist_nohashes.c

diff --git a/certs/Kconfig b/certs/Kconfig
index fc5955f5fc8a..6ce51ede9e9b 100644
--- a/certs/Kconfig
+++ b/certs/Kconfig
@@ -64,4 +64,22 @@ config SECONDARY_TRUSTED_KEYRING
 	  those keys are not blacklisted and are vouched for by a key built
 	  into the kernel or already in the secondary trusted keyring.
 
+config SYSTEM_BLACKLIST_KEYRING
+	bool "Provide system-wide ring of blacklisted keys"
+	depends on KEYS
+	help
+	  Provide a system keyring to which blacklisted keys can be added.
+	  Keys in the keyring are considered entirely untrusted.  Keys in this
+	  keyring are used by the module signature checking to reject loading
+	  of modules signed with a blacklisted key.
+
+config SYSTEM_BLACKLIST_HASH_LIST
+	string "Hashes to be preloaded into the system blacklist keyring"
+	depends on SYSTEM_BLACKLIST_KEYRING
+	help
+	  If set, this option should be the filename of a list of hashes in the
+	  form "<hash>", "<hash>", ... .  This will be included into a C
+	  wrapper to incorporate the list into the kernel.  Each <hash> should
+	  be a string of hex digits.
+
 endmenu
diff --git a/certs/Makefile b/certs/Makefile
index 2773c4afa24c..4119bb376ea1 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -3,6 +3,12 @@
 #
 
 obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
+obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist.o
+ifneq ($(CONFIG_SYSTEM_BLACKLIST_HASH_LIST),"")
+obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_hashes.o
+else
+obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_nohashes.o
+endif
 
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
 
diff --git a/certs/blacklist.c b/certs/blacklist.c
new file mode 100644
index 000000000000..3eddce0e307a
--- /dev/null
+++ b/certs/blacklist.c
@@ -0,0 +1,174 @@
+/* System hash blacklist.
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "blacklist: "fmt
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/key.h>
+#include <linux/key-type.h>
+#include <linux/sched.h>
+#include <linux/ctype.h>
+#include <linux/err.h>
+#include <linux/seq_file.h>
+#include <keys/system_keyring.h>
+#include "blacklist.h"
+
+static struct key *blacklist_keyring;
+
+/*
+ * The description must be a type prefix, a colon and then an even number of
+ * hex digits.  The hash is kept in the description.
+ */
+static int blacklist_vet_description(const char *desc)
+{
+	int n = 0;
+
+	if (*desc == ':')
+		return -EINVAL;
+	for (; *desc; desc++)
+		if (*desc == ':')
+			goto found_colon;
+	return -EINVAL;
+
+found_colon:
+	desc++;
+	for (; *desc; desc++) {
+		if (!isxdigit(*desc))
+			return -EINVAL;
+		n++;
+	}
+
+	if (n == 0 || n & 1)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * The hash to be blacklisted is expected to be in the description.  There will
+ * be no payload.
+ */
+static int blacklist_preparse(struct key_preparsed_payload *prep)
+{
+	if (prep->datalen > 0)
+		return -EINVAL;
+	return 0;
+}
+
+static void blacklist_free_preparse(struct key_preparsed_payload *prep)
+{
+}
+
+static void blacklist_describe(const struct key *key, struct seq_file *m)
+{
+	seq_puts(m, key->description);
+}
+
+static struct key_type key_type_blacklist = {
+	.name			= "blacklist",
+	.vet_description	= blacklist_vet_description,
+	.preparse		= blacklist_preparse,
+	.free_preparse		= blacklist_free_preparse,
+	.instantiate		= generic_key_instantiate,
+	.describe		= blacklist_describe,
+};
+
+/**
+ * mark_hash_blacklisted - Add a hash to the system blacklist
+ * @hash - The hash as a hex string with a type prefix (eg. "tbs:23aa429783")
+ */
+int mark_hash_blacklisted(const char *hash)
+{
+	key_ref_t key;
+
+	key = key_create_or_update(make_key_ref(blacklist_keyring, true),
+				   "blacklist",
+				   hash,
+				   NULL,
+				   0,
+				   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				    KEY_USR_VIEW),
+				   KEY_ALLOC_NOT_IN_QUOTA |
+				   KEY_ALLOC_BUILT_IN);
+	if (IS_ERR(key)) {
+		pr_err("Problem blacklisting hash (%ld)\n", PTR_ERR(key));
+		return PTR_ERR(key);
+	}
+	return 0;
+}
+
+/**
+ * is_hash_blacklisted - Determine if a hash is blacklisted
+ * @hash: The hash to be checked as a binary blob
+ * @hash_len: The length of the binary hash
+ * @type: Type of hash
+ */
+int is_hash_blacklisted(const u8 *hash, size_t hash_len, const char *type)
+{
+	key_ref_t kref;
+	size_t type_len = strlen(type);
+	char *buffer, *p;
+	int ret = 0;
+
+	buffer = kmalloc(type_len + 1 + hash_len * 2 + 1, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	p = memcpy(buffer, type, type_len);
+	p += type_len;
+	*p++ = ':';
+	bin2hex(p, hash, hash_len);
+	p += hash_len * 2;
+	*p = 0;
+
+	kref = keyring_search(make_key_ref(blacklist_keyring, true),
+			      &key_type_blacklist, buffer);
+	if (!IS_ERR(kref)) {
+		key_ref_put(kref);
+		ret = -EKEYREJECTED;
+	}
+
+	kfree(buffer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(is_hash_blacklisted);
+
+/*
+ * Intialise the blacklist
+ */
+static int __init blacklist_init(void)
+{
+	const char *const *bl;
+
+	if (register_key_type(&key_type_blacklist) < 0)
+		panic("Can't allocate system blacklist key type\n");
+
+	blacklist_keyring =
+		keyring_alloc(".blacklist",
+			      KUIDT_INIT(0), KGIDT_INIT(0),
+			      current_cred(),
+			      (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			      KEY_USR_VIEW | KEY_USR_READ |
+			      KEY_USR_SEARCH,
+			      KEY_ALLOC_NOT_IN_QUOTA |
+			      KEY_FLAG_KEEP,
+			      NULL, NULL);
+	if (IS_ERR(blacklist_keyring))
+		panic("Can't allocate system blacklist keyring\n");
+
+	for (bl = blacklist_hashes; *bl; bl++)
+		if (mark_hash_blacklisted(*bl) < 0)
+			pr_err("- blacklisting failed\n");
+	return 0;
+}
+
+/*
+ * Must be initialised before we try and load the keys into the keyring.
+ */
+device_initcall(blacklist_init);
diff --git a/certs/blacklist.h b/certs/blacklist.h
new file mode 100644
index 000000000000..150d82da8e99
--- /dev/null
+++ b/certs/blacklist.h
@@ -0,0 +1,3 @@
+#include <linux/kernel.h>
+
+extern const char __initdata *const blacklist_hashes[];
diff --git a/certs/blacklist_hashes.c b/certs/blacklist_hashes.c
new file mode 100644
index 000000000000..5bd449f7db17
--- /dev/null
+++ b/certs/blacklist_hashes.c
@@ -0,0 +1,6 @@
+#include "blacklist.h"
+
+const char __initdata *const blacklist_hashes[] = {
+#include CONFIG_SYSTEM_BLACKLIST_HASH_LIST
+	, NULL
+};
diff --git a/certs/blacklist_nohashes.c b/certs/blacklist_nohashes.c
new file mode 100644
index 000000000000..851de10706a5
--- /dev/null
+++ b/certs/blacklist_nohashes.c
@@ -0,0 +1,5 @@
+#include "blacklist.h"
+
+const char __initdata *const blacklist_hashes[] = {
+	NULL
+};
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index fbd4647767e9..0d8762622ab9 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -33,6 +33,18 @@ extern int restrict_link_by_builtin_and_secondary_trusted(
 #define restrict_link_by_builtin_and_secondary_trusted restrict_link_by_builtin_trusted
 #endif
 
+#ifdef CONFIG_SYSTEM_BLACKLIST_KEYRING
+extern int mark_hash_blacklisted(const char *hash);
+extern int is_hash_blacklisted(const u8 *hash, size_t hash_len,
+			       const char *type);
+#else
+static inline int is_hash_blacklisted(const u8 *hash, size_t hash_len,
+				      const char *type)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_IMA_BLACKLIST_KEYRING
 extern struct key *ima_blacklist_keyring;
 
