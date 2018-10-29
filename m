From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data
 regions from efi_pgd
Date: Mon, 29 Oct 2018 15:40:46 +0100
Message-ID: <20181029144046.GC744@hirez.programming.kicks-ass.net>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
 <20181026213845.28166-2-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181026213845.28166-2-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 26, 2018 at 02:38:44PM -0700, Sai Praneeth Prakhya wrote:
> +int kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
> +			      unsigned long numpages)
> +{
> +	int retval;
> +
> +	/*
> +	 * The typical sequence for unmapping is to find a pte through
> +	 * lookup_address_in_pgd() (ideally, it should never return NULL because
> +	 * the address is already mapped) and change it's protections.
> +	 * As pfn is the *target* of a mapping, it's not useful while unmapping.
> +	 */
> +	struct cpa_data cpa = {
> +		.vaddr		= &address,
> +		.pgd		= pgd,
> +		.numpages	= numpages,
> +		.mask_set	= __pgprot(0),
> +		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW),
> +		.flags		= 0,
> +	};
> +
> +	retval = __change_page_attr_set_clr(&cpa, 0);
> +	__flush_tlb_all();

How is that not a TLB invalidation bug ?

> +
> +	return retval;
> +}
