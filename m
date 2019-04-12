Return-Path: <SRS0=aW0u=SO=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918E4C10F0E
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 21:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FED720869
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 21:00:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bN3i9Rm/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfDLVA3 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:00:29 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:37551 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfDLVA3 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 12 Apr 2019 17:00:29 -0400
Received: by mail-it1-f195.google.com with SMTP id u65so17975114itc.2
        for <linux-efi@vger.kernel.org>; Fri, 12 Apr 2019 14:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K0i26sKuk617rVt7PZNNuUAIxc8nj8NFqcIAFtJnK0Q=;
        b=bN3i9Rm/K9dKIn+Sa+mw/dXuMOLF89Cenx5qYMK7wTDDdeus3X78gooWspbtP/GGBC
         xdbEYbMi4KBG8fPGmgQ6JFv7Uzf/8HDU9RDyFhNmnfYLVu0kEcrRA6QVPYPGbqrJObA7
         Pw9J+HKETZAwryOUlbvluufa1dI3sqFJbBgvMaTqEmD9Vh8MyQot8q2rQEiabOHLNLP4
         a0v5oQIc1Gu/9l/9ljFFG6YRnPe6LiIHVQtH+x2H9RJrNgrUU6I8xC5uCsDilASctADT
         fN2QbRFO9abq7LSFWuP8M5HCd85+QW0XKdDmPgpnfAFcTcr+kvf/k5fm2SUCbPyM8VaD
         9sQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K0i26sKuk617rVt7PZNNuUAIxc8nj8NFqcIAFtJnK0Q=;
        b=mNLM6Phm0ZLdY2xBtz+Fdr+wGahTSBc4obEIIurRO9sifSKJsyFVcecRVD6mf1iMRn
         Q4izS0SH5xGJpBGTTPvgIyJ9RAPJpadqhT0ZctEL4FqQhLM89CrCL90bOp03fLUUKO8i
         PkILOikTR9pgyy1Sr14M5zwcx6QhDcV7G2yjpECE9iB9lrmsEBEgJLkfIC9Bhl9WLzrn
         +JaSHj2K6nCE5vypLes9hDoHtaTH+Q0liKVdm2giO21gZ2UJDn5dPp1Ac1ZMYA9FlMEU
         /sj3+QlgCb89cfwo9GXTMBwxLR4zTCAJq6WpiItldUl2h13NYZr1+EP/KxUuW22gHbXu
         aUqQ==
X-Gm-Message-State: APjAAAWSKUzGBv7HP+8soB4AhaTVxCkrH+KBGYQ46YF+lhszS5EQ8OXi
        rwz6TL/8flKGnGzXNE2dHM169VJ2R8QOYz+94hTXDozyp2FAHpdb
X-Google-Smtp-Source: APXvYqyhiDbdO/5TEhbahC1ua5b+6BnR7HzZr19pedouhtgZOHxWYX6LY5nSG7XZL4529imhUEGM/NOfDjCN7nfBtxk=
X-Received: by 2002:a24:41cd:: with SMTP id b74mr978725itd.100.1555102828722;
 Fri, 12 Apr 2019 14:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com> <20190412205834.aok6v3fnjaxl27qt@shell.armlinux.org.uk>
In-Reply-To: <20190412205834.aok6v3fnjaxl27qt@shell.armlinux.org.uk>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 12 Apr 2019 14:00:16 -0700
Message-ID:
 <CAKv+Gu_vejJz0Gh4hz75yvUcbpiDGyA0KjUS=hSgMmMv_Z1dOg@mail.gmail.com>
Subject: Re: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning
 the cache
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190412210016.3K2MJhAEI75w-cYeUo9v46-bEZpIMfLUOi4n1btQUJ4@z>

On Fri, 12 Apr 2019 at 13:58, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 12, 2019 at 01:38:12PM -0700, Ard Biesheuvel wrote:
> > On Tue, 9 Apr 2019 at 09:42, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > The EFI stub is entered with the caches and MMU enabled by the
> > > firmware, and once the stub is ready to hand over to the decompressor,
> > > we clean and disable the caches.
> > >
> > > The cache clean routines use CP15 barrier instructions, which can be
> > > disabled via SCTLR. Normally, when using the provided cache handling
> > > routines to enable the caches and MMU, this bit is enabled as well.
> > > However, but since we entered the stub with the caches already enabled,
> > > this routine is not executed before we call the cache clean routines,
> > > resulting in undefined instruction exceptions if the firmware never
> > > enabled this bit.
> > >
> > > So set the bit explicitly in the EFI entry code, but do so in a way that
> > > guarantees that the resulting code can still run on v6 cores as well
> > > (which are guaranteed to have CP15 barriers enabled)
> > >
> > > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  arch/arm/boot/compressed/head.S | 16 +++++++++++++++-
> > >  1 file changed, 15 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > > index 6c7ccb428c07..c174098acdf1 100644
> > > --- a/arch/arm/boot/compressed/head.S
> > > +++ b/arch/arm/boot/compressed/head.S
> > > @@ -1438,7 +1438,21 @@ ENTRY(efi_stub_entry)
> > >
> > >                 @ Preserve return value of efi_entry() in r4
> > >                 mov     r4, r0
> > > -               bl      cache_clean_flush
> > > +
> > > +               @ our cache maintenance code relies on CP15 barrier instructions
> > > +               @ but since we arrived here with the MMU and caches configured
> > > +               @ by UEFI, we must check that the CP15BEN bit is set in SCTLR.
> > > +               @ Note that this bit is RAO/WI on v6 and earlier, so the ISB in
> > > +               @ the enable path will be executed on v7+ only.
> > > +               mrc     p15, 0, r1, c1, c0, 0   @ read SCTLR
> > > +               tst     r1, #(1 << 5)           @ CP15BEN bit set?
> > > +               bne     0f
> > > +               orr     r1, r1, #(1 << 5)       @ CP15 barrier instructions
> > > +               mcr     p15, 0, r1, c1, c0, 0   @ write SCTLR
> > > + ARM(          .inst   0xf57ff06f              @ isb           )
> > > + THUMB(                isb                                             )
> > > +
> > > +0:             bl      cache_clean_flush
> > >                 bl      cache_off
> > >
> > >                 @ Set parameters for booting zImage according to boot protocol
> > > --
> > > 2.17.1
> > >
> >
> > Russell, do you mind if I take this through the EFI tree?
>
> Yes I do mind.
>

Fair enough

> > I had trouble logging into your patch system (it no longer recognizes my
> > email address
>
> I can't debug it based on that - what does it say?
>
> > but when I try to re-create the account, my name is already taken)
>
> Yes, duplicate accounts can't be created, but there is also a forgotten
> password feature.
>
> I've just checked and I can log in fine.
>


If I use the forgotten password feature, it tells me

"""
The email address you provided (ard.biesheuvel@linaro.org) is not
valid. Please try again.
"""

(and I am typing the numbers correctly, in case you were wondering)
