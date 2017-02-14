From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add missing 1:1 mappings to support buggy
 firmware
Date: Tue, 14 Feb 2017 20:51:39 +0000
Message-ID: <20170214205139.GB28416@codeblueprint.co.uk>
References: <1486607948-1509-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486607948-1509-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 08 Feb, at 06:39:08PM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> There are some machines with buggy firmware that access EFI regions in
> 1:1 mode (or physical mode) rather than virtual mode even after kernel
> being booted. On these machines, if we invoke an EFI runtime service
> (that does these buggy accesses) then it causes a page fault and hence
> results in kernel hang. The page fault happens because the requested

Could you include a small amount of the page fault output in the
commit message? We don't need the callstack, but the IP of the
faulting instruction and the rest of the page fault message would be
good (along with which runtime service faulted).

> region doesn't have appropriate page attributes set or the mapping for
> the region might be missing. This issue was introduced by commit
> 67a9108ed431 ("x86/efi: Build our own page table structures"). Before
> this commit, 1:1 mappings for EFI regions were in swapper_pgd and were
> not needed to be synced, but this commit introduced efi_pgd which missed
> these mappings.
 
Oops, good catch.

> Below shown are the efi_pgd dumps before and after the bad commit.
> efi_dump_pagetable() is called before calling efi_merge_regions() in
> __efi_enter_virtual_mode() and this kernel is booted on qemu to obtain
> page table dumps.
> 
> EFI_PGT_DUMP before commit:
> ---------------------------
> [0.007041] ---[ User Space ]---
> [0.007427] 0x0000000000000000-0x0000000000200000 2M    RW     GLB NX pte
> [0.008609] 0x0000000000200000-0x0000000000800000 6M    RW PSE GLB NX pmd
> [0.010069] 0x0000000000800000-0x0000000000808000 32K                 pte
> [0.011068] 0x0000000000808000-0x0000000000810000 32K   RW     GLB NX pte
> [0.012325] 0x0000000000810000-0x0000000000900000 960K                pte
> [0.013071] 0x0000000000900000-0x0000000000a00000 1M    RW     GLB NX pte
> [0.014579] 0x0000000000a00000-0x000000007e800000 2014M RW PSE GLB NX pmd
> [0.015593] 0x000000007e800000-0x000000007e9b6000 1752K RW     GLB NX pte
> [0.016600] 0x000000007e9b6000-0x000000007e9fe000 288K                pte
> [0.018003] 0x000000007e9fe000-0x000000007ea00000 8K    RW     GLB NX pte
> [0.019165] 0x000000007ea00000-0x000000007ec00000 2M    RW PSE GLB NX pmd
> [0.020331] 0x000000007ec00000-0x000000007eda9000 1700K RW     GLB NX pte
> [0.021483] 0x000000007eda9000-0x000000007ee14000 428K                pte
> [0.022500] 0x000000007ee14000-0x000000007f000000 1968K RW     GLB NX pte
> [0.023596] 0x000000007f000000-0x000000007fe00000 14M   RW PSE GLB NX pmd
> [0.025004] 0x000000007fe00000-0x000000007fe94000 592K  RW     GLB NX pte
> [0.026220] 0x000000007fe94000-0x000000007fef8000 400K                pte
> [0.027069] 0x000000007fef8000-0x000000007ffd0000 864K  RW     GLB NX pte
> [0.028420] 0x000000007ffd0000-0x000000007fff0000 128K                pte
> [0.029551] 0x000000007fff0000-0x0000000080000000 64K   RW     GLB NX pte
> [0.030601] 0x0000000080000000-0x0000008000000000 510G                pud
> [0.031499] 0x0000008000000000-0xffff800000000000 17179737600G        pgd
> [0.032152] ---[ Kernel Space ]---
> 
> EFI_PGT_DUMP after commit:
> --------------------------
> [0.005620] ---[ User Space ]---
> [0.005838] 0x0000000000000000-0xffff800000000000 16777088T           pgd
> [0.005873] ---[ Kernel Space ]---
> 
> While not having these mappings isn't a bug but we need these mappings
> to support machines with buggy firmware.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 622fbc7c01cd..43f9cc45ae52 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -137,6 +137,7 @@ int __init efi_alloc_page_tables(void)
>  	pgd_t *pgd;
>  	pud_t *pud;
>  	gfp_t gfp_mask;
> +	unsigned num_pgds;
>  
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return 0;
> @@ -156,6 +157,13 @@ int __init efi_alloc_page_tables(void)
>  
>  	pgd_populate(NULL, pgd, pud);
>  
> +	/*
> +	 * Sync 1:1 mappings to support buggy firmware which haven't updated
> +	 * their addresses even after kernel has booted.
> +	 */
> +	num_pgds = pgd_index(VMALLOC_START) - pgd_index(PAGE_OFFSET);
> +	memcpy(efi_pgd, pgd_offset_k(PAGE_OFFSET), sizeof(pgd_t) * num_pgds);
> +
>  	return 0;
>  }

Is there a reason you didn't add this code to
efi_sync_low_kernel_mappings()? That would seem like the logical place
to put it because that's where we already do some PGD copying.
