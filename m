From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 11/16] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Mon, 18 Jan 2016 10:41:43 +0000
Message-ID: <20160118104142.GC21067@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-12-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452840929-19612-12-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 15, 2016 at 02:55:24PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
> a /hypervisor node in DT. So check if it needs to enable ACPI.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/acpi.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index d1ce8e2..4e92be0 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -67,10 +67,13 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
>  {
>  	/*
>  	 * Return 1 as soon as we encounter a node at depth 1 that is
> -	 * not the /chosen node.
> +	 * not the /chosen node, or /hypervisor node when running on Xen.
>  	 */
> -	if (depth == 1 && (strcmp(uname, "chosen") != 0))
> -		return 1;
> +	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
> +		if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
> +			return 1;
> +	}
> +
>  	return 0;
>  }

As this is changing the semantic of an "empty" DT, we should consider
now if there's anything else that might also need to exist in an "empty"
DT. We don't want to change this again in future if we don't have to,
given the compatiblity nightmare that's sure to result.

We should also consider if the "hypervisor" node name is sufficient (I
think it is, but let's not assume anything).

Mark.

>  
> @@ -184,7 +187,8 @@ void __init acpi_boot_table_init(void)
>  	/*
>  	 * Enable ACPI instead of device tree unless
>  	 * - ACPI has been disabled explicitly (acpi=off), or
> -	 * - the device tree is not empty (it has more than just a /chosen node)
> +	 * - the device tree is not empty (it has more than just a /chosen node,
> +	 *   and a /hypervisor node when running on Xen)
>  	 *   and ACPI has not been force enabled (acpi=force)
>  	 */
>  	if (param_acpi_off ||
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
