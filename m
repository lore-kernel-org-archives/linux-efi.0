Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC5AC43460
	for <linux-efi@archiver.kernel.org>; Fri, 14 May 2021 12:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B9E61461
	for <linux-efi@archiver.kernel.org>; Fri, 14 May 2021 12:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhENMyI (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 14 May 2021 08:54:08 -0400
Received: from foss.arm.com ([217.140.110.172]:49200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233764AbhENMyG (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 14 May 2021 08:54:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 707971476;
        Fri, 14 May 2021 05:52:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.219])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CCC43F73B;
        Fri, 14 May 2021 05:52:46 -0700 (PDT)
Date:   Fri, 14 May 2021 13:52:43 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     will@kernel.org, catalin.marinas@arm.com,
        lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-efi@vger.kernel.org,
        arnd@arndb.de, wei.liu@kernel.org, ardb@kernel.org,
        daniel.lezcano@linaro.org, kys@microsoft.com
Subject: Re: [PATCH v10 2/7] arm64: hyperv: Add Hyper-V hypercall and
 register access utilities
Message-ID: <20210514125243.GC30645@C02TD0UTHF1T.local>
References: <1620841067-46606-1-git-send-email-mikelley@microsoft.com>
 <1620841067-46606-3-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620841067-46606-3-git-send-email-mikelley@microsoft.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, May 12, 2021 at 10:37:42AM -0700, Michael Kelley wrote:
> hyperv-tlfs.h defines Hyper-V interfaces from the Hyper-V Top Level
> Functional Spec (TLFS), and #includes the architecture-independent
> part of hyperv-tlfs.h in include/asm-generic.  The published TLFS
> is distinctly oriented to x86/x64, so the ARM64-specific
> hyperv-tlfs.h includes information for ARM64 that is not yet formally
> published. The TLFS is available here:
> 
>   docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs
> 
> mshyperv.h defines Linux-specific structures and routines for
> interacting with Hyper-V on ARM64, and #includes the architecture-
> independent part of mshyperv.h in include/asm-generic.
> 
> Use these definitions to provide utility functions to make
> Hyper-V hypercalls and to get and set Hyper-V provided
> registers associated with a virtual processor.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
> ---
>  MAINTAINERS                          |   3 +
>  arch/arm64/Kbuild                    |   1 +
>  arch/arm64/hyperv/Makefile           |   2 +
>  arch/arm64/hyperv/hv_core.c          | 130 +++++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/hyperv-tlfs.h |  69 +++++++++++++++++++
>  arch/arm64/include/asm/mshyperv.h    |  54 +++++++++++++++
>  6 files changed, 259 insertions(+)
>  create mode 100644 arch/arm64/hyperv/Makefile
>  create mode 100644 arch/arm64/hyperv/hv_core.c
>  create mode 100644 arch/arm64/include/asm/hyperv-tlfs.h
>  create mode 100644 arch/arm64/include/asm/mshyperv.h

> +/*
> + * hv_do_hypercall- Invoke the specified hypercall
> + */
> +u64 hv_do_hypercall(u64 control, void *input, void *output)
> +{
> +	struct arm_smccc_res	res;
> +	u64			input_address;
> +	u64			output_address;
> +
> +	input_address = input ? virt_to_phys(input) : 0;
> +	output_address = output ? virt_to_phys(output) : 0;

I may have asked this before, but are `input` and `output` always linear
map pointers, or can they ever be vmalloc pointers?

Otherwise, this looks fine to me.

Mark.
