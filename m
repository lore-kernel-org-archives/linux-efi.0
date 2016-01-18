From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 14/16] Xen: EFI: Parse DT parameters for Xen specific
 UEFI
Date: Mon, 18 Jan 2016 11:03:19 +0000
Message-ID: <20160118110319.GF21067@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-15-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452840929-19612-15-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 15, 2016 at 02:55:27PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Add a new function to parse DT parameters for Xen specific UEFI just
> like the way for normal UEFI. Then it could reuse the existing codes.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 38 insertions(+), 7 deletions(-)

> @@ -520,15 +531,28 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  				       int depth, void *data)
>  {
>  	struct param_info *info = data;
> +	struct params *dt_params;
> +	unsigned int size;
>  	const void *prop;
>  	void *dest;
>  	u64 val;
>  	int i, len;
>  
> -	if (depth != 1 || strcmp(uname, "chosen") != 0)
> -		return 0;
> +	if (efi_enabled(EFI_PARAVIRT)) {
> +		if (depth != 2 || strcmp(uname, "uefi") != 0)
> +			return 0;

Please check the full path rather than the leaf node name alone.

Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
