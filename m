Return-Path: <SRS0=aW0u=SO=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFB5C282CE
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 21:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B148218C3
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 21:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gsORl6j2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDLVV7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:21:59 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:38197 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLVV6 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 12 Apr 2019 17:21:58 -0400
Received: by mail-it1-f195.google.com with SMTP id f22so18066819ita.3
        for <linux-efi@vger.kernel.org>; Fri, 12 Apr 2019 14:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CD2wv3rY1Exb2e5pPjoFmtA4i6FCXkTGtKe/HQlzeNE=;
        b=gsORl6j2k7aytbXDr0F8ST7lbFp8EwcAFacKjVWB3VfBRKOjGZyVmlrLmYgwW8ls4R
         1nZyVwJga9Rq9Rft7Y7ojVaKIaafTy1MjnxJBd4g0LwnUPMEneIUnaXZ2SmPb5Rj6fMm
         7zkaWTXBXZ7d3+JAczso3ge6mP1m4gjV2m91DjP8YICfsgB0TG7iAYJr6LkJX9QeX/yG
         gLGvimdegL6tte7fKQBG/SpUQ2HfrTY1EEok+WVSksDvW1KD1bLbht4t4oynfLIErVI5
         Zwjje0/4jEEJ65y8W2XoKR43JbVjO3HccF+2lSQALVPybWfXkRuGL765PeRczhNCJiot
         Uw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CD2wv3rY1Exb2e5pPjoFmtA4i6FCXkTGtKe/HQlzeNE=;
        b=BuhTyvsm82fKmuH/peB9tB3IOyCzt/Att2iCXn0EVzchl5Exi7y0ygbiZYDCpfLNbW
         G8jLcgEmJgqBTLXCF9I0TBnpncJSQbBg2UCENPsf8HCoewKg5dSUzWxCMUcJkVMKkLCw
         3S7HxIP/R3UZaYdwz4wKs7LfgjVdKnsw9C1NU4qnh4BkEt3LEtui4ZsjPLIGr/Xky5Nc
         sHSzM5e4ZQ96/1rjrVj+Yqw3uB77Pt+SAhafB89IhSixZsXLS974YHjA8VUTe8/jR4H9
         7BM3MH0fXvIBM+ue7AAx4KufzRmbike6efmiXH9/8O3huftMaeVJVkm756zrPgPyVFHO
         4xBg==
X-Gm-Message-State: APjAAAU43jyVoWxVti8PMatqW0yUKK/Z6LhzLkkEJLrHhzi6fWLXBpmG
        VtOOJYOp1GGpJc9ifzzUQciZkN0qt/KvT3jNzV0KEw==
X-Google-Smtp-Source: APXvYqxsIf2iesBepnLKUEPL3WM4dzFZMH5djNStuzBJcBUHdG367ilzKYnK83NargB9j03qkbt9sNDT3ATJ8OEW1UA=
X-Received: by 2002:a02:658b:: with SMTP id u133mr35280584jab.17.1555104117739;
 Fri, 12 Apr 2019 14:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com>
 <20190412205834.aok6v3fnjaxl27qt@shell.armlinux.org.uk> <CAKv+Gu_vejJz0Gh4hz75yvUcbpiDGyA0KjUS=hSgMmMv_Z1dOg@mail.gmail.com>
 <20190412212055.lgsnjle3x75gu22m@shell.armlinux.org.uk>
In-Reply-To: <20190412212055.lgsnjle3x75gu22m@shell.armlinux.org.uk>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 12 Apr 2019 14:21:47 -0700
Message-ID:
 <CAKv+Gu_4bNq8D4dRDB=qgcngpXoJNCOz5DN=w-A21cW8swCdQw@mail.gmail.com>
Subject: Re: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning
 the cache
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190412212147.ujsKrPMiUTHAitbVbXEu0rjCiPZ2MyaiUOrZtpXb1Es@z>

On Fri, 12 Apr 2019 at 14:21, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 12, 2019 at 02:00:16PM -0700, Ard Biesheuvel wrote:
> > If I use the forgotten password feature, it tells me
> >
> > """
> > The email address you provided (ard.biesheuvel@linaro.org) is not
> > valid. Please try again.
> > """
>
> Fixed, consequence of the upgrades back in January, requiring a
> change to the regular expression system, which caused my simple
> fixups to then generate an invalid RE.  You should have received
> the new password as a result of my testing.
>
> Thanks for reporting the problem - that's the only way problems
> get fixed!
>

Indeed. Thanks for solving it so quickly.
