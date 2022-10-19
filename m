Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C2EC433FE
	for <linux-efi@archiver.kernel.org>; Wed, 19 Oct 2022 07:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJSHU5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 19 Oct 2022 03:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJSHUv (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 19 Oct 2022 03:20:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E0773C30;
        Wed, 19 Oct 2022 00:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D5AC6179B;
        Wed, 19 Oct 2022 07:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0733C43470;
        Wed, 19 Oct 2022 07:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666164047;
        bh=of0ZAKA9tXwjIpzkLxVj0WEzoODLE+HML3Zt/NyW1FI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rth+6yIaIPUoMoM1pxucaWlgEMssAO8Eru2d0JwqA3zpx1ntiE3YBzXYseEVpxEW1
         Te8mnjIjNvDTSKzNnhxdq4NtkS3sGrrX4YS78GMWNTR40Y/+meT+D6rV3uuvYuB6T4
         Gw8/tr+OQwlVGJfjYrpxxpHZTfJ7CJREowoiRS6Z4EbVDqol3rDoo0dHQXxJo650kV
         32MmU5AZaFqlIgRr2IoWEWHT3ssDT9S3UpGsXSsAvY89uPxXutEAGrGP8+BRGjHXVT
         VXgWDHzvPBLmCS690TSGaRF4uxkxFCMhHYAHlURsbAs7C1KuCiFb5zCRH2CW1CyrJu
         xq8cd//S49iFg==
Received: by mail-lj1-f175.google.com with SMTP id a6so21001584ljq.5;
        Wed, 19 Oct 2022 00:20:47 -0700 (PDT)
X-Gm-Message-State: ACrzQf3NXTmJUzlQAYvxZIV/ymhMsLGMMnLsYKWv8qG89c7faCSZzTVr
        vZpU6AqsoNMBtMSiKEuAjGfFwi021BC2YzF00MA=
X-Google-Smtp-Source: AMsMyM79wv2U9Np07awqzvnz6sL6EQ+0zOwlDh+2fitHZm8BIzvAhkUJ9m1PDDV/Omqe4NVeQ6LRwg9zPvXAObVQN2o=
X-Received: by 2002:a05:651c:1590:b0:26c:4311:9b84 with SMTP id
 h16-20020a05651c159000b0026c43119b84mr2566040ljq.152.1666164045946; Wed, 19
 Oct 2022 00:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662459668.git.baskov@ispras.ru> <fae59721001d43db9a0ad2c9c09947284f1ecaa1.1662459668.git.baskov@ispras.ru>
In-Reply-To: <fae59721001d43db9a0ad2c9c09947284f1ecaa1.1662459668.git.baskov@ispras.ru>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 19 Oct 2022 09:20:34 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEr9qgSjWmXboXXp9_+EBvnzodwegAC9XXNUyt1o6=2cA@mail.gmail.com>
Message-ID: <CAMj1kXEr9qgSjWmXboXXp9_+EBvnzodwegAC9XXNUyt1o6=2cA@mail.gmail.com>
Subject: Re: [PATCH 08/16] x86/boot: Remove mapping from page fault handler
To:     Evgeniy Baskov <baskov@ispras.ru>
Cc:     Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, 6 Sept 2022 at 12:41, Evgeniy Baskov <baskov@ispras.ru> wrote:
>
> After every implicit mapping is removed, this code is no longer needed.
>
> Remove memory mapping from page fault handler to ensure that there are
> no hidden invalid memory accesses.
>
> Signed-off-by: Evgeniy Baskov <baskov@ispras.ru>

I don't grok this 100% but to me, it seems not having to rely on a
page fault handler to ensure that the 1:1 mapping has sufficient
coverage is a win so

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/x86/boot/compressed/ident_map_64.c | 26 ++++++++++---------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
> index 880e08293023..c20cd31e665f 100644
> --- a/arch/x86/boot/compressed/ident_map_64.c
> +++ b/arch/x86/boot/compressed/ident_map_64.c
> @@ -385,27 +385,21 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
>         unsigned long address = native_read_cr2();
>         unsigned long end;
> -       bool ghcb_fault;
> +       char *msg;
>
> -       ghcb_fault = sev_es_check_ghcb_fault(address);
> +       if (sev_es_check_ghcb_fault(address))
> +               msg = "Page-fault on GHCB page:";
> +       else
> +               msg = "Unexpected page-fault:";
>
>         address   &= PMD_MASK;
>         end        = address + PMD_SIZE;
>
>         /*
> -        * Check for unexpected error codes. Unexpected are:
> -        *      - Faults on present pages
> -        *      - User faults
> -        *      - Reserved bits set
> -        */
> -       if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD))
> -               do_pf_error("Unexpected page-fault:", error_code, address, regs->ip);
> -       else if (ghcb_fault)
> -               do_pf_error("Page-fault on GHCB page:", error_code, address, regs->ip);
> -
> -       /*
> -        * Error code is sane - now identity map the 2M region around
> -        * the faulting address.
> +        * Since all memory allocations are made explicit
> +        * now, every page fault at this stage is an
> +        * error and the error handler is there only
> +        * for debug purposes.
>          */
> -       kernel_add_identity_map(address, end, MAP_WRITE);
> +       do_pf_error(msg, error_code, address, regs->ip);
>  }
> --
> 2.35.1
>
