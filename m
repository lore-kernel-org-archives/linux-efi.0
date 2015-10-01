From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/9] ARM: add support for generic early_ioremap/early_memremap
Date: Thu,  1 Oct 2015 19:04:17 +0200
Message-ID: <1443719063-6832-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443719063-6832-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This enables the generic early_ioremap implementation for ARM.

It uses the fixmap region reserved for kmap. Since early_ioremap
is only supported before paging_init(), and kmap is only supported
afterwards, this is guaranteed not to cause any clashes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/Kconfig              |  1 +
 arch/arm/include/asm/Kbuild   |  1 +
 arch/arm/include/asm/fixmap.h | 28 +++++++++++++++++++-
 arch/arm/kernel/setup.c       |  7 +++--
 arch/arm/mm/ioremap.c         |  9 +++++++
 arch/arm/mm/mmu.c             |  2 +-
 6 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 72ad724c67ae..e4b7d6cfd8eb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -20,6 +20,7 @@ config ARM
 	select GENERIC_ALLOCATOR
 	select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
+	select GENERIC_EARLY_IOREMAP
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index be648eb47cd9..4ea9642af500 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -3,6 +3,7 @@
 generic-y += bitsperlong.h
 generic-y += cputime.h
 generic-y += current.h
+generic-y += early_ioremap.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 58cfe9f1a687..defac13e161a 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -19,9 +19,26 @@ enum fixed_addresses {
 	FIX_TEXT_POKE0,
 	FIX_TEXT_POKE1,
 
-	__end_of_fixed_addresses
+	__end_of_fixmap_region,
+
+	/*
+	 * Share the kmap() region with early_ioremap(): this is guaranteed
+	 * not to clash since early_ioremap() is only available before
+	 * paging_init(), and kmap() only after.
+	 */
+#define NR_FIX_BTMAPS		32
+#define FIX_BTMAPS_SLOTS	7
+#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
+
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
+	__end_of_early_ioremap_region
 };
 
+static const enum fixed_addresses __end_of_fixed_addresses =
+	__end_of_fixmap_region > __end_of_early_ioremap_region ?
+	__end_of_fixmap_region : __end_of_early_ioremap_region;
+
 #define FIXMAP_PAGE_COMMON	(L_PTE_YOUNG | L_PTE_PRESENT | L_PTE_XN | L_PTE_DIRTY)
 
 #define FIXMAP_PAGE_NORMAL	(FIXMAP_PAGE_COMMON | L_PTE_MT_WRITEBACK)
@@ -30,9 +47,18 @@ enum fixed_addresses {
 #define FIXMAP_PAGE_IO		(FIXMAP_PAGE_COMMON | L_PTE_MT_DEV_SHARED | L_PTE_SHARED)
 #define FIXMAP_PAGE_NOCACHE	FIXMAP_PAGE_IO
 
+#define __early_set_fixmap	__set_fixmap
+
+#ifdef CONFIG_MMU
+
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 void __init early_fixmap_init(void);
 
 #include <asm-generic/fixmap.h>
 
+#else
+
+static inline void early_fixmap_init(void) { }
+
+#endif
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 20edd349d379..5df2bca57c42 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -38,6 +38,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
+#include <asm/early_ioremap.h>
 #include <asm/fixmap.h>
 #include <asm/procinfo.h>
 #include <asm/psci.h>
@@ -956,8 +957,8 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;
 
-	if (IS_ENABLED(CONFIG_FIX_EARLYCON_MEM))
-		early_fixmap_init();
+	early_fixmap_init();
+	early_ioremap_init();
 
 	parse_early_param();
 
@@ -968,6 +969,8 @@ void __init setup_arch(char **cmdline_p)
 	sanity_check_meminfo();
 	arm_memblock_init(mdesc);
 
+	early_ioremap_reset();
+
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 0c81056c1dd7..66a978d05958 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -30,6 +30,7 @@
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 #include <asm/cacheflush.h>
+#include <asm/early_ioremap.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -469,3 +470,11 @@ int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr)
 }
 EXPORT_SYMBOL_GPL(pci_ioremap_io);
 #endif
+
+/*
+ * Must be called after early_fixmap_init
+ */
+void __init early_ioremap_init(void)
+{
+	early_ioremap_setup();
+}
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 7cd15143a507..b74686be6272 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -389,7 +389,7 @@ void __init early_fixmap_init(void)
 	 * The early fixmap range spans multiple pmds, for which
 	 * we are not prepared:
 	 */
-	BUILD_BUG_ON((__fix_to_virt(__end_of_permanent_fixed_addresses) >> PMD_SHIFT)
+	BUILD_BUG_ON((__fix_to_virt(__end_of_early_ioremap_region) >> PMD_SHIFT)
 		     != FIXADDR_TOP >> PMD_SHIFT);
 
 	pmd = fixmap_pmd(FIXADDR_TOP);
-- 
1.9.1
