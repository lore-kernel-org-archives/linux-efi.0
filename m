From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 1/2] x86/efi: Unmap efi boot services code/data regions from efi_pgd
Date: Sun, 21 Oct 2018 18:35:44 -0700
Message-ID: <1540172145-17134-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Ideally, after kernel assumes control of the platform firmware shouldn't
access EFI Boot Services Code/Data regions. But, it's noticed that this
is not so true in many x86 platforms. Hence, during boot, kernel
reserves efi boot services code/data regions [1] and maps [2] them to
efi_pgd so that call to set_virtual_address_map() doesn't fail. After
returning from set_virtual_address_map(), kernel frees the reserved
regions [3] but they still remain mapped.

This means that any code that's running in efi_pgd address space (e.g:
any efi runtime service) would still be able to access efi boot services
code/data regions but the contents of these regions would have long been
over written by someone else as they are freed by efi_free_boot_services().
So, it's important to unmap these regions. After unmapping boot services
code/data regions, any illegal access by buggy firmware to these regions
would result in page fault which will be handled by efi specific fault
handler.

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
 arch/x86/mm/pageattr.c               | 21 +++++++++++++++++++++
 arch/x86/platform/efi/quirks.c       | 26 ++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b64acb08a62b..796476f11151 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -566,6 +566,8 @@ extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
+extern int kernel_unmap_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+				     unsigned long numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 51a5a69ecac9..b88ed8e91790 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2147,6 +2147,27 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 	return retval;
 }
 
+int kernel_unmap_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+			      unsigned long numpages)
+{
+	int retval;
+
+	struct cpa_data cpa = {
+		.vaddr = &address,
+		.pfn = pfn,
+		.pgd = pgd,
+		.numpages = numpages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
+		.flags = 0,
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
index 669babcaf245..5a1ee9392fcf 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -370,6 +370,25 @@ void __init efi_reserve_boot_services(void)
 	}
 }
 
+/*
+ * Apart from having VA mappings for efi boot services code/data regions,
+ * (duplicate) 1:1 mappings were also created as a catch for buggy firmware. So,
+ * unmap both 1:1 and VA mappings.
+ */
+static void __init efi_unmap_pages(efi_memory_desc_t *md)
+{
+	pgd_t *pgd = efi_mm.pgd;
+	u64 pfn = md->phys_addr >> PAGE_SHIFT;
+
+	if (kernel_unmap_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages))
+		pr_err("Failed to unmap 1:1 mapping: PA 0x%llx -> VA 0x%llx!\n",
+		       md->phys_addr, md->virt_addr);
+
+	if (kernel_unmap_pages_in_pgd(pgd, pfn, md->virt_addr, md->num_pages))
+		pr_err("Failed to unmap VA mapping: PA 0x%llx -> VA 0x%llx!\n",
+		       md->phys_addr, md->virt_addr);
+}
+
 void __init efi_free_boot_services(void)
 {
 	phys_addr_t new_phys, new_size;
@@ -415,6 +434,13 @@ void __init efi_free_boot_services(void)
 		}
 
 		free_bootmem_late(start, size);
+
+		/*
+		 * Before calling set_virtual_address_map(), boot services
+		 * code/data regions were mapped as a catch for buggy firmware.
+		 * Unmap them from efi_pgd as they have already been freed.
+		 */
+		efi_unmap_pages(md);
 	}
 
 	if (!num_entries)
-- 
2.7.4
