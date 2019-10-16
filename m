Return-Path: <SRS0=gNor=YJ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2A9FA3728
	for <linux-efi@archiver.kernel.org>; Wed, 16 Oct 2019 15:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACA521A49
	for <linux-efi@archiver.kernel.org>; Wed, 16 Oct 2019 15:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="W73TA2+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389734AbfJPPsx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:48:53 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35514 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfJPPsx (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 16 Oct 2019 11:48:53 -0400
Received: from zn.tnic (p200300EC2F093900C973EA3B8BE79A94.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:3900:c973:ea3b:8be7:9a94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7C6C21EC0CB7;
        Wed, 16 Oct 2019 17:48:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1571240931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jmX8/r1x/roPBxPzVwV80iSi0MvvPRQDzQnr23dp5ns=;
        b=W73TA2+QOLdkRyLbrczLc/7ptPoKfR2iKpdxfN9wQvwcqbD5amGSiTp9g72BGPqIaBrCEL
        YISTB2/yxFpw1S/wAwsXzKsZnuI3+Ftc6wgcbsCnkmLHr4rGjcfXsCRoFq+iL/jORuisIr
        z0EwpletbOM2Z0/1fE1o4Vrt63QCesk=
Date:   Wed, 16 Oct 2019 17:48:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joe Perches <joe@perches.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Kairui Song <kasong@redhat.com>, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: never relocate kernel below lowest
 acceptable address
Message-ID: <20191016154842.GJ1138@zn.tnic>
References: <20191012034421.25027-1-kasong@redhat.com>
 <20191014101419.GA4715@zn.tnic>
 <20191014202111.GP15552@linux.intel.com>
 <20191014211825.GJ4715@zn.tnic>
 <20191016152014.GC4261@linux.intel.com>
 <fb0e7c13da405970d5cbd59c10005daaf970b8da.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fb0e7c13da405970d5cbd59c10005daaf970b8da.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Oct 16, 2019 at 08:23:56AM -0700, Joe Perches wrote:
> ?  examples please.

From this very thread:

\sEfi\s, \sefi\s, \seFI\s etc should be "EFI"

I'm thinking perhaps start conservatively and catch the most often
misspelled ones in commit messages or comments. "CPU", "SMT", "MCE",
"MCA", "PCI" etc come to mind.

> checkpatch has a db for misspellings, I supposed another for
> acronyms could be added,

Doesn't have to be another one - established acronyms are part of the
dictionary too.

> but how would false positives be avoided?

Perhaps delimited with spaces or non-word chars (\W) and when they're
part of a comment or the commit message...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
