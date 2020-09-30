Return-Path: <SRS0=Khn0=DH=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9C8C2D0A8
	for <linux-efi@archiver.kernel.org>; Wed, 30 Sep 2020 06:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217E2207C3
	for <linux-efi@archiver.kernel.org>; Wed, 30 Sep 2020 06:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601447889;
	bh=CcYqlyb+bLk4U6bGEIhpK1w6r+iuuP2dzI+BlLtZHwA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IySnLaRmVNpUegE+Dosyz4BxXFzGrBpvFGmHORQdPwcDuRzbp0PDbAvAiLzEOYwrU
	 BTMbJI4+1JcAF10dDFxbWxSZ3gm8ReyxLRBdUUMQGSNp7IJM2A7HKMGLn2aSV6NaWo
	 g8KnBeyphylTuEofONAJJKgixf3Y+lhwSLhaeWBg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgI3GiI (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 30 Sep 2020 02:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgI3GiH (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 30 Sep 2020 02:38:07 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14DC820789
        for <linux-efi@vger.kernel.org>; Wed, 30 Sep 2020 06:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601447887;
        bh=CcYqlyb+bLk4U6bGEIhpK1w6r+iuuP2dzI+BlLtZHwA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IeS6irB8g4ga3euxO9u79uPJh1/r2jcu31NbmbLRNjOEslh64sWQjIbReoNKGauvC
         Ieme7QN5K2PK/EcigBQhZqrAg1/ywcJUtfED3kRgpuvA4fV+rR2j38h5AYCgVhZLHA
         1OFWuDy8dlwOmpAlm/n94YyZ3F1m4Y8YOg+yp5m0=
Received: by mail-oi1-f171.google.com with SMTP id x69so557109oia.8
        for <linux-efi@vger.kernel.org>; Tue, 29 Sep 2020 23:38:07 -0700 (PDT)
X-Gm-Message-State: AOAM531xn1ybiJXEq6XOrRASySkFXTu41diO4yEJbwqc7Yak/P3sWHzk
        3uWOP4CfOWwALO+KoVn4vGz8UXhKlwd20P6HRWE=
X-Google-Smtp-Source: ABdhPJzwx5+3oAZeLgNQvkupZ6/LZmSTqGNam6s6/PmM02plC6a1ec1yPLAXlcDjpE8t2eLpF5kuoHcGGxgax+FSuto=
X-Received: by 2002:aca:d845:: with SMTP id p66mr594196oig.47.1601447886219;
 Tue, 29 Sep 2020 23:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200929182405.31809-1-ardb@kernel.org>
In-Reply-To: <20200929182405.31809-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 30 Sep 2020 08:37:55 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG8=tO+nSE_m5N=7tz6VOgMwuBj7dPis4jYhA1jw1q-Bw@mail.gmail.com>
Message-ID: <CAMj1kXG8=tO+nSE_m5N=7tz6VOgMwuBj7dPis4jYhA1jw1q-Bw@mail.gmail.com>
Subject: Re: [GIT PULL] More EFI changes for v5.10
To:     linux-efi <linux-efi@vger.kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, 29 Sep 2020 at 20:24, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The following changes since commit 612b5d506d066cdf0a739963e7cd28642d500ec1:
>
>   cper,edac,efi: Memory Error Record: bank group/address and chip id (2020-09-17 10:19:52 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v5.10-2
>
> for you to fetch changes up to 963fabf37f6a94214a823df0a785e653cb8ad6ea:
>
>   efi: efivars: limit availability to X86 builds (2020-09-29 19:40:57 +0200)
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@alien8.de>
>

It appears there is an issue with this PR in tip efi/core:

My previous pull request for v5.10 ended at 612b5d506d066c (mentioned
above), and the 7 patches below were meant to go on top.

However, that commit (and some of its parents) appear in tip efi/core
under a different commit ID, and therefore, the merge of this PR
resulted in a non-FF merge, and the following patches now appear in
duplicate:

612b5d506d06 (tag: efi-next-for-v5.10) cper,edac,efi: Memory Error
Record: bank group/address and chip id
9baf68cc4544 edac,ghes,cper: Add Row Extension to Memory Error Record
4a568ce29d3f efi/x86: Add a quirk to support command line arguments on
Dell EFI firmware

744de4180a43 cper,edac,efi: Memory Error Record: bank group/address and chip id
3c029b01da60 edac,ghes,cper: Add Row Extension to Memory Error Record
d2778b4891fb efi/x86: Add a quirk to support command line arguments on
Dell EFI firmware

The only difference between d2778b4891fb and 4a568ce29d3f is that I
fixed up a typo in a person's name in the commit log, the patches are
otherwise identical. I recreated the tag right after, and the correct
commit ID is referenced in the PR I sent originally. However, I don't
remember if I failed to push the changes to kernel.org right away, or
whether this is a kernel.org mirroring issue, but the end result is
that that the wrong version of the tag got merged into efi/core

This is not the end of the world, as the patches are identical.
However, if you prefer to fix it, please reset efi/core to
tags/efi-next-for-v5.10-2 - it covers the whole batch of EFI changes
for v5.10.




> ----------------------------------------------------------------
> Second batch of EFI updates for v5.10:
> - followup fix for the new MOKvar table code
> - split efi-pstore from the deprecated efivars sysfs code, so we can
>   disable the latter on !x86
>
> ----------------------------------------------------------------
> Ard Biesheuvel (7):
>       efi: mokvar-table: fix some issues in new code
>       efi: pstore: disentangle from deprecated efivars module
>       efi: pstore: move workqueue handling out of efivars
>       efi: efivars: un-export efivars_sysfs_init()
>       efi: gsmi: fix false dependency on CONFIG_EFI_VARS
>       efi: remove some false dependencies on CONFIG_EFI_VARS
>       efi: efivars: limit availability to X86 builds
>
>  Documentation/arm/uefi.rst          |  2 +-
>  drivers/firmware/efi/Kconfig        | 18 +++-----
>  drivers/firmware/efi/efi-pstore.c   | 83 ++++++++++++++++++++++++++++++++++---
>  drivers/firmware/efi/efivars.c      | 45 +-------------------
>  drivers/firmware/efi/mokvar-table.c | 25 +++++------
>  drivers/firmware/efi/vars.c         | 21 ----------
>  drivers/firmware/google/Kconfig     |  2 +-
>  drivers/firmware/google/gsmi.c      |  8 ++--
>  include/linux/efi.h                 | 11 -----
>  9 files changed, 102 insertions(+), 113 deletions(-)
