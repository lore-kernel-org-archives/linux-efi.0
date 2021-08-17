Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7688C4320E
	for <linux-efi@archiver.kernel.org>; Tue, 17 Aug 2021 10:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9154660F38
	for <linux-efi@archiver.kernel.org>; Tue, 17 Aug 2021 10:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbhHQKIA (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 17 Aug 2021 06:08:00 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36476 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239452AbhHQKHA (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 17 Aug 2021 06:07:00 -0400
Received: from zn.tnic (p200300ec2f1175001ae0093e4550657c.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:7500:1ae0:93e:4550:657c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 95A9E1EC054F;
        Tue, 17 Aug 2021 12:05:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1629194726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=G4eAMTLu2hDkmoQ61+xUHXsjuZXklNaVdRb9b01R0LQ=;
        b=Ezlf7E6kfbk0wj1UX675PJCY/0eAzfm/7wQ3tUGxLlaOWwjDy3wVFlLkLlMNFvuVYmxMAN
        rZSuujCI9mCbXFtsrDcS2WemZquPZaiynSjn8JL5aSXkmF+a+fD163HXMC9x07FG8oGDik
        Bg4RCUoOLPaIIAXfzgh6O65GYecZeCA=
Date:   Tue, 17 Aug 2021 12:06:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-graphics-maintainer@vmware.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 07/12] x86/sev: Replace occurrences of sev_es_active()
 with prot_guest_has()
Message-ID: <YRuKEhzOh8pO4He1@zn.tnic>
References: <cover.1628873970.git.thomas.lendacky@amd.com>
 <0b8480d93b5090fcc34cf5d5035d4d89aa765d79.1628873970.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0b8480d93b5090fcc34cf5d5035d4d89aa765d79.1628873970.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, Aug 13, 2021 at 11:59:26AM -0500, Tom Lendacky wrote:
> Replace occurrences of sev_es_active() with the more generic
> prot_guest_has() using PATTR_GUEST_PROT_STATE, except for in
> arch/x86/kernel/sev*.c and arch/x86/mm/mem_encrypt*.c where PATTR_SEV_ES
> will be used. If future support is added for other memory encyrption
> techonologies, the use of PATTR_GUEST_PROT_STATE can be updated, as
> required, to specifically use PATTR_SEV_ES.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h | 2 --
>  arch/x86/kernel/sev.c              | 6 +++---
>  arch/x86/mm/mem_encrypt.c          | 7 +++----
>  arch/x86/realmode/init.c           | 3 +--
>  4 files changed, 7 insertions(+), 11 deletions(-)

Same comments to this one as for the previous two.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
