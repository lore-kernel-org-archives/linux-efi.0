From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V3 1/3] x86/mm/pageattr: Introduce helper function to unmap EFI boot services
Date: Sun,  4 Nov 2018 12:10:17 -0800
Message-ID: <20181104201019.26142-2-sai.praneeth.prakhya@intel.com>
References: <20181104201019.26142-1-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181104201019.26142-1-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Ideally, after kernel assumes control of the platform, firmware
shouldn't access EFI boot services code/data regions. But, it's noticed
that this is not so true in many x86 platforms. Hence, during boot,
kernel reserves EFI boot services code/data regions [1] and maps [2]
them to efi_pgd so that call to set_virtual_address_map() doesn't fail.
After returning from set_virtual_address_map(), kernel frees the
reserved regions [3] but they still remain mapped. Hence, introduce
kernel_unmap_pages_in_pgd() which will later be used to unmap EFI boot
services code/data regions.

While at it modify kernel_map_pages_in_pgd() by
1. Adding __init modifier because it's always used *only* during boot.
2. Add a warning if it's used after SMP is initialized because it uses
   __flush_tlb_all() which flushes mappings only on current CPU.

Unmapping EFI boot services code/data regions will result in clearing
PAGE_PRESENT bit and it shouldn't bother L1TF cases because it's already
handled by protnone_mask() at arch/x86/include/asm/pgtable-invert.h.

[1] efi_reserve_boot_services()
[2] efi_map_region() -> __map_region() -> kernel_map_pages_in_pgd()
[3] efi_free_boot_services()

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/pgtable_types.h |  8 ++++++--
 arch/x86/mm/pageattr.c               | 40 ++++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b64acb08a62b..79aa79bb2cfa 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -564,8 +564,12 @@ extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 				    unsigned int *level);
 extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
-extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
-				   unsigned numpages, unsigned long page_flags);
+extern int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn,
+					  unsigned long address,
+					  unsigned numpages,
+					  unsigned long page_flags);
+extern int __init kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
+					    unsigned long numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 51a5a69ecac9..1b1d5a68c4b2 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2111,8 +2111,8 @@ bool kernel_page_present(struct page *page)
 
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
-int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
-			    unsigned numpages, unsigned long page_flags)
+int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+				   unsigned numpages, unsigned long page_flags)
 {
 	int retval = -EINVAL;
 
@@ -2126,6 +2126,8 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 		.flags = 0,
 	};
 
+	WARN_ONCE(num_online_cpus() > 1, "Don't call after initializing SMP");
+
 	if (!(__supported_pte_mask & _PAGE_NX))
 		goto out;
 
@@ -2148,6 +2150,40 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 }
 
 /*
+ * __flush_tlb_all() flushes mappings only on current CPU and hence this
+ * function shouldn't be used in an SMP environment. Presently, it's used only
+ * during boot (way before smp_init()) by EFI subsystem and hence is ok.
+ */
+int __init kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
+				     unsigned long numpages)
+{
+	int retval;
+
+	/*
+	 * The typical sequence for unmapping is to find a pte through
+	 * lookup_address_in_pgd() (ideally, it should never return NULL because
+	 * the address is already mapped) and change it's protections. As pfn is
+	 * the *target* of a mapping, it's not useful while unmapping.
+	 */
+	struct cpa_data cpa = {
+		.vaddr		= &address,
+		.pfn		= 0,
+		.pgd		= pgd,
+		.numpages	= numpages,
+		.mask_set	= __pgprot(0),
+		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW),
+		.flags		= 0,
+	};
+
+	WARN_ONCE(num_online_cpus() > 1, "Don't call after initializing SMP");
+
+	retval = __change_page_attr_set_clr(&cpa, 0);
+	__flush_tlb_all();
+
+	return retval;
+}
+
+/*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
  */
-- 
2.7.4
