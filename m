Return-Path: <SRS0=x5cr=C3=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F57C43464
	for <linux-efi@archiver.kernel.org>; Fri, 18 Sep 2020 17:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23CB72075E
	for <linux-efi@archiver.kernel.org>; Fri, 18 Sep 2020 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600449934;
	bh=sAW2CJcEA1vxpXFXQpf1wRDpOzcD8JHXhsU0c7RDYt8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=YeEQqIncunwJEwKHhkFSGcdaqPv8JIXOHNXOgcaIab6TFP/ctUt8Jhwe+gEykAPF9
	 w/nIaLDZE29SkB44vHmYQzDaZxaJooeZTsIyvbIwDNOczg73399UhKBt1+AfwlXDJD
	 5xlGvs4Or7C/LiijJccgZQ2gypVDtvTYzXRoqlR0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIRRZd (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 18 Sep 2020 13:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgIRRZd (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 18 Sep 2020 13:25:33 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A4821707
        for <linux-efi@vger.kernel.org>; Fri, 18 Sep 2020 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600449933;
        bh=sAW2CJcEA1vxpXFXQpf1wRDpOzcD8JHXhsU0c7RDYt8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yTIZLx91Y9A4KrctL5B/ST9sGTv34LjF1dPDZVbfIoRjrX/fX/ue4/YLNBsTWQeys
         ZjiFehYceyJlN3EZMEZbH7M27wT4NtutjMJH9WJHGrynpciPZ59i7TSSM6iSyTVRcj
         nc2bvL2pEfgiM1pV225oEQ0S7zULlJii0UMO82/U=
Received: by mail-ot1-f43.google.com with SMTP id m13so1595633otl.9
        for <linux-efi@vger.kernel.org>; Fri, 18 Sep 2020 10:25:33 -0700 (PDT)
X-Gm-Message-State: AOAM531hyoE5RNPTQmaymcXTT4ymASWqEpzDWK14OS9UcYb3e9Z8CLXw
        ywgn2hxKNiDT2lcTZrshf9wVhPLwgL0fQn/W2nM=
X-Google-Smtp-Source: ABdhPJwqAy/TjgS0F7FQcQy1skAR0m8N59uNwSljhrDqSLnuLS5NaWRj++7TNhAuYNx7XOfNVagTXDJ08byMDB+Z96c=
X-Received: by 2002:a9d:6250:: with SMTP id i16mr25088416otk.77.1600449932416;
 Fri, 18 Sep 2020 10:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200918103102.18107-1-ardb@kernel.org>
In-Reply-To: <20200918103102.18107-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 18 Sep 2020 19:25:18 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG+f8YsjPZ5P9HmEAt4VV_EntV1kerB4yYWvEyWwgqx-A@mail.gmail.com>
Message-ID: <CAMj1kXG+f8YsjPZ5P9HmEAt4VV_EntV1kerB4yYWvEyWwgqx-A@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/6] ARM: p2v: reduce min alignment to 2 MiB
To:     Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 18 Sep 2020 at 12:31, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> This series is inspired by Zhei Len's series [0], which updates the
> ARM p2v patching code to optionally support p2v relative alignments
> of as little as 64 KiB.
>
> Reducing this alignment is necessary for some specific Huawei boards,
> but given that reducing this minimum alignment will make the boot
> sequence more robust for all platforms, especially EFI boot, which
> no longer relies on the 128 MB masking of the decompressor load address,
> but uses firmware memory allocation routines to find a suitable spot
> for the decompressed kernel.
>
> This series is not based on Zhei Len's code, but addresses the same
> problem, and takes some feedback given in the review into account:
> - use of a MOVW instruction to avoid two adds/adcs sequences when dealing
>   with the carry on LPAE
> - add support for Thumb2 kernels as well
> - make the change unconditional - it will bit rot otherwise, and has value
>   for other platforms as well.
>
> The first four patches are general cleanup and preparatory changes.
> Patch #5 implements the switch to a MOVW instruction without changing
> the minimum alignment.
> Patch #6 reduces the minimum alignment to 2 MiB.
>
> Tested on QEMU in ARM/!LPAE, ARM/LPAE, Thumb2/!LPAE and Thumb2/LPAE modes.
>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nicolas Pitre <nico@fluxnic.net>
>
> [0] https://lore.kernel.org/linux-arm-kernel/20200915015204.2971-1-thunder.leizhen@huawei.com/
>
> Ard Biesheuvel (6):
>   ARM: p2v: factor out shared loop processing
>   ARM: p2v: factor out BE8 handling
>   ARM: p2v: drop redundant 'type' argument from __pv_stub
>   ARM: p2v: use relative references in patch site arrays
>   ARM: p2v: switch to MOVW for Thumb2 and ARM/LPAE
>   ARM: p2v: reduce p2v alignment requirement to 2 MiB
>

Note: there is a thinko in this version of the patches, as it
unnecessarily patches ADD instructions into SUB and vice versa. Since
QEMU has its DRAM at 0x4000_0000, the translation for a 3g/1g split is
0x8000_0000, which why it worked in my testing, but will fail on other
platforms (or with other splits, for that matter)

For the general discussion of the approach taken here, that does not
really matter, so I won't send a v2 until people have had some time to
have a look. However, if you want to test this code on other hardware,
please use the code at the following link instead:

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm-p2v-v2
