Return-Path: <SRS0=aW0u=SO=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3451C10F0E
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 20:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415CE20869
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 20:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="eKDtNqUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfDLU6m (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 12 Apr 2019 16:58:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58814 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfDLU6m (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 12 Apr 2019 16:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hdLZEDyQF1uKDeQpIH2d490lmdZeP2uQrnUxm33A+ZY=; b=eKDtNqUHLM93jDMKp18fcpOa3
        aoxXel5ARSStrBZ8ZLVJxXZsvF48t256lHTZ7XMcoUSreKGfbq/SXZLnt6E59+Og6tQeLfoTg2e7t
        UmusREgKpRISJrYrYAxk9h5poL+Ib4uXyGWQZReuJnOgMPlP3HH7gJzWoJVCS+sdGo3tK7dy7J3qt
        Du7qRKCAqE3netwJpK3lXz76u/ipOHP0K7U8yLyzB2KzlwfTY9TM+dRedd3QmBFoXCwybtXg5IdGS
        AU3UdFJ8ck1wdkIXvbrv4y08JmbzNxahfgq/xfoGGhwEbJkigdKVJswkAMJsAklCkQ3BE1vpbzwzQ
        WD0fvOjqQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37734)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hF3Fs-0003Dx-Qb; Fri, 12 Apr 2019 21:58:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hF3Fq-00058T-UQ; Fri, 12 Apr 2019 21:58:34 +0100
Date:   Fri, 12 Apr 2019 21:58:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning
 the cache
Message-ID: <20190412205834.aok6v3fnjaxl27qt@shell.armlinux.org.uk>
References: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190412205834.5eKO1Q2gINnvWCjPxXmANa3NHwuU6nU4G7qJfD6XMuU@z>

On Fri, Apr 12, 2019 at 01:38:12PM -0700, Ard Biesheuvel wrote:
> On Tue, 9 Apr 2019 at 09:42, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > The EFI stub is entered with the caches and MMU enabled by the
> > firmware, and once the stub is ready to hand over to the decompressor,
> > we clean and disable the caches.
> >
> > The cache clean routines use CP15 barrier instructions, which can be
> > disabled via SCTLR. Normally, when using the provided cache handling
> > routines to enable the caches and MMU, this bit is enabled as well.
> > However, but since we entered the stub with the caches already enabled,
> > this routine is not executed before we call the cache clean routines,
> > resulting in undefined instruction exceptions if the firmware never
> > enabled this bit.
> >
> > So set the bit explicitly in the EFI entry code, but do so in a way that
> > guarantees that the resulting code can still run on v6 cores as well
> > (which are guaranteed to have CP15 barriers enabled)
> >
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm/boot/compressed/head.S | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > index 6c7ccb428c07..c174098acdf1 100644
> > --- a/arch/arm/boot/compressed/head.S
> > +++ b/arch/arm/boot/compressed/head.S
> > @@ -1438,7 +1438,21 @@ ENTRY(efi_stub_entry)
> >
> >                 @ Preserve return value of efi_entry() in r4
> >                 mov     r4, r0
> > -               bl      cache_clean_flush
> > +
> > +               @ our cache maintenance code relies on CP15 barrier instructions
> > +               @ but since we arrived here with the MMU and caches configured
> > +               @ by UEFI, we must check that the CP15BEN bit is set in SCTLR.
> > +               @ Note that this bit is RAO/WI on v6 and earlier, so the ISB in
> > +               @ the enable path will be executed on v7+ only.
> > +               mrc     p15, 0, r1, c1, c0, 0   @ read SCTLR
> > +               tst     r1, #(1 << 5)           @ CP15BEN bit set?
> > +               bne     0f
> > +               orr     r1, r1, #(1 << 5)       @ CP15 barrier instructions
> > +               mcr     p15, 0, r1, c1, c0, 0   @ write SCTLR
> > + ARM(          .inst   0xf57ff06f              @ isb           )
> > + THUMB(                isb                                             )
> > +
> > +0:             bl      cache_clean_flush
> >                 bl      cache_off
> >
> >                 @ Set parameters for booting zImage according to boot protocol
> > --
> > 2.17.1
> >
> 
> Russell, do you mind if I take this through the EFI tree?

Yes I do mind.

> I had trouble logging into your patch system (it no longer recognizes my
> email address

I can't debug it based on that - what does it say?

> but when I try to re-create the account, my name is already taken)

Yes, duplicate accounts can't be created, but there is also a forgotten
password feature.

I've just checked and I can log in fine.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
