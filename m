From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] arm64: efi: apply strict permissons for UEFI Runtime Services regions
Date: Mon, 22 Feb 2016 15:25:55 +0100
Message-ID: <1456151158-25849-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1456151158-25849-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456151158-25849-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Recent UEFI versions expose permission attributes for runtime services
memory regions, either in the UEFI memory map or in the separate memory
attributes table. This allows the kernel to map these regions with
stricter permissions, rather than the RWX permissions that are used by
default. So wire this up in our mapping routine.

Note that in the absence of permission attributes, we still only map
regions of type EFI_RUNTIME_SERVICE_CODE with the executable bit set.
Also, we base the mapping attributes of EFI_MEMORY_MAPPED_IO on the
type directly rather than on the absence of the EFI_MEMORY_WB attribute.
This is more correct, but is also required for compatibility with the
upcoming support for the Memory Attributes Table, which only carries
permission attributes, not memory type attributes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 27 ++++++++++++++++----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b6abc852f2a1..3364408c154f 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -24,15 +24,32 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 	/*
 	 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
 	 * executable, everything else can be mapped with the XN bits
-	 * set.
+	 * set. Also take the new (optional) RO/XP bits into account.
 	 */
-	if ((md->attribute & EFI_MEMORY_WB) == 0)
+	if (md->type == EFI_MEMORY_MAPPED_IO)
 		prot_val = PROT_DEVICE_nGnRE;
-	else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
-		 !PAGE_ALIGNED(md->phys_addr))
+	else if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
+			   "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
+		/*
+		 * If the region is not aligned to the page size of the OS, we
+		 * can not use strict permissions, since that would also affect
+		 * the mapping attributes of the adjacent regions.
+		 */
 		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
-	else
+	else if ((md->attribute & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
+		 (EFI_MEMORY_XP | EFI_MEMORY_RO))
+		/* R-- */
+		prot_val = pgprot_val(PAGE_KERNEL_RO);
+	else if (md->attribute & EFI_MEMORY_RO)
+		/* R-X */
+		prot_val = pgprot_val(PAGE_KERNEL_ROX);
+	else if (md->attribute & EFI_MEMORY_XP ||
+		 md->type != EFI_RUNTIME_SERVICES_CODE)
+		/* RW- */
 		prot_val = pgprot_val(PAGE_KERNEL);
+	else
+		/* RWX */
+		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
-- 
2.5.0
