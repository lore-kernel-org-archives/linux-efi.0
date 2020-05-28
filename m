Return-Path: <SRS0=CLSZ=7K=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6617C433E2
	for <linux-efi@archiver.kernel.org>; Thu, 28 May 2020 12:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9570C215A4
	for <linux-efi@archiver.kernel.org>; Thu, 28 May 2020 12:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590667885;
	bh=15vT6BO6SLJKvTbMECpr6jSBvhkfxGZDulCbFJ6eCMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2QIZ4c5fhYS7tXzDrCDY5YPLEuffwQa3vt5RwkoDQsNGCvatmCkEAwN57nQCYBXlW
	 iwhY1celPpF3j679Sp/xdT1H0GVEXlQyD7SmHmoI6Ev8n1x+oWT1wWAuKbn6FZxcX3
	 l+Lc4zecOYglobnvenEdMpU/70LUhK+v5lThP3ew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbgE1MLY (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 28 May 2020 08:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388631AbgE1L4I (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 28 May 2020 07:56:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BEDB21475;
        Thu, 28 May 2020 11:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666968;
        bh=15vT6BO6SLJKvTbMECpr6jSBvhkfxGZDulCbFJ6eCMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwLYj/yz0hVrt9cfz8s8sIG1J6tjLimtg909E7CujgWUS8hJMiYvzNFQSMuEzyDb1
         Ky9tq6qmewzTcayEyg0dn0XNwjkUhLcQFsWIFKRAsOsi/JJ1MojR/gowP3TZscr/Ro
         FectpEHnP8fN8c9xTw1VBo6g7fhW+CoRm5uQoNPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Young <dyoung@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 06/47] efi/earlycon: Fix early printk for wider fonts
Date:   Thu, 28 May 2020 07:55:19 -0400
Message-Id: <20200528115600.1405808-6-sashal@kernel.org>
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

From: Dave Young <dyoung@redhat.com>

[ Upstream commit 8f592ada59b321d248391bae175cd78a12972223 ]

When I play with terminus fonts I noticed the efi early printk does
not work because the earlycon code assumes font width is 8.

Here add the code to adapt with larger fonts.  Tested with all kinds
of kernel built-in fonts on my laptop. Also tested with a local draft
patch for 14x28 !bold terminus font.

Signed-off-by: Dave Young <dyoung@redhat.com>
Link: https://lore.kernel.org/r/20200412024927.GA6884@dhcp-128-65.nay.redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/earlycon.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index 5d4f84781aa0..a52236e11e5f 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -114,14 +114,16 @@ static void efi_earlycon_write_char(u32 *dst, unsigned char c, unsigned int h)
 	const u32 color_black = 0x00000000;
 	const u32 color_white = 0x00ffffff;
 	const u8 *src;
-	u8 s8;
-	int m;
+	int m, n, bytes;
+	u8 x;
 
-	src = font->data + c * font->height;
-	s8 = *(src + h);
+	bytes = BITS_TO_BYTES(font->width);
+	src = font->data + c * font->height * bytes + h * bytes;
 
-	for (m = 0; m < 8; m++) {
-		if ((s8 >> (7 - m)) & 1)
+	for (m = 0; m < font->width; m++) {
+		n = m % 8;
+		x = *(src + m / 8);
+		if ((x >> (7 - n)) & 1)
 			*dst = color_white;
 		else
 			*dst = color_black;
-- 
2.25.1

