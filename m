Return-Path: <SRS0=zJWN=37=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E84DC3F68F
	for <linux-efi@archiver.kernel.org>; Tue, 11 Feb 2020 23:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 260152082F
	for <linux-efi@archiver.kernel.org>; Tue, 11 Feb 2020 23:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="IPgG8KjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgBKXfs (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 11 Feb 2020 18:35:48 -0500
Received: from gateway30.websitewelcome.com ([192.185.198.26]:35516 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727847AbgBKXfs (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 11 Feb 2020 18:35:48 -0500
X-Greylist: delayed 1439 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 18:35:47 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 9133A6088
        for <linux-efi@vger.kernel.org>; Tue, 11 Feb 2020 17:11:47 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 1eh1jeXxDRP4z1eh1j6N1v; Tue, 11 Feb 2020 17:11:47 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cBlTHq1myUnTmxWI32MAqEnmPUPHIV21URB1ell4vKE=; b=IPgG8KjRZHp+MWqIjKB8NeytVK
        cKF7EQJKdjiuo/Zk/wQYgqU3+ce0tUsxukFmCFXK8nxL4gTzlvN3ydTL2SLJQPi09XQRd8xBdAatz
        Vh3FeKTwfQt8HktFsdXkqC2SO/Ww4iCvf1+n+1LbzbY331LxBxe2Ihh3rnVRKDYCZIIwRGrLh4Z8N
        yGKCf4Rd2sVLZ60nqaA5pNBFJfJuagrbVawClUyP5nu8VC2lF2v7Uum0Hr7d+a5fKLR4ug+nGKnQ8
        XxXLZRErhdiJv3R5fXcBlfo59IsgE/J7fsY6/334nhorRXFyKAkJnjcnQMgTW0MYl5ftjNQojF3sY
        ChRnsrRQ==;
Received: from [200.68.140.36] (port=17109 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j1eh0-003VF8-4n; Tue, 11 Feb 2020 17:11:46 -0600
Date:   Tue, 11 Feb 2020 17:14:21 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] efi/apple-properties: Replace zero-length array with
 flexible-array member
Message-ID: <20200211231421.GA15697@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.36
X-Source-L: No
X-Exim-ID: 1j1eh0-003VF8-4n
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.36]:17109
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertenly introduced[3] to the codebase from now on.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/firmware/efi/apple-properties.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 0e206c9e0d7a..590c9003f3b4 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -31,7 +31,7 @@ __setup("dump_apple_properties", dump_properties_enable);
 struct dev_header {
 	u32 len;
 	u32 prop_count;
-	struct efi_dev_path path[0];
+	struct efi_dev_path path[];
 	/*
 	 * followed by key/value pairs, each key and value preceded by u32 len,
 	 * len includes itself, value may be empty (in which case its len is 4)
@@ -42,7 +42,7 @@ struct properties_header {
 	u32 len;
 	u32 version;
 	u32 dev_count;
-	struct dev_header dev_header[0];
+	struct dev_header dev_header[];
 };
 
 static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
-- 
2.25.0

