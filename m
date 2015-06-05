From: Peter Jones <pjones@redhat.com>
Subject: [PATCH] efi: Work around ia64 build problem with ESRT driver.
Date: Fri,  5 Jun 2015 14:54:35 -0400
Message-ID: <1433530475-23814-1-git-send-email-pjones@redhat.com>
References: <20150605171115.GA22534@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150605171115.GA22534@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

So, I'm told this problem exists in the world:
----------------------------------------------
Subject: Build error in -next due to 'efi: Add esrt support'

Building ia64:defconfig ... failed
--------------
Error log:

drivers/firmware/efi/esrt.c:28:31: fatal error: asm/early_ioremap.h: No
such file or directory
----------------------------------------------

I'm not really sure how it's okay that we have things in asm-generic on
some platforms but not others - is having it the same everywhere not the
whole point of asm-generic?

That said, ia64 doesn't have early-ioremap.h .  So instead, since it's
difficult to imagine new IA64 machines with UEFI 2.5, just don't build
this code there.

To me this looks like a workaround - doing something like:

generic-y += early_ioremap.h

in arch/ia64/include/asm/Kbuild would appear to be more correct, but
ia64 has its own early_memremap() decl in arch/ia64/include/asm/io.h ,
and it's a macro.  So adding the above /and/ requiring that asm/io.h be
included /after/ asm/early_ioremap.h in all cases would fix it, but
that's pretty ugly as well.  Since I'm not going to spend the rest of my
life rectifying ia64 headers vs "generic" headers that aren't generic,
it's much simpler to just not build there.

Note that I've only actually tried to build this patch on x86_64, but
esrt.o still gets built there, and that would seem to demonstrate that
the conditional building is working correctly at all the places the code
built before.  I no longer have any ia64 machines handy to test that the
exclusion actually works there.

Signed-off-by: Peter Jones <pjones@redhat.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 drivers/firmware/efi/Kconfig  | 5 +++++
 drivers/firmware/efi/Makefile | 3 ++-
 include/linux/efi.h           | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 8de4da5..2272ff0 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -18,6 +18,11 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://github.com/vathpela/efibootmgr>
 
+config EFI_ESRT
+	bool
+	depends on EFI && !IA64
+	default true
+
 config EFI_VARS_PSTORE
 	tristate "Register efivars backend for pstore"
 	depends on EFI_VARS && PSTORE
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 26eabbc..6fd3da9 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,8 +1,9 @@
 #
 # Makefile for linux kernel
 #
-obj-$(CONFIG_EFI)			+= efi.o esrt.o vars.o reboot.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
+obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 024c27e..2092965 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -879,7 +879,11 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
+#ifdef CONFIG_EFI_ESRT
 extern void __init efi_esrt_init(void);
+#else
+static inline void efi_esrt_init(void) { }
+#endif
 extern int efi_config_parse_tables(void *config_tables, int count, int sz,
 				   efi_config_table_type_t *arch_tables);
 extern u64 efi_get_iobase (void);
-- 
2.4.2
