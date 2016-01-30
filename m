From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] x86/efi: Map EFI_MEMORY_{XP,RO} memory region bits to EFI page tables
Date: Fri, 29 Jan 2016 17:04:40 -0800
Message-ID: <1454115880-6914-3-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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

Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/efi.h     |  2 +-
 arch/x86/platform/efi/efi.c    |  9 +++++++--
 arch/x86/platform/efi/efi_64.c | 45 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 49 insertions(+), 7 deletions(-)

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
index 52ca4615826c..c18df5441305 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -943,7 +943,6 @@ static void __init __efi_enter_virtual_mode(void)
 	}
 
 	efi_sync_low_kernel_mappings();
-	efi_dump_pagetable();
 
 	if (efi_is_native()) {
 		status = phys_efi_set_virtual_address_map(
@@ -981,7 +980,13 @@ static void __init __efi_enter_virtual_mode(void)
 
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
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a6277b79aa99..49e4dd4a1f58 100644
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
2.1.4
