Return-Path: <SRS0=dVV2=DB=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93FEC4363D
	for <linux-efi@archiver.kernel.org>; Thu, 24 Sep 2020 14:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649A3238E3
	for <linux-efi@archiver.kernel.org>; Thu, 24 Sep 2020 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600958311;
	bh=qMNGY6EDO+3ndwJMkmIwz1MhJjJRvKMeigDFXJuA8Vk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ffWZUA6vSrLR/Xa0Ylar40Zlywg5LGq/khyXxnWffOcWwa/BXUGsBsiSRKRnzaUTK
	 7cSdZ9/cVnYmHU3nji1WltZgHytp85/fSJ3LvpLPL7INd2tTMHwe0K+pj1OuTAMdk1
	 +4R2sfnWWnUmxqCIfticMONYqku1ST/EO/jSriUY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgIXOiU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 24 Sep 2020 10:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgIXOiT (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 24 Sep 2020 10:38:19 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6976C23741
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2020 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600958299;
        bh=qMNGY6EDO+3ndwJMkmIwz1MhJjJRvKMeigDFXJuA8Vk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mqkQiSP9PIjLHh91mJZcqPS1QsGcedIMI6sOoihLdOhKbbKbwellui8ecl2iDxiKe
         tJZR+c3NbJq2BoEN5Tcq9DekUAFv56rEcvymaf8jPdsC5cyy37kSzIRcQekIrrdzfL
         dhYbR5Rc3otN3LjWKBQ1P4i1Bsw2rejgg8x1ICow=
Received: by mail-ot1-f43.google.com with SMTP id h17so3394776otr.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2020 07:38:19 -0700 (PDT)
X-Gm-Message-State: AOAM5325cYYjpjHW+yQ8FlIuapxbZarmfyYsf4t8YcIGewUdAYEKsEQ5
        9qEGoUMaTWgdmCm4oQ2hroe007oHBjkBCEkTtws=
X-Google-Smtp-Source: ABdhPJy8HSnkhhNVCCZT6VLlo+FjfgR0WPBZKhGUsGK1xv/n91UQgfdhC9j02mPizee816DVx89dpKmKjXxHYG8e3iY=
X-Received: by 2002:a9d:335:: with SMTP id 50mr974otv.90.1600958298792; Thu,
 24 Sep 2020 07:38:18 -0700 (PDT)
MIME-Version: 1.0
References: <1600653203-57909-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1600653203-57909-1-git-send-email-tiantao6@hisilicon.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 24 Sep 2020 16:38:07 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEr5soECqOOscD0BsXh2uOockqEObR9LpSociH-MF7cBw@mail.gmail.com>
Message-ID: <CAMj1kXEr5soECqOOscD0BsXh2uOockqEObR9LpSociH-MF7cBw@mail.gmail.com>
Subject: Re: [PATCH] efi/libstub: Fix missing-prototypes in string.c
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 21 Sep 2020 at 03:57, Tian Tao <tiantao6@hisilicon.com> wrote:
>
> Fix the following warnings.
> drivers/firmware/efi/libstub/string.c:83:20: warning: no previous
> prototype for =E2=80=98simple_strtoull=E2=80=99 [-Wmissing-prototypes]
> drivers/firmware/efi/libstub/string.c:108:6: warning: no previous
> prototype for =E2=80=98simple_strtol=E2=80=99 [-Wmissing-prototypes]
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Applied as a fix, thanks.

> ---
>  drivers/firmware/efi/libstub/string.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/firmware/efi/libstub/string.c b/drivers/firmware/efi=
/libstub/string.c
> index 1ac2f87..5d13e43 100644
> --- a/drivers/firmware/efi/libstub/string.c
> +++ b/drivers/firmware/efi/libstub/string.c
> @@ -7,6 +7,7 @@
>   */
>
>  #include <linux/ctype.h>
> +#include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
>
> --
> 2.7.4
>
