Return-Path: <SRS0=AX1q=C6=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4318C4727C
	for <linux-efi@archiver.kernel.org>; Mon, 21 Sep 2020 22:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B87A23A62
	for <linux-efi@archiver.kernel.org>; Mon, 21 Sep 2020 22:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="m9L9cROE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgIUWSm (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 21 Sep 2020 18:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUWSm (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 21 Sep 2020 18:18:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ADDC061755
        for <linux-efi@vger.kernel.org>; Mon, 21 Sep 2020 15:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0Cs07+XvqgrJQX4qFJkbQFKhx88Hw8XoTK91JOuGZkA=; b=m9L9cROEnX699g/CTAkZAU6Hs
        wmz+jOZQMa+kxxw6i9hTUyND0upIFXXcFYp+9geqLd/X4s0inGXQFldUGUAo+7mEhLB/uHy0rWU0U
        rqioLubg3OTAOmY2QEzTaO02NiSgzgag6obNajnIKdmfBUMR210m65acb4+TgLOVi7krinTRo6UET
        PgF+8j1+0HcPOsmzeT4Crcnhb9iX6zmGTfaSN1mqfmeFo+mc9Mto6UdoC5CF20UCLTQi2ASy9kQnN
        yzPTpsxdpUJBQ+gYXDQ7cu72e7QWtDP+/fJLfkIA20/MVRT3IVyy8LqvlOxClCX2JJU+MtkMKlMQi
        5KlvTPgOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36594)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kKU8l-0002Hm-5Q; Mon, 21 Sep 2020 23:18:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kKU8i-0001hP-62; Mon, 21 Sep 2020 23:18:28 +0100
Date:   Mon, 21 Sep 2020 23:18:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH v2 01/10] ARM: p2v: fix handling of LPAE translation in
 BE mode
Message-ID: <20200921221828.GZ1551@shell.armlinux.org.uk>
References: <20200921154117.757-1-ardb@kernel.org>
 <20200921154117.757-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921154117.757-2-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, Sep 21, 2020 at 05:41:08PM +0200, Ard Biesheuvel wrote:
> When running in BE mode on LPAE hardware with a PA-to-VA translation
> that exceeds 4 GB, we patch bits 39:32 of the offset into the wrong
> byte of the opcode. So fix that, by rotating the offset in r0 to the
> right by 8 bits, which will put the 8-bit immediate in bits 31:24.
> 
> Note that this will also move bit #22 in its correct place when
> applying the rotation to the constant #0x400000.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Should this have a fixes tag?

> ---
>  arch/arm/kernel/head.S | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index f8904227e7fd..98c1e68bdfcb 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -671,12 +671,8 @@ ARM_BE8(rev16	ip, ip)
>  	ldrcc	r7, [r4], #4	@ use branch for delay slot
>  	bcc	1b
>  	bx	lr
> -#else
> -#ifdef CONFIG_CPU_ENDIAN_BE8
> -	moveq	r0, #0x00004000	@ set bit 22, mov to mvn instruction
>  #else
>  	moveq	r0, #0x400000	@ set bit 22, mov to mvn instruction
> -#endif
>  	b	2f
>  1:	ldr	ip, [r7, r3]
>  #ifdef CONFIG_CPU_ENDIAN_BE8
> @@ -685,7 +681,7 @@ ARM_BE8(rev16	ip, ip)
>  	tst	ip, #0x000f0000	@ check the rotation field
>  	orrne	ip, ip, r6, lsl #24 @ mask in offset bits 31-24
>  	biceq	ip, ip, #0x00004000 @ clear bit 22
> -	orreq	ip, ip, r0      @ mask in offset bits 7-0
> +	orreq	ip, ip, r0, ror #8  @ mask in offset bits 7-0
>  #else
>  	bic	ip, ip, #0x000000ff
>  	tst	ip, #0xf00	@ check the rotation field
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
