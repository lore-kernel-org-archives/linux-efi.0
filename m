From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] x86, efi: remove duplicate code in setup_arch() by using,
 efi_is_native()
Date: Thu, 14 Feb 2013 09:07:35 +0900
Message-ID: <511C2AC7.1080105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux x86 ml <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux EFI ml <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

The check, "IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)",
in setup_arch() can be replaced by efi_is_enabled(). This change
remove duplicate code and improve readability.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/efi.h  |    9 ++++++++-
 arch/x86/kernel/setup.c     |    3 +--
 arch/x86/platform/efi/efi.c |    5 -----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 28677c5..60c89f3 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -102,7 +102,14 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 
-#ifndef CONFIG_EFI
+#ifdef CONFIG_EFI
+
+static inline bool efi_is_native(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
+}
+
+#else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
  */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8b24289..1abb796 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1135,8 +1135,7 @@ void __init setup_arch(char **cmdline_p)
 	 * mismatched firmware/kernel archtectures since there is no
 	 * support for runtime services.
 	 */
-	if (efi_enabled(EFI_BOOT) &&
-	    IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)) {
+	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 928bf83..eb9faeb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -69,11 +69,6 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-static inline bool efi_is_native(void)
-{
-	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
-}
-
 unsigned long x86_efi_facility;
 
 /*
-- 1.7.10.4 
