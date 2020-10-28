Return-Path: <SRS0=/zUi=ED=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE556C4363A
	for <linux-efi@archiver.kernel.org>; Wed, 28 Oct 2020 21:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F06C2245A
	for <linux-efi@archiver.kernel.org>; Wed, 28 Oct 2020 21:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603921733;
	bh=xgJ4DoAg5tZlTub2DaFnEC95Pa+TGCKiAVV3xZ7I7/Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=K21Y3fEdf5X9TVyBjH0znj/ZdzpiACuMwSGyZNWHbREdqAV2SYHfTI08+R3YRCBRy
	 3C2Xnzl4piWMmXIYNajREEkk8QRJ7kQluYngSybrwe2NVwmyYlzG7m5s+lPlCfX3z8
	 WhS3NHMXH0FHlNBZ1qrL0eqZxH6i6xha3zGe9erI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgJ1Vsv (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgJ1VrX (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 28 Oct 2020 17:47:23 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C648D247D0;
        Wed, 28 Oct 2020 15:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603900480;
        bh=xgJ4DoAg5tZlTub2DaFnEC95Pa+TGCKiAVV3xZ7I7/Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G189fbFzZNFzbCXKv2E0ayPTevmgRadS+ahaWrwICVZVGyVzj7bm3E7rX9WGyYi3x
         1qAwDMYYxUVMnqbqEWpowsT7xsdmrq0B0vBC/SrL/E54OMKOQUozOvbqc6YcHnlnix
         JY29Ym5XuWzhjm1rLxrIVVnKcssxzDTKqm2Y2KO4=
Received: by mail-ot1-f45.google.com with SMTP id h62so4636239oth.9;
        Wed, 28 Oct 2020 08:54:40 -0700 (PDT)
X-Gm-Message-State: AOAM53294GJqPUWstgGArC7pYqT2lz9M5mpElCtuLE0otfRRcyneaJiQ
        afyVx/ZhhNey6HlwCQbX/BTTXoPRRZw+GAgYN3Q=
X-Google-Smtp-Source: ABdhPJwtJWDlru0Gd2xfl/n3DxPH1x35FlJ1AFuSN3jnYFgjlqxhh9l8UCbi71EacIancQE1ItfKMN3hAbbignYTxRQ=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr5416122ots.90.1603900479994;
 Wed, 28 Oct 2020 08:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201028153402.1736103-1-geert+renesas@glider.be>
In-Reply-To: <20201028153402.1736103-1-geert+renesas@glider.be>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 28 Oct 2020 16:54:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFtmfBVhGQKuiCxHsJcA614=jKnhJuAG2z5HUu7ri9EPg@mail.gmail.com>
Message-ID: <CAMj1kXFtmfBVhGQKuiCxHsJcA614=jKnhJuAG2z5HUu7ri9EPg@mail.gmail.com>
Subject: Re: [PATCH v2] efi/libstub: EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER
 should not default to yes
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 28 Oct 2020 at 16:34, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER is deprecated, so it should not
> be enabled by default.
>
> In light of commit 4da0b2b7e67524cc ("efi/libstub: Re-enable command
> line initrd loading for x86"), keep the default for X86.
>
> Fixes: cf6b83664895a5c7 ("efi/libstub: Make initrd file loader configurable")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Hopefully kernelCI has updated its QEMU firmware since v1 was posted...

Yes it has!

>
> v2:
>   - Rebase on top of commit d7071743db31b4f6 ("RISC-V: Add EFI stub
>     support.") in v5.10-rc1.

Thanks, I'll queue this up

> ---
>  drivers/firmware/efi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 36ec1f7188934ca4..b452cfa2100b401c 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -122,7 +122,7 @@ config EFI_ARMSTUB_DTB_LOADER
>  config EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER
>         bool "Enable the command line initrd loader" if !X86
>         depends on EFI_STUB && (EFI_GENERIC_STUB || X86)
> -       default y
> +       default y if X86
>         depends on !RISCV
>         help
>           Select this config option to add support for the initrd= command
> --
> 2.25.1
>
