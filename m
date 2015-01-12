From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Add esrt support.
Date: Mon, 12 Jan 2015 13:03:32 +0000
Message-ID: <20150112130332.GG26589@codeblueprint.co.uk>
References: <1420831159-17285-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420831159-17285-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 09 Jan, at 02:19:19PM, Peter Jones wrote:
> Add sysfs files for the EFI System Resource Table (ESRT) under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> The EFI System Resource Table (ESRT) provides a read-only catalog of
> system components for which the system accepts firmware upgrades via
> UEFI's "Capsule Update" feature.  This module allows userland utilities
> to evaluate what firmware updates can be applied to this system, and
> potentially arrange for those updates to occur.
> 
> The ESRT is described as part of the UEFI specification, in version 2.5
> which should be available from http://uefi.org/specifications in early
> 2015.  If you're a member of the UEFI Forum, information about its
> addition to the standard is available as UEFI Mantis 1090.
> 
> For some hardware platforms, additional restrictions may be found at
> http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256.aspx ,
> and additional documentation may be found at
> http://download.microsoft.com/download/5/F/5/5F5D16CD-2530-4289-8019-94C6A20BED3C/windows-uefi-firmware-update-platform.docx
> .
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/Makefile |   2 +-
>  drivers/firmware/efi/efi.c    |  60 ++++++-
>  drivers/firmware/efi/esrt.c   | 402 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h           |   7 +
>  4 files changed, 469 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/esrt.c

[...]

> @@ -223,6 +226,60 @@ err_put:
>  
>  subsys_initcall(efisubsys_init);
>  
> +/*
> + * Find the efi memory descriptor for a given physical address.  Given a
> + * physicall address, determine if it exists within an EFI Memory Map entry,
> + * and if so, populate the supplied memory descriptor with the appropriate
> + * data.
> + */
> +int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
> +{
> +	struct efi_memory_map *map = efi.memmap;
> +	void *p, *e;

This is missing,

	if (!efi_enabled(EFI_MEMMAP))
		return -EINVAL;

> +
> +	if (!map)
> +		return -1;
> +	if (!out_md)
> +		return -1;
> +	if (WARN_ON(!map->phys_map))
> +		return -1;
> +	if (WARN_ON(map->nr_map == 0) || WARN_ON(map->desc_size == 0))
> +		return -1;

Should we be returning -EINVAL here instead?

> +
> +	e = map->phys_map + map->nr_map * map->desc_size;
> +	for (p = map->phys_map; p < e; p += map->desc_size) {
> +		/*
> +		 * If a driver calls this after efi_free_boot_services,
> +		 * ->map will be NULL.
> +		 * So just always get our own virtual map on the CPU.
> +		 */
> +		efi_memory_desc_t *md = phys_to_virt((phys_addr_t)p);
> +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> +		u64 end = md->phys_addr + size;
> +
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> +		    md->type != EFI_BOOT_SERVICES_CODE &&
> +		    md->type != EFI_BOOT_SERVICES_DATA)
> +			continue;
> +		if (!md->virt_addr)
> +			continue;
> +		if (phys_addr >= md->phys_addr && phys_addr < end) {
> +			memcpy(out_md, md, sizeof(*out_md));
> +			return 0;
> +		}
> +	}
> +	return -1;

-ENOENT?

[...]

> +
> +	tmpesrt = ioremap(efi.esrt, size);
> +	if (!tmpesrt) {
> +		pr_err("ioremap failed.\n");
> +		return -ENOMEM;
> +	}

Sadly, this isn't going to work with kexec. I don't that should hold up
this patch, but I just wanted to raise the issue and make people aware.

Dave, Ard, original thread is here,

  http://article.gmane.org/gmane.linux.kernel.efi/5233

Ard has come up with a nice solution to this kind of problem for arm64:
basically you perform all such mappings in the EFI boot stub so that the
kexec and non-kexec code paths are always dealing with virtual
addresses. It's a neat idea.

I'm going to take a look at that this week to see whether we can do
something similar for x86, because no doubt we're going to want to map
more tables in the future (right now we have the ESRT and memmap
tables).

-- 
Matt Fleming, Intel Open Source Technology Center
