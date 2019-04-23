Return-Path: <SRS0=iU5o=SZ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E752EC10F03
	for <linux-efi@archiver.kernel.org>; Tue, 23 Apr 2019 15:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B694E218C3
	for <linux-efi@archiver.kernel.org>; Tue, 23 Apr 2019 15:38:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="utXv/2/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfDWPir (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 23 Apr 2019 11:38:47 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37444 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfDWPir (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 23 Apr 2019 11:38:47 -0400
Received: by mail-it1-f194.google.com with SMTP id u65so878476itc.2
        for <linux-efi@vger.kernel.org>; Tue, 23 Apr 2019 08:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1NsUzL5HUxwLxQfIDPCHoHdUUyWapu/O2a+fWusliTg=;
        b=utXv/2/V84UGcFz7kNfAwXu74UhF6/LkQTxNiNycptpfqVv2G4EFOXkPYF3pbzVZIq
         vc86oB8Z00KcjoGs4tf0tNZyx3sMUeR1UB8+ZJaaKRdlMLK8X4aIJ2S39zYJbOdBEF+5
         ismrgFwCwXTo0FVdPIz7EZk1hKYbktAw1CW8lKw1mwk9xGO7Ww6CHe4gD0cTPVsRumHJ
         aAPZ/yJeJ7SF8aN56tKzD5gYIHrK2rqA7/fFjCWShmWOBVkKs92ip98NYRFqqZkxGTgh
         B2Cu0Thw++I05dVlC5RbxWiq0mGpC8WLkRlFUoXZa3pR8oySmRq0vwXGA8WoNWRVN+ec
         vg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1NsUzL5HUxwLxQfIDPCHoHdUUyWapu/O2a+fWusliTg=;
        b=KUykyVW4SOFU6/ZOVv8Zc8HHea3FFDCToQh7v3/GGG54RxYNWIi/fYjWVeH4bv7Z+s
         hBjt/aEPN9hWcAqDC1duFFR0qTBInNSAT6VzS//O4pbzlffCMU/s4TlzuBlapvJg3GPr
         mYBWRxfQOkjeecUlV2LeXQ+xfNsPxnryeLzXM8VobPfp6p+ZCgDWHT8XFRgxcMvwjY1O
         8jpLRk159TG1ZrlxBj0LCV6Z0QDVVKJIneInBo1bjET50vhGeHo/4vqgIubNeVC9rvNy
         jPZVwFbaJeqeIdvhc9uIKQbFhk80+zuO/tClm7O5Wi/x5AP+ef+aeoAKDYryfeHzQviS
         082Q==
X-Gm-Message-State: APjAAAXrACv2LVCms3b5jf4n1GWPhpCvxaVyp2lxWquqmY3AG9QmUfNl
        V0TSCLZ9kOHTxO224grLD5NTfuHEVjuQh/Q2v0ndTg==
X-Google-Smtp-Source: APXvYqzkJw8doKos993bb37rgMjDWvAcdFq6av1wkh8PU+fc036LSiAXtoaaFs/CEm7I76TLX14H3VMk3BojGzJQWMo=
X-Received: by 2002:a02:1dc7:: with SMTP id 190mr2660658jaj.62.1556033926094;
 Tue, 23 Apr 2019 08:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190423144354.3465-1-ard.biesheuvel@linaro.org> <CADvTj4pYsCq8ZgcL7kELuT77URZbaDmDe-o8qj-M97e0aeCGUw@mail.gmail.com>
In-Reply-To: <CADvTj4pYsCq8ZgcL7kELuT77URZbaDmDe-o8qj-M97e0aeCGUw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 23 Apr 2019 17:38:33 +0200
Message-ID: <CAKv+Gu_EN2A9fBOuw34xw=Exjbqz_0J7BzrOb2ZuWK26ouxtCQ@mail.gmail.com>
Subject: Re: [PATCH] fbdev/efifb: ignore framebuffer memmap entries that lack
 any memory types
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, 23 Apr 2019 at 17:01, James Hilliard <james.hilliard1@gmail.com> wrote:
>
> On Tue, Apr 23, 2019 at 4:44 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Commit 38ac0287b7f4
> >
> >   ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
> >
> > updated the EFI framebuffer code to use memory mappings for the linear
> > framebuffer that are permitted by the memory attributes described by the
> > EFI memory map for the particular region, if the framebuffer happens to
> > be covered by the EFI memory map (which is typically only the case for
> > framebuffers in shared memory). This is required since non-X86 systems
> > may require cacheable attributes for memory mappings that are shared
> > with other masters (such as GPUs), and this information cannot be
> > described by the Graphics Output Protocol (GOP) EFI protocol itself,
> > and so we rely on the EFI memory map for this.
> >
> > As reported by James, this breaks some x86 systems:
> >
> >   [ 1.173368] efifb: probing for efifb
> >   [ 1.173386] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
> >   [ 1.173395] Trying to free nonexistent resource <00000000cf800000-00000000cf9d4bff>
> >   [ 1.173413] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5
> >
> > The problem turns out to be that the memory map entry that describes the
> > framebuffer has no memory attributes listed at all, and so we end up with
> > a mem_flags value of 0x0.
> >
> > So work around this by ensuring that the memory map entry's attribute field
> > has a sane value before using it to mask the set of usable attributes.
> >
> > Reported-by: James Hilliard <james.hilliard1@gmail.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >
> > James, could you give this a try please? Thanks.
> I can confirm this fixes the regression on my system, thanks.

Thanks James, I will add your tested-by.

I forgot to include EFI_MEMORY_UC in the first mask, so I will respin
and resend.

Ingo, Bartlomiej, may i suggest that we take this into tip directly as
a fix? Thanks.


> >
> >  drivers/video/fbdev/efifb.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> > index ba906876cc45..1f9949f50900 100644
> > --- a/drivers/video/fbdev/efifb.c
> > +++ b/drivers/video/fbdev/efifb.c
> > @@ -476,8 +476,11 @@ static int efifb_probe(struct platform_device *dev)
> >                  * If the UEFI memory map covers the efifb region, we may only
> >                  * remap it using the attributes the memory map prescribes.
> >                  */
> > -               mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
> > -               mem_flags &= md.attribute;
> > +               md.attribute &= EFI_MEMORY_WC | EFI_MEMORY_WT | EFI_MEMORY_WB;
> > +               if (md.attribute) {
> > +                       mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
> > +                       mem_flags &= md.attribute;
> > +               }
> >         }
> >         if (mem_flags & EFI_MEMORY_WC)
> >                 info->screen_base = ioremap_wc(efifb_fix.smem_start,
> > --
> > 2.20.1
> >
