From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] x86/efi: Replace efi_pgd with efi_mm.pgd
Date: Tue, 15 Aug 2017 12:18:25 -0700
Message-ID: <1502824706-30762-3-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jlee-IBi9RG/b67k@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Since the previous patch added support for efi_mm, let's handle efi_pgd
through efi_mm and remove global variable efi_pgd.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 8ff1f95627f9..0bb98c35e178 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -187,8 +187,6 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	early_code_mapping_set_exec(0);
 }
 
-static pgd_t *efi_pgd;
-
 /*
  * We need our own copy of the higher levels of the page tables
  * because we want to avoid inserting EFI region mappings (EFI_VA_END
@@ -197,7 +195,7 @@ static pgd_t *efi_pgd;
  */
 int __init efi_alloc_page_tables(void)
 {
-	pgd_t *pgd;
+	pgd_t *pgd, *efi_pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	gfp_t gfp_mask;
@@ -225,6 +223,8 @@ int __init efi_alloc_page_tables(void)
 		return -ENOMEM;
 	}
 
+	efi_mm.pgd = efi_pgd;
+
 	return 0;
 }
 
@@ -237,6 +237,7 @@ void efi_sync_low_kernel_mappings(void)
 	pgd_t *pgd_k, *pgd_efi;
 	p4d_t *p4d_k, *p4d_efi;
 	pud_t *pud_k, *pud_efi;
+	pgd_t *efi_pgd = efi_mm.pgd;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return;
@@ -330,13 +331,12 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	unsigned long pfn, text;
 	struct page *page;
 	unsigned npages;
-	pgd_t *pgd;
+	pgd_t *pgd = efi_mm.pgd;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
 
-	efi_scratch.efi_pgt = (pgd_t *)__pa(efi_pgd);
-	pgd = efi_pgd;
+	efi_scratch.efi_pgt = (pgd_t *)__pa(pgd);
 
 	/*
 	 * It can happen that the physical address of new_memmap lands in memory
@@ -400,7 +400,7 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	unsigned long flags = _PAGE_RW;
 	unsigned long pfn;
-	pgd_t *pgd = efi_pgd;
+	pgd_t *pgd = efi_mm.pgd;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
@@ -501,7 +501,7 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 static int __init efi_update_mappings(efi_memory_desc_t *md, unsigned long pf)
 {
 	unsigned long pfn;
-	pgd_t *pgd = efi_pgd;
+	pgd_t *pgd = efi_mm.pgd;
 	int err1, err2;
 
 	/* Update the 1:1 mapping */
@@ -592,7 +592,7 @@ void __init efi_dump_pagetable(void)
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		ptdump_walk_pgd_level(NULL, swapper_pg_dir);
 	else
-		ptdump_walk_pgd_level(NULL, efi_pgd);
+		ptdump_walk_pgd_level(NULL, efi_mm.pgd);
 #endif
 }
 
-- 
2.1.4
