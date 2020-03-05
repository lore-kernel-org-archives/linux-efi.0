Return-Path: <SRS0=pOKh=4W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5979FC3F2D1
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 08:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C24D2073D
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 08:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583396485;
	bh=ssULYyKVhpj9wQvQULueh4ByO8rBwtN38P9Wf701TCM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OL2C09QYWXstJMLj5Nxi7BGD8eoaD7ssB6OVpMLnqfrmoWwavSTYgRiKrXJ5meb0d
	 vCfLZO8HKWP0yuvfpB4RA4NF3uvgrJudt/MkKSbojto6SOha320RGATLRqfkwhyHfk
	 L1a2msz2XQDmJUptHuYw5U/YmCYUgxSy9ZW7pd1Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCEIVY (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 5 Mar 2020 03:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEIVY (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 5 Mar 2020 03:21:24 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D478F2073D
        for <linux-efi@vger.kernel.org>; Thu,  5 Mar 2020 08:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583396484;
        bh=ssULYyKVhpj9wQvQULueh4ByO8rBwtN38P9Wf701TCM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wTd3UxMmuFpVh0FzqKrjd/1nRLYdMR7A7AYqvdfM6VmWLQ0n2gbo6jZXZdAMo6ywV
         15CW2+fL2HePfB4T5APmzrE0+62qGWNOh/VDkXAz7Xp7qbi5b+8hTKgg48WnEz/xvl
         MyEPeILAQp1Z9TZ6TkGaurbkIrqMZgOYBLW9fbvo=
Received: by mail-wr1-f47.google.com with SMTP id n15so493535wrw.13
        for <linux-efi@vger.kernel.org>; Thu, 05 Mar 2020 00:21:23 -0800 (PST)
X-Gm-Message-State: ANhLgQ2NgSSAmpN4IRIRE7UyetBsfJ5UTPl6TTu7L0fzVJm6z82KyRcL
        r9MeSGP03rNNjsklA7cebg32dAo7ZllaxfGka6l2Aw==
X-Google-Smtp-Source: ADFU+vu2ZEs3C71obBszH1F7umswtBIM65yXR6M8+oeOzKJ+m4sNUBUQbJ1yrfFWi5P7QEHgKseIZZVjqxV93qfQ28A=
X-Received: by 2002:adf:a411:: with SMTP id d17mr8685399wra.126.1583396482363;
 Thu, 05 Mar 2020 00:21:22 -0800 (PST)
MIME-Version: 1.0
References: <20200305055047.6097-1-masahiroy@kernel.org> <CAKv+Gu8KfZZ_v-kUq=vwd+8MfhiOCpTG_AYA06bAuq7G-=c+WQ@mail.gmail.com>
 <CAK7LNATwBALmPjZiY6teac3FcA_BFsBVzwf5cqbVNCZSqGrHJg@mail.gmail.com>
 <CAKv+Gu-7GYj5fJjOMRQQiKhA+PYeHYcwcG6sVx5O0Pj2Ufd2rg@mail.gmail.com> <CAK7LNARL=mj3HuhjuRhZyNvcqVPYaQYN_x+71khX=6YJE-Bsng@mail.gmail.com>
In-Reply-To: <CAK7LNARL=mj3HuhjuRhZyNvcqVPYaQYN_x+71khX=6YJE-Bsng@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 5 Mar 2020 09:21:11 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu-sYi4cBzZzb3_2johni=ncwEiL3qDHMfsUtQjG+X0x1w@mail.gmail.com>
Message-ID: <CAKv+Gu-sYi4cBzZzb3_2johni=ncwEiL3qDHMfsUtQjG+X0x1w@mail.gmail.com>
Subject: Re: [PATCH] efi/libstub: avoid linking libstub/lib-ksyms.o into vmlinux
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 5 Mar 2020 at 09:16, Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Hi Ard,
>
>
> On Thu, Mar 5, 2020 at 4:47 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > If you agree, no need to resend, I'll fix it up when applying
> >
>
>
> I agree.
> Please fix it up.
>

Thank you,

Queued in efi/next
