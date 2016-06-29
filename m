From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] arm64: efi: avoid block mappings for unaligned UEFI memory regions
Date: Wed, 29 Jun 2016 14:51:28 +0200
Message-ID: <1467204690-10790-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467204690-10790-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When running the OS with a page size > 4 KB, we need to round up mappings
for regions that are not aligned to the OS's page size. We already avoid
block mappings for EfiRuntimeServicesCode/Data regions for other reasons,
but in the unlikely event that other unaliged regions exists that have the
EFI_MEMORY_RUNTIME attribute set, ensure that unaligned regions are always
mapped down to pages. This way, the overlapping page is guaranteed not to
be covered by a block mapping that needs to be split.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 4aef89f37049..ba9bee389fd5 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -65,6 +65,20 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 	bool allow_block_mappings = (md->type != EFI_RUNTIME_SERVICES_CODE &&
 				     md->type != EFI_RUNTIME_SERVICES_DATA);
 
+	if (!PAGE_ALIGNED(md->phys_addr) ||
+	    !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT)) {
+		/*
+		 * If the end address of this region is not aligned to page
+		 * size, the mapping is rounded up, and may end up sharing a
+		 * page frame with the next UEFI memory region. If we create
+		 * a block entry now, we may need to split it again when mapping
+		 * the next region, and support for that is going to be removed
+		 * from the MMU routines. So avoid block mappings altogether in
+		 * that case.
+		 */
+		allow_block_mappings = false;
+	}
+
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
 			   __pgprot(prot_val | PTE_NG), allow_block_mappings);
-- 
2.7.4
