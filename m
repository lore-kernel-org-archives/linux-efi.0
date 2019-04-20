Return-Path: <SRS0=oepQ=SW=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B33C282DD
	for <linux-efi@archiver.kernel.org>; Sat, 20 Apr 2019 19:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D3D92147C
	for <linux-efi@archiver.kernel.org>; Sat, 20 Apr 2019 19:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKRWWYEL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfDTTDE (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 20 Apr 2019 15:03:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35425 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfDTTDD (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sat, 20 Apr 2019 15:03:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id o12so7519027wrn.2;
        Sat, 20 Apr 2019 12:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gZ3i31bYdBxBcB/FN2YUIHbyFFC9xc4bYJrB28VIlAM=;
        b=FKRWWYELvlba1o3FzNgKItwAT4M8RlloCImgF0jrsZKP55VDm3WM44N+goOBnOd0qD
         7xg+RhBwH3cV5VVuryvGvyVxoyN273RuMKQ0v2t6duiq515uoWs8mFTjGhV5q1tjH9vN
         Wd/8C8eBU895rdpRZKvOjalvxApc1OL1xfRW6k11FafcRDCd695azn+91FxUeRg9Kp9f
         yJo0Zze9v9fLM4uIurWJI4qANJilvAviWvxsxcGgxAv27t24qSflKc/lhwAdkQSst15e
         qk53z05oSYq+AOwjMIAzXB7+ItQfMV6qisI6rFXgi1VVNeLBolyXrLVQBdaEhuRpMNM5
         EBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gZ3i31bYdBxBcB/FN2YUIHbyFFC9xc4bYJrB28VIlAM=;
        b=O717TaZgh2pHU4xwVkNP5+IYJt1LzzMDs9zavmGJ64XnzYiate2MvEdbqZbWy/e/+m
         xPln94juSjUcNBvqBLTQSwXIFEWAJ4D3otmTFMa39ear5MJrBehWiFUbuUj3FtGP8uwc
         /2SXPOmoSZnkU0KbEakHOMcuSv3sljVebqGHggYVUhd7xW4+taitomkfgLG/rm60XGu1
         VMJqw9xc0fQ6QtLSOuIrH85wxIA/fNGYk4lo2MDSPcrDt5Zf02kuNQJ8N/NW0wP1fv2Y
         L6m0TLrhGT08sWL88DagGvVmcm1LX+5LgH4SD8t0oAbWHEz/vYxiV8oj7mwaPyZl30Kl
         cljQ==
X-Gm-Message-State: APjAAAVap8f2GbFC2WW42i6ODTgdPDHKTyT+akvf0hXzIWzzyvuXTNuV
        hn+rLsGM8413nDt8YvXUBJ3LSa4Gfew48PbPlwc=
X-Google-Smtp-Source: APXvYqxsGpO0jwy0fJ0S4EPF2oNLycpplNUwSkBmx/9ygLMIOlm5m5rfhj05kDnST6Yr6i/EAaBsNjXbS9PJLe4MIWM=
X-Received: by 2002:adf:e9c1:: with SMTP id l1mr7138255wrn.270.1555786981390;
 Sat, 20 Apr 2019 12:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org> <20180711094040.12506-9-ard.biesheuvel@linaro.org>
In-Reply-To: <20180711094040.12506-9-ard.biesheuvel@linaro.org>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Sat, 20 Apr 2019 21:02:49 +0200
Message-ID:
 <CADvTj4rmxgxoJMR4ehZuhHHP3s2KCqO=Vp2igf3-ev_o=+_Duw@mail.gmail.com>
Subject: Re: [PATCH 8/8] fbdev/efifb: honour UEFI memory map attributes when
 mapping the fb
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190420190249.rTQQ9N65f9YU6Fv2QPJJlv7CZ7zY_-i2De7hsK8kJMA@z>

This patch appears to introduce a regression on my
system(https://www.jetwaycomputer.com/NF9B.html).
My board uses an Intel gma3650 GPU.
It causes a complete failure of all video output.
With it reverted I get:
[ 1.169444] efifb: probing for efifb
[ 1.169499] efifb: framebuffer at 0xcf800000, using 1876k, total 1875k
[ 1.169511] efifb: mode is 800x600x32, linelength=3200, pages=1
[ 1.169519] efifb: scrolling: redraw
[ 1.169528] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Without it reverted I get:
[ 1.173368] efifb: probing for efifb
[ 1.173386] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
[ 1.173395] Trying to free nonexistent resource
<00000000cf800000-00000000cf9d4bff>
[ 1.173413] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5

On Wed, Jul 11, 2018 at 11:40 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> If the framebuffer address provided by the Graphics Output Protocol
> (GOP) is covered by the UEFI memory map, it will tell us which memory
> attributes are permitted when mapping this region. In some cases,
> (KVM guest on ARM), violating this will result in loss of coherency,
> which means that updates sent to the framebuffer by the guest will
> not be observeable by the host, and the emulated display simply does
> not work.
>
> So if the memory map contains such a description, take the attributes
> field into account, and add support for creating WT or WB mappings of
> the framebuffer region.
>
> Cc: Peter Jones <pjones@redhat.com>
> Tested-by: Laszlo Ersek <lersek@redhat.com>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/video/fbdev/efifb.c | 51 +++++++++++++++++++++++++++++--------
>  1 file changed, 41 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 46a4484e3da7..c6f78d27947b 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -20,7 +20,7 @@
>  #include <drm/drm_connector.h>  /* For DRM_MODE_PANEL_ORIENTATION_* */
>
>  static bool request_mem_succeeded = false;
> -static bool nowc = false;
> +static u64 mem_flags = EFI_MEMORY_WC | EFI_MEMORY_UC;
>
>  static struct fb_var_screeninfo efifb_defined = {
>         .activate               = FB_ACTIVATE_NOW,
> @@ -68,8 +68,12 @@ static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
>
>  static void efifb_destroy(struct fb_info *info)
>  {
> -       if (info->screen_base)
> -               iounmap(info->screen_base);
> +       if (info->screen_base) {
> +               if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> +                       iounmap(info->screen_base);
> +               else
> +                       memunmap(info->screen_base);
> +       }
>         if (request_mem_succeeded)
>                 release_mem_region(info->apertures->ranges[0].base,
>                                    info->apertures->ranges[0].size);
> @@ -104,7 +108,7 @@ static int efifb_setup(char *options)
>                         else if (!strncmp(this_opt, "width:", 6))
>                                 screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
>                         else if (!strcmp(this_opt, "nowc"))
> -                               nowc = true;
> +                               mem_flags &= ~EFI_MEMORY_WC;
>                 }
>         }
>
> @@ -164,6 +168,7 @@ static int efifb_probe(struct platform_device *dev)
>         unsigned int size_remap;
>         unsigned int size_total;
>         char *option = NULL;
> +       efi_memory_desc_t md;
>
>         if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
>                 return -ENODEV;
> @@ -272,12 +277,35 @@ static int efifb_probe(struct platform_device *dev)
>         info->apertures->ranges[0].base = efifb_fix.smem_start;
>         info->apertures->ranges[0].size = size_remap;
>
> -       if (nowc)
> -               info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
> -       else
> -               info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
> +       if (!efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
> +               if ((efifb_fix.smem_start + efifb_fix.smem_len) >
> +                   (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
> +                       pr_err("efifb: video memory @ 0x%lx spans multiple EFI memory regions\n",
> +                              efifb_fix.smem_start);
> +                       err = -EIO;
> +                       goto err_release_fb;
> +               }
> +               /*
> +                * If the UEFI memory map covers the efifb region, we may only
> +                * remap it using the attributes the memory map prescribes.
> +                */
> +               mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
> +               mem_flags &= md.attribute;
> +       }
> +       if (mem_flags & EFI_MEMORY_WC)
> +               info->screen_base = ioremap_wc(efifb_fix.smem_start,
> +                                              efifb_fix.smem_len);
> +       else if (mem_flags & EFI_MEMORY_UC)
> +               info->screen_base = ioremap(efifb_fix.smem_start,
> +                                           efifb_fix.smem_len);
> +       else if (mem_flags & EFI_MEMORY_WT)
> +               info->screen_base = memremap(efifb_fix.smem_start,
> +                                            efifb_fix.smem_len, MEMREMAP_WT);
> +       else if (mem_flags & EFI_MEMORY_WB)
> +               info->screen_base = memremap(efifb_fix.smem_start,
> +                                            efifb_fix.smem_len, MEMREMAP_WB);
>         if (!info->screen_base) {
> -               pr_err("efifb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
> +               pr_err("efifb: abort, cannot remap video memory 0x%x @ 0x%lx\n",
>                         efifb_fix.smem_len, efifb_fix.smem_start);
>                 err = -EIO;
>                 goto err_release_fb;
> @@ -371,7 +399,10 @@ static int efifb_probe(struct platform_device *dev)
>  err_groups:
>         sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
>  err_unmap:
> -       iounmap(info->screen_base);
> +       if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> +               iounmap(info->screen_base);
> +       else
> +               memunmap(info->screen_base);
>  err_release_fb:
>         framebuffer_release(info);
>  err_release_mem:
> --
> 2.17.1
>
>
>
>
