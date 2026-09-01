Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC2948423F;
	Tue,  1 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281855; cv=none; b=K5aZ7d9+8cRDS8R4xBVaswdMUoHi6YSbYXhD+9W8iZPofEjPt+JEaiL2cF3QrrFCtq03UBXkcPjfkXE3E3N6wVCpFOuz3i+ciZzc2yug9SyExEB6yQ4BLJuYGxwnU1Ryt2VO4TCHKOZqcAg0+SawecOgFa6SLakfeGEZmdXOnKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281855; c=relaxed/simple;
	bh=lFpQ5h8e4gADEnbl2VgWuUPXu3sgbx+mjnfcNij1AVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBJpzS5Mtx5GDY/7SyYT7j+iEFKjPRbeXcEaQ3fatQYf+0asSkXh8x/9y3zQBbaV9evXo6kQ0gJXaQyKrKrkqS8vPbwHd/NlzABa8bT/rI+v6zhEdydnTmRRTjdzGub0JRUc/exAfprFlGnRhNqw/IB7EJqDa3OjxfsXkE1gadU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eM8MW6nX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eM8MW6nX"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id 1928520B7001; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1928520B7001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=The4NHc+XgE3F3fgWjXVI3lQkaMw3MhSHPODgCgMZ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM8MW6nXJKs3UFTfxFlODALVyjceafXMuuoegne6ZWtcMiylra+HusmWDEgAAWbAq
	 n20emivGohHnz8RRyfQ6qLbXt3Pso95t8wgqj8q7Z8MbfhsDJ1Ff+LZBxOKQZbS8FK
	 SM/3x+iMJNCtPl8gotSXlyNpn8tqTDa0mGVxIJzU=
From: Thara Gopinath <tgopinath@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org
Cc: James.Bottomley@HansenPartnership.com,
	"longli@microsoft.com--cc=tzimmermann"@suse.de, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Thara Gopinath <tgopinath@linux.microsoft.com>
Subject: [RFC PATCH 08/12] arch: x86: hyperv: Build initial vCPU context for VTL1 secure kernel
Date: Tue,  1 Sep 2026 09:55:22 -0700
Message-ID: <20260901165647.3160413-9-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enabling VTL1 on the boot processor requires handing Hyper-V a fully
populated hv_init_vp_context describing the state VTL1 should start in:
initial page tables, GDT/TSS, control registers and entry point. Add
the arch-specific builder that assembles this context using the memory
region reserved for the secure kernel.

Actual enablement of VTL1 using this context is done in a subsequent
patch.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 arch/x86/hyperv/Makefile        |   1 +
 arch/x86/hyperv/hv_vtl_vsm.c    | 258 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h |   9 ++
 3 files changed, 268 insertions(+)
 create mode 100644 arch/x86/hyperv/hv_vtl_vsm.c

diff --git a/arch/x86/hyperv/Makefile b/arch/x86/hyperv/Makefile
index 56292102af623..1fdc20e239243 100644
--- a/arch/x86/hyperv/Makefile
+++ b/arch/x86/hyperv/Makefile
@@ -2,6 +2,7 @@
 obj-y			:= hv_init.o mmu.o nested.o irqdomain.o ivm.o
 obj-$(CONFIG_X86_64)	+= hv_apic.o
 obj-$(CONFIG_HYPERV_VTL_MODE)	+= hv_vtl.o mshv_vtl_asm.o
+obj-$(CONFIG_HYPERV_VSM)	+= hv_vtl_vsm.o
 
 $(obj)/mshv_vtl_asm.o: $(obj)/mshv-asm-offsets.h
 
diff --git a/arch/x86/hyperv/hv_vtl_vsm.c b/arch/x86/hyperv/hv_vtl_vsm.c
new file mode 100644
index 0000000000000..edc55264c4d87
--- /dev/null
+++ b/arch/x86/hyperv/hv_vtl_vsm.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Architecture-specific bring-up state for the VTL1 secure kernel: build
+ * the page tables, GDT/TSS and initial vCPU register context that Hyper-V
+ * loads when transitioning the boot processor to VTL1.
+ *
+ * Copyright (c) 2025-2026, Microsoft Corporation.
+ *
+ * Author: Thara Gopinath <tgopinath@linux.microsoft.com>
+ */
+
+#include <linux/align.h>
+#include <linux/bits.h>
+#include <linux/init.h>
+#include <hyperv/vsm.h>
+#include <asm/msr-index.h>
+#include <asm/processor-flags.h>
+#include <asm/mshyperv.h>
+
+/* Define PAGE size and related variables for initial secure kernel pages */
+#define VSM_PAGE_SHIFT			12
+#define VSM_PAGE_SIZE			BIT(VSM_PAGE_SHIFT)
+#define PAGE_AT(addr, idx)		((addr) + (idx) * VSM_PAGE_SIZE)
+#define VSM_VA_FROM_PA(pa)		(pa) /* Assumes identity mapping in secure kernel */
+
+/* Number of entries in a page table (all levels) */
+#define VSM_ENTRIES_PER_PT		512
+#define VSM_PMD_SIZE			(VSM_PAGE_SIZE * VSM_ENTRIES_PER_PT)
+
+/*
+ * Initial memory that will be mapped for secure kernel.
+ * Secure Kernel memory can be larger than this.
+ */
+#define VSM_SK_PTE_PAGES_COUNT	(ALIGN(VSM_SK_INITIAL_MAP_SIZE, VSM_PMD_SIZE) / VSM_PMD_SIZE)
+
+/* VSM pages */
+enum {
+	VSM_GDT_PAGE,
+	VSM_TSS_PAGE,
+	VSM_PML4E_PAGE,
+	VSM_PDPE_PAGE,
+	VSM_PDE_PAGE,
+	VSM_PTE_PAGES,
+	/* PTE tables consume several pages */
+	VSM_KERNEL_STACK_PAGE = VSM_PTE_PAGES + VSM_SK_PTE_PAGES_COUNT,
+	VSM_PAGES_COUNT
+};
+
+#define VSM_PT_FLAGS			(_PAGE_PRESENT | _PAGE_RW)
+#define VSM_PTE_FLAGS			(VSM_PT_FLAGS | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+/* Shifts to compute page table mapping */
+#define VSM_PD_TABLE_SHIFT		21
+#define VSM_PDP_TABLE_SHIFT		30
+#define VSM_PML4_TABLE_SHIFT		39
+
+/* Given VA, get index into the page table at a given level */
+#define VSM_GET_PML4_INDEX(addr)	(((addr) >> VSM_PML4_TABLE_SHIFT) & 0x1FF)
+#define VSM_GET_PDP_INDEX(addr)		(((addr) >> VSM_PDP_TABLE_SHIFT) & 0x1FF)
+#define VSM_GET_PD_INDEX(addr)		(((addr) >> VSM_PD_TABLE_SHIFT) & 0x1FF)
+
+static void __init hv_vsm_fill_pte_tables(phys_addr_t sk_pa, u64 *pde,
+					  int pd_index, int num_pte_tables)
+{
+	u16 i, j;
+	phys_addr_t pte_pa;
+	u64 *pte;
+
+	/* Fill page tables with entries */
+	for (i = 0; i < num_pte_tables; i++) {
+		pte_pa = PAGE_AT(sk_pa, VSM_PTE_PAGES + i);
+		pte = phys_to_virt(pte_pa);
+		*(pde + pd_index + i) = pte_pa | VSM_PTE_FLAGS;
+		for (j = 0; j < VSM_ENTRIES_PER_PT; j++) {
+			*(pte + j) =
+				(sk_pa + ((j + (i * VSM_ENTRIES_PER_PT)) * VSM_PAGE_SIZE)) |
+					VSM_PTE_FLAGS;
+		}
+	}
+}
+
+static void __init hv_vsm_init_page_tables(struct hv_init_vp_context *vp_ctx, phys_addr_t sk_pa)
+{
+	unsigned int pml4_index;
+	unsigned int pdp_index;
+	unsigned int pd_index;
+	phys_addr_t pml4e_pa;
+	phys_addr_t pdpe_pa;
+	phys_addr_t pde_pa;
+	u64 *pml4e;
+	u64 *pdpe;
+	u64 *pde;
+	int num_pte_tables;
+
+	/* Compute the page-table indices at which the secure kernel mapping starts. */
+	pml4_index = VSM_GET_PML4_INDEX(sk_pa);
+	pdp_index = VSM_GET_PDP_INDEX(sk_pa);
+	pd_index = VSM_GET_PD_INDEX(sk_pa);
+
+	pml4e_pa = PAGE_AT(sk_pa, VSM_PML4E_PAGE);
+	pdpe_pa = PAGE_AT(sk_pa, VSM_PDPE_PAGE);
+	pde_pa = PAGE_AT(sk_pa, VSM_PDE_PAGE);
+
+	pml4e = phys_to_virt(pml4e_pa);
+	pdpe = phys_to_virt(pdpe_pa);
+	pde = phys_to_virt(pde_pa);
+
+	/*
+	 * Zero the PML4, PDP, PD and PTE pages before populating them so that
+	 * any entry not explicitly written below has its present bit clear.
+	 */
+	memset(pml4e, 0,
+	       (VSM_KERNEL_STACK_PAGE - VSM_PML4E_PAGE) * VSM_PAGE_SIZE);
+
+	*(pml4e + pml4_index) = pdpe_pa | VSM_PT_FLAGS;
+	*(pdpe + pdp_index) = pde_pa | VSM_PT_FLAGS;
+
+	/*
+	 * Initial page tables map only the first VSM_SK_INITIAL_MAP_SIZE size of memory.
+	 * This memory will be used for the Secure Loader and initial Secure Kernel.
+	 */
+	num_pte_tables = (VSM_SK_INITIAL_MAP_SIZE / VSM_PAGE_SIZE) / VSM_ENTRIES_PER_PT;
+	hv_vsm_fill_pte_tables(sk_pa, pde, pd_index, num_pte_tables);
+
+	vp_ctx->cr3 = pml4e_pa;
+}
+
+static void __init hv_vsm_init_gdt(struct hv_init_vp_context *vp_ctx, phys_addr_t sk_pa)
+{
+	phys_addr_t gdt_pa, tss_pa, kstack_pa;
+	void *gdt_va;
+	u64 tss_sk_va, gdt;
+	struct x86_hw_tss *tss;
+	size_t gdt_size = sizeof(gdt), tss_size = sizeof(*tss), gdt_offset = 0;
+
+	/* Get a page for the GDT */
+	gdt_pa = PAGE_AT(sk_pa, VSM_GDT_PAGE);
+	gdt_va = phys_to_virt(gdt_pa);
+	/* Get a page for the TSS */
+	tss_pa = PAGE_AT(sk_pa, VSM_TSS_PAGE);
+	tss = phys_to_virt(tss_pa);
+	/* Compute the VA that secure kernel will see for the TSS */
+	tss_sk_va = VSM_VA_FROM_PA(tss_pa);
+	/* Get a page for the secure kernel initial stack */
+	kstack_pa = PAGE_AT(sk_pa, VSM_KERNEL_STACK_PAGE);
+	/* Set the initial stack pointer for the kernel to point to bottom of kernel stack */
+	tss->sp0 = VSM_VA_FROM_PA(kstack_pa) + VSM_PAGE_SIZE;
+	vp_ctx->rsp = tss->sp0;
+
+	/* Make and add the NULL descriptor to the GDT */
+	gdt = 0;
+	memcpy(gdt_va + gdt_offset, &gdt, gdt_size);
+	gdt_offset += gdt_size;
+
+	/* Make and add a code segment descriptor to the GDT */
+	gdt = GDT_ENTRY(DESC_CODE64, 0, 0);
+	memcpy(gdt_va + gdt_offset, &gdt, gdt_size);
+	gdt_offset += gdt_size;
+
+	/* Make and add a data segment descriptor to the GDT */
+	gdt = GDT_ENTRY(DESC_DATA64, 0, 0);
+	memcpy(gdt_va + gdt_offset, &gdt, gdt_size);
+	gdt_offset += gdt_size;
+
+	/*
+	 * Make and add a system segment descriptor for the TSS in the GDT.
+	 *
+	 * In 64-bit mode a system-segment descriptor (TSS/LDT) is 16 bytes
+	 * wide: the lower 8 bytes have the same layout as the legacy 32-bit
+	 * descriptor (produced by GDT_ENTRY), and the upper 8 bytes hold
+	 * base[63:32] in the low 32 bits with the high 32 bits reserved 0.
+	 * GDT_ENTRY masks base to 32 bits, so the upper half must be written
+	 * explicitly.
+	 */
+	gdt = GDT_ENTRY(DESC_TSS32, tss_sk_va, tss_size);
+	memcpy(gdt_va + gdt_offset, &gdt, gdt_size);
+	gdt_offset += gdt_size;
+	gdt = tss_sk_va >> 32;
+	memcpy(gdt_va + gdt_offset, &gdt, gdt_size);
+	gdt_offset += gdt_size;
+
+	/* Set up the GDT register */
+	vp_ctx->gdtr.base = VSM_VA_FROM_PA(gdt_pa);
+	vp_ctx->gdtr.limit = gdt_offset - 1;
+
+	/* Set the code segment (CS) selector */
+	vp_ctx->cs.base = 0;
+	vp_ctx->cs.limit = 0;
+	vp_ctx->cs.selector = 1 << 3;
+	vp_ctx->cs.attributes = _DESC_S | _DESC_PRESENT | _DESC_ACCESSED |
+				_DESC_CODE_READABLE | _DESC_CODE_EXECUTABLE |
+				_DESC_LONG_CODE | _DESC_GRANULARITY_4K;
+
+	/* Set the data segment (DS) selector */
+	vp_ctx->ds.base = 0;
+	vp_ctx->ds.limit = 0;
+	vp_ctx->ds.selector = 2 << 3;
+	vp_ctx->ds.attributes = _DESC_S | _DESC_PRESENT | _DESC_ACCESSED |
+				_DESC_DATA_WRITABLE | _DESC_GRANULARITY_4K | _DESC_DB;
+
+	/* Set the ES, FS and GS to be the same as DS, for now */
+	vp_ctx->es = vp_ctx->ds;
+	vp_ctx->fs = vp_ctx->ds;
+	vp_ctx->gs = vp_ctx->ds;
+
+	/* Set the stack selector to 0 (unused in long mode) */
+	vp_ctx->ss.selector = 0;
+
+	/* Set the task register selector */
+	vp_ctx->tr.base = tss_sk_va;
+	vp_ctx->tr.limit = tss_size - 1;
+	vp_ctx->tr.selector = 3 << 3;
+	vp_ctx->tr.attributes = _DESC_PRESENT | _DESC_SYSTEM(11);
+}
+
+static void __init hv_vsm_init_cpu(struct hv_init_vp_context *vp_ctx, Elf64_Addr sk_entry_pa)
+{
+	/* Offset rip by any secure kernel header length */
+	vp_ctx->rip = VSM_VA_FROM_PA(sk_entry_pa);
+
+	/* ToDo: Check if can be replaced with CR0_STATE */
+	vp_ctx->cr0 =
+		X86_CR0_PG |	/* Paging */
+		X86_CR0_WP |	/* Write Protect */
+		X86_CR0_NE |	/* Numeric Error */
+		X86_CR0_ET |	/* Extension Type */
+		X86_CR0_MP |	/* Math Present */
+		X86_CR0_PE;	/* Protection Enable */
+
+	vp_ctx->cr4 =
+		X86_CR4_PSE |	/* Page Size Extensions */
+		X86_CR4_PGE |	/* Page Global Enable */
+		X86_CR4_PAE;	/* Physical Address Extensions */
+
+	vp_ctx->efer =
+		EFER_LMA |	/* Long Mode Active */
+		EFER_LME |	/* Long Mode Enable */
+		EFER_NX  |	/* No Execute Enable */
+		EFER_SCE;	/* System Call Enable */
+
+	/*
+	 * Intel CPUs fail if the architectural read-as-one bit 1 of RFLAGS is not
+	 * set. See Intel SDM Vol 3C, 26.3.1.4 (RFLAGS).
+	 *
+	 * TODO: Has Hyper-V implemented setting this automatically?
+	 */
+	vp_ctx->rflags = X86_EFLAGS_FIXED;
+
+	vp_ctx->msr_cr_pat = PAT_VALUE(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
+}
+
+void __init hv_vsm_arch_init_vp(struct hv_init_vp_context *vp_ctx, Elf64_Addr sk_entry_pa,
+				phys_addr_t sk_pa)
+{
+	hv_vsm_init_cpu(vp_ctx, sk_entry_pa);
+	hv_vsm_init_gdt(vp_ctx, sk_pa);
+	hv_vsm_init_page_tables(vp_ctx, sk_pa);
+}
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index f64393e853ee3..5f0d689641f05 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -7,6 +7,7 @@
 #include <linux/msi.h>
 #include <linux/io.h>
 #include <linux/static_call.h>
+#include <linux/elf.h>
 #include <asm/nospec-branch.h>
 #include <asm/msr.h>
 #include <hyperv/hvhdk.h>
@@ -248,6 +249,14 @@ void hv_crash_asm_end(void);
 static inline void hv_root_crash_init(void) {}
 #endif  /* CONFIG_MSHV_ROOT && CONFIG_CRASH_DUMP */
 
+#ifdef CONFIG_HYPERV_VSM
+void __init hv_vsm_arch_init_vp(struct hv_init_vp_context *vp_ctx, Elf64_Addr sk_entry_pa,
+				phys_addr_t sk_pa);
+#else /* CONFIG_HYPERV_VSM */
+static inline void __init hv_vsm_arch_init_vp(struct hv_init_vp_context *vp_ctx,
+					      Elf64_Addr sk_entry_pa, phys_addr_t sk_pa) {}
+#endif
+
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
-- 
2.34.1

