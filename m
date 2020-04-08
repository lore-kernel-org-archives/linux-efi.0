Return-Path: <SRS0=FM6U=5Y=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3BDC2D0EA
	for <linux-efi@archiver.kernel.org>; Wed,  8 Apr 2020 08:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AAC320769
	for <linux-efi@archiver.kernel.org>; Wed,  8 Apr 2020 08:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586334064;
	bh=IlTWYDpkouH55bUQbBIsWp5XJ3JIkFdXiv4/ae3lQ2k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PXsZG77K67L3ihk5lGlnyEet7n1iDzSuQOes6GHEW0+kYxJQFeUzsbgKrzwLwNiHN
	 8X1tYVpbrnlS2qw93PkKEcT1BRiwwRz7/H85z3yu+FsDLRF+w3nBmS3owxJ17NKaCJ
	 0gCnVb1MMgJHKlM2oOBeSE6DdGHRCKa7aVhex8bU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDHIVD (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 8 Apr 2020 04:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgDHIVD (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 8 Apr 2020 04:21:03 -0400
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EEC20769
        for <linux-efi@vger.kernel.org>; Wed,  8 Apr 2020 08:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586334063;
        bh=IlTWYDpkouH55bUQbBIsWp5XJ3JIkFdXiv4/ae3lQ2k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iOmqhjKqVIEc4vkeaOFkMzWaOEFvJIJwGe/KVwSDrH4CJ0oVZu4pnT5ejFxYpeiPA
         GIZkJxBiZlFSMAvpn9ubq8JVigwKLHJ/U4EKh7RqrERri71glooylyiz6UIox7KP/U
         H7tMtuhab4tXku696G4MPr1/8CkrflWUVENK4l28=
Received: by mail-io1-f53.google.com with SMTP id n20so6260958ioa.4
        for <linux-efi@vger.kernel.org>; Wed, 08 Apr 2020 01:21:02 -0700 (PDT)
X-Gm-Message-State: AGi0PuYDiACNPaX/sQBR1NyJX9Y/A3NIE8Nt/+LITZqtXRcyxD5HA9r2
        Z6DQ7FKl02WPTQM5q9zg7jfGwRkiGCd8SAm0Alc=
X-Google-Smtp-Source: APiQypJLeLJtEcswxpm/iT7iTiSI17GVo9IQZzVNV+3dCxnjRef7DKfuXSXZ0acCiOediQlSDuHPPHnC3Ep5wUuy0ac=
X-Received: by 2002:a05:6638:a22:: with SMTP id 2mr5982368jao.74.1586334062367;
 Wed, 08 Apr 2020 01:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200408081606.1504-1-glin@suse.com>
In-Reply-To: <20200408081606.1504-1-glin@suse.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 8 Apr 2020 10:20:50 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFwZiirOQ2gu2CcScdb3H782vpL2qT6ijqTfdQ8-cKSgw@mail.gmail.com>
Message-ID: <CAMj1kXFwZiirOQ2gu2CcScdb3H782vpL2qT6ijqTfdQ8-cKSgw@mail.gmail.com>
Subject: Re: [PATCH] efi/x86: Fix the deletion of variables in mixed mode
To:     Gary Lin <glin@suse.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 8 Apr 2020 at 10:18, Gary Lin <glin@suse.com> wrote:
>
> efi_thunk_set_variable() treated the NULL "data" pointer as an invalid
> parameter, and this broke the deletion of variables in mixed mode.
> This commit fixes the check of data so that the userspace program can
> delete a variable in mixed mode.
>
> Fixes: 8319e9d5ad98ffcc ("efi/x86: Handle by-ref arguments covering multiple pages in mixed mode")
> Cc: linux-efi@vger.kernel.org
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Gary Lin <glin@suse.com>

Thanks Gary.

I'll queue this in efi/urgent.



> ---
>  arch/x86/platform/efi/efi_64.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 211bb9358b73..e0e2e8136cf5 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -638,7 +638,7 @@ efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
>         phys_vendor = virt_to_phys_or_null(vnd);
>         phys_data = virt_to_phys_or_null_size(data, data_size);
>
> -       if (!phys_name || !phys_data)
> +       if (!phys_name || (data && !phys_data))
>                 status = EFI_INVALID_PARAMETER;
>         else
>                 status = efi_thunk(set_variable, phys_name, phys_vendor,
> @@ -669,7 +669,7 @@ efi_thunk_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
>         phys_vendor = virt_to_phys_or_null(vnd);
>         phys_data = virt_to_phys_or_null_size(data, data_size);
>
> -       if (!phys_name || !phys_data)
> +       if (!phys_name || (data && !phys_data))
>                 status = EFI_INVALID_PARAMETER;
>         else
>                 status = efi_thunk(set_variable, phys_name, phys_vendor,
> --
> 2.25.1
>
