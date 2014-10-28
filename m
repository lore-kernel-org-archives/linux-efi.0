From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 04/10] arm64/efi: invert UEFI memory region reservation logic
Date: Tue, 28 Oct 2014 17:18:37 +0100
Message-ID: <1414513123-20400-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1414513123-20400-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414513123-20400-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Instead of reserving the memory regions based on which types we know
need to be reserved, consider only regions of the following types as
free for general use by the OS:

EFI_LOADER_CODE
EFI_LOADER_DATA
EFI_BOOT_SERVICES_CODE
EFI_BOOT_SERVICES_DATA
EFI_CONVENTIONAL_MEMORY

Note that this also fixes a problem with the original code, which would
misidentify a EFI_RUNTIME_SERVICES_DATA region as not reserved if it
does not have the EFI_MEMORY_RUNTIME attribute set. However, it is
perfectly legal for the firmware not to request a virtual mapping for
EFI_RUNTIME_SERVICES_DATA regions that contain configuration tables, in
which case the EFI_MEMORY_RUNTIME attribute would not be set.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 95c49ebc660d..2e829148fb36 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -125,17 +125,17 @@ out:
  */
 static __init int is_reserve_region(efi_memory_desc_t *md)
 {
-	if (!is_normal_ram(md))
+	switch (md->type) {
+	case EFI_LOADER_CODE:
+	case EFI_LOADER_DATA:
+	case EFI_BOOT_SERVICES_CODE:
+	case EFI_BOOT_SERVICES_DATA:
+	case EFI_CONVENTIONAL_MEMORY:
 		return 0;
-
-	if (md->attribute & EFI_MEMORY_RUNTIME)
-		return 1;
-
-	if (md->type == EFI_ACPI_RECLAIM_MEMORY ||
-	    md->type == EFI_RESERVED_TYPE)
-		return 1;
-
-	return 0;
+	default:
+		break;
+	}
+	return is_normal_ram(md);
 }
 
 static __init void reserve_regions(void)
-- 
1.8.3.2
