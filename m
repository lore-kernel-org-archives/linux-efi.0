Return-Path: <SRS0=iU5o=SZ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E41C10F03
	for <linux-efi@archiver.kernel.org>; Tue, 23 Apr 2019 15:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 445A5217D9
	for <linux-efi@archiver.kernel.org>; Tue, 23 Apr 2019 15:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt7+CvCD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfDWPBh (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 23 Apr 2019 11:01:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46087 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbfDWPBh (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 23 Apr 2019 11:01:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id t17so20594533wrw.13
        for <linux-efi@vger.kernel.org>; Tue, 23 Apr 2019 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jn9FGTURdKvkjwax8Bram+1t29xTm2V39ip0pKxcK6Q=;
        b=Jt7+CvCD/PrjSSjLYGUXTyosB19spqE6wxBFuh5sBCIosELtiBP/SQQM+6eNJGg2Dp
         IKIglVQS3KmBb2R4ZHcIg4jtkP+YMJF/fMSRAlOavfFpc9rAe6YexQ5zHT8+gvP92n7w
         fUJ01k8XjY1EPIW6AjBDiEnfLCH1w/s7IOLus6ack4guEYUdqrrGMSeNx2YOIuVJKtn0
         FCj5yqjtyjpOMunOHWcn5NKc5g7rYMyPxu09QzTWWME7OnnujZxc2NwYeqenzG3rtkdY
         lC8R/ap/VktqG1w6fqPPgX1vgPNQ1gpJQ+u5RK0QXGJmnG76W0V4XvjBwi/pUmD4FAOx
         ibtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jn9FGTURdKvkjwax8Bram+1t29xTm2V39ip0pKxcK6Q=;
        b=X1j5D/aPfRNlRB2bZcGEzyTexZ9B9L/3Yo+Ji3xcR5Po1am7kq6U8L16TqYM9y4o81
         5hBrRrrFsVpKz3oZnpeXDZaNmyF8HsXUS7+GIeWkIcrykRxi1lVUetpwRepufEqaCC2e
         VyQPvu4Il0JjSkExfdI2Olg5Alz5IxPYRH3e0JBJgLb87ibpP2H2Z3Mu9wjxhkw1bBqU
         /5T76jQO7t3uJawr89I57t9NzHIVXMvUB9wD8SCxEOhNS0BX4AnI7oqBkznr7JT4BFlE
         xIgXhfYdrAHlQhPd/EpieonqwONNYtmRJJ3YeTq3MhSdOBkgwRlZHC9U0t+SKAJQv5al
         sZqw==
X-Gm-Message-State: APjAAAWXogJAcO3Z9mYRS16D6WdmfvAJBhxsitbb0lAB7r7X1NHVbaZo
        9ajvhGOuhr9GkcTdZ/PXEFdnhuVZrrB7k9OMEa4=
X-Google-Smtp-Source: APXvYqycK2a/yfFR3bYWpQ/NHrcRUq8koAvl6IK02k7vFwpYvAylHaI/UZjp7Q+9pgavgHihkRoOyElR+AgU2nhdgIY=
X-Received: by 2002:adf:e309:: with SMTP id b9mr13253097wrj.165.1556031695661;
 Tue, 23 Apr 2019 08:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190423144354.3465-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190423144354.3465-1-ard.biesheuvel@linaro.org>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Tue, 23 Apr 2019 17:01:23 +0200
Message-ID: <CADvTj4pYsCq8ZgcL7kELuT77URZbaDmDe-o8qj-M97e0aeCGUw@mail.gmail.com>
Subject: Re: [PATCH] fbdev/efifb: ignore framebuffer memmap entries that lack
 any memory types
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Jones <pjones@redhat.com>, b.zolnierkie@samsung.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Apr 23, 2019 at 4:44 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Commit 38ac0287b7f4
>
>   ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
>
> updated the EFI framebuffer code to use memory mappings for the linear
> framebuffer that are permitted by the memory attributes described by the
> EFI memory map for the particular region, if the framebuffer happens to
> be covered by the EFI memory map (which is typically only the case for
> framebuffers in shared memory). This is required since non-X86 systems
> may require cacheable attributes for memory mappings that are shared
> with other masters (such as GPUs), and this information cannot be
> described by the Graphics Output Protocol (GOP) EFI protocol itself,
> and so we rely on the EFI memory map for this.
>
> As reported by James, this breaks some x86 systems:
>
>   [ 1.173368] efifb: probing for efifb
>   [ 1.173386] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
>   [ 1.173395] Trying to free nonexistent resource <00000000cf800000-00000000cf9d4bff>
>   [ 1.173413] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5
>
> The problem turns out to be that the memory map entry that describes the
> framebuffer has no memory attributes listed at all, and so we end up with
> a mem_flags value of 0x0.
>
> So work around this by ensuring that the memory map entry's attribute field
> has a sane value before using it to mask the set of usable attributes.
>
> Reported-by: James Hilliard <james.hilliard1@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>
> James, could you give this a try please? Thanks.
I can confirm this fixes the regression on my system, thanks.
>
>  drivers/video/fbdev/efifb.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index ba906876cc45..1f9949f50900 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -476,8 +476,11 @@ static int efifb_probe(struct platform_device *dev)
>                  * If the UEFI memory map covers the efifb region, we may only
>                  * remap it using the attributes the memory map prescribes.
>                  */
> -               mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
> -               mem_flags &= md.attribute;
> +               md.attribute &= EFI_MEMORY_WC | EFI_MEMORY_WT | EFI_MEMORY_WB;
> +               if (md.attribute) {
> +                       mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
> +                       mem_flags &= md.attribute;
> +               }
>         }
>         if (mem_flags & EFI_MEMORY_WC)
>                 info->screen_base = ioremap_wc(efifb_fix.smem_start,
> --
> 2.20.1
>
