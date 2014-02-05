From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 01/22] arm: break part of __soft_restart out into separate function
Date: Wed,  5 Feb 2014 17:03:52 +0000
Message-ID: <1391619853-10601-2-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

Certain operations can be considered mandatory for any piece of code
preparing to switch off the MMU. Break this out into separate function
idmap_prepare().

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Suggested-by: Will Deacon <will.deacon@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
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
index 92f7b15..91b4cec 100644
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
