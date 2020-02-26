Return-Path: <SRS0=gsoD=4O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118FEC4BA18
	for <linux-efi@archiver.kernel.org>; Wed, 26 Feb 2020 17:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D384324680
	for <linux-efi@archiver.kernel.org>; Wed, 26 Feb 2020 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582736857;
	bh=hdBOrNvqms6LuHkKaNu6g1GZnlXtrzXpNgMmojjUAoU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=fj/wSVJybZF97CdifVf1DZ+3uhVo6wLHRsAn/DxsPsYw9ba3WgUsUZu4zdtg5NtHw
	 Mm0NXRLzxpfS/SHAjJIDxxC0zRt40ZxjugqUrbTU28wPFRUvpGzCcftbUj72a9X7AV
	 i8lcPN3MaAvLaFd4OEMMWHbAP7CMEZmUbo0ZlM+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgBZRHh (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgBZRHh (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 26 Feb 2020 12:07:37 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0622467F
        for <linux-efi@vger.kernel.org>; Wed, 26 Feb 2020 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582736857;
        bh=hdBOrNvqms6LuHkKaNu6g1GZnlXtrzXpNgMmojjUAoU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bzckcxKBmI/41g+OQgQVT4JyCXrpKENm0o4X2kIZxb8b7Tq0Ju0jpRG4fcAQOdYBr
         em9Jx5NQojxt+gALqKJPJBcTbxAlPk9pu5yyaWvRtcaoKWLlJHHS5PFwD4W+hCT61C
         mjM3Q6lS9TwA5hp0O5wXYjKHUcEu8XFZpG7fm7fE=
Received: by mail-wr1-f47.google.com with SMTP id r17so1883656wrj.7
        for <linux-efi@vger.kernel.org>; Wed, 26 Feb 2020 09:07:36 -0800 (PST)
X-Gm-Message-State: APjAAAWJzkKReeDYB6Mb8rWzxszs9fFE85gUNNVbzG0lga6ROfYGn6+u
        0Toc3VHAqBjxRh4Vow7QDT35Yly8VBMh9u8sf5mBaA==
X-Google-Smtp-Source: APXvYqx+iElQIGWBKUiundYdfvD86tWpE7osPnNNLRATKnU/zrwkEUsr7nY9Tn2lBt1Hkf0xS0YZvAhu9gwG/tuHw0c=
X-Received: by 2002:a05:6000:110b:: with SMTP id z11mr6703799wrw.252.1582736855337;
 Wed, 26 Feb 2020 09:07:35 -0800 (PST)
MIME-Version: 1.0
References: <20200223221324.156086-1-xypron.glpk@gmx.de>
In-Reply-To: <20200223221324.156086-1-xypron.glpk@gmx.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 Feb 2020 18:07:24 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu84RKGFxFSGra__NbsYVLzu9TH7C+b02e1GxEbo5zyHFw@mail.gmail.com>
Message-ID: <CAKv+Gu84RKGFxFSGra__NbsYVLzu9TH7C+b02e1GxEbo5zyHFw@mail.gmail.com>
Subject: Re: [PATCH 1/1] efi: don't shadow i in efi_config_parse_tables()
To:     Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Sun, 23 Feb 2020 at 23:13, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
>
> Shadowing variables is generally frowned upon.
>
> Let's simply reuse the existing loop counter i instead of shadowing it.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Queued in efi/next, thanks.

> ---
>  drivers/firmware/efi/efi.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 69a585106d30..d0c7f4c1db31 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -553,7 +553,6 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
>                 while (prsv) {
>                         struct linux_efi_memreserve *rsv;
>                         u8 *p;
> -                       int i;
>
>                         /*
>                          * Just map a full page: that is what we will get
> --
> 2.25.0
>
