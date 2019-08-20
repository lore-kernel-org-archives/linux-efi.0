Return-Path: <SRS0=vns8=WQ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EBCC3A589
	for <linux-efi@archiver.kernel.org>; Tue, 20 Aug 2019 11:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C71722CF7
	for <linux-efi@archiver.kernel.org>; Tue, 20 Aug 2019 11:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="mQnUignn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfHTL5C (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:57:02 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36142 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTL5C (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 20 Aug 2019 07:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=viiM5yef80mqYHoKubrPSE4uLR54U0Urs44z5uxA47U=; b=mQnUignnqiBHoHq4snqG+ZRNV
        vZZ9u5OQGD/zs0XLpbn6qTbGj3DCsO8rDSF1Mp9exhjRsGuIfplteaRjLYaIt2S1X37WLjaZHt2qo
        BIZOigOwmPOnGyn4HjCsbrUH69ZUPB0TZ2wA34q/E2kBRzHKahQG6M0T86P31KOhRwZMvmf2sw+7j
        IhhmGGkbzxSYZLjH6rL6hJ4q9QKGR5raLcNs7i0Sdpt+M/kB/w5lUVbKMH3LTDoXlmtWvYoD1IozU
        Mlin2XuG2Fzf34UwLqObDThoIECgqfzSGVSTKsRl1n4IJK0zhZbioBrn/ARbJm8CFs2W9JrWqhv2G
        /of5Tn8vQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:47222)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i02kp-00021b-52; Tue, 20 Aug 2019 12:56:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i02ko-0005mY-1U; Tue, 20 Aug 2019 12:56:46 +0100
Date:   Tue, 20 Aug 2019 12:56:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Chester Lin <clin@suse.com>
Cc:     "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "ren_guo@c-sky.com" <ren_guo@c-sky.com>,
        Juergen Gross <JGross@suse.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "guillaume.gardet@arm.com" <guillaume.gardet@arm.com>,
        Joey Lee <JLee@suse.com>, Gary Lin <GLin@suse.com>
Subject: Re: [PATCH] efi/arm: fix allocation failure when reserving the
 kernel base
Message-ID: <20190820115645.GP13294@shell.armlinux.org.uk>
References: <20190802053744.5519-1-clin@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802053744.5519-1-clin@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Aug 02, 2019 at 05:38:54AM +0000, Chester Lin wrote:
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index f3ce34113f89..909b11ba48d8 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1184,6 +1184,9 @@ void __init adjust_lowmem_bounds(void)
>  		phys_addr_t block_start = reg->base;
>  		phys_addr_t block_end = reg->base + reg->size;
>  
> +		if (memblock_is_nomap(reg))
> +			continue;
> +
>  		if (reg->base < vmalloc_limit) {
>  			if (block_end > lowmem_limit)
>  				/*

I think this hunk is sane - if the memory is marked nomap, then it isn't
available for the kernel's use, so as far as calculating where the
lowmem/highmem boundary is, it effectively doesn't exist and should be
skipped.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
