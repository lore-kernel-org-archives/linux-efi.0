Return-Path: <SRS0=kHF9=DC=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD10C4363D
	for <linux-efi@archiver.kernel.org>; Fri, 25 Sep 2020 07:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39498221EB
	for <linux-efi@archiver.kernel.org>; Fri, 25 Sep 2020 07:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601017310;
	bh=bYQA1KksxrM7SaxkyjkI60HSt3WPTblP3/0Gtd4vSYA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lw783iinqSlq63rAfuvF1cX5+KIGwp++PWvfLTbVELUZZxEE4PMDTpe8rF0t4ZwlS
	 yI2OrVwqAxZCzeS0oYVw/cqEUGnjEWMUI6huLRMHQ0gNW5VrSIvTPJlWoYX8l0+ooz
	 GE/JKeNLBelDirionQUMlwibHAv1OkvF9fpQ/A5Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgIYHBt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 25 Sep 2020 03:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgIYHBt (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 25 Sep 2020 03:01:49 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A64A22211;
        Fri, 25 Sep 2020 07:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601017308;
        bh=bYQA1KksxrM7SaxkyjkI60HSt3WPTblP3/0Gtd4vSYA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U+N4QjyAMehcRUJ7lWfXzXqfrXTwmbK+cSFKnqYsq/OHprFpZM2RmkZR631IXVGR0
         R02MK4zByBAfhpfglcN7gbXj5Ai9DQ2FpaYMc7asAOB0TUGLqdqaUNScaR84rk6zbx
         SUCD/IdFUrvzNced8pIn3MS6r4hj8HJ1AAQ7PKEo=
Received: by mail-ot1-f48.google.com with SMTP id 95so1334206ota.13;
        Fri, 25 Sep 2020 00:01:48 -0700 (PDT)
X-Gm-Message-State: AOAM53018XrzWX4QRU6TEFypyK0RBb1N6rMyRVeOhvA9w+4QE0mKdJHk
        A1DDoRXq1XDtybj8r5tPPIv6c20PvO209ATFHIw=
X-Google-Smtp-Source: ABdhPJzkqyhbmwrKdXg/AqpTpftDgl2KsVGMboGt67hHWUuXK8UktR/+mXSBxIVLdAqfUUEUlPEbYWdoSQO85lrh4lY=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr1920750otk.108.1601017307399;
 Fri, 25 Sep 2020 00:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200924082833.12722-1-jlee@suse.com> <CAMj1kXE64kMU7wnMQK+k=0tjaH9OMOrzN86yJPPRkx5Nq8XBqw@mail.gmail.com>
 <20200925005049.GD31226@linux-l9pv.suse>
In-Reply-To: <20200925005049.GD31226@linux-l9pv.suse>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Sep 2020 09:01:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFtg854N4PjrV_8ZKdibYKGoEHH5NV_kjTOTt7EKPANaQ@mail.gmail.com>
Message-ID: <CAMj1kXFtg854N4PjrV_8ZKdibYKGoEHH5NV_kjTOTt7EKPANaQ@mail.gmail.com>
Subject: Re: [PATCH] efi/efivars: Create efivars mount point in the
 registration of efivars abstraction
To:     joeyli <jlee@suse.com>
Cc:     "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        Fabian Vogt <fvogt@suse.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arthur Heymans <arthur@aheymans.xyz>,
        Patrick Rudolph <patrick.rudolph@9elements.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 25 Sep 2020 at 02:51, joeyli <jlee@suse.com> wrote:
>
> Hi Ard,
>
> On Thu, Sep 24, 2020 at 12:47:46PM +0200, Ard Biesheuvel wrote:
> > On Thu, 24 Sep 2020 at 10:28, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> > >
> > > This patch moved the logic of creating efivars mount point to the
> > > registration of efivars abstraction. It's useful for userland to
> > > determine the availability of efivars filesystem by checking the
> > > existence of mount point.
> > >
> > > The 'efivars' platform device be created on generic EFI runtime services
> > > platform, so it can be used to determine the availability of efivarfs.
> > > But this approach is not available for google gsmi efivars abstraction.
> > >
> > > This patch be tested on Here on qemu-OVMF and qemu-uboot.
> > >
> > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > Cc: Matthias Brugger <mbrugger@suse.com>
> > > Cc: Fabian Vogt <fvogt@suse.com>
> > > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Arthur Heymans <arthur@aheymans.xyz>
> > > Cc: Patrick Rudolph <patrick.rudolph@9elements.com>
> > > Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> > > ---
> >
> > I take it this is v3 of [0]? If so, please explain how it deviates
> > from v2. If it doesn't deviate from v2, it is better to continue the
> > discussion in the other thread.
> >
> > For the sake of discussion, it helps to clarify the confusing nomenclature:
> >
> > a) 'efivars abstraction' - an internal kernel API that exposes EFI
> > variables, and can potentially be backed by an implementation that is
> > not EFI based (i.e., Google gsmi)
> >
> > b) efivars.ko module, built on top of the efivars abstraction, which
> > exposes EFI variables (real ones or gsmi ones) via the deprecated
> > sysfs interface
> >
> > c) efivarfs filesystem, also built on top of the efivars abstraction,
> > which exposes EFI variables (real ones or gsmi ones) via a special
> > filesystem independently of sysfs.
> >
> > Of course, the sysfs mount point we create for efivarfs is not called
> > 'efivarfs' but 'efivars'. The sysfs subdirectory we create for
> > efivars.ko is called 'vars'. Sigh.
> >
>
> Thanks for your clarification. It's useful to me!
>
> >
> > In this patch, you create the mount point for c) based on whether a)
> > gets registered (which occurs on systems with EFI Get/SetVariable
> > support or GSMI), right? So, to Greg's point, wouldn't it be easier to
> > simply check whether efivarfs is listed in /proc/filesystems?
> >
>
> Yes, I think that Greg's suggestion is good enough for a userland tool
> to detect the availability of efivarfs. You can ignore my patch.
>

Excellent! Thanks for confirming.
