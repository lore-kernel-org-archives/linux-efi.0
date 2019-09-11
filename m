Return-Path: <SRS0=tepa=XG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A25AC49ED6
	for <linux-efi@archiver.kernel.org>; Wed, 11 Sep 2019 23:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66FA02085B
	for <linux-efi@archiver.kernel.org>; Wed, 11 Sep 2019 23:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UNh7ITeT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfIKXRx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 11 Sep 2019 19:17:53 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:39406 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfIKXRx (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 11 Sep 2019 19:17:53 -0400
Received: by mail-wm1-f41.google.com with SMTP id q12so5412632wmj.4
        for <linux-efi@vger.kernel.org>; Wed, 11 Sep 2019 16:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcKJG1JLrjH0Zh/aaXRveLGykoSZPnG2kjjgal1kH50=;
        b=UNh7ITeTVCdHOtmWKV7xouGWlZ6f8j8Wo5zvmXwFKIxXr7IeXswQ6bePdjBP7lcF9w
         C56STKs7BkfRbQRXQmSkgYH6Vcx/fnzXco2GccdEI8YgHg4gY0Hw9A11WE+ZpIicPI/E
         G/OgJ3dpi3C5/Z1//V/vjwY+txbPtTCGLqXhvJgRYR0Ku++1l3RLj67PBvEOGzFbwRRr
         j9PCykoqXqu5eMm0QX939krR5KAHIcR2jMlPYSJNZMHfebzGoZD7tjmhezjSZzz26lHR
         GVIWjBT3lcbPZw6v+PlLa8dETcEhAn+LQBSv6OXf/fl6CwechXTnfIjwUWOhz89SaTjS
         Akyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcKJG1JLrjH0Zh/aaXRveLGykoSZPnG2kjjgal1kH50=;
        b=RTQ7OnPRvtkbtc7akOldq2alc4xlTZxTqdJl7RxcnLlDGZLsNJzSZBeWoY+9wXO/RG
         7TU/X5GmwSbyQnyVNPaJ2Bf6u6bil+FO7h8X6YshSP2FaGodC8SLEkwTXm8KpsWia2VT
         VykGxy0S6F9NV7DpRqMJehWmDEWfC8qbSWZ7443/61jlHlhTlDVIyykG4lAZKrN2WK9e
         G8atwB98T4akcSXvlcG5zbHq+f6hIpyV9Vz8oLI7VaxZtOIzPXo7SiXDl6oY77lgMgcw
         /sjmJaTFTDiPKgFbv523zK/dAZDkJzQYlFjV/9qxbPZzE2QgcK/dHLud4G6v8+FG0xfO
         UeFw==
X-Gm-Message-State: APjAAAVrqvLGhC61auTBDyx/41mHn2zKlybmdOIZhOTz71YB1C01lTvB
        r42XghTNH+GgzL53ELbmSag2cpTt4GA/pICOwW0KOg==
X-Google-Smtp-Source: APXvYqyruieOtLvnqmAvYIWMLgr36vf18NLk4fCNZB7Z8nJVK/yZaD88u0ZrU+BNmAAiOQU3DkXQLcLNr6tRsj3YoUQ=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr5606206wma.119.1568243871768;
 Wed, 11 Sep 2019 16:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.1909111635530.3954@bear.techie.net>
In-Reply-To: <alpine.DEB.2.21.1909111635530.3954@bear.techie.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 12 Sep 2019 00:17:30 +0100
Message-ID: <CAKv+Gu_9oeMWA0_dcBkg1s2XaR4H_axGgjQ9pWELACD9uQ-0hg@mail.gmail.com>
Subject: Re: Boot regression in 4.8 for Mac Pro server
To:     Scott Talbert <swt@techie.net>
Cc:     linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 11 Sep 2019 at 21:48, Scott Talbert <swt@techie.net> wrote:
>
> Hi,
>
> I just recently discovered a boot regression that occurred starting in 4.8
> on a Mac Pro Mid-2012 server (MacPro5,1).  Yes, I realize this problem is
> over 3 years old.  Obviously, I haven't been using Linux on this hardware
> in a while.  :-)  I bisected the regression to
> 475fb4e8b2f4444d1d7b406ff3a7d21bc89a1e6f "efi / ACPI: load SSTDs from EFI
> variables".  And indeed, v5.3-rc7 will boot if I comment out the
> efivar_ssdt_load() call, as in:
>
> $ git diff
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index ad3b1f4866b3..691a8671a2ba 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -364,8 +364,8 @@ static int __init efisubsys_init(void)
>          if (error)
>                  goto err_put;
>
> -       if (efi_enabled(EFI_RUNTIME_SERVICES))
> -               efivar_ssdt_load();
> +       //if (efi_enabled(EFI_RUNTIME_SERVICES))
> +       //      efivar_ssdt_load();
>
>          error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
>          if (error) {
>
>
> Any thoughts on how to fix this?
>

Thanks for the report. It appears the SSDT loading code is slightly
broken, in the sense that it always iterates over all EFI variables
regardless of whether an SSDT override was actually requested on the
command line, which is silly.

I'll have a patch out shortly, and I'll put you on cc. Please test it
and report back.
