Return-Path: <SRS0=d1h+=5K=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DBFC43331
	for <linux-efi@archiver.kernel.org>; Wed, 25 Mar 2020 10:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA290206F6
	for <linux-efi@archiver.kernel.org>; Wed, 25 Mar 2020 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585131200;
	bh=YoGWxBSDa8w2HaKjgI6HCFScbw5ThSeWBwlptOiz/TE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MWJdeZHJHg8H45z/WNy+EL+BYH38k/lhy0CmflD42teolhDTb6sbHju71OaRhTWSm
	 Zu6n7og7riTj16JA41I9FyXRSlThRmk75oxkf0UIt0ey0A1P6AA6DqfxaM/4vTFmSY
	 PvCsfntJ5hQX87EM9i1cHvTHI0WNVQqxEKEdgix0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgCYKNU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 25 Mar 2020 06:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgCYKNU (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 25 Mar 2020 06:13:20 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73AB3206F6
        for <linux-efi@vger.kernel.org>; Wed, 25 Mar 2020 10:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585131199;
        bh=YoGWxBSDa8w2HaKjgI6HCFScbw5ThSeWBwlptOiz/TE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y2s/IPFKUpYRXJCoE3UJfCr4MD9IRwAleMh2xexVEGbo/6v8Tdt+l+HKJtpvrt48v
         4cWlfTERVL4qXwmC4Km5B29gNryOzIulscaSeRe/h/eoopl8v8sJdaoZ7TB7N0T5W4
         MN9+OKDBb5tc98guMnBVVP6pCnw7vTnN2xTZdKt0=
Received: by mail-wm1-f52.google.com with SMTP id b12so1696038wmj.3
        for <linux-efi@vger.kernel.org>; Wed, 25 Mar 2020 03:13:19 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1NP+0TkPWO/AXqVzqKh1EMHhmzADCNyy2hblGFW660B3JdrBzt
        MusVLVf5wBTWAYaR3K9kEDoKiTeN2fGYNGoyvq8FVg==
X-Google-Smtp-Source: ADFU+vvJHI5y1nnOoWdOwcn46Rc67YSck/gQ/al4nNQHZr/R78WNYxgs+8VffdUMuf5eX56X1J8x7enaFSrMKd1oh84=
X-Received: by 2002:a7b:cb81:: with SMTP id m1mr2648477wmi.1.1585131197918;
 Wed, 25 Mar 2020 03:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200311072145.5001-1-tiwai@suse.de> <s5h4kukuyga.wl-tiwai@suse.de>
In-Reply-To: <s5h4kukuyga.wl-tiwai@suse.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Mar 2020 11:13:07 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu-GNbgqDWYvp9=ZA+SgpZC=NXgvdMLxF-AY854XF8wTmA@mail.gmail.com>
Message-ID: <CAKv+Gu-GNbgqDWYvp9=ZA+SgpZC=NXgvdMLxF-AY854XF8wTmA@mail.gmail.com>
Subject: Re: [PATCH] efi/cper: Use scnprintf() for avoiding potential buffer overflow
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 19 Mar 2020 at 17:00, Takashi Iwai <tiwai@suse.de> wrote:
>
> On Wed, 11 Mar 2020 08:21:45 +0100,
> Takashi Iwai wrote:
> >
> > Since snprintf() returns the would-be-output size instead of the
> > actual output size, the succeeding calls may go beyond the given
> > buffer limit.  Fix it by replacing with scnprintf().
> >
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>
> A gentle reminder for this forgotten patch.
> Let me know if any further changes are needed.
>


Thanks Takashi, I'll queue this up.
