From: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v16 1/6] efi: ARM/arm64: ignore DT memory nodes instead
 of removing them
Date: Thu, 14 Apr 2016 12:02:11 +0100
Message-ID: <20160414110210.GA11788@e103986-lin>
References: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
 <1460155828-8690-2-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460155828-8690-2-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 08, 2016 at 03:50:23PM -0700, David Daney wrote:
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
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-init.c    |  8 ++++++++
>  drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
>  2 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index aa1f743..5d6945b 100644
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

Does this change need to be applied to any other architectures given
that deletion code has been removed from libstub below?

Cheers,
-- 
Steve

>  	for_each_efi_memory_desc(&memmap, md) {
>  		paddr = md->phys_addr;
>  		npages = md->num_pages;
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 6dba78a..e58abfa 100644
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
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
