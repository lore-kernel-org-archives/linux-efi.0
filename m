From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/4] efi/arm64: map the stack and entry wrapper into the
 UEFI page tables
Date: Fri, 26 Jan 2018 16:57:45 +0000
Message-ID: <20180126165744.GD16008@arm.com>
References: <20180125103131.19168-1-ard.biesheuvel@linaro.org>
 <20180125103131.19168-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125103131.19168-3-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, joakim.bech-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Thu, Jan 25, 2018 at 10:31:29AM +0000, Ard Biesheuvel wrote:
> As a preparatory step towards unmapping the kernel entirely while
> executing UEFI runtime services, move the stack and the entry
> wrapper routine mappings into the EFI page tables. Also, create a
> vector table that overrides the main one while executing in the
> firmware so we will be able to remap/unmap the kernel while taking
> interrupts.

[...]

> +	.macro	ventry
> +	.align	7
> +.Lv\@ :	stp	x29, x30, [sp, #-16]!		// preserve x29 and x30
> +	mrs	x29, elr_el1			// preserve ELR
> +	adr	x30, .Lret			// take return address
> +	msr	elr_el1, x30			// set ELR to return address

Oh man, are you really doing two ERETs for a single exception, or am I
missing something?

> +	ldr	x30, 2b				// take address of 'vectors'
> +	msr	vbar_el1, x30			// set VBAR to 'vectors'
> +	isb
> +	add	x30, x30, #.Lv\@ - __efi_rt_vectors
> +	br	x30
> +	.endm
> +
> +.Lret:	msr	elr_el1, x29

If you take an IRQ here, aren't you toast?

> +	adr	x30, __efi_rt_vectors
> +	msr	vbar_el1, x30
> +	isb
> +	ldp	x29, x30, [sp], #16
> +	eret
> +
> +	.align	11
> +__efi_rt_vectors:
> +	.rept	8
> +	ventry
> +	.endr

Have you thought about SDEI at all? I can't see any code here to handle
that.

> +	/*
> +	 * EFI runtime services never drop to EL0, so the
> +	 * remaining vector table entries are not needed.
> +	 */
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index af4f943cffac..68c920b2f4f0 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -130,3 +130,27 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
>  	pr_err_ratelimited(FW_BUG "register x18 corrupted by EFI %s\n", f);
>  	return s;
>  }
> +
> +bool on_efi_stack(unsigned long sp)
> +{
> +	return sp >= EFI_STACK_BASE && sp < (EFI_STACK_BASE + EFI_STACK_SIZE);
> +}
> +
> +int __init efi_allocate_runtime_regions(struct mm_struct *mm)
> +{
> +	static u8 stack[EFI_STACK_SIZE] __page_aligned_bss;

Probably just me, but the use of a function static variable in a function
annotated with __init just makes me feel uneasy. Could we move it out into
wider scope?

> +
> +	/* map the stack */
> +	create_pgd_mapping(mm, __pa_symbol(stack),
> +			   EFI_STACK_BASE, EFI_STACK_SIZE,
> +			   __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
> +			   false);
> +
> +	/* map the runtime wrapper pivot function */
> +	create_pgd_mapping(mm, __pa_symbol(__efi_rt_asm_wrapper),
> +			   EFI_CODE_BASE, EFI_CODE_SIZE,
> +			   __pgprot(pgprot_val(PAGE_KERNEL_ROX) | PTE_NG),
> +			   false);
> +
> +	return 0;
> +}
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index b34e717d7597..3bab6c60a12b 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -204,6 +204,7 @@ alternative_if ARM64_HAS_PAN
>  alternative_else_nop_endif
>  
>  	.if	\el != 0
> +	tbz	x21, #63, 1f			// skip if TTBR0 covers the stack

So this is really a "detect EFI" check, right? Maybe comment it as such.
Also, probably want to check bit 55 just in case tagging ever takes off.

Will
