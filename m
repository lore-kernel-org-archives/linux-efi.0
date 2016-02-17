From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 12/13] x86/efi: Map EFI_MEMORY_{XP,RO} memory region bits to EFI page tables
Date: Wed, 17 Feb 2016 12:36:05 +0000
Message-ID: <1455712566-16727-13-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, "Lee, Chun-Yi" <jlee@suse.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Now that we have EFI memory region bits that indicate which regions do
not need execute permission or read/write permission in the page tables,
let's use them.

We also check for EFI_NX_PE_DATA and only enforce the restrictive
mappings if it's present (to allow us to ignore buggy firmware that sets
bits it didn't mean to and to preserve backwards compatibility).

Instead of assuming that firmware would set appropriate attributes in
memory descriptor like EFI_MEMORY_RO for code and EFI_MEMORY_XP for
data, we can expect some firmware out there which might only set *type*
in memory descriptor to be EFI_RUNTIME_SERVICES_CODE or
EFI_RUNTIME_SERVICES_DATA leaving away attribute. This will lead to
improper mappings of EFI runtime regions. In order to avoid it, we check
attribute and type of memory descriptor to update mappings and moreover
Windows works this way.

Cc: Borislav Petkov <bp@alien8.de>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/include/asm/efi.h     |  2 +-
 arch/x86/platform/efi/efi.c    |  9 +++++++--
 arch/x86/platform/efi/efi_32.c |  2 +-
 arch/x86/platform/efi/efi_64.c | 45 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 8fd9e637629a..7bb206f73915 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -141,7 +141,7 @@ extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pa
 extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
-extern void __init efi_runtime_mkexec(void);
+extern void __init efi_runtime_update_mappings(void);
 extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e80826e6f3a9..994a7df84a7b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -934,7 +934,6 @@ static void __init __efi_enter_virtual_mode(void)
 	}
 
 	efi_sync_low_kernel_mappings();
-	efi_dump_pagetable();
 
 	if (efi_is_native()) {
 		status = phys_efi_set_virtual_address_map(
@@ -972,7 +971,13 @@ static void __init __efi_enter_virtual_mode(void)
 
 	efi.set_virtual_address_map = NULL;
 
-	efi_runtime_mkexec();
+	/*
+	 * Apply more restrictive page table mapping attributes now that
+	 * SVAM() has been called and the firmware has performed all
+	 * necessary relocation fixups for the new virtual addresses.
+	 */
+	efi_runtime_update_mappings();
+	efi_dump_pagetable();
 
 	/*
 	 * We mapped the descriptor array into the EFI pagetable above
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 58d669bc8250..338402b91d2e 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -90,7 +90,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	__flush_tlb_all();
 }
 
-void __init efi_runtime_mkexec(void)
+void __init efi_runtime_update_mappings(void)
 {
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index b0965b27e47f..40d2f447a9dd 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -393,13 +393,50 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 	efi_setup = phys_addr + sizeof(struct setup_data);
 }
 
-void __init efi_runtime_mkexec(void)
+void __init efi_runtime_update_mappings(void)
 {
-	if (!efi_enabled(EFI_OLD_MEMMAP))
+	unsigned long pfn;
+	pgd_t *pgd = efi_pgd;
+	efi_memory_desc_t *md;
+	void *p;
+
+	if (efi_enabled(EFI_OLD_MEMMAP)) {
+		if (__supported_pte_mask & _PAGE_NX)
+			runtime_code_page_mkexec();
+		return;
+	}
+
+	if (!efi_enabled(EFI_NX_PE_DATA))
 		return;
 
-	if (__supported_pte_mask & _PAGE_NX)
-		runtime_code_page_mkexec();
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		unsigned long pf = 0;
+		md = p;
+
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+
+		if (!(md->attribute & EFI_MEMORY_WB))
+			pf |= _PAGE_PCD;
+
+		if ((md->attribute & EFI_MEMORY_XP) ||
+			(md->type == EFI_RUNTIME_SERVICES_DATA))
+			pf |= _PAGE_NX;
+
+		if (!(md->attribute & EFI_MEMORY_RO) &&
+			(md->type != EFI_RUNTIME_SERVICES_CODE))
+			pf |= _PAGE_RW;
+
+		/* Update the 1:1 mapping */
+		pfn = md->phys_addr >> PAGE_SHIFT;
+		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages, pf))
+			pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+				   md->phys_addr, md->virt_addr);
+
+		if (kernel_map_pages_in_pgd(pgd, pfn, md->virt_addr, md->num_pages, pf))
+			pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+				   md->phys_addr, md->virt_addr);
+	}
 }
 
 void __init efi_dump_pagetable(void)
-- 
2.6.2
