From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.10 31/69] efi/libstub: Skip GOP with PIXEL_BLT_ONLY format
Date: Wed, 19 Apr 2017 16:37:00 +0200
Message-ID: <20170419141556.411296026@linuxfoundation.org>
References: <20170419141555.114738231@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170419141555.114738231@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Eugene Cohen <eugene@hp.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, leif.lindholm@linaro.org, linux-efi@vger.kernel.org, lorenzo.pieralisi@arm.com, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cohen, Eugene <eugene@hp.com>

commit 540f4c0e894f7e46a66dfa424b16424cbdc12c38 upstream.

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

Signed-off-by: Eugene Cohen <eugene@hp.com>
[ Moved the Blt() only check into the loop and clarified that Blt() only GOPs are unusable by the kernel. ]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: leif.lindholm@linaro.org
Cc: linux-efi@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com
Fixes: 9822504c1fa5 ("efifb: Enable the efi-framebuffer platform driver ...")
Link: http://lkml.kernel.org/r/20170404152744.26687-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/libstub/gop.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -149,7 +149,8 @@ setup_gop32(efi_system_table_t *sys_tabl
 
 		status = __gop_query32(sys_table_arg, gop32, &info, &size,
 				       &current_fb_base);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+		if (status == EFI_SUCCESS && (!first_gop || conout_found) &&
+		    info->pixel_format != PIXEL_BLT_ONLY) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
 			 * provide multiple GOP devices, not all of which are
@@ -266,7 +267,8 @@ setup_gop64(efi_system_table_t *sys_tabl
 
 		status = __gop_query64(sys_table_arg, gop64, &info, &size,
 				       &current_fb_base);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+		if (status == EFI_SUCCESS && (!first_gop || conout_found) &&
+		    info->pixel_format != PIXEL_BLT_ONLY) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
 			 * provide multiple GOP devices, not all of which are
