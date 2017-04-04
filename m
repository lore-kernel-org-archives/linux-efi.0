From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi/libstub: Skip GOP with PIXEL_BLT_ONLY format
Date: Tue,  4 Apr 2017 17:02:35 +0100
Message-ID: <20170404160245.27812-2-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Cohen, Eugene" <eugene-VXdhtT5mjnY@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Cohen, Eugene" <eugene-VXdhtT5mjnY@public.gmane.org>

The UEFI Specification permits Graphics Output Protocol (GOP) instances
without direct framebuffer access. This is indicated in the Mode structure
with a PixelFormat enumeration value of PIXEL_BLT_ONLY. Given that the
kernel does not know how to drive a Blt() only framebuffer (which is only
permitted before ExitBootServices() anyway), we should disregard such
framebuffers when looking for a GOP instance that is suitable for use as
the boot console.

So modify the EFI GOP initialization to not use a PIXEL_BLT_ONLY instance,
preventing attempts later in boot to use an invalid screen_info.lfb_base
address.

Fixes: 9822504c1fa5 ("efifb: Enable the efi-framebuffer platform driver ...")
Signed-off-by: Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>
[ardb: - move Blt() only check into the loop
       - clarify that Blt() only GOPs are unusable by the kernel]
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/gop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 932742e4cf23..24c461dea7af 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -149,7 +149,8 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 		status = __gop_query32(sys_table_arg, gop32, &info, &size,
 				       &current_fb_base);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+		if (status == EFI_SUCCESS && (!first_gop || conout_found) &&
+		    info->pixel_format != PIXEL_BLT_ONLY) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
 			 * provide multiple GOP devices, not all of which are
@@ -266,7 +267,8 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 		status = __gop_query64(sys_table_arg, gop64, &info, &size,
 				       &current_fb_base);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+		if (status == EFI_SUCCESS && (!first_gop || conout_found) &&
+		    info->pixel_format != PIXEL_BLT_ONLY) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
 			 * provide multiple GOP devices, not all of which are
-- 
2.9.3
