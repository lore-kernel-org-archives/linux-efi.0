From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 11/17] x86/mm, resource: Use PAGE_KERNEL
 protection for ioremap of memory pages
Date: Wed, 2 Aug 2017 06:02:56 +0200
Message-ID: <20170802040255.GA4336@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-12-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-12-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:51PM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> 
> In order for memory pages to be properly mapped when SEV is active, we
> need to use the PAGE_KERNEL protection attribute as the base protection.
> This will insure that memory mapping of, e.g. ACPI tables, receives the
> proper mapping attributes.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/mm/ioremap.c  | 28 ++++++++++++++++++++++++++++
>  include/linux/ioport.h |  3 +++
>  kernel/resource.c      | 17 +++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index c0be7cf..7b27332 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -69,6 +69,26 @@ static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
>  	return 0;
>  }
>  
> +static int __ioremap_res_desc_other(struct resource *res, void *arg)
> +{
> +	return (res->desc != IORES_DESC_NONE);
> +}
> +
> +/*
> + * This function returns true if the target memory is marked as
> + * IORESOURCE_MEM and IORESOURCE_BUSY and described as other than
> + * IORES_DESC_NONE (e.g. IORES_DESC_ACPI_TABLES).
> + */
> +static bool __ioremap_check_if_mem(resource_size_t addr, unsigned long size)
> +{
> +	u64 start, end;
> +
> +	start = (u64)addr;
> +	end = start + size - 1;
> +
> +	return (walk_mem_res(start, end, NULL, __ioremap_res_desc_other) == 1);
> +}
> +
>  /*
>   * Remap an arbitrary physical address space into the kernel virtual
>   * address space. It transparently creates kernel huge I/O mapping when
> @@ -146,7 +166,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  		pcm = new_pcm;
>  	}
>  
> +	/*
> +	 * If the page being mapped is in memory and SEV is active then
> +	 * make sure the memory encryption attribute is enabled in the
> +	 * resulting mapping.
> +	 */
>  	prot = PAGE_KERNEL_IO;
> +	if (sev_active() && __ioremap_check_if_mem(phys_addr, size))
> +		prot = pgprot_encrypted(prot);

Hmm, so this function already does walk_system_ram_range() a bit
earlier and now on SEV systems we're going to do it again. Can we make
walk_system_ram_range() return a distinct value for SEV systems and act
accordingly in __ioremap_caller() instead of repeating the operation?

It looks to me like we could...

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
