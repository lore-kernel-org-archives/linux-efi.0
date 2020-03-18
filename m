Return-Path: <SRS0=aUYe=5D=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83935C10DCE
	for <linux-efi@archiver.kernel.org>; Wed, 18 Mar 2020 20:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56EFF20714
	for <linux-efi@archiver.kernel.org>; Wed, 18 Mar 2020 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584562785;
	bh=2BOvFL6wDqhZM4tL2WXsTzNvoXA1qAyLp4CuLbPElwQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=jlKE1U8WPXSBZFiW8DiuIMSV+Us1NK4dhcJVV7aCqG8UXjP0LfvnjG+A6zgNXUy8o
	 nOubxXwm4HXKAo4WqbfNut5f50l89eK9pR6FdpHEz+CzO5HsukZdJJR6nprMfeEDL5
	 5Wu6GwgG9uNqilxuyNWOgnhfE+AVustOQoI3uqh8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCRUTo (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 18 Mar 2020 16:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgCRUTo (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 18 Mar 2020 16:19:44 -0400
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5EE82077B
        for <linux-efi@vger.kernel.org>; Wed, 18 Mar 2020 20:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584562783;
        bh=2BOvFL6wDqhZM4tL2WXsTzNvoXA1qAyLp4CuLbPElwQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rxyYS/KThs08WX8a343+WvilwkUHtvjfmEQXw/7enmZL0mDD7wDw4C73UHDTEN9sM
         ShC2iFMjOmb3ZzEj3mG4Euob5FcZg0izLoHYcTyxHwlARFo7CGDU6mEqXuc4dqvGs5
         W6UR6Jb37n+UiSi1Qt1u4bVyrINBMvl1p+0wecYs=
Received: by mail-qv1-f50.google.com with SMTP id n1so9910420qvz.4
        for <linux-efi@vger.kernel.org>; Wed, 18 Mar 2020 13:19:43 -0700 (PDT)
X-Gm-Message-State: ANhLgQ31Pq/boZE12j6TOq5Iat+uqim7+JzvRy3fVZanr/cOqa2dj45M
        2muo7vogHLMS4o70YtuvAEIn1aX+Yi9zUcsHCJXccg==
X-Google-Smtp-Source: ADFU+vvcG/jaaqeVu4NnhMXDQ3RRng6YN9Mn4g+XqWh2XIesDR7bZ/BoYLXTyeygvvnYgL3hUzCcPYMgEVmKtorH2vQ=
X-Received: by 2002:a0c:80a5:: with SMTP id 34mr6294470qvb.184.1584562782783;
 Wed, 18 Mar 2020 13:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200312011312.70653-1-qiuxu.zhuo@intel.com> <CAKv+Gu9BvqZavV6XjfuacXXpabNCXLYEw-f=81fwX8hdL6Fn-A@mail.gmail.com>
 <d0a09900ca0341029980d351bbe2aecc@intel.com>
In-Reply-To: <d0a09900ca0341029980d351bbe2aecc@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 18 Mar 2020 16:19:31 -0400
X-Gmail-Original-Message-ID: <CAKv+Gu82OFMJk-jQKdvA0_Sgp_CCmvC1a63QYrY+Cc4Qjx3+Yw@mail.gmail.com>
Message-ID: <CAKv+Gu82OFMJk-jQKdvA0_Sgp_CCmvC1a63QYrY+Cc4Qjx3+Yw@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] Add capsule-pstore backend support
To:     "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "Gao, Liming" <liming.gao@intel.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 16 Mar 2020 at 01:33, Zhuo, Qiuxu <qiuxu.zhuo@intel.com> wrote:
>
> > From: linux-efi-owner@vger.kernel.org <linux-efi-owner@vger.kernel.org> On
> >...
> > On Wed, 11 Mar 2020 at 21:12, Qiuxu Zhuo <qiuxu.zhuo@intel.com> wrote:
> > >
> > > Change Log v5->v6:
> > >   Part1: No changes.
> > >   Part2: Update capsule-pstore.c file header.
> > >          Move the variable 'efi_capsule_pstore_info' backward (for removing
> > some function declarations).
> > >
> >
> > This conflicts badly with the efi/core changes queued up in the tip tree (and hence linux-next) Please rebase and repost
>
> Hi Ard,
>
> The following commit on the tip tree removes the variables 'config_table' from the efi structure.
>
>     9cd437ac0ef4 ("efi/x86: Make fw_vendor, config_table and runtime sysfs nodes x86 specific")
>
> But the external driver "capsule-pstore.ko" needs to access 'config_table' and 'nr_tables' to go through
> the configuration table to extract crash capsules.
>
> Adding 'config_table' and 'nr_tables' back to the efi structure looks like not a good way.
> Do you have any  suggestion on how to export 'config_table' and 'nr_tables' variables for the external driver "capsule-pstore.ko"?
>

I will get back to you on monday about this. In any case, this will
have to wait until v5.8

>
