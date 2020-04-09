Return-Path: <SRS0=7pYY=5Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79105C38A29
	for <linux-efi@archiver.kernel.org>; Thu,  9 Apr 2020 13:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5037D214DB
	for <linux-efi@archiver.kernel.org>; Thu,  9 Apr 2020 13:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586437521;
	bh=j2Uul8LoJ+xuLlVQplR6zRGNuoR46qZQgWKeGWtCP9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CHNqSk8PzINAN6ZMgu6aJCCqAmqg4fI3Hb1bTee7DWIa/BtNkDHYqppOlT8B4lyjG
	 1z+PIcOZoU5UkWbwDb2VMsCXnUsT6PXoXxD0ffUJz5/T2fLjV4PeRJf1SOfe+2ewyT
	 6luwUH2NBooUG1/DzmegmLz5Pmb/0omO8vEsxDSE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgDINFK (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgDINFJ (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 9 Apr 2020 09:05:09 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A468D214DB;
        Thu,  9 Apr 2020 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586437509;
        bh=j2Uul8LoJ+xuLlVQplR6zRGNuoR46qZQgWKeGWtCP9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FVLQHqZZ3dJFJ/Dp0qXgAM9u3DO6P8HY2BB8qSBahAVovsuk4F52Kvugkw8PW9p3
         rWlneg+YMLuxJXM6M7fMy++9jzWeKXrYcnnyk+rFmbe0thDzOQ2PpuhkdSQC09GZwQ
         LzuZsKXGkmQiuH3SDzkZE5b7r9a4DyrICFPT+5E8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Colin Ian King <colin.king@canonical.com>,
        Gary Lin <glin@suse.com>, Jiri Slaby <jslaby@suse.cz>,
        Sergey Shatunov <me@prok.pw>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5/9] efi/arm: Deal with ADR going out of range in efi_enter_kernel()
Date:   Thu,  9 Apr 2020 15:04:30 +0200
Message-Id: <20200409130434.6736-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409130434.6736-1-ardb@kernel.org>
References: <20200409130434.6736-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Commit

  0698fac4ac2a ("efi/arm: Clean EFI stub exit code from cache instead of avoiding it")

introduced a PC-relative reference to 'call_cache_fn' into
efi_enter_kernel(), which lives way at the end of head.S. In some cases,
the ARM version of the ADR instruction does not have sufficient range,
resulting in a build error:

  arch/arm/boot/compressed/head.S:1453: Error: invalid constant (fffffffffffffbe4) after fixup

ARM defines an alternative with a wider range, called ADRL, but this does
not exist for Thumb-2. At the same time, the ADR instruction in Thumb-2
has a wider range, and so it does not suffer from the same issue.

So let's switch to ADRL for ARM builds, and keep the ADR for Thumb-2 builds.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/boot/compressed/head.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 04f77214f050..61e6ee3ba75f 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1454,7 +1454,8 @@ ENTRY(efi_enter_kernel)
 		@ running beyond the PoU, and so calling cache_off below from
 		@ inside the PE/COFF loader allocated region is unsafe unless
 		@ we explicitly clean it to the PoC.
-		adr	r0, call_cache_fn		@ region of code we will
+ ARM(		adrl	r0, call_cache_fn	)
+ THUMB(		adr	r0, call_cache_fn	)	@ region of code we will
 		adr	r1, 0f				@ run with MMU off
 		bl	cache_clean_flush
 		bl	cache_off
-- 
2.17.1

