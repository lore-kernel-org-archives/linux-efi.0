Return-Path: <SRS0=Vl2z=D4=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9854C56201
	for <linux-efi@archiver.kernel.org>; Wed, 21 Oct 2020 20:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7775A24196
	for <linux-efi@archiver.kernel.org>; Wed, 21 Oct 2020 20:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9o+ks4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505274AbgJUUXW (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 21 Oct 2020 16:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505278AbgJUUXV (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 21 Oct 2020 16:23:21 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C219BC0613CF
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2020 13:23:21 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r10so2155039pgb.10
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2020 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+s7Ur1cmG5XqfTGOC/3u1pEc/MJLj9wk8CuInHNfl0=;
        b=u9o+ks4LjBOspKLmy2nyynqoBHh72LwZahO4wvabcZIKXobljmI08z32I7gYeTjSv8
         seryJm+J7Smc6ZmBzbscs/8VQb31DY3hgnDvlZ6xBx2A18Dol4MFV08Kme2W39g+Dgwi
         y9uOlIGO/TPcPqXUT1ko2Q7XS0xkxCjKR9VTvFDXsN8rJXW7G39x4yt2IIGUrK2Gs4bM
         I/55fD9Fw8DMf0CY2B0G8dXzK5RX5jiFDw6SpzeXeKLt2JX3SUNsLhS54aAApjuKmqIg
         TT8CQGejVYOPEycZFFTyY6EIfivQw+cZ5G+izSNSd2xfXKlylHUnqhUj4pZaHJ9Gst/6
         qtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+s7Ur1cmG5XqfTGOC/3u1pEc/MJLj9wk8CuInHNfl0=;
        b=Cja//AHUUfkZ8620+0G/j1ayFLSHH5wqzLEDuafW8D5v0Y/+Zj3W7i1pWvME01NiQN
         gEhDwE1Gx9E8+pAwpDpO3UOrfG5/aERxl4we3Sj08n5i5Yla2oeu2FayUTy9JHDHZjv0
         MGzPX+mZFunshP/QLIWKRJOVc1ohG90aoBvv4EsNlyvWF6KRAVsOvMq8G3hABFl6Z76+
         LmCvMBJ6uBR4pjHJbb1sIvlJl9TXhkhkQCquR3GUdkVhoM1fhPQU5bOIrhl7XSpiGND9
         76I5Y3/NaCgWG7LFyHxWo8/Z7/tvJbAj/dRy/kuchVzK1+nzIK1TGBdOtcbMAf64CecV
         CULQ==
X-Gm-Message-State: AOAM531yIeGaSWdNPeJLDeAGiPivMxLwsLChoNGY9whE2DvENtCOTYlC
        +VutwvkALkDtWUN0NpbC/jCCarwycF9uyosEt51ksg==
X-Google-Smtp-Source: ABdhPJwZ8di/I0Rw8/MnM4OjvLQmXHmKCdAD3LHxy/vTzE3YpGKvn1cDuXqKM3tMdH0hFxN1YJlF5IeIucQDHuvlJbk=
X-Received: by 2002:a62:1613:0:b029:152:743c:355c with SMTP id
 19-20020a6216130000b0290152743c355cmr5213068pfw.15.1603311800680; Wed, 21 Oct
 2020 13:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <e9b1ba517f06b81bd24e54c84f5e44d81c27c566.camel@perches.com>
 <CAMj1kXHe0hEDiGNMM_fg3_RYjM6B6mbKJ+1R7tsnA66ZzsiBgw@mail.gmail.com> <1cecfbfc853b2e71a96ab58661037c28a2f9280e.camel@perches.com>
In-Reply-To: <1cecfbfc853b2e71a96ab58661037c28a2f9280e.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 21 Oct 2020 13:23:08 -0700
Message-ID: <CAKwvOd=y4joNkmpvRNTiyRZuqqk1NrXXhAoSsh3e=PmGMsoC6A@mail.gmail.com>
Subject: Re: [PATCH -next] treewide: Remove stringification from __alias macro definition
To:     Joe Perches <joe@perches.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Oct 21, 2020 at 12:07 PM Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2020-10-21 at 21:02 +0200, Ard Biesheuvel wrote:
> > On Wed, 21 Oct 2020 at 20:58, Joe Perches <joe@perches.com> wrote:
> > > Like the __section macro, the __alias macro uses
> > > macro # stringification to create quotes around
> > > the section name used in the __attribute__.
> > >
> > > Remove the stringification and add quotes or a
> > > stringification to the uses instead.
> > >
> >
> > Why?
>
> Using quotes in __section caused/causes differences
> between clang and gcc.
>
> https://lkml.org/lkml/2020/9/29/2187
>
> Using common styles for details like this is good.

Luckily, there's no difference/issue here with alias as there exist
with section: https://godbolt.org/z/eWxc7P
So it's just a stylistic cleanup, not a bugfix.
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

$ grep -rn __attribute__ | grep alias

didn't turn up any other cases that look like they don't use strings.
-- 
Thanks,
~Nick Desaulniers
