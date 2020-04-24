Return-Path: <SRS0=8DUf=6I=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E884CC54FCB
	for <linux-efi@archiver.kernel.org>; Fri, 24 Apr 2020 13:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C764120728
	for <linux-efi@archiver.kernel.org>; Fri, 24 Apr 2020 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587733696;
	bh=2mZCKtYRxieeXbekBkiiyJNTO6FmbsTF0OKojHO/iqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WYx2f/pIp9OLp6VjeoLKNargp5CwPJa5ERnWMEJW9tk96O0MjfwQVB7jF57rbjZLz
	 LWv6OTNm5adxgLeA3ipZw8syV2OSXcke0T3sGHJy0PCRCT1Cb4rOKREvPzLX6wgzjy
	 sy2NE8nP14/suIRCEc5PKFDM7/Rvwg9WuADx08S8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgDXNG1 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgDXNG0 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 24 Apr 2020 09:06:26 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94F921655;
        Fri, 24 Apr 2020 13:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587733585;
        bh=2mZCKtYRxieeXbekBkiiyJNTO6FmbsTF0OKojHO/iqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kk+GsYR2+pabwwlKSl+YvbWXH8xIXMXrus/J+waWOMMx336TMnExtBL2q8ceeKDW7
         9vM6a2Dg+C9htwH/k86kl5YneL37sYEjJtMkbPnt5HjQVhBEK2LMkT/DpZCntWVPGP
         wJ2ivyj6QZmRh7LFX9XRJpWrZ8lwnLoB1JmSvZxE=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH 06/33] efi/gop: Move check for framebuffer before con_out
Date:   Fri, 24 Apr 2020 15:05:04 +0200
Message-Id: <20200424130531.30518-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424130531.30518-1-ardb@kernel.org>
References: <20200424130531.30518-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

If the gop doesn't have a framebuffer, there's no point in checking for
con_out support.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200320020028.1936003-3-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index f40d535dccb8..201b66970b2b 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -113,15 +113,16 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		if (status != EFI_SUCCESS)
 			continue;
 
+		mode = efi_table_attr(gop, mode);
+		info = efi_table_attr(mode, info);
+		if (info->pixel_format == PIXEL_BLT_ONLY)
+			continue;
+
 		status = efi_bs_call(handle_protocol, h, &conout_proto, &dummy);
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
-		mode = efi_table_attr(gop, mode);
-		info = efi_table_attr(mode, info);
-
-		if ((!first_gop || conout_found) &&
-		    info->pixel_format != PIXEL_BLT_ONLY) {
+		if (!first_gop || conout_found) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
 			 * provide multiple GOP devices, not all of which are
-- 
2.17.1

