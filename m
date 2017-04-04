From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] efi/libstub: Skip GOP with PIXEL_BLT_ONLY format
Date: Tue,  4 Apr 2017 16:27:43 +0100
Message-ID: <20170404152744.26687-2-ard.biesheuvel@linaro.org>
References: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: leif.lindholm@linaro.org, lorenzo.pieralisi@arm.com, "Cohen, Eugene" <eugene@hp.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: "Cohen, Eugene" <eugene@hp.com>

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
Signed-off-by: Eugene Cohen <eugene@hp.com>
[ardb: - move Blt() only check into the loop
       - clarify that Blt() only GOPs are unusable by the kernel]
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: <stable@vger.kernel.org> # v4.7+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
