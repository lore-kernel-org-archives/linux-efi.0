Return-Path: <SRS0=CLSZ=7K=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667BAC433E1
	for <linux-efi@archiver.kernel.org>; Thu, 28 May 2020 12:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E11E21841
	for <linux-efi@archiver.kernel.org>; Thu, 28 May 2020 12:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590667882;
	bh=wa6gO+L0hyvh69MnAos/uWPgEGhyjuAYeC+eZMTDkvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KlrOWKpMv9SxwOY0BBjaIJsDkt7B6DeYpQTPhxLd6Emsf/yhQTpsTasmCal8FztoC
	 uW/9jiaBCrrdb4RI2J0sSz4ixF8osbp5A5v80BiEc3XUNQBrHrZrzzplaq8Cwsbl3K
	 cChnq+/kmTUaDKyRZieDM+NXPidz7JTU6Ish49xE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbgE1L4J (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 28 May 2020 07:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388627AbgE1L4F (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 28 May 2020 07:56:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E24E2089D;
        Thu, 28 May 2020 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666964;
        bh=wa6gO+L0hyvh69MnAos/uWPgEGhyjuAYeC+eZMTDkvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTmpvVDKKWOcQUppyyCLtmomEctta478cZ2L19Ivj83IWYxVibKYprxeF4591ww+s
         LL1zIsNAgwnhMorfU/IoLt1fyhldd5cYUhmIqOpMPAqiQDYCKQwAWLlQWvFk0dB4wd
         YWwmI+7Q9va3k5gbmvRFnINpPY+4pZ47xeB9f+kk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 03/47] efi/libstub: Avoid returning uninitialized data from setup_graphics()
Date:   Thu, 28 May 2020 07:55:16 -0400
Message-Id: <20200528115600.1405808-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

[ Upstream commit 081d5150845ba3fa49151a2f55d3cc03b0987509 ]

Currently, setup_graphics() ignores the return value of efi_setup_gop(). As
AllocatePool() does not zero out memory, the screen information table will
contain uninitialized data in this case.

We should free the screen information table if efi_setup_gop() returns an
error code.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Link: https://lore.kernel.org/r/20200426194946.112768-1-xypron.glpk@gmx.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 7bbef4a67350..30e77a9e62b2 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -59,7 +59,11 @@ static struct screen_info *setup_graphics(void)
 		si = alloc_screen_info();
 		if (!si)
 			return NULL;
-		efi_setup_gop(si, &gop_proto, size);
+		status = efi_setup_gop(si, &gop_proto, size);
+		if (status != EFI_SUCCESS) {
+			free_screen_info(si);
+			return NULL;
+		}
 	}
 	return si;
 }
-- 
2.25.1

