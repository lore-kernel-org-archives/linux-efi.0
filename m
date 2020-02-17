Return-Path: <SRS0=yOzI=4F=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B356C7619B
	for <linux-efi@archiver.kernel.org>; Mon, 17 Feb 2020 08:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 276A320725
	for <linux-efi@archiver.kernel.org>; Mon, 17 Feb 2020 08:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581928658;
	bh=YuwYn1OuFVo6pyjqNruXJfjYrKy4a216ddFYzIXWbZk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Wj+313c435ib4AjXtYADerJce7nVpny+uNI0mwhBq7MdsSoNRl/FxWWHkfld/ui78
	 E57Eq2ww4CyHTyj6MdTnyaHNkAIjn/Hn+vEb4W8szrqUNsYMFkL1HnWW04gPNDuWCE
	 9+9axhBpe4VBOiSIkz5bxjE92HhJ/RNq2uOCmUuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgBQIhh (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 17 Feb 2020 03:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbgBQIhh (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 17 Feb 2020 03:37:37 -0500
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DA520725
        for <linux-efi@vger.kernel.org>; Mon, 17 Feb 2020 08:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581928657;
        bh=YuwYn1OuFVo6pyjqNruXJfjYrKy4a216ddFYzIXWbZk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EpU/3uHxkmPQ++DOQk715M2m9B7EnCNfOJEprjTJwXoCfHgWwO6OR0VYmZnZWnTIl
         /naKlhR3HMIOwB1lhBx1ArKIyIIEAxaHUgzFKsPnENV3X09u3gtJmuqnbitnCyhxS+
         4EbbnQ/SI1MLXeQvHLkh0r/dQUiRyqolibzmhs/A=
Received: by mail-wm1-f54.google.com with SMTP id a6so17403143wme.2
        for <linux-efi@vger.kernel.org>; Mon, 17 Feb 2020 00:37:36 -0800 (PST)
X-Gm-Message-State: APjAAAU90GOMyEwnYeJOx/BNDMDAJQ9oKJidEEkpLfrTPcy70RbF0dy8
        at6+7YMpTuUoApIjSX2Lsp6XM2zjs5XiRn46XzJB4w==
X-Google-Smtp-Source: APXvYqwOE0W8BHa3zBYISaB7jk+5QILSPKIAAxZ6SUXeMKl2Rfr2yhn5YuTvlqofpRg9XLkoIybdGcDZiAWXDvvON4E=
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr22275347wmk.68.1581928655220;
 Mon, 17 Feb 2020 00:37:35 -0800 (PST)
MIME-Version: 1.0
References: <20200210160248.4889-1-ardb@kernel.org> <20200210160248.4889-14-ardb@kernel.org>
 <952796db5423caf21c411c6f5629f32882f55b29.camel@wdc.com>
In-Reply-To: <952796db5423caf21c411c6f5629f32882f55b29.camel@wdc.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 17 Feb 2020 09:37:24 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu_eJvZn8a45t5Hr23+QQySJOBaBwSsxW7dkYCoVPO4RPw@mail.gmail.com>
Message-ID: <CAKv+Gu_eJvZn8a45t5Hr23+QQySJOBaBwSsxW7dkYCoVPO4RPw@mail.gmail.com>
Subject: Re: [PATCH 13/19] efi/libstub: Move get_dram_base() into arm-stub.c
To:     Atish Patra <Atish.Patra@wdc.com>
Cc:     "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "nivedita@alum.mit.edu" <nivedita@alum.mit.edu>,
        "lukas@wunner.de" <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 17 Feb 2020 at 02:17, Atish Patra <Atish.Patra@wdc.com> wrote:
>
> On Mon, 2020-02-10 at 17:02 +0100, Ard Biesheuvel wrote:
> > get_dram_base() is only called from arm-stub.c so move it into
> > the same source file as its caller.
> >
>
> Just FYI: riscv efi stub port is also going to use get_dram_base().
> However, I have renamed arm-stub.c to generic efi-stub.c so that arm,
> arm64 and riscv can reuse it. Thus, Moving get_dram_base() into arm-
> stub.c works for riscv as well. I will rebase my patches on top of this
> series.
>

Thanks Atish. I was hoping it would turn out like this, which is why I
am pushing this series now.

I haven't looked at your code yet, but please avoid using the command
line based initrd/dtb loading routines. I am proposing a cleaner way
to provide the initrd from firmware [0], and dtb loading by the stub
should not be done in the first place.

[0] https://lore.kernel.org/linux-efi/20200216141104.21477-1-ardb@kernel.org/
