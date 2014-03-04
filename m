From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] efi: Quirk out SGI UV
Date: Tue,  4 Mar 2014 17:02:17 +0100
Message-ID: <1393948937-21840-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Getting this thing to work with the new mapping scheme would need more
work.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     | 10 ++--------
 arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index e985d6bf7d3a..86d1fd4bf24c 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -135,6 +135,7 @@ extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
 extern void __init efi_dump_pagetable(void);
+extern void __init efi_apply_memmap_quirks(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 830ae2d95450..09c76d265550 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1238,14 +1238,8 @@ void __init setup_arch(char **cmdline_p)
 	register_refined_jiffies(CLOCK_TICK_RATE);
 
 #ifdef CONFIG_EFI
-	/* Once setup is done above, unmap the EFI memory map on
-	 * mismatched firmware/kernel archtectures since there is no
-	 * support for runtime services.
-	 */
-	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
-		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
-		efi_unmap_memmap();
-	}
+	if (efi_enabled(EFI_BOOT))
+		efi_apply_memmap_quirks();
 #endif
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 482986c3afc5..518aa8540a6d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -52,6 +52,7 @@
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
+#include <asm/uv/uv.h>
 
 #define EFI_DEBUG
 
@@ -1298,3 +1299,22 @@ static int __init parse_efi_cmdline(char *str)
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
+
+void __init efi_apply_memmap_quirks(void)
+{
+	/*
+	 * Once setup is done earlier, unmap the EFI memory map on mismatched
+	 * firmware/kernel architectures since there is no support for runtime
+	 * services.
+	 */
+	if (!efi_is_native()) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_unmap_memmap();
+	}
+
+	/*
+	 * UV doesn't support the new EFI pagetable mapping yet.
+	 */
+	if (is_uv_system())
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
+}
-- 
1.9.0
