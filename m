Return-Path: <SRS0=QuFd=SK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07925C10F13
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EC520883
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfDHPXP (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:15 -0400
Received: from foss.arm.com ([217.140.101.70]:50060 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfDHPXP (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9445215AB;
        Mon,  8 Apr 2019 08:23:14 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 157993F557;
        Mon,  8 Apr 2019 08:23:11 -0700 (PDT)
Date:   Mon, 8 Apr 2019 16:23:09 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Torsten Duwe <duwe@lst.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v8 2/5] arm64: replace -pg with CC_FLAGS_FTRACE in efi
 Makefiles
Message-ID: <20190408152309.GJ6139@lakrids.cambridge.arm.com>
References: <20190208150826.44EBC68DD2@newverein.lst.de>
 <20190208151011.0807668DD3@newverein.lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20190208151011.0807668DD3@newverein.lst.de>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190408152309.koZgzawK6JGzBNBc7VHsctKKtcYqVrfIKVnx5lwo5Uw@z>

On Fri, Feb 08, 2019 at 04:10:11PM +0100, Torsten Duwe wrote:
>   In preparation for arm64 supporting ftrace built on other compiler
>   options, let's have makefiles remove the $(CC_FLAGS_FTRACE)
>   flags, whatever these may be, rather than assuming '-pg'.
>   While at it, fix arm32 as well.
> 
>   There should be no functional change as a result of this patch.
> 
> Signed-off-by: Torsten Duwe <duwe@suse.de>

Ard, would you be happy if we were to take this via the arm64 tree?

Assuming so, can we have your ack?

Thanks,
Mark.

> 
> ---
>  drivers/firmware/efi/libstub/Makefile |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -16,9 +16,9 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__K
>  
>  # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
>  # disable the stackleak plugin
> -cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -fpie \
> -				   $(DISABLE_STACKLEAK_PLUGIN)
> -cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
> +cflags-$(CONFIG_ARM64)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
> +				   -fpie $(DISABLE_STACKLEAK_PLUGIN)
> +cflags-$(CONFIG_ARM)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
>  				   -fno-builtin -fpic \
>  				   $(call cc-option,-mno-single-pic-base)
>  
