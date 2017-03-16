From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/libstub: skip GOP with PIXEL_BLT_ONLY format
Date: Thu, 16 Mar 2017 07:51:02 +0000
Message-ID: <1489650662-3598-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, "Cohen, Eugene" <eugene-VXdhtT5mjnY@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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

Signed-off-by: Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>
[ardb: clarify that Blt() only GOPs are unusable by the kernel]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/gop.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 932742e4cf23..b05b282b470d 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -178,6 +178,10 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 	if (!first_gop)
 		goto out;
 
+	/* Does the GOP implement a BLT-only framebuffer? */
+	if (pixel_format == PIXEL_BLT_ONLY)
+		goto out;
+
 	/* EFI framebuffer */
 	si->orig_video_isVGA = VIDEO_TYPE_EFI;
 
@@ -295,6 +299,10 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 	if (!first_gop)
 		goto out;
 
+	/* Does the GOP implement a BLT-only framebuffer? */
+	if (pixel_format == PIXEL_BLT_ONLY)
+		goto out;
+
 	/* EFI framebuffer */
 	si->orig_video_isVGA = VIDEO_TYPE_EFI;
 
-- 
2.7.4
