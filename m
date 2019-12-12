Return-Path: <SRS0=J6bi=2C=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17059C43603
	for <linux-efi@archiver.kernel.org>; Thu, 12 Dec 2019 22:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB65122527
	for <linux-efi@archiver.kernel.org>; Thu, 12 Dec 2019 22:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vEFH2Vhr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfLLWfU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 12 Dec 2019 17:35:20 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45207 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730827AbfLLWfU (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 12 Dec 2019 17:35:20 -0500
Received: by mail-qt1-f194.google.com with SMTP id p5so564256qtq.12
        for <linux-efi@vger.kernel.org>; Thu, 12 Dec 2019 14:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8y+n05VSAZVzaNiEn+4pe0yu8ocwe69cUUwysAroYqI=;
        b=vEFH2VhrIzBLSQ8xBlTyA6I2+ZiEl/Nq2l+eoyZ4vSNkV7w/rsDjGiZBzFwmbHOykR
         atW/HnCWRsnRQjgdTrMiyhvecZy28qckL4To2uDDg8760VhfemyfkXYcDaqEpk7k6koK
         1dFudpEaAFGIRCQIgg/l5GJ+3gzYE/qltLmgSrTlaK/ovjjLG34pFHkZyUttGGO6YoMZ
         /PT3xvGzBAx0oE2nOaAXUaJhKwT0izh3pY/pYjpY4WFHpH85G3uafwc9VRaBIvqj8em/
         04o7DKo0559z4a63c8CNqwTEar0zdfP9ahDKfNImSf+qv0qM7SED0Qvv/CZyBiAohXC2
         5tJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8y+n05VSAZVzaNiEn+4pe0yu8ocwe69cUUwysAroYqI=;
        b=NEv9rizCIPss/HTltwf5q6RFTqtzU2YSgY30iPP2H0W3nB8KdrVwI6YfTYbZ7Ey4PG
         QEtY9A+fyCrsyVVJDjNoJjJsyYnSKkHd88b0YRADfY3qsNsHP0qlub2SaWbzu4brEQ9x
         zzGCp2FtWjtp6+5FNYre4T/nyzWeZcpYXNeNU9yHla2siYsv59O8r+1+P6cGe7y4yE7S
         Yy7aCvZB/pZ5fXqILlO6v52KtmxJlU4DkoloDT9VE96HwnatR626oykYIHUtk4ODvgJo
         xSdov7uQ/c4YJSHhC+rEANg8ZvETDmzRG648vIJU3SR1VwYCk41TBV42A+j3NP+wYhCF
         6ptg==
X-Gm-Message-State: APjAAAX4cgYiacQUfDLapyZnNPZdQicyQVz5/y4LkytjbbCP9IgyISlK
        ta305gAiD7jp71keRNklyNc=
X-Google-Smtp-Source: APXvYqx9XcfIw5Tvz7zp05joj2kEHEQ3Uikk/IsEgQL053ZFUJrRhCYoO8e9vEG0WgcRZMMN8Ot4ZA==
X-Received: by 2002:ac8:4991:: with SMTP id f17mr7672668qtq.8.1576190119318;
        Thu, 12 Dec 2019 14:35:19 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id d25sm2579762qtn.49.2019.12.12.14.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 14:35:18 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 12 Dec 2019 17:35:17 -0500
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] efi/gop: Merge 32/64-bit code
Message-ID: <20191212223516.GB10385@rani.riverdale.lan>
References: <20191212213443.24128-1-nivedita@alum.mit.edu>
 <CAKv+Gu_EDan06Cm+LC3Rr8RZhrGsRELwLQWUOLHyzhToenuG8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_EDan06Cm+LC3Rr8RZhrGsRELwLQWUOLHyzhToenuG8Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Dec 12, 2019 at 10:08:49PM +0000, Ard Biesheuvel wrote:
> Hello Arvind,
> 
> On Thu, 12 Dec 2019 at 22:34, Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > This series unifies the 32-bit and 64-bit firmware functions in gop.c.
> >
> > Patches 1, 2 and 5 are bugfix/cleanup. The merge is in patches 3/4.
> >
> 
> Which tree are these patches based on? I get a conflict applying #3
> 
Sorry, it's based on 5.5-rc1 + 3 earlier efi/gop patches in tip/efi/urgent:
	efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
	efi/gop: Return EFI_SUCCESS if a usable GOP was found
	efi/gop: Fix memory leak in __gop_query32/64()

> > Patch 1 removes __packed from the GOP structures, which is wrong but
> > didn't impact their layout.
> >
> > The UEFI spec differs from the standard gcc layout for 32-bit systems,
> > in that it specifies 64-bit alignment for 64-bit members. We have a bit
> > of a mix in the type definitions currently, with different types doing
> > one of the below:
> >         (a) nothing, if a 64-bit member happens to fall naturally on a
> >             64-bit boundary
> >         (b) explicit padding fields
> >         (c) use of __aligned_u64
> > The last method is the only one that gets the alignment requirement of
> > the structure itself correct as well as the internal layout -- is it
> > worth fixing everything to use it?
> >
> 
> Absolutely.
> 
Ok I will create a separate patch for that
> 
> > Patch 5 is to make sure that we don't wind up with a >4G framebuffer on
> > a 32-bit kernel that can only address 4G. I'm not sure if this can
> > practically happen on anything that we can run a 32-bit kernel on, but
> > UEFI specs the framebuffer physical address to be 64-bit even on 32-bit
> > systems, so I figured we might as well cover this edge case.
> >
> 
> This cannot happen. The 32-bit kernel can only run on 32-bit firmware,
> which cannot create mappings above 4 GB, so in that case, fb_base is
> guaranteed to be 32-bit addressable.
> 
Is that still true with PAE? i.e. is it conceivable that some system
uses the 36-bit address space to map PCI memory to above 4G physical
addresses, or can PAE only be used with actual RAM?

I can mostly drop patch 5 if this can't happen. I'd still like to get
rid of the unnecessary cast of fb_base if that's fine?
