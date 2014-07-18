From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/7] arm: break part of __soft_restart out into separate function
Date: Fri, 18 Jul 2014 15:00:47 +0100
Message-ID: <1405692053-7514-2-git-send-email-leif.lindholm@linaro.org>
References: <1405692053-7514-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405692053-7514-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Certain operations can be considered mandatory for any piece of code
preparing to switch off the MMU. Break this out into separate function
idmap_prepare().

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Suggested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm/include/asm/idmap.h |    1 +
 arch/arm/kernel/process.c    |   12 +-----------
 arch/arm/mm/idmap.c          |   15 +++++++++++++++
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/idmap.h b/arch/arm/include/asm/idmap.h
index bf863ed..2e914a8 100644
--- a/arch/arm/include/asm/idmap.h
+++ b/arch/arm/include/asm/idmap.h
@@ -10,5 +10,6 @@
 extern pgd_t *idmap_pgd;
 
 void setup_mm_for_reboot(void);
+void idmap_prepare(void);
 
 #endif	/* __ASM_IDMAP_H */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 81ef686..6849e13 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -75,17 +75,7 @@ static void __soft_restart(void *addr)
 {
 	phys_reset_t phys_reset;
 
-	/* Take out a flat memory mapping. */
-	setup_mm_for_reboot();
-
-	/* Clean and invalidate caches */
-	flush_cache_all();
-
-	/* Turn off caching */
-	cpu_proc_fin();
-
-	/* Push out any further dirty data, and ensure cache is empty */
-	flush_cache_all();
+	idmap_prepare();
 
 	/* Switch to the identity mapping. */
 	phys_reset = (phys_reset_t)(unsigned long)virt_to_phys(cpu_reset);
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 8e0e52e..5c85779 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -122,3 +122,18 @@ void setup_mm_for_reboot(void)
 	local_flush_tlb_all();
 #endif
 }
+
+void idmap_prepare(void)
+{
+	/* Take out a flat memory mapping. */
+	setup_mm_for_reboot();
+
+	/* Clean and invalidate caches */
+	flush_cache_all();
+
+	/* Turn off caching */
+	cpu_proc_fin();
+
+	/* Push out any further dirty data, and ensure cache is empty */
+	flush_cache_all();
+}
-- 
1.7.10.4
