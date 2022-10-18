Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257E9C4332F
	for <linux-efi@archiver.kernel.org>; Tue, 18 Oct 2022 11:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJRL2K (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 18 Oct 2022 07:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJRL2J (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 18 Oct 2022 07:28:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D130B2D99
        for <linux-efi@vger.kernel.org>; Tue, 18 Oct 2022 04:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275D1B81EA6
        for <linux-efi@vger.kernel.org>; Tue, 18 Oct 2022 11:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B75C433D6;
        Tue, 18 Oct 2022 11:28:02 +0000 (UTC)
Date:   Tue, 18 Oct 2022 12:27:58 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, keescook@chromium.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Xi Ruoyao <xry111@xry111.site>,
        Lennart Poettering <lennart@poettering.net>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/21] arm64: efi: Move dcache cleaning of loaded image
 out of efi_enter_kernel()
Message-ID: <Y06Nvsji+NZkutTN@arm.com>
References: <20221017171700.3736890-1-ardb@kernel.org>
 <20221017171700.3736890-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017171700.3736890-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, Oct 17, 2022 at 07:16:40PM +0200, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> index 61a87fa1c305..1c1be004a271 100644
> --- a/arch/arm64/kernel/efi-entry.S
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -23,15 +23,6 @@ SYM_CODE_START(efi_enter_kernel)
>  	add	x19, x0, x2		// relocated Image entrypoint
>  	mov	x20, x1			// DTB address
>  
> -	/*
> -	 * Clean the copied Image to the PoC, and ensure it is not shadowed by
> -	 * stale icache entries from before relocation.
> -	 */
> -	ldr	w1, =kernel_size
> -	add	x1, x0, x1
> -	bl	dcache_clean_poc
> -	ic	ialluis
> -
>  	/*
>  	 * Clean the remainder of this routine to the PoC
>  	 * so that we can safely disable the MMU and caches.
[...]
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index 598c76c4bbaa..e767a5ac8c3d 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
[...]
> @@ -174,5 +174,13 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	*image_addr = *reserve_addr;
>  	memcpy((void *)*image_addr, _text, kernel_size);
>  
> +clean_image_to_poc:
> +	/*
> +	 * Clean the copied Image to the PoC, and ensure it is not shadowed by
> +	 * stale icache entries from before relocation.
> +	 */
> +	dcache_clean_poc(*image_addr, *image_addr + kernel_size);
> +	asm("ic ialluis");

Does this need some barriers, at least a DSB? The original code had DSB
and ISB, though not immediately after the IC instruction.

-- 
Catalin
