From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init()
Date: Wed, 15 Jan 2014 15:25:48 +0800
Message-ID: <1389770748-32698-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Cc: Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a variant patch from Rafael J. Wysocki's
ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

According to Matt Fleming, if acpi_early_init() was executed before
efi_enter_virtual_mode(), the EFI initialization could benefit from
it, so Rafael's patch makes that happen.

And, we want accessing ACPI TAD device to set system clock, so move
acpi_early_init() before timekeeping_init(). This final position is
also before efi_enter_virtual_mode().

v2:
Move acpi_early_init() before timekeeping_init() to prepare setting
system clock with ACPI TAD.

v1:
Rafael J. Wysocki
ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

Cc: Rafael J. Wysocki <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index febc511..b6d93c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
 	init_timers();
 	hrtimers_init();
 	softirq_init();
+	acpi_early_init();
 	timekeeping_init();
 	time_init();
 	sched_clock_postinit();
@@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
 
 	check_bugs();
 
-	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-- 
1.6.4.2
