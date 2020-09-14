Return-Path: <SRS0=ddwy=CX=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B998BC43461
	for <linux-efi@archiver.kernel.org>; Mon, 14 Sep 2020 09:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 832CC21BE5
	for <linux-efi@archiver.kernel.org>; Mon, 14 Sep 2020 09:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600077453;
	bh=ZktTHwaeE3hkSCjdusjTsi9JrBRGAVazC164mdkYVqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H63f+MZS5RjluN/7aaN9Zh3bWWFnRz0yrE4QhZ5oWIVgVKMhS/zT3Au+ex5oL7bkQ
	 qV6xAHFVdP6OdfnKqmCCsz+Gq3Wdko9/ougxZsdFbkOvlZyuOAo2mPGDyzXt5Vuovn
	 a9Gm4QfK6xeaim6JGt6Hzvyzfjg7qk44G+stjjAY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgINJ5c (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 14 Sep 2020 05:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgINJ5c (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 14 Sep 2020 05:57:32 -0400
Received: from e123331-lin.nice.arm.com (unknown [37.6.197.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 639062192A;
        Mon, 14 Sep 2020 09:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600077451;
        bh=ZktTHwaeE3hkSCjdusjTsi9JrBRGAVazC164mdkYVqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cW1LmI0SZDI8ktFDsBtRXB0+cefaZK+U3d02oWFgqAqFKroV1hWwu2dxQMr+FoWtP
         Bz35iuitbsrZqI5FP4T/iGWpLa3nrOucotZo/v5WSNueYQf9tqQGq2WkAYqNTf63zB
         r/VFQ1vHghjntZcG4n5YdqvM96fQ7iioarW7Y5Sc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 02/12] ARM: efistub: replace adrl pseudo-op with adr_l macro invocation
Date:   Mon, 14 Sep 2020 12:56:56 +0300
Message-Id: <20200914095706.3985-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200914095706.3985-1-ardb@kernel.org>
References: <20200914095706.3985-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The ARM 'adrl' pseudo instruction is a bit problematic, as it does not
exist in Thumb mode, and it is not implemented by Clang either. Since
the Thumb variant has a slightly bigger range, it is sometimes necessary
to emit the 'adrl' variant in ARM mode where Thumb mode can use adr just
fine. However, that still leaves the Clang issue, which does not appear
to be supporting this any time soon.

So let's switch to the adr_l macro, which works for both ARM and Thumb,
and has unlimited range.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/boot/compressed/head.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 434a16982e34..6a430d1f4d31 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1444,8 +1444,7 @@ ENTRY(efi_enter_kernel)
 		mov	r4, r0			@ preserve image base
 		mov	r8, r1			@ preserve DT pointer
 
- ARM(		adrl	r0, call_cache_fn	)
- THUMB(		adr	r0, call_cache_fn	)
+		adr_l	r0, call_cache_fn
 		adr	r1, 0f			@ clean the region of code we
 		bl	cache_clean_flush	@ may run with the MMU off
 
-- 
2.17.1

