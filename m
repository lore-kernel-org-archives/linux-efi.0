Return-Path: <SRS0=uFlG=23=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61477C33C8C
	for <linux-efi@archiver.kernel.org>; Mon,  6 Jan 2020 21:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 334032080A
	for <linux-efi@archiver.kernel.org>; Mon,  6 Jan 2020 21:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578346508;
	bh=ImuT7QasAEumpFYS+d5DxYJyizDtZbc+TYx7DAquXhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aZ4aYVdJWIOnySz35yGCcuIOtuzvxUqEInnvqHj6VScbLWL9nJ1i9ZCYOu/nzbW9x
	 Mif99iXoIyhcBQaeaDEH3XQSqaAtUC4IAR0CcIy/FUffHq1cp0LNqDucVpGGbjGt4Z
	 09TDTrGS3SLjufXLGtM1OLiX0CUVxBwi5zXyuH2Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgAFVfI (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 6 Jan 2020 16:35:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44558 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgAFVfH (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 6 Jan 2020 16:35:07 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so27439383pgl.11;
        Mon, 06 Jan 2020 13:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m5JbUZHGVS7KhF/eteOGbVRmf/p5dDdWHItMOmdV+PY=;
        b=KXEBFPr7uLQ4erGLtuIgSp+jERI4sICam+LtekOisclwM/7Qx2N3YufOUEUvR5OLLO
         XdTzdU8wj6aTXkVgZQghUWNKX8HHrujLuUn7U/6QdzzfigQDunDmhBZPk7pTbg4HAn09
         8ux3h6/ue1ptdVg7cPXq2UwMXsxX3J3i0cCAbZXn4HTwJig05+Ff2b8/ARSw65Au3Z4c
         WDfXSfvuEh9BNLMKuAY1hTMyoLvov63knvGkpmFO2OaYyzPQivH3SevLolpROMrsxRba
         mpsaWA5DwVT6nUFBEWYEFJ7GnNTFP0nIBGlGku150zrhA4iZjYHmjachj/FdlaSVvnle
         omPg==
X-Gm-Message-State: APjAAAUaDyzvedV6CbNNLujbyp3HLCfwfxN1tinkfl0NdZXKzsJpBi6I
        DUjEMlCNofyeOBCdPVIJ0v8=
X-Google-Smtp-Source: APXvYqw182QJjFmapUgFthZkzGtp0VoNIvjQLkmo3FZplcl6V6fewGd0Km+oD9FveLcEgGfjcf+wSw==
X-Received: by 2002:a62:486:: with SMTP id 128mr111783695pfe.236.1578346506948;
        Mon, 06 Jan 2020 13:35:06 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g22sm74464874pgk.85.2020.01.06.13.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 13:35:05 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 2F19740321; Mon,  6 Jan 2020 21:35:05 +0000 (UTC)
Date:   Mon, 6 Jan 2020 21:35:05 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Dave Olsthoorn <dave@bewaar.me>,
        the arch/x86 maintainers <x86@kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v10 00/10] efi/firmware/platform-x86: Add EFI embedded fw
 support
Message-ID: <20200106213505.GW11244@42.do-not-panic.com>
References: <20191210115117.303935-1-hdegoede@redhat.com>
 <66f45932-756d-0bb0-d7a8-330d61785663@redhat.com>
 <CAKv+Gu_X+UM95MJJMjT69upL9zN3H9BnUkv8s9TjcpevANbYEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_X+UM95MJJMjT69upL9zN3H9BnUkv8s9TjcpevANbYEw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Jan 03, 2020 at 12:36:04PM +0100, Ard Biesheuvel wrote:
> On Fri, 3 Jan 2020 at 12:27, Hans de Goede <hdegoede@redhat.com> wrote:
> >
> > Hi All,
> >
> > Since I send this out, efi-next has seen some changes causing the first
> > 2 patches to no longer cleanly apply. So it looks like we need to
> > merge this one bit at a time with immutable branches.
> >
> > Ard, the first 2 patches in this series should be merged through your
> > efi tree. AFAIK everyone is happy with them in their current state
> > so they are ready for merging. Can you create an immutable branch
> > with these 2 patches and merge that into your efi-next branch?
> >
> > Note if you do the immutable branch on 5.5-rc1 + just these 2 patches,
> > there will be a conflict when you merge this into efi-next, but it is
> > trivial to resolve.
> >
> 
> I will need to defer to Ingo here, as he usually applies the EFI
> changes piecemeal rather than merging my branches directly.
> 
> I'd be fine with just annotating the conflict in the pull request if
> it is trivial, though, but it is really up to Luis and Ingo to align
> here.

I don't have a tree, and firmware goes Greg's driver core tree so
actually its up to Greg and Ingo on how this gets merged. But it seems
you just have one issue to fix:

[PATCH v10 05/10] test_firmware: add support for firmware_request_platform

There is a few set of empty lines added and I had one comment on the
release of the firmware.

Other than this, I agree this seems ready to be merged.

  Luis
