Return-Path: <SRS0=QuFd=SK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D45C282CE
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 09:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611C7208E3
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 09:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfDHJUc (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Apr 2019 05:20:32 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:44790 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfDHJUb (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 8 Apr 2019 05:20:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8348415AD;
        Mon,  8 Apr 2019 02:20:31 -0700 (PDT)
Received: from [10.1.34.154] (unknown [10.1.34.154])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8D113F718;
        Mon,  8 Apr 2019 02:20:29 -0700 (PDT)
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     Leif Lindholm <leif.lindholm@linaro.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Steve McIntyre <steve.mcintyre@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com>
 <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com>
 <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <1a77f587-3538-441f-c6c1-8e56fb65d855@arm.com>
Date:   Mon, 8 Apr 2019 10:20:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190408092027.VfrAaUwjKGUjTL0D00RvSZLYOPJT4lZU6mUd6ZLDLQo@z>

On 4/7/19 7:19 PM, Ard Biesheuvel wrote:
> Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
> v6. Would reading back SCTLR suffice?


I think instr_sync macro should do the trick.

Cheers
Vladimir
