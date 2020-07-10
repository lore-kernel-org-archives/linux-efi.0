Return-Path: <SRS0=M/Y5=AV=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC96DC433E1
	for <linux-efi@archiver.kernel.org>; Fri, 10 Jul 2020 14:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E6582064B
	for <linux-efi@archiver.kernel.org>; Fri, 10 Jul 2020 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594391249;
	bh=z5GS7bzW3vt89ODcDbxTwcqTDUKbrhtLbUgZN/aPJks=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=C6++5kxjqZglu1g728WmHmMdP4Hey6x9S3Ao0XQW1evTkaM26mKR1n7vFItnCO+1A
	 igw0pA9iy2zYjobUjgdoy8DDJXr6nV5jrEohYHbn3VKtwQlsZIZWjaxZ+0EYfnbYJy
	 JjEJV9v/hcgn3qVNNIAlhUwiaK9k0H1ijTE+ejGA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGJO1Z (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 10 Jul 2020 10:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgGJO1Z (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 10 Jul 2020 10:27:25 -0400
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB264206E2;
        Fri, 10 Jul 2020 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594391245;
        bh=z5GS7bzW3vt89ODcDbxTwcqTDUKbrhtLbUgZN/aPJks=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=udoNZF8P0ADm4fqn4Qy5x9C2vHCV2p9r+Ns+aU2CoUVQCPkWqe/5EBJWiz/+wZ+cB
         ex+pS3L2z+DH2RCdK6ZdxCS5z+5yAfPJTi10+K61d8UR22uyLQCnmMaVnZGFU6P9C/
         uuafWvzXw3P/2xm2EvwMJq+xrmLFHHZ/dRnwr/yQ=
Received: by mail-oo1-f43.google.com with SMTP id t12so1024069ooc.10;
        Fri, 10 Jul 2020 07:27:24 -0700 (PDT)
X-Gm-Message-State: AOAM531jNgohfFBhdc7i2YIe5CYkagWdUJcejRmyIG9X5sxFRNDbFGz4
        Zgtg9wwMmYEgZP2vb91GsIR4ywWoy02g6cXOBe8=
X-Google-Smtp-Source: ABdhPJz6+EdbHPDvR54y8i1lkJirNkR+7jQgNft2XWsMwOMmyjZqITES3V6nwxYUU7/dFIw3al47o4ejMuE4Cv4kjXk=
X-Received: by 2002:a4a:b34b:: with SMTP id n11mr59771293ooo.41.1594391244224;
 Fri, 10 Jul 2020 07:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200710142253.28070-1-jgross@suse.com>
In-Reply-To: <20200710142253.28070-1-jgross@suse.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 10 Jul 2020 17:27:13 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEdm8MrdWVLO0w_-LJLvpiUURHhazv4-B39L1Bbk8kqFw@mail.gmail.com>
Message-ID: <CAMj1kXEdm8MrdWVLO0w_-LJLvpiUURHhazv4-B39L1Bbk8kqFw@mail.gmail.com>
Subject: Re: [PATCH v2] efi: avoid error message when booting under Xen
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 10 Jul 2020 at 17:24, Juergen Gross <jgross@suse.com> wrote:
>
> efifb_probe() will issue an error message in case the kernel is booted
> as Xen dom0 from UEFI as EFI_MEMMAP won't be set in this case. Avoid
> that message by calling efi_mem_desc_lookup() only if EFI_MEMMAP is set.
>
> Fixes: 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/video/fbdev/efifb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 65491ae74808..e57c00824965 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -453,7 +453,7 @@ static int efifb_probe(struct platform_device *dev)
>         info->apertures->ranges[0].base = efifb_fix.smem_start;
>         info->apertures->ranges[0].size = size_remap;
>
> -       if (efi_enabled(EFI_BOOT) &&
> +       if (efi_enabled(EFI_MEMMAP) &&
>             !efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
>                 if ((efifb_fix.smem_start + efifb_fix.smem_len) >
>                     (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
> --
> 2.26.2
>
