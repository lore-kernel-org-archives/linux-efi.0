From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] arm64/efi: ignore DT memory nodes instead of
 removing them
Date: Wed, 26 Aug 2015 16:25:26 +0100
Message-ID: <20150826152526.GD10728@bivouac.eciton.net>
References: <1440576391-25725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1440576391-25725-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440576391-25725-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leo.yan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 26, 2015 at 10:06:30AM +0200, Ard Biesheuvel wrote:
> There are two problems with the UEFI stub DT memory node removal
> routine:
> - it deletes nodes as it traverses the tree, which happens to work
>   but is not supported, as deletion invalidates the node iterator;
> - deleting memory nodes entirely may discard annotations in the form
>   of additional properties on the nodes.
> 
> Now that the UEFI initialization has moved to an earlier stage, we can
> actually just ignore any memblocks that are installed after we have
> processed the UEFI memory map. This way, it is no longer necessary to
> remove the nodes, so we can remove that logic from the stub as well.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/mm/init.c               | 10 ++++++++
>  drivers/firmware/efi/libstub/fdt.c | 24 +-------------------
>  2 files changed, 11 insertions(+), 23 deletions(-)

Nice cleanup.

Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index ab25fde7397c..ecbc051bc66b 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -379,6 +379,16 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
>  	const u64 phys_offset = __pa(PAGE_OFFSET);
>  
> +	/*
> +	 * This callback will be invoked both when booting via UEFI and when
> +	 * booting via DT only. In the former case, we need to ignore memory
> +	 * nodes in the DT since UEFI is authoritative when it comes to the
> +	 * memory map. So ignore any invocations of this callback after
> +	 * EFI_MEMMAP has been set.
> +	 */
> +	if (efi_enabled(EFI_MEMMAP))
> +		return;
> +
>  	if (!PAGE_ALIGNED(base)) {
>  		if (size < PAGE_SIZE - (base & ~PAGE_MASK)) {
>  			pr_warn("Ignoring memory block 0x%llx - 0x%llx\n",
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index ef5d764e2a27..343e7992bd8f 100644
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
> 1.9.1
> 
