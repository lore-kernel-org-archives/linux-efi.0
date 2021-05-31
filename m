Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64298C47097
	for <linux-efi@archiver.kernel.org>; Mon, 31 May 2021 14:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D162613AE
	for <linux-efi@archiver.kernel.org>; Mon, 31 May 2021 14:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhEaOar (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 31 May 2021 10:30:47 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41678 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhEaO2c (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 31 May 2021 10:28:32 -0400
Received: from zn.tnic (p200300ec2f080f0041f75464688c3931.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:f00:41f7:5464:688c:3931])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B500D1EC04DE;
        Mon, 31 May 2021 16:26:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622471209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pWoyNc/5ib9ExSAsSvvyTuh8dISKublQeSIUTS6gyFo=;
        b=rUBHLWxlsportLZb96JapQrhx5KY6L5errtTbQH2jp+5S2P1RucW73TDiJCobc8l0fs/S6
        sLXnY5sGpE7mMcThzoRfy52OxtLU42abXyuaLvw6rqqeo4fsaZdpFA56eW0sdmQ49dSeSn
        drQRgCA/RPeDd4XXZVYd0wRhG9bv2lY=
Date:   Mon, 31 May 2021 16:26:42 +0200
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
Message-ID: <YLTyIn2S9wCB88Es@zn.tnic>
References: <20210531090023.16471-1-lijiang@redhat.com>
 <YLSnkKeoQnokXVsK@zn.tnic>
 <YLSzUBQ/7CyINu87@kernel.org>
 <YLS/1sqz6Bncg5VU@zn.tnic>
 <YLTTR5bpOv3XNu32@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YLTTR5bpOv3XNu32@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, May 31, 2021 at 03:15:03PM +0300, Mike Rapoport wrote:
> Hmm, why?
> The regression is from v5.13-rc1, isn't it?

Ah ok

a799c2bd29d1 ("x86/setup: Consolidate early memory reservations")

went into -rc1.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
