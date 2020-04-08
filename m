Return-Path: <SRS0=FM6U=5Y=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5800C2D0F4
	for <linux-efi@archiver.kernel.org>; Wed,  8 Apr 2020 17:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A70452075E
	for <linux-efi@archiver.kernel.org>; Wed,  8 Apr 2020 17:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="HgiWbD9r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgDHR6C (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 8 Apr 2020 13:58:02 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59098 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgDHR6C (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 8 Apr 2020 13:58:02 -0400
Received: from zn.tnic (p200300EC2F0A93002886CB34BCAFCB01.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9300:2886:cb34:bcaf:cb01])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 90F541EC0CD9;
        Wed,  8 Apr 2020 19:58:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586368680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EzzxUVtmTm/3Jlc1oShOC/yjn0NG06h83DNl2MgAQgg=;
        b=HgiWbD9rW0RVGYaoQrtZR5kayVtadTnVRw9XJ447LU49VDnnv61CUm0N4zhFCIeH5YYvJf
        J7L61rcPQRI1RLxG/kahf3/pN6RIid/wknNDP+fJzhEqyMLr6NXpTfLaVgctoP0Qc6tz9C
        N6eLcJkM+MS1n52Zzcrj/tDuou+0V/w=
Date:   Wed, 8 Apr 2020 19:57:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Benjamin Thiel <b.thiel@posteo.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: Add a prototype for efi_arch_mem_reserve()
Message-ID: <20200408175756.GG24663@zn.tnic>
References: <20200326135041.3264-1-b.thiel@posteo.de>
 <CAMj1kXF6UF318wCL74T9orJk=+LafZ3VFXUGmqoBefYVaP2gNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXF6UF318wCL74T9orJk=+LafZ3VFXUGmqoBefYVaP2gNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Apr 08, 2020 at 07:39:56PM +0200, Ard Biesheuvel wrote:
> On Thu, 26 Mar 2020 at 14:50, Benjamin Thiel <b.thiel@posteo.de> wrote:
> >
> > ... in order to fix a -Wmissing-ptototypes warning:
> >
> > arch/x86/platform/efi/quirks.c:245:13: warning:
> > no previous prototype for ‘efi_arch_mem_reserve’ [-Wmissing-prototypes]
> > void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
> >
> > Signed-off-by: Benjamin Thiel <b.thiel@posteo.de>
> 
> Thanks. I'll queue this as a fix.

I already took that one, see:

860f89e61824 ("x86/efi: Add a prototype for efi_arch_mem_reserve()")

but forgot to Cc: linux-efi@.

Sorry about that.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
