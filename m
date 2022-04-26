Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8D3C433F5
	for <linux-efi@archiver.kernel.org>; Tue, 26 Apr 2022 14:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbiDZOOe (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 26 Apr 2022 10:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbiDZOOd (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 26 Apr 2022 10:14:33 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4AB140A2;
        Tue, 26 Apr 2022 07:11:24 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1njLuP-0005Ql-Pw; Tue, 26 Apr 2022 16:11:17 +0200
Date:   Tue, 26 Apr 2022 15:11:15 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tom Rini <trini@konsulko.com>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [RFC PATCH 4/5] mtd_blkdevs: scan partitions on mtdblock if
 FIT_PARTITION is set
Message-ID: <Ymf9gyfkTn/x7u4S@makrotopia.org>
References: <Yma3ck/hygQ0badz@makrotopia.org>
 <Ymf5KpEAGybW8W17@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ymf5KpEAGybW8W17@infradead.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Apr 26, 2022 at 06:52:42AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 25, 2022 at 04:00:02PM +0100, Daniel Golle wrote:
> > Enable partition parsers on plain mtdblock devices in case of
> > CONFIG_FIT_PARTITION being selected.
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  drivers/mtd/mtd_blkdevs.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> > index f7317211146550..e9759c4182f8d5 100644
> > --- a/drivers/mtd/mtd_blkdevs.c
> > +++ b/drivers/mtd/mtd_blkdevs.c
> > @@ -359,7 +359,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
> >  	} else {
> >  		snprintf(gd->disk_name, sizeof(gd->disk_name),
> >  			 "%s%d", tr->name, new->devnum);
> > +#ifndef CONFIG_FIT_PARTITION
> >  		gd->flags |= GENHD_FL_NO_PART;
> > +#endif
> 
> This will just recreate the fixed regression, just with the extra
> twist of needіng a completely unrelted config option to trigger it.

Do have any alternative suggestion of how partition scanning could
be (ideally selectively) enabled for mtdblock (and ubiblock) devices?
And why it should be disabled in first place?
