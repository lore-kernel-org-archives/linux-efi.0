From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] arm64: efi: always map runtime services code and data regions down to pages
Date: Wed, 29 Jun 2016 14:51:27 +0200
Message-ID: <1467204690-10790-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467204690-10790-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To avoid triggering diagnostics in the MMU code that are finicky about
splitting block mappings into more granular mappings, ensure that regions
that are likely to appear in the Memory Attributes table as well as the
UEFI memory map are always mapped down to pages. This way, we can use
apply_to_page_range() instead of create_pgd_mapping() for the second pass,
which cannot split or merge block entries, and operates strictly on PTEs.

Note that this aligns the arm64 Memory Attributes table handling code with
the ARM code, which already uses apply_to_page_range() to set the strict
permissions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h |  3 +-
 arch/arm64/kernel/efi.c      | 36 +++++++++++++++++++-
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 622db3c6474e..8b13476cdf96 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,8 +14,7 @@ extern void efi_init(void);
 #endif
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
-
-#define efi_set_mapping_permissions	efi_create_mapping
+int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define arch_efi_call_virt_setup()					\
 ({									\
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 981604948521..4aef89f37049 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -62,13 +62,47 @@ struct screen_info screen_info __section(.data);
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	pteval_t prot_val = create_mapping_protection(md);
+	bool allow_block_mappings = (md->type != EFI_RUNTIME_SERVICES_CODE &&
+				     md->type != EFI_RUNTIME_SERVICES_DATA);
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
-			   __pgprot(prot_val | PTE_NG), true);
+			   __pgprot(prot_val | PTE_NG), allow_block_mappings);
 	return 0;
 }
 
+static int __init set_permissions(pte_t *ptep, pgtable_t token,
+				  unsigned long addr, void *data)
+{
+	efi_memory_desc_t *md = data;
+	pte_t pte = *ptep;
+
+	if (md->attribute & EFI_MEMORY_RO)
+		pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
+	if (md->attribute & EFI_MEMORY_XP)
+		pte = set_pte_bit(pte, __pgprot(PTE_PXN));
+	set_pte(ptep, pte);
+	return 0;
+}
+
+int __init efi_set_mapping_permissions(struct mm_struct *mm,
+				       efi_memory_desc_t *md)
+{
+	BUG_ON(md->type != EFI_RUNTIME_SERVICES_CODE &&
+	       md->type != EFI_RUNTIME_SERVICES_DATA);
+
+	/*
+	 * Calling apply_to_page_range() is only safe on regions that are
+	 * guaranteed to be mapped down to pages. Since we are only called
+	 * for regions that have been mapped using efi_create_mapping() above
+	 * (and this is checked by the generic Memory Attributes table parsing
+	 * routines), there is no need to check that again here.
+	 */
+	return apply_to_page_range(mm, md->virt_addr,
+				   md->num_pages << EFI_PAGE_SHIFT,
+				   set_permissions, md);
+}
+
 static int __init arm64_dmi_init(void)
 {
 	/*
-- 
2.7.4
