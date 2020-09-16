Return-Path: <SRS0=vmFw=CZ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F57C433E2
	for <linux-efi@archiver.kernel.org>; Wed, 16 Sep 2020 19:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F05A521582
	for <linux-efi@archiver.kernel.org>; Wed, 16 Sep 2020 19:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b6z8nNIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgIPTxe (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 16 Sep 2020 15:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbgIPTxV (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 16 Sep 2020 15:53:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486C7C06174A
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2020 12:53:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s65so4532716pgb.0
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2020 12:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wdKPr4vaZGLgDdf4fb4YJOAXZq3KUMm99avxu6Rq8RM=;
        b=b6z8nNImPhp5pYkPNUfMkURdmGurmqIgJLQlvvSF0aZm2LX4hjUwxs8WDAPiQcOZXq
         sj1xnTc4hkeXtUiFem+jeTsVAOdBzreyEL2RlLeRdYQjkAhWnBWpQYm8ydvcKfx9UlcQ
         fRq7C6yO6wizXg05wdGW+B8IjU4Zo4WYagQO92Oud1iv0eA4hXRdPYGa0PZ/OeflGrG7
         CpBDVWMlkfJSnHDk5rNh1LpRFtxKvplTDLScvTK34Xb31NLH3Qd9HRDHFLrFAghKUBZU
         610PYfE1ungfT9hljbcfHtXGdOr3ofDkJhkxu4xTCUIQ0zT0uChD6ygZt609vtxYSsrF
         FpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdKPr4vaZGLgDdf4fb4YJOAXZq3KUMm99avxu6Rq8RM=;
        b=eWeebW2RiV/3Xj/rFuI1sY7uAIRKgULXzy0+KvrHCFBCAx+6HmWIzf0LI9wfcQ7Ziz
         DqWmMOeh06hOv6H6t0cZbVk13kLIFxsrFEGb7qHmfz1GsOuI/vXsEugb5m35rbhSVdRC
         yXAOtYJ8W6vw6ijo9Czbjy5E1Qfb2agv4yhqm19i5K2pc/o2I1uzm1mCg/T21tLoM0Vn
         MOdChGHx76sPw77C/HsHUMuw/+t4Yrbko0geZKxVARvF5mGef9WKkkTozI5b84uTbXd9
         fRrT/nUNqZ2XcDJ/lzpOTMbacLKrQsXgDj3fqYxbZcDz6pbjM3/CzvrCEGwDDyeBClni
         pkFw==
X-Gm-Message-State: AOAM531v58YRVCgoGgW7ljN9EmRmyeVxEF/GAAWGs4krAV/aC5xCAOA8
        8yvXfEtJ7gE/+XQHd4lsD8PUTEG2q4+jOfYpMf5VTn12XRwNnw==
X-Google-Smtp-Source: ABdhPJxkl3GKV7PCMxAgQTcubKJT4ctNlVxoQuThW5Mrl+cuX3F4q4Pf9aASZoGWvdvQtt3scBojckQLMi5V8O2Fi6w=
X-Received: by 2002:a62:5586:0:b029:13e:d13d:a108 with SMTP id
 j128-20020a6255860000b029013ed13da108mr23650516pfb.36.1600286000566; Wed, 16
 Sep 2020 12:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200914095706.3985-1-ardb@kernel.org> <CAKwvOdmSXm7cV3hB_Yp=DD0RwwDHtPzzDBU8Xj5kBREn3xqYdA@mail.gmail.com>
 <CAMj1kXGuFFUyT48EYvzFmjCP4QZi_Sk_GpBrBCaHjP7HKLhjBA@mail.gmail.com>
 <CAKwvOdmkNgi_+kfauTSLwtpVChipW851_KGJG+gBbhwRxJJORA@mail.gmail.com> <CAMj1kXHTkP7-8xscGZGXN_0Sq=BCSnt3zWqkcm8xdO11xmditA@mail.gmail.com>
In-Reply-To: <CAMj1kXHTkP7-8xscGZGXN_0Sq=BCSnt3zWqkcm8xdO11xmditA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 16 Sep 2020 12:53:09 -0700
Message-ID: <CAKwvOd=G2Rr3StUJ=oWu1L4b5y615m+uYNW-Y5sis13uqBvrYQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] ARM: use adr_l/ldr_l macros for PC-relative references
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Sep 15, 2020 at 10:55 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 16 Sep 2020 at 02:31, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Tue, Sep 15, 2020 at 2:30 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > Excellent, thanks for testing. Do you have any coverage for Thumb2
> > > builds as well? (CONFIG_THUMB2_KERNEL=y)
> >
> > Ah, right, manually testing ARCH=arm defconfig with
> > CONFIG_THUMB2_KERNEL enabled via menuconfig:
> >
> > Builds and boots for clang.
> >
> > (Also needed https://lore.kernel.org/lkml/20200915225751.274531-1-ndesaulniers@google.com/T/#u
> > for an unrelated issue).
> >
> > For GCC, I observe:
> >
> > arch/arm/vfp/vfphw.o: in function `vfp_support_entry':
> > (.text+0xa): relocation truncated to fit: R_ARM_THM_JUMP19 against
> > symbol `vfp_kmode_exception' defined in .text.unlikely section in
> > arch/arm/vfp/vfpmodule.o
> >
>
> Interesting. And this is using ld.bfd ?

$ arm-linux-gnueabihf-ld --version
GNU ld (GNU Binutils for Debian) 2.34

.text.unlikely reminds me of the sections created when profiling data
is present.  That's obviously not the case here, so maybe there's
other ways this section can be created by GCC?  I may have added a
patch recently for placing this section explicitly, which was a
prerequisite for Kees' series explicitly placing all sections.
https://lore.kernel.org/lkml/159896087937.20229.4955362311782724603.tip-bot2@tip-bot2/
Maybe that can be improved?

IIRC, LLD is able to emit range extension thunks for these cases, but
BFD does not.
-- 
Thanks,
~Nick Desaulniers
