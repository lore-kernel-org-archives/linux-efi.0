From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/10] x86/efi: Return error status if mapping EFI regions fail
Date: Sat,  2 Feb 2019 10:41:11 +0100
Message-ID: <20190202094119.13230-3-ard.biesheuvel@linaro.org>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

efi_map_region() creates VA mappings for an given EFI region using any one
of the two helper functions (namely __map_region() and old_map_region()).
These helper functions *could* fail while creating mappings and presently
their return value is not checked. Not checking for the return value of
these functions might create issues because after these functions return
"md->virt_addr" is set to the requested virtual address (so it's assumed
that these functions always succeed which is not quite true). This
assumption leads to "md->virt_addr" having invalid mapping should any of
__map_region() or old_map_region() fail.

Hence, check for the return value of these functions and if indeed they
fail, turn off EFI Runtime Services forever because kernel cannot
prioritize among EFI regions.

This also fixes the comment "FIXME: add error handling" in
kexec_enter_virtual_mode().

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/efi.h     |  6 +++---
 arch/x86/platform/efi/efi.c    | 21 +++++++++++++-----
 arch/x86/platform/efi/efi_32.c |  6 +++---
 arch/x86/platform/efi/efi_64.c | 39 ++++++++++++++++++++++------------
 4 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 107283b1eb1e..a37378f986ec 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -125,12 +125,12 @@ extern pgd_t * __init efi_call_phys_prolog(void);
 extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
 extern void __init efi_print_memmap(void);
 extern void __init efi_memory_uc(u64 addr, unsigned long size);
-extern void __init efi_map_region(efi_memory_desc_t *md);
-extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
+extern int __init efi_map_region(efi_memory_desc_t *md);
+extern int __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern int __init efi_alloc_page_tables(void);
 extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
-extern void __init old_map_region(efi_memory_desc_t *md);
+extern int __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_update_mappings(void);
 extern void __init efi_dump_pagetable(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e1cb01a22fa8..3d43ec58775b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -581,7 +581,7 @@ void __init efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
-void __init old_map_region(efi_memory_desc_t *md)
+int __init old_map_region(efi_memory_desc_t *md)
 {
 	u64 start_pfn, end_pfn, end;
 	unsigned long size;
@@ -601,10 +601,14 @@ void __init old_map_region(efi_memory_desc_t *md)
 		va = efi_ioremap(md->phys_addr, size,
 				 md->type, md->attribute);
 
-	md->virt_addr = (u64) (unsigned long) va;
-	if (!va)
+	if (!va) {
 		pr_err("ioremap of 0x%llX failed!\n",
 		       (unsigned long long)md->phys_addr);
+		return -ENOMEM;
+	}
+
+	md->virt_addr = (u64)(unsigned long)va;
+	return 0;
 }
 
 /* Merge contiguous regions of the same type and attribute */
@@ -797,7 +801,9 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
 		if (!should_map_region(md))
 			continue;
 
-		efi_map_region(md);
+		if (efi_map_region(md))
+			return NULL;
+
 		get_systab_virt_addr(md);
 
 		if (left < desc_size) {
@@ -849,7 +855,12 @@ static void __init kexec_enter_virtual_mode(void)
 	* fixed addr which was used in first kernel of a kexec boot.
 	*/
 	for_each_efi_memory_desc(md) {
-		efi_map_region_fixed(md); /* FIXME: add error handling */
+		if (efi_map_region_fixed(md)) {
+			pr_err("Error mapping EFI regions, EFI runtime non-functional!\n");
+			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+			return;
+		}
+
 		get_systab_virt_addr(md);
 	}
 
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 9959657127f4..4d369118391a 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -58,12 +58,12 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-void __init efi_map_region(efi_memory_desc_t *md)
+int __init efi_map_region(efi_memory_desc_t *md)
 {
-	old_map_region(md);
+	return old_map_region(md);
 }
 
-void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
+int __init efi_map_region_fixed(efi_memory_desc_t *md) { return 0; }
 void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
 
 pgd_t * __init efi_call_phys_prolog(void)
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index cf0347f61b21..ba83e2e2664b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -408,7 +408,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-static void __init __map_region(efi_memory_desc_t *md, u64 va)
+static int __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	unsigned long flags = _PAGE_RW;
 	unsigned long pfn;
@@ -421,12 +421,16 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 		flags |= _PAGE_ENC;
 
 	pfn = md->phys_addr >> PAGE_SHIFT;
-	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
-		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
-			   md->phys_addr, va);
+	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags)) {
+		pr_err("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+		       md->phys_addr, va);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
-void __init efi_map_region(efi_memory_desc_t *md)
+int __init efi_map_region(efi_memory_desc_t *md)
 {
 	unsigned long size = md->num_pages << PAGE_SHIFT;
 	u64 pa = md->phys_addr;
@@ -439,7 +443,8 @@ void __init efi_map_region(efi_memory_desc_t *md)
 	 * firmware which doesn't update all internal pointers after switching
 	 * to virtual mode and would otherwise crap on us.
 	 */
-	__map_region(md, md->phys_addr);
+	if (__map_region(md, md->phys_addr))
+		return -ENOMEM;
 
 	/*
 	 * Enforce the 1:1 mapping as the default virtual address when
@@ -448,7 +453,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
 	 */
 	if (!efi_is_native () && IS_ENABLED(CONFIG_EFI_MIXED)) {
 		md->virt_addr = md->phys_addr;
-		return;
+		return 0;
 	}
 
 	efi_va -= size;
@@ -468,13 +473,16 @@ void __init efi_map_region(efi_memory_desc_t *md)
 	}
 
 	if (efi_va < EFI_VA_END) {
-		pr_warn(FW_WARN "VA address range overflow!\n");
-		return;
+		pr_err(FW_WARN "VA address range overflow!\n");
+		return -ENOMEM;
 	}
 
 	/* Do the VA map */
-	__map_region(md, efi_va);
+	if (__map_region(md, efi_va))
+		return -ENOMEM;
+
 	md->virt_addr = efi_va;
+	return 0;
 }
 
 /*
@@ -482,10 +490,15 @@ void __init efi_map_region(efi_memory_desc_t *md)
  * md->virt_addr is the original virtual address which had been mapped in kexec
  * 1st kernel.
  */
-void __init efi_map_region_fixed(efi_memory_desc_t *md)
+int __init efi_map_region_fixed(efi_memory_desc_t *md)
 {
-	__map_region(md, md->phys_addr);
-	__map_region(md, md->virt_addr);
+	if (__map_region(md, md->phys_addr))
+		return -ENOMEM;
+
+	if (__map_region(md, md->virt_addr))
+		return -ENOMEM;
+
+	return 0;
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-- 
2.17.1
