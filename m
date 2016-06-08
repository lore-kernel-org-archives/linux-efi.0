From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [RFC PATCH v1 10/18] x86/efi: Access EFI related tables in the
 clear
Date: Wed, 8 Jun 2016 12:18:44 +0100
Message-ID: <20160608111844.GV2658@codeblueprint.co.uk>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160426225740.13567.85438.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160426225740.13567.85438.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Apr, at 05:57:40PM, Tom Lendacky wrote:
> The EFI tables are not encrypted and need to be accessed as such. Be sure
> to memmap them without the encryption attribute set. For EFI support that
> lives outside of the arch/x86 tree, create a routine that uses the __weak
> attribute so that it can be overridden by an architecture specific routine.
> 
> When freeing boot services related memory, since it has been mapped as
> un-encrypted, be sure to change the mapping to encrypted for future use.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/include/asm/cacheflush.h  |    3 +
>  arch/x86/include/asm/mem_encrypt.h |   22 +++++++++++
>  arch/x86/kernel/setup.c            |    6 +--
>  arch/x86/mm/mem_encrypt.c          |   56 +++++++++++++++++++++++++++
>  arch/x86/mm/pageattr.c             |   75 ++++++++++++++++++++++++++++++++++++
>  arch/x86/platform/efi/efi.c        |   26 +++++++-----
>  arch/x86/platform/efi/efi_64.c     |    9 +++-
>  arch/x86/platform/efi/quirks.c     |   12 +++++-
>  drivers/firmware/efi/efi.c         |   18 +++++++--
>  drivers/firmware/efi/esrt.c        |   12 +++---
>  include/linux/efi.h                |    3 +
>  11 files changed, 212 insertions(+), 30 deletions(-)

[...]

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 994a7df8..871b213 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -53,6 +53,7 @@
>  #include <asm/x86_init.h>
>  #include <asm/rtc.h>
>  #include <asm/uv/uv.h>
> +#include <asm/mem_encrypt.h>
>  
>  #define EFI_DEBUG
>  
> @@ -261,12 +262,12 @@ static int __init efi_systab_init(void *phys)
>  		u64 tmp = 0;
>  
>  		if (efi_setup) {
> -			data = early_memremap(efi_setup, sizeof(*data));
> +			data = sme_early_memremap(efi_setup, sizeof(*data));
>  			if (!data)
>  				return -ENOMEM;
>  		}

Beware, this data comes from a previous kernel that kexec'd this
kernel. Unless you've updated bzImage64_load() to allocate an
unencrypted region 'efi_setup' will in fact be encrypted.

> @@ -690,6 +691,7 @@ static void *realloc_pages(void *old_memmap, int old_shift)
>  	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
>  	if (!ret)
>  		goto out;
> +	sme_set_mem_dec(ret, PAGE_SIZE << (old_shift + 1));
>  
>  	/*
>  	 * A first-time allocation doesn't have anything to copy.

I'm not sure why it's necessary to mark this region as unencrypted,
because at this point the kernel controls the platform and when we
call into the firmware it should be using our page tables. I wouldn't
expect the firmware to mess with the SYSCFG MSR either.

Have you come across a situation where the above was required?

> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 49e4dd4..834a992 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -223,7 +223,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return 0;
>  
> -	efi_scratch.efi_pgt = (pgd_t *)__pa(efi_pgd);
> +	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(efi_pgd);
>  	pgd = efi_pgd;
>  
>  	/*

Huh? Why does __pa() now OR in sme_mas_mask? I thought SME only
required the page table structures to be modified, not the end
address?

> @@ -262,7 +262,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  		pfn = md->phys_addr >> PAGE_SHIFT;
>  		npages = md->num_pages;
>  
> -		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, _PAGE_RW)) {
> +		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages,
> +					    _PAGE_RW | _PAGE_ENC)) {
>  			pr_err("Failed to map 1:1 memory\n");
>  			return 1;
>  		}

Could you push the _PAGE_ENC addition down into
kernel_map_pages_in_pgd()? Other flags are also handled that way, see
_PAGE_PRESENT.

> @@ -272,6 +273,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	if (!page)
>  		panic("Unable to allocate EFI runtime stack < 4GB\n");
>  
> +	sme_set_mem_dec(page_address(page), PAGE_SIZE);
>  	efi_scratch.phys_stack = virt_to_phys(page_address(page));
>  	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
>  

We should not need to mark the stack as unencrypted, the firmware
should respect our SME settings, right?

> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index ab50ada..dde4fb6b 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -13,6 +13,7 @@
>  #include <linux/dmi.h>
>  #include <asm/efi.h>
>  #include <asm/uv/uv.h>
> +#include <asm/mem_encrypt.h>
>  
>  #define EFI_MIN_RESERVE 5120
>  
> @@ -265,6 +266,13 @@ void __init efi_free_boot_services(void)
>  		if (md->attribute & EFI_MEMORY_RUNTIME)
>  			continue;
>  
> +		/*
> +		 * Change the mapping to encrypted memory before freeing.
> +		 * This insures any future allocations of this mapped area
> +		 * are used encrypted.
> +		 */
> +		sme_set_mem_enc(__va(start), size);
> +
>  		free_bootmem_late(start, size);
>  	}
>  

I don't think it's necessary to have to mark the __va() mapping of
these regions as encrypted at this point. They should be setup that
way initially.

The reason is that it'd be a bug if these regions were accessed via
the __va() mappings before this point. Unless there's something I'm
missing.

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 3a69ed5..25010c7 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -76,6 +76,16 @@ static int __init parse_efi_cmdline(char *str)
>  }
>  early_param("efi", parse_efi_cmdline);
>  
> +/*
> + * If memory encryption is supported, then an override to this function
> + * will be provided.
> + */
> +void __weak __init *efi_me_early_memremap(resource_size_t phys_addr,
> +					  unsigned long size)
> +{
> +	return early_memremap(phys_addr, size);
> +}
> +
>  struct kobject *efi_kobj;
>  
>  /*

Like I said in my other mail, I'd much prefer to see this buried in
arch/x86 by passing a flag to early_memremap() which can be parsed in
arch directories.
