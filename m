From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/3] arm64/efi: remove /chosen/linux,uefi-stub-kern-ver DT property
Date: Tue,  6 Oct 2015 12:03:42 +0100
Message-ID: <1444129424-8284-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1444129424-8284-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444129424-8284-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

With the stub to kernel interface being promoted to a proper interface
so that other agents than the stub can boot the kernel proper in EFI
mode, we can remove the linux,uefi-stub-kern-ver field, considering
that its original purpose was to prevent this from happening in the
first place.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/arm/uefi.txt         | 2 --
 drivers/firmware/efi/libstub/fdt.c | 9 ---------
 2 files changed, 11 deletions(-)

diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
index d60030a1b909..7f1bed8872f3 100644
--- a/Documentation/arm/uefi.txt
+++ b/Documentation/arm/uefi.txt
@@ -58,7 +58,5 @@ linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
 --------------------------------------------------------------------------------
 linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
 --------------------------------------------------------------------------------
-linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
---------------------------------------------------------------------------------
 
 For verbose debug messages, specify 'uefi_debug' on the kernel command line.
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index ef5d764e2a27..b62e2f5dcab3 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -147,15 +147,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	if (status)
 		goto fdt_set_fail;
 
-	/*
-	 * Add kernel version banner so stub/kernel match can be
-	 * verified.
-	 */
-	status = fdt_setprop_string(fdt, node, "linux,uefi-stub-kern-ver",
-			     linux_banner);
-	if (status)
-		goto fdt_set_fail;
-
 	return EFI_SUCCESS;
 
 fdt_set_fail:
-- 
1.9.1
