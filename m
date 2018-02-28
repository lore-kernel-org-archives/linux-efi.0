From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 061/254] efi: Move some sysfs files to be read-only
 by root
Date: Wed, 28 Feb 2018 15:20:18 +0000
Message-ID: <lsq.1519831218.738032988@decadent.org.uk>
References: <lsq.1519831217.271785318@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1519831217.271785318@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Young <dyoung@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-efi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

3.16.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit af97a77bc01ce49a466f9d4c0125479e2e2230b6 upstream.

Thanks to the scripts/leaking_addresses.pl script, it was found that
some EFI values should not be readable by non-root users.

So make them root-only, and to do that, add a __ATTR_RO_MODE() macro to
make this easier, and use it in other places at the same time.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20171206095010.24170-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: drop changes in esrt.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -72,8 +72,7 @@ static ssize_t systab_show(struct kobjec
 	return str - buf;
 }
 
-static struct kobj_attribute efi_attr_systab =
-			__ATTR(systab, 0400, systab_show, NULL);
+static struct kobj_attribute efi_attr_systab = __ATTR_RO_MODE(systab, 0400);
 
 #define EFI_FIELD(var) efi.var
 
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -67,11 +67,11 @@ static ssize_t map_attr_show(struct kobj
 	return map_attr->show(entry, buf);
 }
 
-static struct map_attribute map_type_attr = __ATTR_RO(type);
-static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
-static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
-static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
-static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
+static struct map_attribute map_type_attr = __ATTR_RO_MODE(type, 0400);
+static struct map_attribute map_phys_addr_attr = __ATTR_RO_MODE(phys_addr, 0400);
+static struct map_attribute map_virt_addr_attr = __ATTR_RO_MODE(virt_addr, 0400);
+static struct map_attribute map_num_pages_attr = __ATTR_RO_MODE(num_pages, 0400);
+static struct map_attribute map_attribute_attr = __ATTR_RO_MODE(attribute, 0400);
 
 /*
  * These are default attributes that are added for every memmap entry.
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -82,6 +82,12 @@ struct attribute_group {
 	.show	= _name##_show,						\
 }
 
+#define __ATTR_RO_MODE(_name, _mode) {					\
+	.attr	= { .name = __stringify(_name),				\
+		    .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
+	.show	= _name##_show,						\
+}
+
 #define __ATTR_WO(_name) {						\
 	.attr	= { .name = __stringify(_name), .mode = S_IWUSR },	\
 	.store	= _name##_store,					\
