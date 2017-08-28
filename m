From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 3/3] x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3
Date: Mon, 28 Aug 2017 16:37:12 -0700
Message-ID: <1503963432-32055-4-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: jlee@suse.com, bp@alien8.de, tony.luck@intel.com, luto@kernel.org, mst@redhat.com, ricardo.neri@intel.com, ravi.v.shankar@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Use helper function (efi_switch_mm()) to switch to/from efi_mm. We
switch to efi_mm before calling
1. efi_set_virtual_address_map() and
2. Invoking any efi_runtime_service()

Likewise, we need to switch back to previous mm (mm context stolen by
efi_mm) after the above calls return successfully. We can use
efi_switch_mm() helper function only with x86_64 kernel and
"efi=old_map" disabled because, x86_32 and efi=old_map doesn't use
efi_pgd, rather they use swapper_pg_dir.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
---
 arch/x86/include/asm/efi.h           | 29 ++++++++++++++---------------
 arch/x86/platform/efi/efi_64.c       | 36 +++++++++++++++++++++---------------
 arch/x86/platform/efi/efi_thunk_64.S |  2 +-
 3 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 2f77bcefe6b4..23b2137a95e5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -1,10 +1,14 @@
 #ifndef _ASM_X86_EFI_H
 #define _ASM_X86_EFI_H
 
+#include <linux/sched/mm.h>
+#include <linux/sched/task.h>
+
 #include <asm/fpu/api.h>
 #include <asm/pgtable.h>
 #include <asm/processor-flags.h>
 #include <asm/tlb.h>
+#include <asm/mmu_context.h>
 
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
@@ -57,14 +61,13 @@ extern u64 asmlinkage efi_call(void *fp, ...);
 #define efi_call_phys(f, args...)		efi_call((f), args)
 
 /*
- * Scratch space used for switching the pagetable in the EFI stub
+ * struct efi_scratch - Scratch space used while switching to/from efi_mm
+ * @phys_stack: stack used during EFI Mixed Mode
+ * @prev_mm:    store/restore stolen mm_struct while switching to/from efi_mm
  */
 struct efi_scratch {
-	u64	r15;
-	u64	prev_cr3;
-	pgd_t	*efi_pgt;
-	bool	use_pgd;
-	u64	phys_stack;
+	u64			phys_stack;
+	struct mm_struct	*prev_mm;
 } __packed;
 
 #define arch_efi_call_virt_setup()					\
@@ -73,11 +76,8 @@ struct efi_scratch {
 	preempt_disable();						\
 	__kernel_fpu_begin();						\
 									\
-	if (efi_scratch.use_pgd) {					\
-		efi_scratch.prev_cr3 = read_cr3();			\
-		write_cr3((unsigned long)efi_scratch.efi_pgt);		\
-		__flush_tlb_all();					\
-	}								\
+	if (!efi_enabled(EFI_OLD_MEMMAP))				\
+		efi_switch_mm(&efi_mm);					\
 })
 
 #define arch_efi_call_virt(p, f, args...)				\
@@ -85,10 +85,8 @@ struct efi_scratch {
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
-	if (efi_scratch.use_pgd) {					\
-		write_cr3(efi_scratch.prev_cr3);			\
-		__flush_tlb_all();					\
-	}								\
+	if (!efi_enabled(EFI_OLD_MEMMAP))				\
+		efi_switch_mm(efi_scratch.prev_mm);			\
 									\
 	__kernel_fpu_end();						\
 	preempt_enable();						\
@@ -130,6 +128,7 @@ extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
+extern void efi_switch_mm(struct mm_struct *mm);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 0bb98c35e178..e0545f56d703 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -80,9 +80,8 @@ pgd_t * __init efi_call_phys_prolog(void)
 	int n_pgds, i, j;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
-		save_pgd = (pgd_t *)read_cr3();
-		write_cr3((unsigned long)efi_scratch.efi_pgt);
-		goto out;
+		efi_switch_mm(&efi_mm);
+		return NULL;
 	}
 
 	early_code_mapping_set_exec(1);
@@ -152,8 +151,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	pud_t *pud;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
-		write_cr3((unsigned long)save_pgd);
-		__flush_tlb_all();
+		efi_switch_mm(efi_scratch.prev_mm);
 		return;
 	}
 
@@ -336,8 +334,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
 
-	efi_scratch.efi_pgt = (pgd_t *)__pa(pgd);
-
 	/*
 	 * It can happen that the physical address of new_memmap lands in memory
 	 * which is not mapped in the EFI page table. Therefore we need to go
@@ -350,8 +346,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 		return 1;
 	}
 
-	efi_scratch.use_pgd = true;
-
 	/*
 	 * Certain firmware versions are way too sentimential and still believe
 	 * they are exclusive and unquestionable owners of the first physical page,
@@ -596,6 +590,22 @@ void __init efi_dump_pagetable(void)
 #endif
 }
 
+/*
+ * Makes the calling thread switch to/from efi_mm context. Can be used
+ * for SetVirtualAddressMap() i.e. current->active_mm == init_mm as well
+ * as during efi runtime calls i.e current->active_mm == current_mm.
+ * We are not mm_dropping()/mm_grabbing() any mm, because we are not
+ * losing/creating any references.
+ */
+void efi_switch_mm(struct mm_struct *mm)
+{
+	task_lock(current);
+	efi_scratch.prev_mm = current->active_mm;
+	current->active_mm = mm;
+	switch_mm(efi_scratch.prev_mm, mm, NULL);
+	task_unlock(current);
+}
+
 #ifdef CONFIG_EFI_MIXED
 extern efi_status_t efi64_thunk(u32, ...);
 
@@ -649,17 +659,13 @@ efi_status_t efi_thunk_set_virtual_address_map(
 	efi_sync_low_kernel_mappings();
 	local_irq_save(flags);
 
-	efi_scratch.prev_cr3 = read_cr3();
-	write_cr3((unsigned long)efi_scratch.efi_pgt);
-	__flush_tlb_all();
+	efi_switch_mm(&efi_mm);
 
 	func = (u32)(unsigned long)phys_set_virtual_address_map;
 	status = efi64_thunk(func, memory_map_size, descriptor_size,
 			     descriptor_version, virtual_map);
 
-	write_cr3(efi_scratch.prev_cr3);
-	__flush_tlb_all();
-	local_irq_restore(flags);
+	efi_switch_mm(efi_scratch.prev_mm);
 
 	return status;
 }
diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
index ff85d28c50f2..5cdc72ebbc82 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -32,7 +32,7 @@ ENTRY(efi64_thunk)
 	 * Switch to 1:1 mapped 32-bit stack pointer.
 	 */
 	movq	%rsp, efi_saved_sp(%rip)
-	movq	efi_scratch+25(%rip), %rsp
+	movq	efi_scratch(%rip), %rsp
 
 	/*
 	 * Calculate the physical address of the kernel text.
-- 
2.1.4
