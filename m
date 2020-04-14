Return-Path: <SRS0=RBj2=56=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A220C2BB1D
	for <linux-efi@archiver.kernel.org>; Tue, 14 Apr 2020 23:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634B82064A
	for <linux-efi@archiver.kernel.org>; Tue, 14 Apr 2020 23:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="ib1UjBT7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgDNX3d (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 14 Apr 2020 19:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731159AbgDNX32 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 14 Apr 2020 19:29:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889C9C061A0C
        for <linux-efi@vger.kernel.org>; Tue, 14 Apr 2020 16:29:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o81so9509399wmo.2
        for <linux-efi@vger.kernel.org>; Tue, 14 Apr 2020 16:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DaIj/rbAw4W3jLn7XkZgr37bN5WduReOv7XYvGppjlQ=;
        b=ib1UjBT7RJxA6SItuC/eWkxS6sqPhikUX9F152KczmlnrLhwf5EFI4ywNGOBOetPVE
         /XPD86nOkxLx5YeWr5b/DVbF+PAtOFayGhEBbdQLx/lsptxfz/VdifgKL4G3CrK+6C8t
         wH7amwyJYnTxmj4YoYpYk27UJpgxnQq84YnTCi7+x/Jk49RIwQZiQPGBG9CmcwfxWIj2
         r3kP990JtWggOiN0/QYc+eBNvtn0fydAtqP1ejRgg+VQ/Bfvzjm+ySufqEuBdA+8zoFB
         f9DVEXf3BhVaG6SLZr/tp6XuOGeJozrLCAVx42/lG8ja6t4mEf2Un0udsAMYxhO3F/Bm
         yMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DaIj/rbAw4W3jLn7XkZgr37bN5WduReOv7XYvGppjlQ=;
        b=hM3+N85Fy1gx15wgnmTukLI46Pg3yD+tdaUuXqTQG1e0XCpQYP4S0Nq4dl93C33zEP
         3SEy2OXW5z9jtF+p+X00zNf2lmKz39w0sg80uy71nbyanuDueEDKF3L87I8weNQ9XLsG
         0OV4XiTsf3H9KTyncMg7t1sIARg9WkX18R3abuK9+HoR7l2/bgolaMHiUxqDwLO8Dqev
         7LNfpAxtqas28PKWep1Q0EzqcEUZ9ybDdUQcP8QsIs/SSfLE+8E4asoJQBRrxxXJUphS
         WurPg4YrwiZZN5BVkCmAiM2tZtmbUTXnYtAPWrY/Dbi6cie3s9GZQBzp8muv/8sRHQEo
         mmcA==
X-Gm-Message-State: AGi0PuYd1kEaC9k9Mp49XnzIq9h24pPWJg/sTCA2KQwzPvhcblgla661
        USl454MYjE4Tgwzbi2KZHnZHG5q1/gxjJzdUvopTTfQ=
X-Google-Smtp-Source: APiQypKMANibGTHKC/mG+tVKEkQ1bdQw2x261kjdbN7MEWDtFUf7WPTWJZSzPlnlur713nNr+E/ZoAjLQTJxLk3Bv+c=
X-Received: by 2002:a1c:ba09:: with SMTP id k9mr2135744wmf.176.1586906967302;
 Tue, 14 Apr 2020 16:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200413155521.24698-1-ardb@kernel.org> <20200413155521.24698-8-ardb@kernel.org>
In-Reply-To: <20200413155521.24698-8-ardb@kernel.org>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 14 Apr 2020 16:29:16 -0700
Message-ID: <CAOnJCUKDOC30KhHVLt2bCN2jJ3ztMvUXJhR=C1K2XJay9P7yXw@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] efi/libstub/arm64: switch to ordinary page
 allocator for kernel image
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>, Jonathan.Cameron@huawei.com,
        nivedita@alum.mit.edu
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, Apr 13, 2020 at 8:55 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> It is no longer necessary to locate the kernel as low as possible in
> physical memory, and so we can switch from efi_low_alloc() [which is
> a rather nasty concoction on top of GetMemoryMap()] to a new helper
> called efi_allocate_pages_aligned(), which simply rounds up the size
> to account for the alignment, and frees the misaligned pages again.
>
> So considering that the kernel can live anywhere in the physical
> address space, as long as its alignment requirements are met, let's
> switch to efi_allocate_pages_aligned() to allocate the pages.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/libstub/arm64-stub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index 6fc3bd9a56db..99b67e88a33b 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -98,8 +98,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>                         return EFI_SUCCESS;
>                 }
>
> -               status = efi_low_alloc(*reserve_size,
> -                                      min_kimg_align, reserve_addr);
> +               status = efi_allocate_pages_aligned(*reserve_size, reserve_addr,
> +                                                   ULONG_MAX, min_kimg_align);
>
>                 if (status != EFI_SUCCESS) {
>                         pr_efi_err("Failed to relocate kernel\n");
> --
> 2.17.1
>

Reviewed-by: Atish Patra <atish.patra@wdc.com>
-- 
Regards,
Atish
