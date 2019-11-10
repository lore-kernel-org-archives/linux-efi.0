Return-Path: <SRS0=TBuH=ZC=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359E7C43331
	for <linux-efi@archiver.kernel.org>; Sun, 10 Nov 2019 03:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F15215EA
	for <linux-efi@archiver.kernel.org>; Sun, 10 Nov 2019 03:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573355225;
	bh=Nie5KcE/bv2R3qZeKePgfZiKNZdaUTRXVrjT3s8MwA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cp2YWmJ9cjQDxzJScAlK2wFyrzHgDDde5/3qzJGjp0KuqdLp/FzuMm+johVQx4SY7
	 3PUUe2C5/QDesJr2/MGMhQTxZo4+CYkVt4ON5iCtFQJ6xhMtqoczYKN4CDQYVSpghi
	 WpFzgjYkCaGNAqoznZ2+ubr1E6lw4STqUtGeoYOY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfKJDHA (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfKJCpd (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC00E222C5;
        Sun, 10 Nov 2019 02:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353932;
        bh=Nie5KcE/bv2R3qZeKePgfZiKNZdaUTRXVrjT3s8MwA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/pkp0kj6GBgBPLgSBOuI2iDtreyu+i1Q9mRnSBHwscw0EllssZ4EbehiWEacEEdV
         H42VzEPuhsUkwfX8qY/OgxDcc9nPB3Ae55JloKfBopO0cBfLvxz2rmsoEM+uU0ycO1
         8B/S+EJ5mrW/IIwMn1rfC0Kg7FD5jAvhEx+FUCUo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>,
        "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 191/191] x86/efi: fix a -Wtype-limits compilation warning
Date:   Sat,  9 Nov 2019 21:40:13 -0500
Message-Id: <20191110024013.29782-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 919aef44d73d5d0c04213cb1bc31149cc074e65e ]

Compiling a kernel with W=1 generates this warning,

arch/x86/platform/efi/quirks.c:731:16: warning: comparison of unsigned
expression >= 0 is always true [-Wtype-limits]

Fixes: 3425d934fc03 ("efi/x86: Handle page faults occurring while running ...")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 669babcaf245a..c75d5ba732f18 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -684,7 +684,7 @@ void efi_recover_from_page_fault(unsigned long phys_addr)
 	 * Address range 0x0000 - 0x0fff is always mapped in the efi_pgd, so
 	 * page faulting on these addresses isn't expected.
 	 */
-	if (phys_addr >= 0x0000 && phys_addr <= 0x0fff)
+	if (phys_addr <= 0x0fff)
 		return;
 
 	/*
-- 
2.20.1

