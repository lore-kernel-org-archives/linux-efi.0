Return-Path: <SRS0=G8aV=ST=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB3BC282DA
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 19:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37F0E2073F
	for <linux-efi@archiver.kernel.org>; Wed, 17 Apr 2019 19:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="swuHrS5r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733068AbfDQTIC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:08:02 -0400
Received: from mail-it1-f179.google.com ([209.85.166.179]:40672 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732634AbfDQTIC (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 17 Apr 2019 15:08:02 -0400
Received: by mail-it1-f179.google.com with SMTP id k64so6176772itb.5
        for <linux-efi@vger.kernel.org>; Wed, 17 Apr 2019 12:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OUguioRnkkOtXfn8MCcdCtihLKJAwW4dPEPsNDxxckc=;
        b=swuHrS5rK/zw2AIHToL3i9iRG38IuAR8vjBCZv9rDrVEeBBUWX0poW/r5VShb6fIea
         LeUCc4HsagKc/1D1TLF8eUqli4aevqcrwerCLUzq+aUtaPliacRbmIGm2zLVpBguclQj
         ZloKDb1XyujFeuGCrbxt0K7LQSMVSRlo8otozaBmwvjLm/ENvD0gY6WDEyXK5668eLAb
         rAdoXlWo8M1Zv+yVV8fGiMZuoZwPPP2SZ0fTHdIX8zhYWG6hAAxTSnjSQBtST73yspau
         deRZ9ab6VhU19LRaF5qqUU8mVikHiFiuvn8MrIZ/9rPWEMB0TQqkWmk+H70HenVSEmE6
         UygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUguioRnkkOtXfn8MCcdCtihLKJAwW4dPEPsNDxxckc=;
        b=PCeLBaBzCJnuOKrEj1i8z2WzULaKrIriLXc6ciAieOaV7cF3ReHr8qRJROiEo+uF1i
         RT7dLbLSxzeazuNnvlhUM2Os/NPkPT+RVSck8GXGTreWkstfSoqId3EcdNpf65WzZKRF
         rh1SFhnkiWE3TSv6UTJeIjwGveznUqdOeSwMelV0NO6KWaqvnBl5iR0joQF5Wd0bogXW
         JVsG+9LMXDIM+ZOHmhUdlS2hZnv6EXG9ADdSIjV4SX1ZeGiDjxNeW7DK3WTfUMLnhocp
         LNhsG2j9cngjRYHy+uQYA5xSbI8utGjmgqOmdaWuNy8o6h0KadL3dUyG1/rYGODePUMu
         erGQ==
X-Gm-Message-State: APjAAAW/lC7DUdb0FMAGUmUnjPlNbltuQjKJ0ykX4MlHxG9oyOThENix
        QqMGzXzORwnzjZ8hgkgQgW+BzDI3PTSu4jO2KPu1XA==
X-Google-Smtp-Source: APXvYqyw+4+2Z1yiryHwnhu9XCRC0+/WMxExt8JlOE11w+pZeEpaV/tbOu5x8MsVDEiPCW4Wo8IQTA/IAhoqpDcpauo=
X-Received: by 2002:a05:660c:4c2:: with SMTP id v2mr121801itk.71.1555528081522;
 Wed, 17 Apr 2019 12:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190412080152.3718-1-jian-hong@endlessm.com> <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com> <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com> <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com> <CAKv+Gu_jqoKiqq4ozcPwSxLmpuaWsFKy_xyYGhECLz+KLHOjOw@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F48AFEFF2@ORSMSX114.amr.corp.intel.com> <20190417182341.GA5140@gmail.com>
In-Reply-To: <20190417182341.GA5140@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 17 Apr 2019 12:07:50 -0700
Message-ID:
 <CAKv+Gu9NJH02obRtgtNf7O7Bd8Z0SdKjsBLppGd60f6ryq6OoA@mail.gmail.com>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent] x86/reboot,
 efi: Use EFI reboot for Acer TravelMate X514-51T)
To:     Ingo Molnar <mingo@kernel.org>
Cc:     "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel Drake <drake@endlessm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        linux-efi <linux-efi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        Endless Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190417190750.l2zdyUSNSAP_4DLB7KleD5aWDrW8ZUUS2rqXc-UpsCw@z>

On Wed, 17 Apr 2019 at 11:23, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Prakhya, Sai Praneeth <sai.praneeth.prakhya@intel.com> wrote:
>
> > I will ask around internally to check if it is a good idea to make EFI
> > reboot the default method when the machine is booted in EFI mode.
>
> Or whether there's some robust signature that indicates "modern EFI
> system where EFI reboot is the primary method"?
>
> Major EFI version or ACPI version or such?
>

I am actually at Microsoft right now, and I managed to get
clarification on how Windows deals with this: Windows will attempt to
use ACPI reboot first, and will only attempt to use anything else if
that fails. EFI reset is actually its least preferred option, and so
it is highly likely that it is untested on most of the shipping x86
hardware if any of the other methods work.

So let's not touch this.
