From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 2/5] efi: Dump the EFI page table
Date: Mon, 20 Jan 2014 13:38:02 +0000
Message-ID: <20140120133802.GA684@console-pimps.org>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-3-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1390045698-16882-3-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
List-Id: linux-efi@vger.kernel.org

On Sat, 18 Jan, at 12:48:15PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> This is very useful for debugging issues with the recently added
> pagetable switching code for EFI virtual mode.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  arch/x86/Kconfig               | 9 +++++++++
>  arch/x86/include/asm/efi.h     | 1 +
>  arch/x86/platform/efi/efi.c    | 1 +
>  arch/x86/platform/efi/efi_32.c | 1 +
>  arch/x86/platform/efi/efi_64.c | 9 +++++++++
>  5 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 02241d8dcab6..ba0d86cca926 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1614,6 +1614,15 @@ config EFI_STUB
>  
>  	  See Documentation/efi-stub.txt for more information.
>  
> +config EFI_PGT_DUMP
> +	bool "Dump the EFI pagetable"
> +	depends on EFI && X86_PTDUMP
> +	---help---
> +	  Enable this if you want to dump the EFI page table before
> +	  enabling virtual mode. This can be used to debug miscellaneous
> +	  issues with the mapping of the EFI runtime regions into that
> +	  table.
> +

Would this be more suitable in arch/x86/Kconfig.debug?

-- 
Matt Fleming, Intel Open Source Technology Center
