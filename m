Return-Path: <SRS0=rbXi=5M=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6F3C2D0E5
	for <linux-efi@archiver.kernel.org>; Fri, 27 Mar 2020 10:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DED42072F
	for <linux-efi@archiver.kernel.org>; Fri, 27 Mar 2020 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585306765;
	bh=F0c5zcW/sx76sx67kUehl4mwaTCL3ffhJDE5AAIoebM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t6xxd+ZIWR+URrV0CXal+xRUQl44erHOjeAwVSkFkIXu+eZfC0bFHAsT5FI/a0dvp
	 w3Lb3eLhPMsdJMVRux4Az3UThsRvv2Hsbk4FOj6bt3SVzvVEQsUnRKdbFVzKymqNcS
	 6OBgxFxlmwb1ZpcEoJ1ZGQN95vDZSwqAyDgsOUE8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgC0K7Z (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 27 Mar 2020 06:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgC0K7Z (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 27 Mar 2020 06:59:25 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9DE120714;
        Fri, 27 Mar 2020 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585306764;
        bh=F0c5zcW/sx76sx67kUehl4mwaTCL3ffhJDE5AAIoebM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDuJ13rSsZOPbW2NIPz9c1fa/XuVPJpca6js/Rq329CW70kUcFtfV7F7kV2NsdBXo
         CxSu6lNutwPrePUjCYKROtMYFLq7SO+6RXTYKKYi8P5ScZvF8lhF4g1aod8LkeGLXZ
         0838GQp/6ff149lhOfaBy2rwnf7G3NjoZVu90T/0=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 1/5] ARM: decompressor: move headroom variable out of LC0
Date:   Fri, 27 Mar 2020 11:59:02 +0100
Message-Id: <20200327105906.2665-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327105906.2665-1-ardb@kernel.org>
References: <20200327105906.2665-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Before breaking up LC0 into different pieces, move out the variable
that is already place relative (given that it subtracts 'restart' in
the expression) and so its value does not need to be added to the
runtime address of the LC0 symbol itself.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/boot/compressed/head.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 2d2a42865b39..bb674febf640 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -339,7 +339,7 @@ not_angel:
 		 */
 		mov	r0, pc
 		cmp	r0, r4
-		ldrcc	r0, LC0+28
+		ldrcc	r0, .Lheadroom
 		addcc	r0, r0, pc
 		cmpcc	r4, r0
 		orrcc	r4, r4, #1		@ remember we skipped cache_on
@@ -716,9 +716,11 @@ LC0:		.word	LC0			@ r1
 		.word	_got_start		@ r11
 		.word	_got_end		@ ip
 		.word	.L_user_stack_end	@ sp
-		.word	_end - restart + 16384 + 1024*1024
 		.size	LC0, . - LC0
 
+.Lheadroom:
+		.word	_end - restart + 16384 + 1024*1024
+
 .Linflated_image_size_offset:
 		.long	(input_data_end - 4) - .
 
-- 
2.17.1

