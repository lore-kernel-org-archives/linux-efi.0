From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/6] x86/efi: Map RAM into the identity page table for
 mixed mode
Date: Thu, 12 Nov 2015 19:01:26 +0100
Message-ID: <20151112180126.GD3838@pd.tnic>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-4-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447342823-3612-4-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 12, 2015 at 03:40:20PM +0000, Matt Fleming wrote:
> We are relying on the pre-existing mappings in 'trampoline_pgd' when
> accessing function arguments in the EFI mixed mode thunking code.
> 
> Instead let's map memory explicitly so that things will continue to
> work when we move to a separate page table in the future.
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/platform/efi/efi_64.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index c8b58ac47b77..634536034e32 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -144,6 +144,7 @@ void efi_sync_low_kernel_mappings(void)
>  int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  {
>  	unsigned long pfn, text;
> +	efi_memory_desc_t *md;
>  	struct page *page;
>  	unsigned npages;
>  	pgd_t *pgd;
> @@ -200,6 +201,25 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  
>  	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
>  
> +	/*
> +	 * Map all of RAM so that we can access arguments in the 1:1

Why "all of RAM"?

> +	 * mapping when making EFI runtime calls.
> +	 */
> +	for_each_efi_memory_desc(&memmap, md) {
> +		if (md->type != EFI_CONVENTIONAL_MEMORY &&
> +		    md->type != EFI_LOADER_DATA &&
> +		    md->type != EFI_LOADER_CODE)

That's mapping all those EFI_* types...

> +			continue;
> +
> +		pfn = md->phys_addr >> PAGE_SHIFT;
> +		npages = md->num_pages;
> +
> +		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, 0)) {
> +			pr_err("Failed to map 1:1 memory\n");
> +			return 1;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.6.2
> 
> 

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
