Return-Path: <SRS0=iuKK=SL=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FE0C10F0E
	for <linux-efi@archiver.kernel.org>; Tue,  9 Apr 2019 16:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 675272084C
	for <linux-efi@archiver.kernel.org>; Tue,  9 Apr 2019 16:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oY1oyE6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfDIQmZ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:42:25 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34454 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfDIQmZ (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 9 Apr 2019 12:42:25 -0400
Received: by mail-pl1-f195.google.com with SMTP id y6so9735694plt.1
        for <linux-efi@vger.kernel.org>; Tue, 09 Apr 2019 09:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Lwv0DS81R3UDGsDpa6oEEiS09+Iy8UYSWPxuCX54ix4=;
        b=oY1oyE6jnRUWo5pShSwWr7HP2ZhWyMHmiyWwAujmXbYCDdLS+56Wmifj0wJ7X0isGD
         EvPajv/pIrjMS90xl3OiqJ7aB7aCzvgdS7M1aXDw62dS+CwaPaWuYv9W9VHmdUYl/Fam
         /SMONECHNcN65aj75YzaioGlgntom1ER8Ena7QjF12zwrn5gw8ZVVd0EstDH3zC6j9bm
         hTSXRzhlN12UGFPbRuaDvGkZbyBXiEjQaUEDaLad4B5etDAc0XDwqcT4hKBLNjy98Iq1
         BySE6fOUNso9tKGTInHAtv76iEqTEIGwJnkEOi/imUIHurKkEQuzGzC/xZTPokM6KRL1
         gFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Lwv0DS81R3UDGsDpa6oEEiS09+Iy8UYSWPxuCX54ix4=;
        b=M/nIzxIRQhmtz9+Vc0PLK2B45qUuM+VuEXfogilA9jHr7RraqhFAWz9AR351F30xhu
         3wln5m72Lzie2nHH1iseAFwCyjuRLC1Qf2NCW11OEZteAgGd2oaT59lHJPVGy5+w/jJB
         jCWVTh5gpjbKd1popOqhtdnF0DmRSsVkmvxF9Ubxq5KpCVEVF9tSrI8AnvPXDR/DM58z
         C+chWyeYmSaCpVdP0SaRECz1N/AkTt5eBE47dYGXWxKdN2IeAPJIs/5TrKLnLXsQTX7L
         Nk8Jg/OJJ33Zzhii4EcMcsprr22jgZNslevb+8pjYU2CtT+Tri9KUcLP+9H9T6nTjTYs
         ZzeQ==
X-Gm-Message-State: APjAAAW51dY/Dl5LToDZ7T+FUjEaaqZ14fNuMzMhSTXyzJxMp18C/7C6
        ZA3RMVuQiwDiPdthNSsfM968KQ==
X-Google-Smtp-Source: APXvYqzOAUmKIHRNH4pEZruDrENCmVtf/xZnd/2ih0N/6hHyAn7pMfG7JgI0AQiNDMUg1J3OrCduVg==
X-Received: by 2002:a17:902:441:: with SMTP id 59mr8471761ple.242.1554828144068;
        Tue, 09 Apr 2019 09:42:24 -0700 (PDT)
Received: from localhost.localdomain (50-205-23-12-static.hfc.comcastbusiness.net. [50.205.23.12])
        by smtp.gmail.com with ESMTPSA id j16sm44455524pfi.58.2019.04.09.09.42.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 09:42:22 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-efi@vger.kernel.org, linux@armlinux.org.uk,
        vladimir.murzin@arm.com, marc.zyngier@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning the cache
Date:   Tue,  9 Apr 2019 09:42:20 -0700
Message-Id: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190409164220.EoSwamhYnHPEt3OeDiGFn8JyasSKs8zUlOu0aqO42XE@z>

The EFI stub is entered with the caches and MMU enabled by the
firmware, and once the stub is ready to hand over to the decompressor,
we clean and disable the caches.

The cache clean routines use CP15 barrier instructions, which can be
disabled via SCTLR. Normally, when using the provided cache handling
routines to enable the caches and MMU, this bit is enabled as well.
However, but since we entered the stub with the caches already enabled,
this routine is not executed before we call the cache clean routines,
resulting in undefined instruction exceptions if the firmware never
enabled this bit.

So set the bit explicitly in the EFI entry code, but do so in a way that
guarantees that the resulting code can still run on v6 cores as well
(which are guaranteed to have CP15 barriers enabled)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/boot/compressed/head.S | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 6c7ccb428c07..c174098acdf1 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1438,7 +1438,21 @@ ENTRY(efi_stub_entry)
 
 		@ Preserve return value of efi_entry() in r4
 		mov	r4, r0
-		bl	cache_clean_flush
+
+		@ our cache maintenance code relies on CP15 barrier instructions
+		@ but since we arrived here with the MMU and caches configured
+		@ by UEFI, we must check that the CP15BEN bit is set in SCTLR.
+		@ Note that this bit is RAO/WI on v6 and earlier, so the ISB in
+		@ the enable path will be executed on v7+ only.
+		mrc	p15, 0, r1, c1, c0, 0	@ read SCTLR
+		tst	r1, #(1 << 5)		@ CP15BEN bit set?
+		bne	0f
+		orr	r1, r1, #(1 << 5)	@ CP15 barrier instructions
+		mcr	p15, 0, r1, c1, c0, 0	@ write SCTLR
+ ARM(		.inst	0xf57ff06f		@ isb		)
+ THUMB(		isb						)
+
+0:		bl	cache_clean_flush
 		bl	cache_off
 
 		@ Set parameters for booting zImage according to boot protocol
-- 
2.17.1

