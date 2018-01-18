From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V4 2/3] x86/efi: Replace efi_pgd with efi_mm.pgd
Date: Thu, 18 Jan 2018 13:01:31 -0800
Message-ID: <1516309291-24021-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Since the previous patch added support for efi_mm, let's handle efi_pgd
through efi_mm and remove global variable efi_pgd.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c9f8e6924df7..c93f59731608 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -191,8 +191,6 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	early_code_mapping_set_exec(0);
 }
 
-static pgd_t *efi_pgd;
-
 /*
  * We need our own copy of the higher levels of the page tables
  * because we want to avoid inserting EFI region mappings (EFI_VA_END
@@ -204,7 +202,7 @@ static pgd_t *efi_pgd;
  */
 int __init efi_alloc_page_tables(void)
 {
-	pgd_t *pgd;
+	pgd_t *pgd, *efi_pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	gfp_t gfp_mask;
@@ -232,6 +230,7 @@ int __init efi_alloc_page_tables(void)
 		return -ENOMEM;
 	}
 
+	efi_mm.pgd = efi_pgd;
 	mm_init_cpumask(&efi_mm);
 	init_new_context(NULL, &efi_mm);
 
@@ -247,6 +246,7 @@ void efi_sync_low_kernel_mappings(void)
 	pgd_t *pgd_k, *pgd_efi;
 	p4d_t *p4d_k, *p4d_efi;
 	pud_t *pud_k, *pud_efi;
+	pgd_t *efi_pgd = efi_mm.pgd;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return;
@@ -340,7 +340,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	unsigned long pfn, text, pf;
 	struct page *page;
 	unsigned npages;
-	pgd_t *pgd;
+	pgd_t *pgd = efi_mm.pgd;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
@@ -350,8 +350,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	 * this value is loaded into cr3 the PGD will be decrypted during
 	 * the pagetable walk.
 	 */
-	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(efi_pgd);
-	pgd = efi_pgd;
+	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(pgd);
 
 	/*
 	 * It can happen that the physical address of new_memmap lands in memory
@@ -421,7 +420,7 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	unsigned long flags = _PAGE_RW;
 	unsigned long pfn;
-	pgd_t *pgd = efi_pgd;
+	pgd_t *pgd = efi_mm.pgd;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
@@ -525,7 +524,7 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 static int __init efi_update_mappings(efi_memory_desc_t *md, unsigned long pf)
 {
 	unsigned long pfn;
-	pgd_t *pgd = efi_pgd;
+	pgd_t *pgd = efi_mm.pgd;
 	int err1, err2;
 
 	/* Update the 1:1 mapping */
@@ -622,7 +621,7 @@ void __init efi_dump_pagetable(void)
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		ptdump_walk_pgd_level(NULL, swapper_pg_dir);
 	else
-		ptdump_walk_pgd_level(NULL, efi_pgd);
+		ptdump_walk_pgd_level(NULL, efi_mm.pgd);
 #endif
 }
 
-- 
2.1.4
