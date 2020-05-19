Return-Path: <SRS0=DG+M=7B=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAC9C433DF
	for <linux-efi@archiver.kernel.org>; Tue, 19 May 2020 16:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7FD20823
	for <linux-efi@archiver.kernel.org>; Tue, 19 May 2020 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589905627;
	bh=C7HgoJDn2kYqnmr2QmhsUs8JI2aan9kSJKl1W84BSOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yVsxir07Zl1L2uDrg9o/iMds2jCKGRl/+UfX8Oe44CIwy29A1/BNEITVFx/+jE09z
	 HcpR1tyCRU4UnfyP+7DICI7HFV03BR9C8hztMWjfPgCz3dkyPAx5GuA9sVd1nNFBMV
	 ecnHKf2PW0lISGgMwSTfmrew6yRryB7uXH07YZso=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgESQ1H (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 19 May 2020 12:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgESQ1G (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 19 May 2020 12:27:06 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0249207FB;
        Tue, 19 May 2020 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589905626;
        bh=C7HgoJDn2kYqnmr2QmhsUs8JI2aan9kSJKl1W84BSOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oBt2noI2iW40P3wwK0l9PNHZKrkxe+NIZa8eCEdhjgy0nFm8fNmlz3i1YWqaoh3z
         momG0znFpyDre4CAVNy8I1vwWNBluT/ptuf9gKIaU5KZnmtx1M9muJ1T3wc4bgmdsm
         oeo3et6vAyCfNgS+qQKm5jyJ1o4t4Cmt8PjWdZ5g=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH v4 3/5] ARM: decompressor: defer loading of the contents of the LC0 structure
Date:   Tue, 19 May 2020 18:26:43 +0200
Message-Id: <20200519162645.31065-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200519162645.31065-1-ardb@kernel.org>
References: <20200519162645.31065-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The remaining contents of LC0 are only used after the point in the
decompressor startup code where we enter via 'wont_overwrite'. So
move the loading of the LC0 structure after it. This will allow us
to jump to wont_overwrite directly from the EFI stub, and execute
the decompressor in place at the offset it was loaded by the UEFI
firmware.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
---
 arch/arm/boot/compressed/head.S | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 5d712e2c0001..ce442ec5028a 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -299,10 +299,6 @@ restart:	adr	r0, LC1
 		add	sp, sp, r0
 		add	r6, r6, r0
 
-		adr	r0, LC0
-		ldmia	r0, {r1, r2, r3, r11, r12}
-		sub	r0, r0, r1		@ calculate the delta offset
-
 		get_inflated_image_size	r9, r10, lr
 
 #ifndef CONFIG_ZBOOT_ROM
@@ -320,9 +316,6 @@ restart:	adr	r0, LC1
 		mov	r5, #0			@ init dtb size to 0
 #ifdef CONFIG_ARM_APPENDED_DTB
 /*
- *   r0  = delta
- *   r2  = BSS start
- *   r3  = BSS end
  *   r4  = final kernel address (possibly with LSB set)
  *   r5  = appended dtb size (still unknown)
  *   r6  = _edata
@@ -330,8 +323,6 @@ restart:	adr	r0, LC1
  *   r8  = atags/device tree pointer
  *   r9  = size of decompressed image
  *   r10 = end of this image, including  bss/stack/malloc space if non XIP
- *   r11 = GOT start
- *   r12 = GOT end
  *   sp  = stack pointer
  *
  * if there are device trees (dtb) appended to zImage, advance r10 so that the
@@ -379,7 +370,6 @@ restart:	adr	r0, LC1
 		/* temporarily relocate the stack past the DTB work space */
 		add	sp, sp, r5
 
-		stmfd	sp!, {r0-r3, ip, lr}
 		mov	r0, r8
 		mov	r1, r6
 		mov	r2, r5
@@ -398,7 +388,6 @@ restart:	adr	r0, LC1
 		mov	r2, r5
 		bleq	atags_to_fdt
 
-		ldmfd	sp!, {r0-r3, ip, lr}
 		sub	sp, sp, r5
 #endif
 
@@ -535,6 +524,10 @@ dtb_check_done:
 		mov	pc, r0
 
 wont_overwrite:
+		adr	r0, LC0
+		ldmia	r0, {r1, r2, r3, r11, r12}
+		sub	r0, r0, r1		@ calculate the delta offset
+
 /*
  * If delta is zero, we are running at the address we were linked at.
  *   r0  = delta
-- 
2.17.1

