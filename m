Return-Path: <SRS0=aW0u=SO=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DEEC10F0E
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 21:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBE44218A3
	for <linux-efi@archiver.kernel.org>; Fri, 12 Apr 2019 21:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="X8q8v4Me"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfDLVVC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:21:02 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59072 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLVVC (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 12 Apr 2019 17:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fphs08nT3UJgnpf/eth67NHe2iN7SpZRRZOc7nasMU4=; b=X8q8v4MeuEzEYQNgTGzD86pud
        UZz5xxFGTp1HluJkNSTsgGEB5YmfP8D1Fkmv+pzRys7gPl4mzTh+UfK7+Pea7WnppAo4HIgWzAN0/
        mmB7n2CRlCULkt+qXCWJ+jyc4Uux1Pzf/e+sgciTKIlzixNS6IHEBIAOR0YyTgcaTpVIMnd8JZNY2
        Yi7w9B219r3jtwzW6egRHua48Aq+DDQUAlENxVyMLcinhiK3+lyUUovLFnMVam0K77iJwUj0wrUJN
        jHCnubdsgt99g6y/YwpgI7ZxhJX6NDN7QQgCPjSt47o7gKeZym6RZHr90eFpoIdrKX5LYWz0bnIfY
        XLPnnZbVQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55434)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hF3bV-0003Jx-0a; Fri, 12 Apr 2019 22:20:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hF3bT-00059Y-Pe; Fri, 12 Apr 2019 22:20:55 +0100
Date:   Fri, 12 Apr 2019 22:20:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning
 the cache
Message-ID: <20190412212055.lgsnjle3x75gu22m@shell.armlinux.org.uk>
References: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com>
 <20190412205834.aok6v3fnjaxl27qt@shell.armlinux.org.uk>
 <CAKv+Gu_vejJz0Gh4hz75yvUcbpiDGyA0KjUS=hSgMmMv_Z1dOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_vejJz0Gh4hz75yvUcbpiDGyA0KjUS=hSgMmMv_Z1dOg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190412212055.3SxQ7uxJDd-Jd-ZvSiZ0CLs6E0XdaDAIpyIgrfGm3uw@z>

On Fri, Apr 12, 2019 at 02:00:16PM -0700, Ard Biesheuvel wrote:
> If I use the forgotten password feature, it tells me
> 
> """
> The email address you provided (ard.biesheuvel@linaro.org) is not
> valid. Please try again.
> """

Fixed, consequence of the upgrades back in January, requiring a
change to the regular expression system, which caused my simple
fixups to then generate an invalid RE.  You should have received
the new password as a result of my testing.

Thanks for reporting the problem - that's the only way problems
get fixed!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
