Return-Path: <SRS0=XvGZ=DG=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14A4C4727C
	for <linux-efi@archiver.kernel.org>; Tue, 29 Sep 2020 17:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB1F2076B
	for <linux-efi@archiver.kernel.org>; Tue, 29 Sep 2020 17:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601401017;
	bh=R+BspxoVDllk+vporK/akvNxcNaeF4A2h++L1ZRNi0w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SgwWL3cIjvQyu07QZR2/rdx8Q92EvGAt+Y2xXIwt3bpa0jDgIFea8GIJccn6M6Zwv
	 fv6jDmel7C8I+epW7iyIO2tejI9SYEi1EI1G69lcdrqXfy1uZ+ssu508BeEzZo1blg
	 bWbfzvR2tSU7VMjZHxbeRtF/7NtOUHuwSev4u6Lc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgI2Rg5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2Rg5 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 29 Sep 2020 13:36:57 -0400
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F6792076B
        for <linux-efi@vger.kernel.org>; Tue, 29 Sep 2020 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601401016;
        bh=R+BspxoVDllk+vporK/akvNxcNaeF4A2h++L1ZRNi0w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=D2UUYAi+2lcJ8xExnvOjTC2zmDUTrqwPpl9fzOasOpDGJS23/aljBA/EsKpiqlAzw
         xSmZzqM9+56hqMawvVDPZDPmFwDzKg5RjsNxcIV4bRf/PzJT6PhivJDumrFTKY6ykG
         V9Rsfua19f2R66oRhPGgrKHM0yo9rBYOavkCf7H4=
Received: by mail-oo1-f52.google.com with SMTP id w25so1486255oos.10
        for <linux-efi@vger.kernel.org>; Tue, 29 Sep 2020 10:36:56 -0700 (PDT)
X-Gm-Message-State: AOAM533UAyY/B0auuPghY09OXK12O1RPr5EtSKLtsHhHx/kPpnUlfj55
        c5FW1C1mRWcjYzb1gmfEyM7T272bfXjPKrlIe4E=
X-Google-Smtp-Source: ABdhPJzFWLyZIBvBT9/otONtvk/yewBOTnMqvBPr0tZp/rWSLpTjpNi4ONepcr8ZBf54tWGR1PUJ0JSICVAAz1B6cDc=
X-Received: by 2002:a4a:b443:: with SMTP id h3mr5423163ooo.45.1601401015532;
 Tue, 29 Sep 2020 10:36:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200924160546.8967-1-ardb@kernel.org> <20200929165840.GI21110@zn.tnic>
In-Reply-To: <20200929165840.GI21110@zn.tnic>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 29 Sep 2020 19:36:44 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHP7NjXd9gzKCYW2jsHE67PdmxGwGTTBD1o_301Sts-yw@mail.gmail.com>
Message-ID: <CAMj1kXHP7NjXd9gzKCYW2jsHE67PdmxGwGTTBD1o_301Sts-yw@mail.gmail.com>
Subject: Re: [PATCH] efi: mokvar-table: fix some issues in new code
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, 29 Sep 2020 at 18:58, Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 24, 2020 at 06:05:46PM +0200, Ard Biesheuvel wrote:
> > Fix a couple of issues in the new mokvar-table handling code, as
> > pointed out by Arvind and Boris:
> > - don't bother checking the end of the physical region against the start
> >   address of the mokvar table,
> > - ensure that we enter the loop with err = -EINVAL,
> > - replace size_t with unsigned long to appease pedantic type equality
> >   checks.
> >
> > Cc: Lenny Szubowicz <lszubowi@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Arvind Sankar <nivedita@alum.mit.edu>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  drivers/firmware/efi/mokvar-table.c | 25 +++++++++++--------------
> >  1 file changed, 11 insertions(+), 14 deletions(-)
>
> i386 allmodconfig looks good.
>
> Tested-by: Borislav Petkov <bp@suse.de>
>

Thanks Boris. I'll have a PR out shortly.
