Return-Path: <SRS0=dzaO=EM=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1CBC2D0A3
	for <linux-efi@archiver.kernel.org>; Fri,  6 Nov 2020 12:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C9D208C7
	for <linux-efi@archiver.kernel.org>; Fri,  6 Nov 2020 12:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="pOg1gXD9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgKFMKA (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 6 Nov 2020 07:10:00 -0500
Received: from mail.skyhub.de ([5.9.137.197]:39140 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgKFMKA (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 6 Nov 2020 07:10:00 -0500
Received: from zn.tnic (p200300ec2f0d1f002c83f8cfec6c8cbe.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1f00:2c83:f8cf:ec6c:8cbe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CE4111EC0472;
        Fri,  6 Nov 2020 13:09:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604664598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=j1PYejKujTzZ/tSUIC/Wh38qTKLxeYqq2vi+CCupqFs=;
        b=pOg1gXD9RbShON5QIY388DRMfh/n6cHip5XN9ueWCBaJvrWgIBB9DIi4YiziscNf/2CHhU
        J5z+zKU0F96T24Cr99x4cYwYw2qL7DFg+SkZVwH3VrnHCNfIHqvQUxEdzXlSVNEMNSA9aD
        9m/ZuAdKiZueEZgWJfVoNVRmQH9yEyw=
Date:   Fri, 6 Nov 2020 13:09:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc:     Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>
Subject: Re: [PATCH v5] cper, apei, mce: Pass x86 CPER through the MCA
 handling chain
Message-ID: <20201106120950.GC14914@zn.tnic>
References: <20201103164952.5126-1-Smita.KoralahalliChannabasappa@amd.com>
 <87a6vv9hch.fsf@kokedama.swc.toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a6vv9hch.fsf@kokedama.swc.toshiba.co.jp>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Nov 06, 2020 at 02:36:46PM +0900, Punit Agrawal wrote:
> > diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
> > index 2531de49f56c..438ed9eff6d0 100644
> > --- a/drivers/firmware/efi/cper-x86.c
> > +++ b/drivers/firmware/efi/cper-x86.c
> > @@ -2,6 +2,7 @@
> >  // Copyright (C) 2018, Advanced Micro Devices, Inc.
> >  
> >  #include <linux/cper.h>
> > +#include <linux/acpi.h>
> 
> Did you mean to include <asm/acpi.h>?

Why?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
