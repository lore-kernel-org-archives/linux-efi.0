Return-Path: <SRS0=RuHd=SJ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BB4C10F0E
	for <linux-efi@archiver.kernel.org>; Sun,  7 Apr 2019 18:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FCE320870
	for <linux-efi@archiver.kernel.org>; Sun,  7 Apr 2019 18:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ufx/ySWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfDGSTx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 7 Apr 2019 14:19:53 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51666 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfDGSTx (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sun, 7 Apr 2019 14:19:53 -0400
Received: by mail-it1-f194.google.com with SMTP id s3so17309597itk.1
        for <linux-efi@vger.kernel.org>; Sun, 07 Apr 2019 11:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V08dLIq9PhwLF7upjWHwURfkJ/gBXMfnmkMKxmsotvg=;
        b=ufx/ySWBoM2zafy4ABaBUuoxiK3yeZbLwkOn4i402r25f5HSrgigHRLN3/Yzw+mOy+
         vA8ZxNVDSHMMudP4xKE3dQLlWkDTJfe4TkIM8qxbncQFlIQIIdHEF1tb1BaZ3RCRyNV4
         /TnIGHwC/V2uqNFo7gXpI42+EGamMdW6QqCt0ckf5ZSXnu9lCJAdFmGQ0E+BXN5gi/29
         DaspsHbcLQq+77ZgXHpY5oLPy+SRqNTn45sBg4K3luh+DQdgvSp6EFIRUzd7S4VopmFU
         2Y5qprV+HzLJyINPlEtTwI/1ZQaalngjsUImp1y+PzH9LPrZS12Sxqmo4zjWqWJmJDMd
         aTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V08dLIq9PhwLF7upjWHwURfkJ/gBXMfnmkMKxmsotvg=;
        b=NSDds9kKjzqGJGlVyqqtpPFCAczVDaGqUlzv2+rw2+Zl83qcBcfTc/Bw87jDVaulnU
         9U39pVSOH1G7V1ZeYOnCcbMfiZTBRgovT6/1pZig/hPMLUsuEuv9iIIgH0pa1CdIHX7i
         2vAMSZddSV+6kKekodtM/2fiPCTcVYmfB2LHi9YMNIqOw6rkMMucmvheLlg+ktrDM7nw
         Mhd2TGhWPRopksYZ6D0c8Kf2zsaLM86rGCxqn3GvUxN7YtQXYa7mkfCLbtYG3E59zmrC
         eSfoXPlglMwW9xTuvqxVguAXxiriKW/2RM6QQTZWLJVsubteZBk0k1cqAxXYQrZeAReF
         oMMw==
X-Gm-Message-State: APjAAAU2oOu3wG3Jt5lAmgSGGkU4t+lA5YveZrK4Z/s3dUBpQGCDJ+aC
        TjTapIg0o6/3torq0KUl9D1114gXUaLn/SgY9oSIufv713s=
X-Google-Smtp-Source: APXvYqxLlemWllCknVRz5m4mmfCPCZx0OEnD/F3pVoRvc8rybrVyG3DQ89t2VX+zk3yfo86vP1C0b50ePr7Wp1ibLOk=
X-Received: by 2002:a05:660c:2c5:: with SMTP id j5mr17171403itd.154.1554661192560;
 Sun, 07 Apr 2019 11:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com> <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com>
In-Reply-To: <86tvfj5t2g.wl-marc.zyngier@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 7 Apr 2019 20:19:40 +0200
Message-ID:
 <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the cache
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Steve McIntyre <steve.mcintyre@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190407181940.CrQoBWJLveRG5WNXTg0i5H1IeW2HRPznMGdA9K1-p7A@z>

On Sun, 31 Mar 2019 at 10:47, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> On Sat, 30 Mar 2019 13:10:58 +0000,
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Sat, 30 Mar 2019 at 10:50, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > >
> > > Hi Ard,
> > >
> > > On Fri, 29 Mar 2019 18:24:18 +0000,
> > > Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > The EFI stub is entered with the caches and MMU enabled by the
> > > > firmware, and once the stub is ready to hand over to the decompressor,
> > > > we clean and disable the caches.
> > > >
> > > > The cache clean routines use CP15 barrier instructions, which can be
> > > > disabled via SCTLR. Normally, when using the provided cache handling
> > > > routines to enable the caches and MMU, this bit is enabled as well.
> > > > However, but since we entered the stub with the caches already enabled,
> > > > this routine is not executed before we call the cache clean routines,
> > > > resulting in undefined instruction exceptions if the firmware never
> > > > enabled this bit.
> > > >
> > > > So set the bit explicitly in the EFI entry code.
> > > >
> > > > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > ---
> > > >  arch/arm/boot/compressed/head.S | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > >
> > > > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > > > index 6c7ccb428c07..62a49356fca3 100644
> > > > --- a/arch/arm/boot/compressed/head.S
> > > > +++ b/arch/arm/boot/compressed/head.S
> > > > @@ -1438,6 +1438,16 @@ ENTRY(efi_stub_entry)
> > > >
> > > >               @ Preserve return value of efi_entry() in r4
> > > >               mov     r4, r0
> > > > +
> > > > +             @ our cache maintenance code relies on CP15 barrier instructions
> > > > +             @ but since we arrived here with the MMU and caches configured
> > > > +             @ by UEFI, we must ensure that the use of those instructions is
> > > > +             @ enabled in the SCTLR register, since we never executed our own
> > > > +             @ cache enable routine, which is normally in charge of this.
> > > > +             mrc     p15, 0, r1, c1, c0, 0   @ read SCTLR
> > > > +             orr     r1, r1, #(1 << 5)       @ CP15 barrier instructions
> > > > +             mcr     p15, 0, r1, c1, c0, 0   @ write SCTLR
> > > > +
> > >
> > > To be on the safe side, you could add an isb here. I'm pretty sure it
> > > is immaterial on any ARMv7 core, but hey, I'm paranoid.
> > >
> >
> > Well, this is actually triggering now under KVM, so I wonder if this
> > is a regression of some kind on the host side. But the EFI stub
> > shouldn't use CP15 barriers without enabling them, so we need this
> > patch in any case.
>
> My remark was only about the lack of an ISB instruction after the
> write to SCTLR, and you're perfectly right to enable CP15BEN.
>

Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
v6. Would reading back SCTLR suffice?

> But there is something fishy. Looking at the KVM/arm64 code,
> SCTLR_EL1.CP15BEN resets to 1. If the barrier undefs in the stubs,
> something must have cleared it (or the reset code is busted...).
>
> I've dumped SCTLR from a guest running EFI (using GDB), and I do see
> SCTLR.CP15EN being set...
>

Yeah. I won't be able to dig into this for a while, but in the mean
time, I'd like to get a guest fix in in any case.
