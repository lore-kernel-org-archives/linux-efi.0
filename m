Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C255C47082
	for <linux-efi@archiver.kernel.org>; Mon, 31 May 2021 10:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC2966127C
	for <linux-efi@archiver.kernel.org>; Mon, 31 May 2021 10:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhEaKxz (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 31 May 2021 06:53:55 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33492 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhEaKxz (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 31 May 2021 06:53:55 -0400
Received: from zn.tnic (p200300ec2f080f0029ca4f7a5f3cda43.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:f00:29ca:4f7a:5f3c:da43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 567FF1EC0532;
        Mon, 31 May 2021 12:52:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622458334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=gz+T85U8W74nvX9nrcXN0uN8SHElMA1YwRXNF8oaJg8=;
        b=UZNv76eCVT9x1LF4NTudjctiOiAxzkPNQ32B0xhAoNQhvLig14UNhtM9bEtbaYpzpr9WCy
        R6mbz1AOZJtflnLOAppaPD6NHdeSKgS6gpeDWVuHyKoz0ilpsEkvtN21FYCEsLiDyWVs19
        rrB1ZcNY+qYoCyUaTIe3QxSioM4NsBw=
Date:   Mon, 31 May 2021 12:52:06 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Lianbo Jiang <lijiang@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, kexec@lists.infradead.org,
        ardb@kernel.org, dvhart@infradead.org, andy@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        luto@amacapital.net, bhe@redhat.com, dyoung@redhat.com
Subject: Re: [PATCH v2] x86/efi: unconditionally hold the whole low-1MB
 memory regions
Message-ID: <YLS/1sqz6Bncg5VU@zn.tnic>
References: <20210531090023.16471-1-lijiang@redhat.com>
 <YLSnkKeoQnokXVsK@zn.tnic>
 <YLSzUBQ/7CyINu87@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YLSzUBQ/7CyINu87@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, May 31, 2021 at 12:58:40PM +0300, Mike Rapoport wrote:
> Right, but TBH, I didn't update efi_free_boot_services() in my initial
> version. I've added similar change there now and I'm waiting now to see if
> kbuild is happy with this:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=x86/reservelow

Right, also I'm guessing that first patch should be

Cc: <stable@vger.kernel.org>

as there was one report with failing boot, right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
