From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v12 1/5] efi: ARM/arm64: ignore DT memory nodes instead
 of removing them
Date: Tue, 23 Feb 2016 11:58:05 +0000
Message-ID: <20160223115805.GB4989@leverpostej>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-2-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456192703-2274-2-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

On Mon, Feb 22, 2016 at 05:58:19PM -0800, David Daney wrote:
> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> There are two problems with the UEFI stub DT memory node removal
> routine:
> - it deletes nodes as it traverses the tree, which happens to work
>   but is not supported, as deletion invalidates the node iterator;
> - deleting memory nodes entirely may discard annotations in the form
>   of additional properties on the nodes.
> 
> Since the discovery of DT memory nodes occurs strictly before the
> UEFI init sequence, we can simply clear the memblock memory table
> before parsing the UEFI memory map. This way, it is no longer
> necessary to remove the nodes, so we can remove that logic from the
> stub as well.

This is a little bit scary, but I guess this works.

My only concern is that when we get kexec, a subsequent kernel must also
have EFI memory map support, or things go bad for the next EFI-aware
kernel after that (as things like the runtime services may have been
corrupted by the kernel in the middle). It's difficult to fix the
general case later.

A different option would be to support status="disabled" for the memory
nodes, and ignore these in early_init_dt_scan_memory. That way a kernel
cannot use memory without first having parsed the EFI memory map, and we
can still get NUMA info from the disabled nodes.

You'd still need a new kernel to take into account status, but at least
we'd know all kernels would avoid using RAM that potentially needs to be
preserved.

Ard, Rob, thoughts?

Mark.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-init.c    |  8 ++++++++
>  drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
>  2 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 9e15d57..40c9d85 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -143,6 +143,14 @@ static __init void reserve_regions(void)
>  	if (efi_enabled(EFI_DBG))
>  		pr_info("Processing EFI memory map:\n");
>  
> +	/*
> +	 * Discard memblocks discovered so far: if there are any at this
> +	 * point, they originate from memory nodes in the DT, and UEFI
> +	 * uses its own memory map instead.
> +	 */
> +	memblock_dump_all();
> +	memblock_remove(0, ULLONG_MAX);
> +
>  	for_each_efi_memory_desc(&memmap, md) {
>  		paddr = md->phys_addr;
>  		npages = md->num_pages;
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index cf7b7d4..9df1560 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -24,7 +24,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>  			unsigned long map_size, unsigned long desc_size,
>  			u32 desc_ver)
>  {
> -	int node, prev, num_rsv;
> +	int node, num_rsv;
>  	int status;
>  	u32 fdt_val32;
>  	u64 fdt_val64;
> @@ -54,28 +54,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>  		goto fdt_set_fail;
>  
>  	/*
> -	 * Delete any memory nodes present. We must delete nodes which
> -	 * early_init_dt_scan_memory may try to use.
> -	 */
> -	prev = 0;
> -	for (;;) {
> -		const char *type;
> -		int len;
> -
> -		node = fdt_next_node(fdt, prev, NULL);
> -		if (node < 0)
> -			break;
> -
> -		type = fdt_getprop(fdt, node, "device_type", &len);
> -		if (type && strncmp(type, "memory", len) == 0) {
> -			fdt_del_node(fdt, node);
> -			continue;
> -		}
> -
> -		prev = node;
> -	}
> -
> -	/*
>  	 * Delete all memory reserve map entries. When booting via UEFI,
>  	 * kernel will use the UEFI memory map to find reserved regions.
>  	 */
> -- 
> 1.8.3.1
> 
