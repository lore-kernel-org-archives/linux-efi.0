From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Date: Thu, 06 Jun 2013 12:28:20 -0700
Message-ID: <51B0E2D4.3040007@zytor.com>
References: <1370177770-26661-1-git-send-email-bp@alien8.de> <1370177770-26661-5-git-send-email-bp@alien8.de> <20130606131439.GI30420@console-pimps.org> <20130606132908.GE20972@pd.tnic> <20130606155822.GH20972@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130606155822.GH20972@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Linux EFI <linux-efi@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On 06/06/2013 08:58 AM, Borislav Petkov wrote:
> --
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 654be4ae3047..7a6129afdff1 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1021,6 +1021,9 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	/* Get the faulting address: */
>  	address = read_cr2();
>  
> +	if (read_cr3() == (unsigned long)real_mode_header->trampoline_pgd)
> +		pr_err("%s: #PF addr: 0x%lx\n", __func__, address);
> +
>  	/*
>  	 * Detect and handle instructions that would cause a page fault for
>  	 * both a tracked kernel page and a userspace page.
> 

Or we could materialize mappings for this specific PGD.  However, adding
a read of %cr3 in __do_page_fault sounds expensive.

	-hpa
