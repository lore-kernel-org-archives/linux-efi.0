From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2 5/6] x86/mm: If in_atomic(), allocate pages without
 sleeping
Date: Mon, 3 Sep 2018 10:34:59 +0200
Message-ID: <20180903083459.GT24124@hirez.programming.kicks-ass.net>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1535881594-25469-6-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1535881594-25469-6-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On Sun, Sep 02, 2018 at 02:46:33AM -0700, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> A page fault occurs when any EFI Runtime Service tries to reference a
> memory region which it shouldn't. If the illegally accessed region
> is EFI_BOOT_SERVICES_<CODE/DATA>, the efi specific page fault handler
> fixes it up by dynamically creating VA->PA mappings using
> efi_map_region().
> 
> Originally, efi_map_region() and hence the functionality of creating
> mappings for efi regions was intended to be used *only* during boot time
> (please note __init modifier) and hence when called during runtime (i.e.
> from efi page fault handler), the page allocators complain. Calling
> efi_map_region() during runtime complains because "gfp_allowed_mask"
> value changes from boot time to runtime (GFP_BOOT_MASK to
> __GFP_BITS_MASK). During boot, even though efi_map_region() calls
> alloc_<pte/pmd>_page with GFP_KERNEL, the page allocator doesn't
> complain because "__GFP_RECLAIM" flag is cleared by "gfp_allowed_mask",
> but during runtime it isn't cleared and hence prints below stack trace.
> 
> BUG: sleeping function called from invalid context at mm/page_alloc.c:4320

> get_zeroed_page+0x12/0x40
> alloc_pmd_page+0x13/0x50
> populate_pmd+0xc0/0x2e0
> __cpa_process_fault+0x2e1/0x5d0
> __change_page_attr_set_clr+0x7c3/0xcd0
> kernel_map_pages_in_pgd+0x8c/0x160
> __map_region+0x3c/0x60
> efi_map_region+0x83/0xd0
> efi_illegal_accesses_fixup+0x1ca/0x1e0
> no_context+0x112/0x390
> __do_page_fault+0xc7/0x4f0

> Fix the above warning by conditionally changing the allocation from
> GFP_KERNEL to GFP_ATOMIC, so that efi page fault handler could use
> efi_map_region() during runtime. This change shouldn't effect any other
> generic page allocations because this allocation is used only by efi
> functions [1].

> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 3bded76e8d5c..1b28a333c8ce 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -926,7 +926,13 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
>  
>  static int alloc_pte_page(pmd_t *pmd)
>  {
> -	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> +	pte_t *pte;
> +
> +	if (in_atomic())
> +		pte = (pte_t *)get_zeroed_page(GFP_ATOMIC);
> +	else
> +		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> +
>  	if (!pte)
>  		return -1;
>  

This looks like tinkering to me..
