Return-Path: <SRS0=8Umt=4J=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F67C35657
	for <linux-efi@archiver.kernel.org>; Fri, 21 Feb 2020 15:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F49206E2
	for <linux-efi@archiver.kernel.org>; Fri, 21 Feb 2020 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582299900;
	bh=48BvdhEQtUJU8+6OGE8cEsvGVyAAiBApYV9aIFVank0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PdAYJCk+IMge+nsVfejFKLY1Yvyxkkc/rGjbt1igsfpPz/SawM5/AA3zD3zD7K+KW
	 ORp3ga6eUu0W5ZLHI9PFE43JwWeptOFbD/QLqpDYLn2mWg8i+52dn3p6Ctz9pX8+ql
	 07AdR6+JrY/G81hITU9qnGJ87hKHcUYXpCXMq8V8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgBUPo7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbgBUPo7 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 21 Feb 2020 10:44:59 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C283324650
        for <linux-efi@vger.kernel.org>; Fri, 21 Feb 2020 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582299898;
        bh=48BvdhEQtUJU8+6OGE8cEsvGVyAAiBApYV9aIFVank0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EeetZYvCiRffEBrR3vT2K7sU04weXZLuuKpi/lSjnx858FiAS8Vuw5I21HOLAMJav
         V6v5Ik2uyu3LOuJIvFJCG41DwAhNvAa8DVH2Vpw1BtGiNeCsC6yHm+NeeXWSOX89Xg
         WNOFMnRpBOvnsYjFnkheYpBZB1XIrgbvhylxC5Uw=
Received: by mail-wm1-f43.google.com with SMTP id a6so2403315wme.2
        for <linux-efi@vger.kernel.org>; Fri, 21 Feb 2020 07:44:57 -0800 (PST)
X-Gm-Message-State: APjAAAXjQlRi53jhUAChhzGdYDzN94MTcYh9VSV/VWy52wpGIObrXkhF
        DqfKDfXRcF+ll6yRAJ25akisQna3hYViTx7d6ODa/A==
X-Google-Smtp-Source: APXvYqxzVHxjianXZjn/dPOJ4coC5k84JaxX22gy7hY+6Ilv2pBdV7pd1dPSP/HhLDtWoyZe+gt8xKr0YvD2FW5TBY8=
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr4493608wmj.1.1582299896175;
 Fri, 21 Feb 2020 07:44:56 -0800 (PST)
MIME-Version: 1.0
References: <20200221152430.GA20788@embeddedor>
In-Reply-To: <20200221152430.GA20788@embeddedor>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 21 Feb 2020 16:44:43 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu9wZ1PjDVQmFPaoxwyDZRYev2LAXr5vBkBGAstdf-5W7w@mail.gmail.com>
Message-ID: <CAKv+Gu9wZ1PjDVQmFPaoxwyDZRYev2LAXr5vBkBGAstdf-5W7w@mail.gmail.com>
Subject: Re: [PATCH] efi/apple-properties: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 21 Feb 2020 at 16:41, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Please don't send duplicates. I already queued this in efi/next, and
responded accordingly.

> ---
>  drivers/firmware/efi/apple-properties.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
> index 5ccf39986a14..084942846f4d 100644
> --- a/drivers/firmware/efi/apple-properties.c
> +++ b/drivers/firmware/efi/apple-properties.c
> @@ -31,7 +31,7 @@ __setup("dump_apple_properties", dump_properties_enable);
>  struct dev_header {
>         u32 len;
>         u32 prop_count;
> -       struct efi_dev_path path[0];
> +       struct efi_dev_path path[];
>         /*
>          * followed by key/value pairs, each key and value preceded by u32 len,
>          * len includes itself, value may be empty (in which case its len is 4)
> @@ -42,7 +42,7 @@ struct properties_header {
>         u32 len;
>         u32 version;
>         u32 dev_count;
> -       struct dev_header dev_header[0];
> +       struct dev_header dev_header[];
>  };
>
>  static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
> --
> 2.25.0
>
