From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 08/17] x86/efi: Access EFI data as encrypted
 when SEV is active
Date: Fri, 28 Jul 2017 12:31:52 +0200
Message-ID: <20170728103152.GE1889@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-9-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-9-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:48PM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> 
> EFI data is encrypted when the kernel is run under SEV. Update the
> page table references to be sure the EFI memory areas are accessed
> encrypted.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 12e8388..1ecb3f6 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -32,6 +32,7 @@
>  #include <linux/reboot.h>
>  #include <linux/slab.h>
>  #include <linux/ucs2_string.h>
> +#include <linux/mem_encrypt.h>
>  
>  #include <asm/setup.h>
>  #include <asm/page.h>
> @@ -369,7 +370,10 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	 * as trim_bios_range() will reserve the first page and isolate it away
>  	 * from memory allocators anyway.
>  	 */
> -	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
> +	pf = _PAGE_RW;
> +	if (sev_active())
> +		pf |= _PAGE_ENC;

\n here

> +	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, pf)) {
>  		pr_err("Failed to create 1:1 mapping for the first page!\n");
>  		return 1;
>  	}
> @@ -412,6 +416,9 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
>  	if (!(md->attribute & EFI_MEMORY_WB))
>  		flags |= _PAGE_PCD;
>  
> +	if (sev_active())
> +		flags |= _PAGE_ENC;
> +
>  	pfn = md->phys_addr >> PAGE_SHIFT;
>  	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
>  		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
> @@ -511,6 +518,9 @@ static int __init efi_update_mappings(efi_memory_desc_t *md, unsigned long pf)
>  	pgd_t *pgd = efi_pgd;
>  	int err1, err2;
>  
> +	if (sev_active())
> +		pf |= _PAGE_ENC;

Move this assignment to the caller efi_update_mem_attr() where pf is being
set...

> +
>  	/* Update the 1:1 mapping */
>  	pfn = md->phys_addr >> PAGE_SHIFT;
>  	err1 = kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages, pf);
> @@ -589,6 +599,9 @@ void __init efi_runtime_update_mappings(void)
>  			(md->type != EFI_RUNTIME_SERVICES_CODE))
>  			pf |= _PAGE_RW;
>  
> +		if (sev_active())
> +			pf |= _PAGE_ENC;

... just like here.

> +
>  		efi_update_mappings(md, pf);

In general, I'm not totally excited about that sprinkling of if
(sev_active())... :-\

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
