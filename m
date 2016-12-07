From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [RFC PATCH v3 10/20] Add support to access boot related data in
	the clear
Date: Wed, 7 Dec 2016 13:19:03 +0000
Message-ID: <20161207131903.GU20785@codeblueprint.co.uk>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
	<20161110003631.3280.73292.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161110003631.3280.73292.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Nov, at 06:36:31PM, Tom Lendacky wrote:
> Boot data (such as EFI related data) is not encrypted when the system is
> booted and needs to be accessed unencrypted.  Add support to apply the
> proper attributes to the EFI page tables and to the early_memremap and
> memremap APIs to identify the type of data being accessed so that the
> proper encryption attribute can be applied.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/include/asm/e820.h    |    1 
>  arch/x86/kernel/e820.c         |   16 +++++++
>  arch/x86/mm/ioremap.c          |   89 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/platform/efi/efi_64.c |   12 ++++-
>  drivers/firmware/efi/efi.c     |   33 +++++++++++++++
>  include/linux/efi.h            |    2 +
>  kernel/memremap.c              |    8 +++-
>  mm/early_ioremap.c             |   18 +++++++-
>  8 files changed, 172 insertions(+), 7 deletions(-)
 
FWIW, I think this version is an improvement over all the previous
ones.

[...]

> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index ff542cd..ee347c2 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -20,6 +20,9 @@
>  #include <asm/tlbflush.h>
>  #include <asm/pgalloc.h>
>  #include <asm/pat.h>
> +#include <asm/e820.h>
> +#include <asm/setup.h>
> +#include <linux/efi.h>
>  
>  #include "physaddr.h"
>  
> @@ -418,6 +421,92 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
>  	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
>  }
>  
> +static bool memremap_setup_data(resource_size_t phys_addr,
> +				unsigned long size)
> +{
> +	u64 paddr;
> +
> +	if (phys_addr == boot_params.hdr.setup_data)
> +		return true;
> +

Why is the setup_data linked list not traversed when checking for
matching addresses? Am I reading this incorrectly? I don't see how
this can work.

> +	paddr = boot_params.efi_info.efi_memmap_hi;
> +	paddr <<= 32;
> +	paddr |= boot_params.efi_info.efi_memmap;
> +	if (phys_addr == paddr)
> +		return true;
> +
> +	paddr = boot_params.efi_info.efi_systab_hi;
> +	paddr <<= 32;
> +	paddr |= boot_params.efi_info.efi_systab;
> +	if (phys_addr == paddr)
> +		return true;
> +
> +	if (efi_table_address_match(phys_addr))
> +		return true;
> +
> +	return false;
> +}
> +
> +static bool memremap_apply_encryption(resource_size_t phys_addr,
> +				      unsigned long size)
> +{
> +	/* SME is not active, just return true */
> +	if (!sme_me_mask)
> +		return true;
> +
> +	/* Check if the address is part of the setup data */
> +	if (memremap_setup_data(phys_addr, size))
> +		return false;
> +
> +	/* Check if the address is part of EFI boot/runtime data */
> +	switch (efi_mem_type(phys_addr)) {
> +	case EFI_BOOT_SERVICES_DATA:
> +	case EFI_RUNTIME_SERVICES_DATA:
> +		return false;
> +	}

EFI_LOADER_DATA is notable by its absence.

We use that memory type for allocations inside of the EFI boot stub
that are than used while the kernel is running. One use that comes to
mind is for initrd files, see handle_cmdline_files().

Oh I see you handle that in PATCH 9, never mind.

> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 58b0f80..3f89179 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -221,7 +221,13 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return 0;
>  
> -	efi_scratch.efi_pgt = (pgd_t *)__pa(efi_pgd);
> +	/*
> +	 * Since the PGD is encrypted, set the encryption mask so that when
> +	 * this value is loaded into cr3 the PGD will be decrypted during
> +	 * the pagetable walk.
> +	 */
> +	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(efi_pgd);
> +
>  	pgd = efi_pgd;
>  
>  	/*

Do all callers of __pa() in arch/x86 need fixing up like this?
