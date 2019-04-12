Return-Path: <SRS0=aW0u=SO=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E0DC10F0E
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 20:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA02C2082E
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 20:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WhEoQR/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDLUiY (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 12 Apr 2019 16:38:24 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53568 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfDLUiX (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 12 Apr 2019 16:38:23 -0400
Received: by mail-it1-f193.google.com with SMTP id y204so18075074itf.3
        for <linux-efi@vger.kernel.org>; Fri, 12 Apr 2019 13:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ft70r9hZ9Ta5dHtyNCfbG1TAk4rvzEBbEw3nu2vRgzs=;
        b=WhEoQR/OBOmpVHsYV03yg4mVPe35QJuJ4pjISQX+6B4ImgTwbwECwTWFp8SAOcesu/
         r48+/BmerqW04jrZym75lQ91MDDVisnfLEfrYBfxq8zCZYkcGG3UW/EbS6mJZd3FKZrC
         aVdHwINzy7boPG+WGYFO3jofCbN6ss67UK5kJ3GYDw3onYrXpwWp+u0qQkWeaPOLxGRc
         cPwpXoWU3q1YBWPLOuvzlG8NBI0k30oDQzBqWrKAIJJJKuWegyzuGgdgo34L7+AdGutd
         PoC0muo1sxxJETJFmjcfF7lcUS4GTNCujM635fZ4WTkcFW1G/Up8FS3YpzEAg2LwCDwB
         73Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ft70r9hZ9Ta5dHtyNCfbG1TAk4rvzEBbEw3nu2vRgzs=;
        b=ZBbdMVQapYP9nAVDI87fJxFIAqQmppR5ON7PB9m6YIutYSWdimd82lIvkWT0/5onZ4
         T8xIeb12GPKo880jIaQT3ZKlP2wdaA6Si/yUhcOPkDzbnIpMmHC0S3Vzx31Om7fGZXrK
         tR9lbB0pNTQehClYdsLTWTQ6TwmxOjD9d7EcWvMpScRplMUyIepEBymadKOxrfDIeAdE
         O8QUYFhWL/C5v/Kf6xsUM45ik5DR1F8xVEb2RqBBifNwLfbIc9cDygYmV1JzfHYEsOCh
         ODaRm4EhsqjRecrxSwFztiOOQd/xhFw/5+kHR0/foEfJgMpqfwAUd/Y9wqkr4ylbLYj1
         GBUw==
X-Gm-Message-State: APjAAAVLvuqqENpyDLaIuJWE4qkvLUXR+Trjg/SvyN4ghKAJsW/7RkpZ
        KWqJOxoLVi30NBU16rq4sWKGQA5A/rEMssZgEqhNSw==
X-Google-Smtp-Source: APXvYqyHptYIw0skX2X7fTeuckcblcQBY27NV+DNdc4I4+YWZU0j4j/6aKhgrK1LESLhcuKwf2G++nmtHcRrSIVBPms=
X-Received: by 2002:a02:bb06:: with SMTP id y6mr41816420jan.98.1555101502963;
 Fri, 12 Apr 2019 13:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 12 Apr 2019 13:38:12 -0700
Message-ID:
 <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com>
Subject: Re: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning
 the cache
To:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190412203812.OtjL52RjUnZ0p9_k1VUuhyFHilHORENz1mPHZjnkPXc@z>

On Tue, 9 Apr 2019 at 09:42, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> The EFI stub is entered with the caches and MMU enabled by the
> firmware, and once the stub is ready to hand over to the decompressor,
> we clean and disable the caches.
>
> The cache clean routines use CP15 barrier instructions, which can be
> disabled via SCTLR. Normally, when using the provided cache handling
> routines to enable the caches and MMU, this bit is enabled as well.
> However, but since we entered the stub with the caches already enabled,
> this routine is not executed before we call the cache clean routines,
> resulting in undefined instruction exceptions if the firmware never
> enabled this bit.
>
> So set the bit explicitly in the EFI entry code, but do so in a way that
> guarantees that the resulting code can still run on v6 cores as well
> (which are guaranteed to have CP15 barriers enabled)
>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/boot/compressed/head.S | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 6c7ccb428c07..c174098acdf1 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -1438,7 +1438,21 @@ ENTRY(efi_stub_entry)
>
>                 @ Preserve return value of efi_entry() in r4
>                 mov     r4, r0
> -               bl      cache_clean_flush
> +
> +               @ our cache maintenance code relies on CP15 barrier instructions
> +               @ but since we arrived here with the MMU and caches configured
> +               @ by UEFI, we must check that the CP15BEN bit is set in SCTLR.
> +               @ Note that this bit is RAO/WI on v6 and earlier, so the ISB in
> +               @ the enable path will be executed on v7+ only.
> +               mrc     p15, 0, r1, c1, c0, 0   @ read SCTLR
> +               tst     r1, #(1 << 5)           @ CP15BEN bit set?
> +               bne     0f
> +               orr     r1, r1, #(1 << 5)       @ CP15 barrier instructions
> +               mcr     p15, 0, r1, c1, c0, 0   @ write SCTLR
> + ARM(          .inst   0xf57ff06f              @ isb           )
> + THUMB(                isb                                             )
> +
> +0:             bl      cache_clean_flush
>                 bl      cache_off
>
>                 @ Set parameters for booting zImage according to boot protocol
> --
> 2.17.1
>

Russell, do you mind if I take this through the EFI tree? I had
trouble logging into your patch system (it no longer recognizes my
email address but when I try to re-create the account, my name is
already taken)

Thanks,
Ard.
