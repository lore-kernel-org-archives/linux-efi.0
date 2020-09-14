Return-Path: <SRS0=ddwy=CX=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC772C43461
	for <linux-efi@archiver.kernel.org>; Mon, 14 Sep 2020 09:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93EC12192A
	for <linux-efi@archiver.kernel.org>; Mon, 14 Sep 2020 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600077490;
	bh=+oeGgbQVQqmXwzpMCEv6iAwovE39GEbRKdH/nBUyzkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qvHrHj8hUOjd4qTT114iV8+MSIW3nUzU5/sMvjepNDIBCy/qhaC7avEX6qdf7S0XF
	 F+no21pay4n2hQ9ozk+gZbr2PWrnj+0DmduPtb3wlABT0VzAFmKFKcMcouuRu5vrAl
	 E3eV5117x8jVahMd7sueoHcxPRJnlmtuLipknHoU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgINJ6J (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 14 Sep 2020 05:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgINJ6I (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 14 Sep 2020 05:58:08 -0400
Received: from e123331-lin.nice.arm.com (unknown [37.6.197.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A76820731;
        Mon, 14 Sep 2020 09:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600077488;
        bh=+oeGgbQVQqmXwzpMCEv6iAwovE39GEbRKdH/nBUyzkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUyR7ZIdhxlzKG2c/VTjO/s/ZMIeV5LO5mLQl69TP9j+/5F2m4ZiO/EhYalWdDp/X
         4vu3IkWBI76qyrQL1DEQSQxUB1alxa21/XqjtlIAiZyfuyTfncb8ZbGeCXfTgaWTID
         I7ebBrtKZ8qQgNjPvJQMy0wkYf3gK1EuXcwdDbSE=
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
Subject: [PATCH 11/12] ARM: head.S: use PC relative insn sequence to calculate PHYS_OFFSET
Date:   Mon, 14 Sep 2020 12:57:05 +0300
Message-Id: <20200914095706.3985-12-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200914095706.3985-1-ardb@kernel.org>
References: <20200914095706.3985-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Replace the open coded arithmetic with a simple adr_l/sub pair. This
removes some open coded arithmetic involving virtual addresses, avoids
literal pools on v7+, and slightly reduces the footprint of the code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/kernel/head.S | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6f334df5d3b9..2e6127b2662e 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -103,10 +103,8 @@ ENTRY(stext)
 #endif
 
 #ifndef CONFIG_XIP_KERNEL
-	adr	r3, 2f
-	ldmia	r3, {r4, r8}
-	sub	r4, r3, r4			@ (PHYS_OFFSET - PAGE_OFFSET)
-	add	r8, r8, r4			@ PHYS_OFFSET
+	adr_l	r8, _text			@ __pa(_text)
+	sub	r8, r8, #TEXT_OFFSET		@ PHYS_OFFSET
 #else
 	ldr	r8, =PLAT_PHYS_OFFSET		@ always constant in this case
 #endif
@@ -158,10 +156,6 @@ ENTRY(stext)
 1:	b	__enable_mmu
 ENDPROC(stext)
 	.ltorg
-#ifndef CONFIG_XIP_KERNEL
-2:	.long	.
-	.long	PAGE_OFFSET
-#endif
 
 /*
  * Setup the initial page tables.  We only setup the barest
-- 
2.17.1

