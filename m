Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DD2C636C9
	for <linux-efi@archiver.kernel.org>; Sat, 17 Jul 2021 04:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50DFD613DF
	for <linux-efi@archiver.kernel.org>; Sat, 17 Jul 2021 04:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhGQEtN (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 17 Jul 2021 00:49:13 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47962 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhGQEtK (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 17 Jul 2021 00:49:10 -0400
Received: from nazgul.tnic (dynamic-046-114-108-062.46.114.pool.telefonica.de [46.114.108.62])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 087031EC01DF;
        Sat, 17 Jul 2021 06:46:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1626497173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3M0HHIDsXQMiqNzK6NF6d4UYiioYoZODXBgEh9/csxQ=;
        b=VwKk7MlHT0KOjk3EULO8DBbbQHyPS0IFWlTSrWmlbaftespX+XMiM9hek8QhUhn+fq+702
        eH6QI1X3QM/2XV0YAS4YnIERJ432GxO7Ro3NKt6pJKkQjp63kd6S4E6gaTL3PBavlU7BzD
        jcgXgau+X/nZNHmKVndKudZAv1dMmQY=
Date:   Sat, 17 Jul 2021 06:46:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Lenny Szubowicz <lszubowi@redhat.com>, Gary Lin <glin@suse.com>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] efi/mokvar: Reserve the table only if it is in boot
 services data
Message-ID: <YPJgYp9kt5p06WX+@nazgul.tnic>
References: <YNwu7LmZaImyoOer@zn.tnic>
 <CAMj1kXE--H53wu_X=GpgeJmWs7vjpnkUnG_fc+59GaNDF+sYEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXE--H53wu_X=GpgeJmWs7vjpnkUnG_fc+59GaNDF+sYEw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Jul 16, 2021 at 07:10:17PM +0200, Ard Biesheuvel wrote:
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks for checking me here.

> Would you like me to queue this as a fix?

Well, I wanna say it is unnecessary to send it as an urgent fix because
we have the SEV fix in place now and I guess we'll leave it in in case
something else is in boot services and is needed for SEV guests to boot.

So I guess just a normal, unexpedited fix please, so that it sees more
testing before it goes up.

Thx Ard!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
