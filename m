Return-Path: <SRS0=QuFd=SK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44657C10F13
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 21:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 126EF2148E
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 21:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FCwwjEBs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfDHVjL (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:39:11 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37820 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfDHVjL (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 8 Apr 2019 17:39:11 -0400
Received: by mail-io1-f65.google.com with SMTP id x7so12417006ioh.4
        for <linux-efi@vger.kernel.org>; Mon, 08 Apr 2019 14:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kfbop1Rhh0LwC0/fiY9eje6v/iTvzNLN1C0UmH+zUl8=;
        b=FCwwjEBsmKid8gqcGPRG6SR31tD2DMQkJU9c200IuFCOUhSIOXKSxal7cVysY63Syc
         EMdKvDpwMywC+Yfy0r2idxul0NqmjRE6WJEFzdUxR5UzRKoHEw2Xyy9ZxDjPH8UbOEM+
         otkSeLpcjWBgFpEW/V/0rTc3Xd2umXYjSQKPLH29HnvTZn+FjGy3y1cNjJz/GC7iIuvX
         bMrSeZ9Vz9kbrNmMI2Db4kM6s55kNVtrEbVzR8iItGDVCFZpbJp8TfuKzBhL++7igvJ+
         lLuSYlTXdQsXCYw3J15Jk2xAkL3ozLj2RcAaNnzQD7Ac0TQPJh6CQxOLb6c7X0XH/gk/
         R91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kfbop1Rhh0LwC0/fiY9eje6v/iTvzNLN1C0UmH+zUl8=;
        b=NrgWcWNXjQMvAwyMMPABV1lta0wvwkPE+zLeRU5qJqXyflLYtxMa5/ak4e9nJhOgXn
         3XrItC4FpsYmVxuSHCX8H9qCB+voj8EWEtotiH1rqgCrjDacxjmym0/WVpVywzdvP0al
         BoZYUoWZWBk/+V/7DuVR/ILcEI4woTASbU+SdFS5DRp9EIhHdKvudchJlTHdKGIdc2pV
         Xsz0l166FNriPC0UxwgmJmRWtHVK8w6O2ssauumWTqJKtU8AoRr8D+eHYB7MEg3tJuaa
         p9Lz2npms5zCYxwMT6kCW33u8gu7GhS4bL7cPWhgBjdDdT0144gS1Lh2p5F7hv+w0Q4/
         7sNA==
X-Gm-Message-State: APjAAAWK52nP9C/HnucXxUykXC1Ew0DW2S2jYFW+cgfwT2hbvhTEqxP7
        r16qFZWKgXg5ou9xiglen2fLVdVzBiGpLIFX4jLi7A==
X-Google-Smtp-Source: APXvYqxJy8tMfAe98EFeJwN4HlMEXAZ/pGNGpN1EFtDyq7rO1GNg1qIeP17ul/BHPaN1yL9EfQLdxhQfP2AXqNJPH4M=
X-Received: by 2002:a6b:3b07:: with SMTP id i7mr19936460ioa.230.1554759550537;
 Mon, 08 Apr 2019 14:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com> <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com> <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
 <1a77f587-3538-441f-c6c1-8e56fb65d855@arm.com>
In-Reply-To: <1a77f587-3538-441f-c6c1-8e56fb65d855@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 8 Apr 2019 23:38:59 +0200
Message-ID:
 <CAKv+Gu9dF-m_qjwJhDv656UGv9dQME=646TN55MUEB6Njwv-qQ@mail.gmail.com>
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the cache
To:     Vladimir Murzin <vladimir.murzin@arm.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Steve McIntyre <steve.mcintyre@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190408213859.F1An7nYS2_DConR0jPpfRTJsryy63e8txkAUi1lNOWM@z>

On Mon, 8 Apr 2019 at 11:20, Vladimir Murzin <vladimir.murzin@arm.com> wrote:
>
> On 4/7/19 7:19 PM, Ard Biesheuvel wrote:
> > Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
> > v6. Would reading back SCTLR suffice?
>
>
> I think instr_sync macro should do the trick.
>

This code should run on v7 when compiled for v6, and instr_sync uses
the CP15 ISB in that case, which we cannot use since that is what we
are enabling in the first place.

I'll go with Marc's suggestion, which should work in all cases
(although it may require a .arch directive to ensure the isb is
accepted)
