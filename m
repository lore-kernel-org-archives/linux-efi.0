Return-Path: <SRS0=pOKh=4W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303C1C3F2CD
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 08:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C5420870
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 08:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583398293;
	bh=0cu+E7SCRqW6qkQHGXrzeQ+THUKLi1C1UePfJyu621M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=P6eMrBdynhuOzISKGya5zseMmHBwT1XEzd0Zi3HUUZD5TBlmDyGL9OxiLd9+NP7Br
	 pt0E1l5kHEb/e2rfoTRMEJigMhe3dGK9lm4Crx4RXp8DoXmowMUzaGIYHf5QwN0pMy
	 M0c05fyCdveyKJ7ccHWfV9cD7ExaKsLk29O50QRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgCEIvc (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 5 Mar 2020 03:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgCEIvc (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 5 Mar 2020 03:51:32 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6576021556
        for <linux-efi@vger.kernel.org>; Thu,  5 Mar 2020 08:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583398291;
        bh=0cu+E7SCRqW6qkQHGXrzeQ+THUKLi1C1UePfJyu621M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r4fzgfaMgkKh+As+J8drFx6XKOa59EaD3zNOFsNH76p0Vz4E8Gozfob3HT2U1GdhD
         49pnayl9w7uPl/YibyEKehJCohTD7tjNPxNdIZRknXQ/nsU+jpPU9oP55qe1j6enCZ
         KoMjOYtEebuTRua40kfCZIr51ysrzmt2fveEq29E=
Received: by mail-wr1-f43.google.com with SMTP id j16so5960978wrt.3
        for <linux-efi@vger.kernel.org>; Thu, 05 Mar 2020 00:51:31 -0800 (PST)
X-Gm-Message-State: ANhLgQ0b850lNeGeVzUeN9HlFgLSX/6U9WABChfgne3NC+vd2M47/nO7
        UkRy8FmMO0V/ofII84aX8q6ZNgRcRFEkDh7aVy45sQ==
X-Google-Smtp-Source: ADFU+vu1ijqG8p3DiUfaypO6t/Xgilxszgy8aBBPXyoFMVMrP4wcYC1eIZIlszQmXGBZPcUsbJET0oDCe8arwlQ0SVo=
X-Received: by 2002:a05:6000:110b:: with SMTP id z11mr9167986wrw.252.1583398289927;
 Thu, 05 Mar 2020 00:51:29 -0800 (PST)
MIME-Version: 1.0
References: <CAKv+Gu_3ZRRcoAcLTVVQe26q5x9KALmztaNQF=e=KqWaAwxtpA@mail.gmail.com>
 <20200305084041.24053-1-vdronov@redhat.com>
In-Reply-To: <20200305084041.24053-1-vdronov@redhat.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 5 Mar 2020 09:51:19 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu8EzLoaa5PP8FjPqY1OUYoftmibHJUPB13mFW3AH_Y4cw@mail.gmail.com>
Message-ID: <CAKv+Gu8EzLoaa5PP8FjPqY1OUYoftmibHJUPB13mFW3AH_Y4cw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] efi: fix a race and add a sanity check
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>, joeyli <jlee@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 5 Mar 2020 at 09:41, Vladis Dronov <vdronov@redhat.com> wrote:
>
> There is a race and a buffer overflow while reading an efi variable
> and the first patch fixes it. The second patch adds a sanity check
> to efivar_store_raw(). And the third one just fixes mistypes in
> comments.
>
> Vladis Dronov (3):
>   efi: fix a race and a buffer overflow while reading efivars via sysfs
>   efi: add a sanity check to efivar_store_raw()
>   efi: fix a mistype in comments mentioning efivar_entry_iter_begin()
>

Queued in efi/next

Thanks!

>  drivers/firmware/efi/efi-pstore.c |  2 +-
>  drivers/firmware/efi/efivars.c    | 32 +++++++++++++++++++++++---------
>  drivers/firmware/efi/vars.c       |  2 +-
>  3 files changed, 25 insertions(+), 11 deletions(-)
>
