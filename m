Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E503CC6379F
	for <linux-efi@archiver.kernel.org>; Sat, 21 Nov 2020 11:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5A10221FA
	for <linux-efi@archiver.kernel.org>; Sat, 21 Nov 2020 11:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="iq0EhciR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgKULEc (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 21 Nov 2020 06:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKULEb (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sat, 21 Nov 2020 06:04:31 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D7FC0613CF;
        Sat, 21 Nov 2020 03:04:30 -0800 (PST)
Received: from zn.tnic (p200300ec2f21450079a94482c6f26574.dip0.t-ipconnect.de [IPv6:2003:ec:2f21:4500:79a9:4482:c6f2:6574])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 504611EC050B;
        Sat, 21 Nov 2020 12:04:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1605956668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xTNpSQOfBnbSZHVrgjYHyZy78qIIonrK5XUe0MFL0Dw=;
        b=iq0EhciR37FiZZhglndkftsi4+UZlziM9YvYnNArT2pMr7tQ7OtbUKYHa3cSDln7Iimd+3
        8Hp2lBY/vz/TgdxDr4/trIuHha+ybAX0oy1YhBfNiP6/3gFp/RKpUHXPAcl6rzWsumq012
        iGdnBJCQVj8dGEvpoHjp40KggKTju9E=
Date:   Sat, 21 Nov 2020 12:04:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        devel@acpica.org, Tony Luck <tony.luck@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        Yazen Ghannam <yazen.ghannam@amd.com>
Subject: Re: [PATCH v6] cper, apei, mce: Pass x86 CPER through the MCA
 handling chain
Message-ID: <20201121110423.GB24020@zn.tnic>
References: <20201119182938.151155-1-Smita.KoralahalliChannabasappa@amd.com>
 <20201121101511.GA24020@zn.tnic>
 <CAMj1kXEAkmKCSwKAnvWhZyo7=HdQNYFLQOzX0R+qN=WVHYd+OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXEAkmKCSwKAnvWhZyo7=HdQNYFLQOzX0R+qN=WVHYd+OQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Sat, Nov 21, 2020 at 11:38:02AM +0100, Ard Biesheuvel wrote:
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
