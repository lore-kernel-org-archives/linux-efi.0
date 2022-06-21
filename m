Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B64C43334
	for <linux-efi@archiver.kernel.org>; Tue, 21 Jun 2022 16:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353848AbiFUQTl (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 21 Jun 2022 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353832AbiFUQTl (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 21 Jun 2022 12:19:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C116229341;
        Tue, 21 Jun 2022 09:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65C12B81A68;
        Tue, 21 Jun 2022 16:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D51BC341CD;
        Tue, 21 Jun 2022 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655828378;
        bh=+aUKE0SFMaGezZlSeajtIkMvPvTFPzVipH+jo+TsWqA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e8pnXNhu/Uvp7P+YdDcoB4ahSriETYOE2AN2yvBMsIZFSrhVhl6BsNUdy1eAHmq35
         Lvt0EOwOjDXzfBsXdXgHofOREO0yiI2Xme5UGIUI8BUHmmbeMm45xnXFfhuNBfD7OI
         UGfb6NrcwNh9rQyFkDg9Ubfc+rCvKOZFlCK5D2KNh2TL03grdoTcsO/OtTooEiZFL1
         ZOFF6oP9d9QR2x1mhmEE+60BF2vIOBNSxWv8DQC1/Hul1ykH4oS9cT1Utolqqusp+M
         5yQCGn6EC7PDcPXIMlNtpLhDE/4eR3CGw+/1z70T3QVBlKnX74i3OS6oxSUjmA5bWf
         JVSTJjMr7Du1g==
Received: by mail-lj1-f174.google.com with SMTP id d19so16038461lji.10;
        Tue, 21 Jun 2022 09:19:37 -0700 (PDT)
X-Gm-Message-State: AJIora+kgbTqTLlswsw8pj6TG5c1/nLL7LanptySa7DyNCWM0ZdDfoYQ
        jCCgoPR0gzjYUYAAYyiIqvrkTdan7d2rO/ROSJs=
X-Google-Smtp-Source: AGRyM1tC5ZyuRR6Qjr+zkCD7Q1NS2YCBKqcMBusMiPyh19mwiXS1NxFzEuOurJy0IUhaQMbG+flgP1Lz6wLFBF4dTdE=
X-Received: by 2002:a05:651c:54c:b0:25a:641b:3aaa with SMTP id
 q12-20020a05651c054c00b0025a641b3aaamr8196677ljp.421.1655828376063; Tue, 21
 Jun 2022 09:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220617174851.1286026-1-ardb@kernel.org> <87bkunpv42.fsf@kernel.org>
In-Reply-To: <87bkunpv42.fsf@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 21 Jun 2022 18:19:24 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHQribJA=JyQ9t_NPYmj3c6rdXn7W_TieXOULPF1RfOew@mail.gmail.com>
Message-ID: <CAMj1kXHQribJA=JyQ9t_NPYmj3c6rdXn7W_TieXOULPF1RfOew@mail.gmail.com>
Subject: Re: [PATCH 0/4] efivar: remove inappropriate uses of the efivar API
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 20 Jun 2022 at 11:00, Kalle Valo <kvalo@kernel.org> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> writes:
>
> > The efivar layer is a caching non-volatile variable store abstraction
> > that is normally backed by EFI, but in some cases, might be backed by
> > Google SMI firmware interfaces instead.
> >
> > It is mainly used by efivarfs and EFI pstore, both of which actually
> > need the caching and abstraction properties. However, there are a few
> > other occurrences where efivar is not necessary, or used in an invalid
> > way. So let's fix this up, and remove some impediments to refactoring
> > and cleaning up the efivars layer in the future.
> >
> > Assuming there are no objections to these changes, I intend to queue
> > them up in the EFI tree fairly soon, so that ongoing work depending on
> > these changes can continue as well.
> >
>
> [...]
>
> >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |  25 ++---
> >  drivers/net/wireless/intel/iwlwifi/fw/uefi.c                |  96 ++++++------------
>
> Feel free to take the wireless patches via your tree:
>
> Acked-by: Kalle Valo <kvalo@kernel.org>
>

Thanks, I've queued these up.
