From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 8/9] ARM: wire up UEFI init and runtime support
Date: Thu,  1 Oct 2015 19:04:22 +0200
Message-ID: <1443719063-6832-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, linux@arm.linux.org.uk, will.deacon@arm.com, grant.likely@linaro.org, leif.lindholm@linaro.org, roy.franz@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com
Cc: ryan.harkin@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

This adds support to the kernel proper for booting via UEFI. It shares
most of the code with arm64, so this patch mostly just wires it up for
use with ARM.

Note that this does not include the EFI stub, it is added in a subsequent
patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/efi.h              | 69 +++++++++++++++++++
 arch/arm/kernel/Makefile                |  1 +
 arch/arm/kernel/devtree.c               |  4 ++
 arch/arm/kernel/efi.c                   | 71 ++++++++++++++++++++
 arch/arm/kernel/setup.c                 |  3 +
 arch/arm/mm/init.c                      | 14 +++-
 drivers/firmware/efi/libstub/arm-stub.c |  4 +-
 7 files changed, 164 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
new file mode 100644
index 000000000000..2622322f1135
--- /dev/null
+++ b/arch/arm/include/asm/efi.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARM_EFI_H
+#define __ASM_ARM_EFI_H
+
+#include <asm/cacheflush.h>
+#include <asm/cachetype.h>
+#include <asm/early_ioremap.h>
+#include <asm/fixmap.h>
+#include <asm/highmem.h>
+#include <asm/mach/map.h>
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
+
+#ifdef CONFIG_EFI
+void efi_init(void);
+void efi_parse_fdt(void *fdt);
+
+int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
+
+#define efi_call_virt(f, ...)						\
+({									\
+	efi_##f##_t *__f;						\
+	efi_status_t __s;						\
+									\
+	efi_virtmap_load();						\
+	__f = efi.systab->runtime->f;					\
+	__s = __f(__VA_ARGS__);						\
+	efi_virtmap_unload();						\
+	__s;								\
+})
+
+#define __efi_call_virt(f, ...)						\
+({									\
+	efi_##f##_t *__f;						\
+									\
+	efi_virtmap_load();						\
+	__f = efi.systab->runtime->f;					\
+	__f(__VA_ARGS__);						\
+	efi_virtmap_unload();						\
+})
+
+static inline void efi_set_pgd(struct mm_struct *mm)
+{
+	if (unlikely(mm->context.vmalloc_seq != init_mm.context.vmalloc_seq))
+		__check_vmalloc_seq(mm);
+
+	cpu_switch_mm(mm->pgd, mm);
+
+	flush_tlb_all();
+	if (icache_is_vivt_asid_tagged())
+		__flush_icache_all();
+}
+
+void efi_virtmap_load(void);
+void efi_virtmap_unload(void);
+
+#else
+#define efi_init()
+#define efi_parse_fdt(x)
+#endif /* CONFIG_EFI */
+
+#endif /* _ASM_ARM_EFI_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index af9e59bf3831..c90f4a70d646 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -77,6 +77,7 @@ CFLAGS_pj4-cp0.o		:= -marm
 AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
 obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
 obj-$(CONFIG_VDSO)		+= vdso.o
+obj-$(CONFIG_EFI)		+= efi.o
 
 ifneq ($(CONFIG_ARCH_EBSA110),y)
   obj-y		+= io.o
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 11c54de9f8cf..c3439eaf46ce 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/efi.h>
 #include <linux/export.h>
 #include <linux/errno.h>
 #include <linux/types.h>
@@ -21,6 +22,7 @@
 #include <linux/smp.h>
 
 #include <asm/cputype.h>
+#include <asm/efi.h>
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/smp_plat.h>
@@ -215,6 +217,8 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 	if (!dt_phys || !early_init_dt_verify(phys_to_virt(dt_phys)))
 		return NULL;
 
+	efi_parse_fdt(phys_to_virt(dt_phys));
+
 	mdesc = of_flat_dt_match_machine(mdesc_best, arch_get_next_mach);
 
 	if (!mdesc) {
diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
new file mode 100644
index 000000000000..ef4dab987da5
--- /dev/null
+++ b/arch/arm/kernel/efi.c
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <asm/efi.h>
+#include <asm/mach/map.h>
+#include <asm/mmu_context.h>
+
+static int set_efi_permissions(pte_t *ptep, pgtable_t token, unsigned long addr,
+			       void *data)
+{
+	pteval_t *prot_val = data;
+	pte_t pte = *ptep;
+
+	pte = set_pte_bit(pte, __pgprot(*prot_val));
+	set_pte_ext(ptep, pte, 0);
+	return 0;
+}
+
+int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
+{
+	struct map_desc desc = {
+		.virtual	= md->virt_addr,
+		.pfn		= __phys_to_pfn(md->phys_addr),
+		.length		= md->num_pages * EFI_PAGE_SIZE,
+	};
+	pteval_t prot_val = 0;
+	int ret = 0;
+
+	/*
+	 * Order is important here: memory regions may have all of the
+	 * bits below set (and usually do), and any memory that has the
+	 * EFI_MEMORY_WB bit set may be covered by the linear mapping
+	 * and mapped write-back cacheable already. So check the
+	 * EFI_MEMORY_WB bit first.
+	 */
+	if (md->attribute & EFI_MEMORY_WB)
+		desc.type = MT_MEMORY_RWX;
+	else if (md->attribute & EFI_MEMORY_WT)
+		desc.type = MT_MEMORY_RWX_NONCACHED;
+	else if (md->attribute & EFI_MEMORY_WC)
+		desc.type = MT_DEVICE_WC;
+	else if (md->attribute & EFI_MEMORY_UC)
+		desc.type = MT_DEVICE;
+	else
+		return -EINVAL;
+
+	create_mapping_late(mm, &desc);
+
+	if (md->attribute & EFI_MEMORY_RO)
+		prot_val |= L_PTE_RDONLY;
+	if (md->attribute & EFI_MEMORY_XP)
+		prot_val |= L_PTE_XN;
+
+	/*
+	 * MT_DEVICE[_WC] implies XN, so no need to set it again.
+	 */
+	if (desc.type == MT_DEVICE_WC || desc.type == MT_DEVICE)
+		prot_val &= ~L_PTE_XN;
+
+	if (prot_val != 0)
+		ret = apply_to_page_range(mm, desc.virtual, desc.length,
+					  set_efi_permissions, &prot_val);
+
+	return ret;
+}
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 5df2bca57c42..b341b1c3b2fa 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -7,6 +7,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/efi.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
@@ -37,6 +38,7 @@
 #include <asm/cp15.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
+#include <asm/efi.h>
 #include <asm/elf.h>
 #include <asm/early_ioremap.h>
 #include <asm/fixmap.h>
@@ -966,6 +968,7 @@ void __init setup_arch(char **cmdline_p)
 	early_paging_init(mdesc);
 #endif
 	setup_dma_zone(mdesc);
+	efi_init();
 	sanity_check_meminfo();
 	arm_memblock_init(mdesc);
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 1c667c6804a6..43df6a23689b 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
+#include <linux/efi.h>
 #include <linux/errno.h>
 #include <linux/swap.h>
 #include <linux/init.h>
@@ -24,6 +25,7 @@
 #include <linux/sizes.h>
 
 #include <asm/cp15.h>
+#include <asm/efi.h>
 #include <asm/mach-types.h>
 #include <asm/memblock.h>
 #include <asm/prom.h>
@@ -269,7 +271,8 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 		mdesc->reserve();
 
 	early_init_fdt_reserve_self();
-	early_init_fdt_scan_reserved_mem();
+	if (!efi_enabled(EFI_MEMMAP))
+		early_init_fdt_scan_reserved_mem();
 
 	/* reserve memory for DMA contiguous allocations */
 	dma_contiguous_reserve(arm_dma_limit);
@@ -751,3 +754,12 @@ static int __init keepinitrd_setup(char *__unused)
 
 __setup("keepinitrd", keepinitrd_setup);
 #endif
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	/*
+	 * Ignore DT memory nodes if we are booting via UEFI.
+	 */
+	if (!efi_enabled(EFI_MEMMAP))
+		early_init_dt_add_memory(base, size);
+}
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 950c87f5d279..3397902e4040 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -303,8 +303,10 @@ fail:
  * The value chosen is the largest non-zero power of 2 suitable for this purpose
  * both on 32-bit and 64-bit ARM CPUs, to maximize the likelihood that it can
  * be mapped efficiently.
+ * Since 32-bit ARM could potentially execute with a 1G/3G user/kernel split,
+ * map everything below 1 GB.
  */
-#define EFI_RT_VIRTUAL_BASE	0x40000000
+#define EFI_RT_VIRTUAL_BASE	SZ_512M
 
 static int cmp_mem_desc(const void *l, const void *r)
 {
-- 
1.9.1
