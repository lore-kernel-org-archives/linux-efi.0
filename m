From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86: EFI stub support for large memory maps
Date: Fri, 6 Sep 2013 11:03:25 +0100
Message-ID: <20130906100325.GB7579@console-pimps.org>
References: <1377291771-21302-1-git-send-email-linn@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1377291771-21302-1-git-send-email-linn-VXdhtT5mjnY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 23 Aug, at 03:02:51PM, Linn Crosetto wrote:
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
>  arch/x86/boot/compressed/eboot.c | 220 ++++++++++++++++++++++++++++-----------
>  1 file changed, 157 insertions(+), 63 deletions(-)

[...]

> @@ -1016,6 +1154,19 @@ get_map:
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
> +			return status;

In the error path shouldn't we jump to free_mem_map to avoid leaking
memory?

-- 
Matt Fleming, Intel Open Source Technology Center
