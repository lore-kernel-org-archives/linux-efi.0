From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCHv2] x86: EFI stub support for large memory maps
Date: Tue, 17 Sep 2013 21:14:52 +0100
Message-ID: <20130917201452.GI3409@console-pimps.org>
References: <1377291771-21302-1-git-send-email-linn@hp.com>
 <1378487056-9857-1-git-send-email-linn@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1378487056-9857-1-git-send-email-linn-VXdhtT5mjnY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 06 Sep, at 11:04:16AM, Linn Crosetto wrote:
> This patch fixes a problem with EFI memory maps larger than 128 entries
> when booting using the EFI stub, which results in overflowing e820_map
> in boot_params and an eventual halt when checking the map size in
> sanitize_e820_map().
> 
> If the number of map entries is greater than what can fit in e820_map,
> add the extra entries to the setup_data list using type SETUP_E820_EXT.
> These extra entries are then picked up when the setup_data list is
> parsed in parse_e820_ext().
> 
> Signed-off-by: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
> ---
> Changes in v2:
> * Free memory when error is returned from alloc_e820ext() as suggested by Matt
>   Fleming
> * Set pointer to NULL and size to 0 after freeing memory in alloc_e820ext()
> 
>  arch/x86/boot/compressed/eboot.c | 223 ++++++++++++++++++++++++++++-----------
>  1 file changed, 160 insertions(+), 63 deletions(-)

[...]

> +static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
> +				  u32 *e820ext_size)
> +{
> +	efi_status_t status;
> +	unsigned long size;
> +
> +	size = sizeof(struct setup_data) +
> +		sizeof(struct e820entry) * nr_desc;
> +
> +	if (*e820ext && size <= *e820ext_size)
> +		return EFI_SUCCESS; /* Already allocated */

Do we actually need this check? I thought the 'prev_nr_desc' below
ensures we only allocate 'e820ext' if we need more memory.

[...]

> @@ -1016,6 +1157,19 @@ get_map:
>  	if (status != EFI_SUCCESS)
>  		goto free_mem_map;
>  
> +	prev_nr_desc = nr_desc;
> +	nr_desc = size / desc_size;
> +	if (nr_desc > prev_nr_desc &&
> +	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
> +		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
> +
> +		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
> +		if (status != EFI_SUCCESS)
> +			goto free_mem_map;
> +
> +		goto get_map; /* Allocated memory, get map again */
> +	}
> +

-- 
Matt Fleming, Intel Open Source Technology Center
