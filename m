From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V4 3/3] x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3
Date: Thu, 18 Jan 2018 13:01:45 -0800
Message-ID: <1516309305-24066-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>
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
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
---
 arch/x86/include/asm/efi.h           | 25 +++++++++-------------
 arch/x86/platform/efi/efi_64.c       | 40 +++++++++++++++++++-----------------
 arch/x86/platform/efi/efi_thunk_64.S |  2 +-
 3 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 00f977ddd718..cda9940bed7a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -62,14 +62,13 @@ extern asmlinkage u64 efi_call(void *fp, ...);
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
@@ -78,11 +77,8 @@ struct efi_scratch {
 	preempt_disable();						\
 	__kernel_fpu_begin();						\
 									\
-	if (efi_scratch.use_pgd) {					\
-		efi_scratch.prev_cr3 = __read_cr3();			\
-		write_cr3((unsigned long)efi_scratch.efi_pgt);		\
-		__flush_tlb_all();					\
-	}								\
+	if (!efi_enabled(EFI_OLD_MEMMAP))				\
+		efi_switch_mm(&efi_mm);					\
 })
 
 #define arch_efi_call_virt(p, f, args...)				\
@@ -90,10 +86,8 @@ struct efi_scratch {
 
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
@@ -135,6 +129,7 @@ extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
+extern void efi_switch_mm(struct mm_struct *mm);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c93f59731608..d6892ad2a693 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -82,9 +82,8 @@ pgd_t * __init efi_call_phys_prolog(void)
 	int n_pgds, i, j;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
-		save_pgd = (pgd_t *)__read_cr3();
-		write_cr3((unsigned long)efi_scratch.efi_pgt);
-		goto out;
+		efi_switch_mm(&efi_mm);
+		return NULL;
 	}
 
 	early_code_mapping_set_exec(1);
@@ -156,8 +155,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	pud_t *pud;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
-		write_cr3((unsigned long)save_pgd);
-		__flush_tlb_all();
+		efi_switch_mm(efi_scratch.prev_mm);
 		return;
 	}
 
@@ -346,13 +344,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 		return 0;
 
 	/*
-	 * Since the PGD is encrypted, set the encryption mask so that when
-	 * this value is loaded into cr3 the PGD will be decrypted during
-	 * the pagetable walk.
-	 */
-	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(pgd);
-
-	/*
 	 * It can happen that the physical address of new_memmap lands in memory
 	 * which is not mapped in the EFI page table. Therefore we need to go
 	 * and ident-map those pages containing the map before calling
@@ -365,8 +356,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 		return 1;
 	}
 
-	efi_scratch.use_pgd = true;
-
 	/*
 	 * Certain firmware versions are way too sentimential and still believe
 	 * they are exclusive and unquestionable owners of the first physical page,
@@ -625,6 +614,22 @@ void __init efi_dump_pagetable(void)
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
 
@@ -678,16 +683,13 @@ efi_status_t efi_thunk_set_virtual_address_map(
 	efi_sync_low_kernel_mappings();
 	local_irq_save(flags);
 
-	efi_scratch.prev_cr3 = __read_cr3();
-	write_cr3((unsigned long)efi_scratch.efi_pgt);
-	__flush_tlb_all();
+	efi_switch_mm(&efi_mm);
 
 	func = (u32)(unsigned long)phys_set_virtual_address_map;
 	status = efi64_thunk(func, memory_map_size, descriptor_size,
 			     descriptor_version, virtual_map);
 
-	write_cr3(efi_scratch.prev_cr3);
-	__flush_tlb_all();
+	efi_switch_mm(efi_scratch.prev_mm);
 	local_irq_restore(flags);
 
 	return status;
diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
index 189b218da87c..46c58b08739c 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -33,7 +33,7 @@ ENTRY(efi64_thunk)
 	 * Switch to 1:1 mapped 32-bit stack pointer.
 	 */
 	movq	%rsp, efi_saved_sp(%rip)
-	movq	efi_scratch+25(%rip), %rsp
+	movq	efi_scratch(%rip), %rsp
 
 	/*
 	 * Calculate the physical address of the kernel text.
-- 
2.1.4
