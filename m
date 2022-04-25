Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D86CC433F5
	for <linux-efi@archiver.kernel.org>; Mon, 25 Apr 2022 15:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbiDYPDO (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 25 Apr 2022 11:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiDYPDN (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 25 Apr 2022 11:03:13 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3548011C986;
        Mon, 25 Apr 2022 08:00:09 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1nj0C7-0000qH-6k; Mon, 25 Apr 2022 17:00:07 +0200
Date:   Mon, 25 Apr 2022 16:00:02 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Tom Rini <trini@konsulko.com>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [RFC PATCH 4/5] mtd_blkdevs: scan partitions on mtdblock if
 FIT_PARTITION is set
Message-ID: <Yma3ck/hygQ0badz@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Enable partition parsers on plain mtdblock devices in case of
CONFIG_FIT_PARTITION being selected.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/mtd/mtd_blkdevs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index f7317211146550..e9759c4182f8d5 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -359,7 +359,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	} else {
 		snprintf(gd->disk_name, sizeof(gd->disk_name),
 			 "%s%d", tr->name, new->devnum);
+#ifndef CONFIG_FIT_PARTITION
 		gd->flags |= GENHD_FL_NO_PART;
+#endif
 	}
 
 	set_capacity(gd, ((u64)new->size * tr->blksize) >> 9);
-- 
2.36.0

