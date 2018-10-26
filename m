From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data regions from efi_pgd
Date: Fri, 26 Oct 2018 14:38:44 -0700
Message-ID: <20181026213845.28166-2-sai.praneeth.prakhya@intel.com>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Ideally, after kernel assumes control of the platform, firmware shouldn't
access EFI boot services code/data regions. But, it's noticed that this is
not so true in many x86 platforms. Hence, during boot, kernel reserves EFI
boot services code/data regions [1] and maps [2] them to efi_pgd so that
call to set_virtual_address_map() doesn't fail. After returning from
set_virtual_address_map(), kernel frees the reserved regions [3] but they
still remain mapped.

This means that any code that's running in efi_pgd address space (e.g: any
EFI runtime service) would still be able to access EFI boot services
code/data regions but the contents of these regions would have long been
over written by someone else as they are freed by efi_free_boot_services().
So, it's important to unmap these regions. After unmapping EFI boot
services code/data regions, any illegal access by buggy firmware to these
regions would result in page fault which will be handled by efi specific
fault handler.

Unmapping EFI boot services code/data regions will result in clearing
PAGE_PRESENT bit and it shouldn't bother L1TF cases because it's already
handled by protnone_mask() at arch/x86/include/asm/pgtable-invert.h.

[1] Please see efi_reserve_boot_services()
[2] Please see efi_map_region() -> __map_region()
[3] Please see efi_free_boot_services()

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
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/pageattr.c               | 26 ++++++++++++++++++++++++++
 arch/x86/platform/efi/quirks.c       | 25 +++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b64acb08a62b..cda04ecf5432 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -566,6 +566,8 @@ extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
+extern int kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
+				     unsigned long numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 51a5a69ecac9..248f16181bed 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2147,6 +2147,32 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 	return retval;
 }
 
+int kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
+			      unsigned long numpages)
+{
+	int retval;
+
+	/*
+	 * The typical sequence for unmapping is to find a pte through
+	 * lookup_address_in_pgd() (ideally, it should never return NULL because
+	 * the address is already mapped) and change it's protections.
+	 * As pfn is the *target* of a mapping, it's not useful while unmapping.
+	 */
+	struct cpa_data cpa = {
+		.vaddr		= &address,
+		.pgd		= pgd,
+		.numpages	= numpages,
+		.mask_set	= __pgprot(0),
+		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW),
+		.flags		= 0,
+	};
+
+	retval = __change_page_attr_set_clr(&cpa, 0);
+	__flush_tlb_all();
+
+	return retval;
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 669babcaf245..fb1c44b11235 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -370,6 +370,24 @@ void __init efi_reserve_boot_services(void)
 	}
 }
 
+/*
+ * Apart from having VA mappings for EFI boot services code/data regions,
+ * (duplicate) 1:1 mappings were also created as a quirk for buggy firmware. So,
+ * unmap both 1:1 and VA mappings.
+ */
+static void __init efi_unmap_pages(efi_memory_desc_t *md)
+{
+	pgd_t *pgd = efi_mm.pgd;
+	u64 pa = md->phys_addr;
+	u64 va = md->virt_addr;
+
+	if (kernel_unmap_pages_in_pgd(pgd, pa, md->num_pages))
+		pr_err("Failed to unmap 1:1 mapping for 0x%llx\n", pa);
+
+	if (kernel_unmap_pages_in_pgd(pgd, va, md->num_pages))
+		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
+}
+
 void __init efi_free_boot_services(void)
 {
 	phys_addr_t new_phys, new_size;
@@ -394,6 +412,13 @@ void __init efi_free_boot_services(void)
 			continue;
 		}
 
+		/*
+		 * Before calling set_virtual_address_map(), EFI boot services
+		 * code/data regions were mapped as a quirk for buggy firmware.
+		 * Unmap them from efi_pgd before freeing them up.
+		 */
+		efi_unmap_pages(md);
+
 		/*
 		 * Nasty quirk: if all sub-1MB memory is used for boot
 		 * services, we can get here without having allocated the
-- 
2.19.1
