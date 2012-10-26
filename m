From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 08/20] x86-64/efi: Use EFI to deal with platform wall clock (again)
Date: Fri, 26 Oct 2012 08:51:51 +0100
Message-ID: <1351237923-10313-9-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "[added commit history]"@arkanian.console-pimps.org
List-Id: linux-efi@vger.kernel.org

From: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>

Other than ix86, x86-64 on EFI so far didn't set the
{g,s}et_wallclock accessors to the EFI routines, thus
incorrectly using raw RTC accesses instead.

Simply removing the #ifdef around the respective code isn't
enough, however: While so far early get-time calls were done in
physical mode, this doesn't work properly for x86-64, as virtual
addresses would still need to be set up for all runtime regions
(which wasn't the case on the system I have access to), so
instead the patch moves the call to efi_enter_virtual_mode()
ahead (which in turn allows to drop all code related to calling
efi-get-time in physical mode).

Additionally the earlier calling of efi_set_executable()
requires the CPA code to cope, i.e. during early boot it must be
avoided to call cpa_flush_array(), as the first thing this
function does is a BUG_ON(irqs_disabled()).

Also make the two EFI functions in question here static -
they're not being referenced elsewhere.

History:

    This commit was originally merged as bacef661acdb ("x86-64/efi:
    Use EFI to deal with platform wall clock") but it resulted in some
    ASUS machines no longer booting due to a firmware bug, and so was
    reverted in f026cfa82f62. A pre-emptive fix for the buggy ASUS
    firmware was merged in 03a1c254975e ("x86, efi: 1:1 pagetable
    mapping for virtual EFI calls") so now this patch can be
    reapplied.

Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
Tested-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [added commit history]
---
 arch/x86/mm/pageattr.c      | 10 ++++++----
 arch/x86/platform/efi/efi.c | 30 ++++--------------------------
 include/linux/efi.h         |  2 --
 init/main.c                 |  8 ++++----
 4 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a718e0d..931930a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -919,11 +919,13 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it and in the
-	 * error case we fall back to cpa_flush_all (which uses
-	 * wbindv):
+	 * avoid the wbindv. If the CPU does not support it, in the
+	 * error case, and during early boot (for EFI) we fall back
+	 * to cpa_flush_all (which uses wbinvd):
 	 */
-	if (!ret && cpu_has_clflush) {
+	if (early_boot_irqs_disabled)
+		__cpa_flush_all((void *)(long)cache);
+	else if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 			cpa_flush_array(addr, numpages, cache,
 					cpa.flags, pages);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index aded2a9..7578344 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -235,22 +235,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
-					     efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
-				virt_to_phys(tc));
-	efi_call_phys_epilog();
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-int efi_set_rtc_mmss(unsigned long nowtime)
+static int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
 	efi_status_t 	status;
@@ -279,7 +264,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 	return 0;
 }
 
-unsigned long efi_get_time(void)
+static unsigned long efi_get_time(void)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -635,18 +620,13 @@ static int __init efi_runtime_init(void)
 	}
 	/*
 	 * We will only need *early* access to the following
-	 * two EFI runtime services before set_virtual_address_map
+	 * EFI runtime service before set_virtual_address_map
 	 * is invoked.
 	 */
-	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
 	efi_phys.set_virtual_address_map =
 		(efi_set_virtual_address_map_t *)
 		runtime->set_virtual_address_map;
-	/*
-	 * Make efi_get_time can be called before entering
-	 * virtual mode.
-	 */
-	efi.get_time = phys_efi_get_time;
+
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
@@ -734,12 +714,10 @@ void __init efi_init(void)
 		efi_enabled = 0;
 		return;
 	}
-#ifdef CONFIG_X86_32
 	if (efi_native) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
-#endif
 
 #if EFI_DEBUG
 	print_efi_memmap();
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 337aefb..5e2308d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -516,8 +516,6 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern unsigned long efi_get_time(void);
-extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
diff --git a/init/main.c b/init/main.c
index 9cf77ab..ae70b64 100644
--- a/init/main.c
+++ b/init/main.c
@@ -461,6 +461,10 @@ static void __init mm_init(void)
 	percpu_init_late();
 	pgtable_cache_init();
 	vmalloc_init();
+#ifdef CONFIG_X86
+	if (efi_enabled)
+		efi_enter_virtual_mode();
+#endif
 }
 
 asmlinkage void __init start_kernel(void)
@@ -601,10 +605,6 @@ asmlinkage void __init start_kernel(void)
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
-#ifdef CONFIG_X86
-	if (efi_enabled)
-		efi_enter_virtual_mode();
-#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);
-- 
1.7.11.7
