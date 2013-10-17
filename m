From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 1/2] efi: Add asm-generic/efi.h for non-x86
Date: Thu, 17 Oct 2013 13:19:14 +0100
Message-ID: <1382012355-8846-2-git-send-email-matt@console-pimps.org>
References: <1382012355-8846-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382012355-8846-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>From the #ifdef CONFIG_X86 in linux/efi.h it's clear we need a place to
declare functions that are implemented differently for each
architecture.

Since it's only x86 that needs to do special things, add a generic EFI
header file that can be used by everyone else and move the x86-specific
stuff to arch/x86/include/asm/efi.h.

Because the asm files are now included from linux/efi.h directly, this
change means we no longer have to include the asm file explicitly from C
files, allowing us to delete quite a few #include lines.

Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/ia64/include/asm/efi.h      |  6 ++++++
 arch/x86/boot/compressed/eboot.c |  1 -
 arch/x86/include/asm/efi.h       | 10 ++++++++++
 arch/x86/kernel/setup.c          |  1 -
 arch/x86/platform/efi/efi.c      |  1 -
 arch/x86/platform/efi/efi_32.c   |  1 -
 arch/x86/platform/efi/efi_64.c   |  1 -
 arch/x86/platform/uv/bios_uv.c   |  1 -
 include/asm-generic/efi.h        | 17 +++++++++++++++++
 include/linux/efi.h              | 31 ++-----------------------------
 10 files changed, 35 insertions(+), 35 deletions(-)
 create mode 100644 arch/ia64/include/asm/efi.h
 create mode 100644 include/asm-generic/efi.h

diff --git a/arch/ia64/include/asm/efi.h b/arch/ia64/include/asm/efi.h
new file mode 100644
index 0000000..7b69db7
--- /dev/null
+++ b/arch/ia64/include/asm/efi.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_EFI_H
+#define _ASM_EFI_H
+
+#include <asm-generic/efi.h>
+
+#endif /* _ASM_EFI_H */
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..d6eb766 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -9,7 +9,6 @@
 
 #include <linux/efi.h>
 #include <linux/pci.h>
-#include <asm/efi.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0062a01..4c8f5c2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -101,9 +101,14 @@ extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
+extern void efi_late_init(void);
+extern void efi_free_boot_services(void);
+extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
 
 #ifdef CONFIG_EFI
 
+extern int efi_enabled(int facility);
+
 static inline bool efi_is_native(void)
 {
 	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
@@ -120,6 +125,11 @@ static inline bool efi_is_native(void)
 #define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
 #define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
+
+static inline int efi_enabled(int facility)
+{
+	return 0;
+}
 #endif /* CONFIG_EFI */
 
 #endif /* _ASM_X86_EFI_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..415e51b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -78,7 +78,6 @@
 #include <asm/e820.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
-#include <asm/efi.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/sections.h>
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..4fce62a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -44,7 +44,6 @@
 #include <linux/bcd.h>
 
 #include <asm/setup.h>
-#include <asm/efi.h>
 #include <asm/time.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 40e4469..108a825 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -29,7 +29,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
-#include <asm/efi.h>
 
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 39a0e7f..de26614 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -35,7 +35,6 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
-#include <asm/efi.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 
diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 7666121..f3b1fa1 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -21,7 +21,6 @@
 
 #include <linux/efi.h>
 #include <linux/export.h>
-#include <asm/efi.h>
 #include <linux/io.h>
 #include <asm/uv/bios.h>
 #include <asm/uv/uv_hub.h>
diff --git a/include/asm-generic/efi.h b/include/asm-generic/efi.h
new file mode 100644
index 0000000..8a31713
--- /dev/null
+++ b/include/asm-generic/efi.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_GENERIC_EFI_H
+#define _ASM_GENERIC_EFI_H
+
+static inline void efi_late_init(void) {}
+static inline void efi_free_boot_services(void) {}
+
+static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+{
+	return EFI_SUCCESS;
+}
+
+static inline int efi_enabled(int facility)
+{
+	return IS_ENABLED(CONFIG_EFI);
+}
+
+#endif /* _ASM_GENERIC_EFI_H */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..ced7644 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -573,19 +573,6 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
-#ifdef CONFIG_X86
-extern void efi_late_init(void);
-extern void efi_free_boot_services(void);
-extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
-#else
-static inline void efi_late_init(void) {}
-static inline void efi_free_boot_services(void) {}
-
-static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
-{
-	return EFI_SUCCESS;
-}
-#endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
@@ -635,22 +622,6 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
-#ifdef CONFIG_EFI
-# ifdef CONFIG_X86
-extern int efi_enabled(int facility);
-# else
-static inline int efi_enabled(int facility)
-{
-	return 1;
-}
-# endif
-#else
-static inline int efi_enabled(int facility)
-{
-	return 0;
-}
-#endif
-
 /*
  * Variable Attributes
  */
@@ -842,4 +813,6 @@ int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
+#include <asm/efi.h>
+
 #endif /* _LINUX_EFI_H */
-- 
1.8.1.4
