From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 02/10] x86/efi: Return error status if mapping EFI
 regions fail
Date: Mon, 4 Feb 2019 08:18:09 +0100
Message-ID: <20190204071809.GA115714@gmail.com>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
 <20190202094119.13230-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190202094119.13230-3-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> 
> efi_map_region() creates VA mappings for an given EFI region using any one
> of the two helper functions (namely __map_region() and old_map_region()).
> These helper functions *could* fail while creating mappings and presently
> their return value is not checked. Not checking for the return value of
> these functions might create issues because after these functions return
> "md->virt_addr" is set to the requested virtual address (so it's assumed
> that these functions always succeed which is not quite true). This
> assumption leads to "md->virt_addr" having invalid mapping should any of
> __map_region() or old_map_region() fail.
> 
> Hence, check for the return value of these functions and if indeed they
> fail, turn off EFI Runtime Services forever because kernel cannot
> prioritize among EFI regions.
> 
> This also fixes the comment "FIXME: add error handling" in
> kexec_enter_virtual_mode().
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/include/asm/efi.h     |  6 +++---
>  arch/x86/platform/efi/efi.c    | 21 +++++++++++++-----
>  arch/x86/platform/efi/efi_32.c |  6 +++---
>  arch/x86/platform/efi/efi_64.c | 39 ++++++++++++++++++++++------------
>  4 files changed, 48 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 107283b1eb1e..a37378f986ec 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -125,12 +125,12 @@ extern pgd_t * __init efi_call_phys_prolog(void);
>  extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
>  extern void __init efi_print_memmap(void);
>  extern void __init efi_memory_uc(u64 addr, unsigned long size);
> -extern void __init efi_map_region(efi_memory_desc_t *md);
> -extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
> +extern int __init efi_map_region(efi_memory_desc_t *md);
> +extern int __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern int __init efi_alloc_page_tables(void);
>  extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
> -extern void __init old_map_region(efi_memory_desc_t *md);
> +extern int __init old_map_region(efi_memory_desc_t *md);
>  extern void __init runtime_code_page_mkexec(void);
>  extern void __init efi_runtime_update_mappings(void);
>  extern void __init efi_dump_pagetable(void);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e1cb01a22fa8..3d43ec58775b 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -581,7 +581,7 @@ void __init efi_memory_uc(u64 addr, unsigned long size)
>  	set_memory_uc(addr, npages);
>  }
>  
> -void __init old_map_region(efi_memory_desc_t *md)
> +int __init old_map_region(efi_memory_desc_t *md)
>  {
>  	u64 start_pfn, end_pfn, end;
>  	unsigned long size;
> @@ -601,10 +601,14 @@ void __init old_map_region(efi_memory_desc_t *md)
>  		va = efi_ioremap(md->phys_addr, size,
>  				 md->type, md->attribute);
>  
> -	md->virt_addr = (u64) (unsigned long) va;
> -	if (!va)
> +	if (!va) {
>  		pr_err("ioremap of 0x%llX failed!\n",
>  		       (unsigned long long)md->phys_addr);
> +		return -ENOMEM;
> +	}
> +
> +	md->virt_addr = (u64)(unsigned long)va;
> +	return 0;

Just wondering, shouldn't the failure path set ->virt_addr to something 
safe, just in case a caller doesn't check the error and relies on it? 

That's because in this commit we've now changed it from 0 to undefined.

> +int __init efi_map_region_fixed(efi_memory_desc_t *md) { return 0; }

Inline functions should be marked inline ...

>  	if (efi_va < EFI_VA_END) {
> -		pr_warn(FW_WARN "VA address range overflow!\n");
> -		return;
> +		pr_err(FW_WARN "VA address range overflow!\n");
> +		return -ENOMEM;
>  	}
>  
>  	/* Do the VA map */
> -	__map_region(md, efi_va);
> +	if (__map_region(md, efi_va))
> +		return -ENOMEM;
> +
>  	md->virt_addr = efi_va;
> +	return 0;

Same error return problem of leaving ->virt_addr undefined.

Note that I also fixed up the grammar and readability of the changelog - 
see the updated version below.

Thanks,

	Ingo

=============>
Subject: x86/efi: Return error status if mapping of EFI regions fails
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sat, 2 Feb 2019 10:41:11 +0100

From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

efi_map_region() creates VA mappings for a given EFI region using one
of the two helper functions (namely __map_region() and old_map_region()).

These helper functions could fail while creating mappings and presently
their return value is not checked.

Not checking for the return value of these functions might create bugs,
because after these functions return "md->virt_addr" is set to the
requested virtual address (so it's assumed that these functions always
succeed which is not quite true). This assumption leads to
"md->virt_addr" having invalid mapping, should any of __map_region()
or old_map_region() fail.

Hence, check for the return value of these functions and if indeed they
fail, turn off EFI Runtime Services forever because kernel cannot
prioritize among EFI regions.

This also fixes the comment "FIXME: add error handling" in
kexec_enter_virtual_mode().
