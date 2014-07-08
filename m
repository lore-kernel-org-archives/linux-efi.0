From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Tue, 8 Jul 2014 12:09:24 +0100
Message-ID: <20140708110923.GO4179@bivouac.eciton.net>
References: <20140523094513.GC9252@arm.com>
 <20140523131656.GR4179@bivouac.eciton.net>
 <20140523134720.GA9256@arm.com>
 <20140523150331.GS4179@bivouac.eciton.net>
 <20140708092100.GA21320@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140708092100.GA21320-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 08, 2014 at 10:21:00AM +0100, Catalin Marinas wrote:
> I forgot about this thread. I think we need it sorted in some way.

Agreed.
 
> On Fri, May 23, 2014 at 04:03:31PM +0100, Leif Lindholm wrote:
> > My view is that this should be fixed in fdt_find_uefi_params(). A
> > single info message that we can't find evidence of UEFI should be
> > printed in the non-error case.
> [...]
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index cd36deb..4bb42e1e 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -366,11 +366,8 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> >  
> >  	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> >  		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
> > -		if (!prop) {
> > -			pr_err("Can't find %s in device tree!\n",
> > -			       dt_params[i].name);
> > -			return 0;
> > -		}
> > +		if (!prop)
> > +			goto fail;
> >  		dest = info->params + dt_params[i].offset;
> >  
> >  		val = of_read_number(prop, len / sizeof(u32));
> > @@ -385,6 +382,14 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> >  				dt_params[i].size * 2, val);
> >  	}
> >  	return 1;
> > +
> > +	fail:
> > +	if (i == 0)
> > +		pr_info("  UEFI not found.\n");
> > +	else
> > +		pr_err("Can't find %s in device tree!\n", dt_params[i].name);
> > +
> > +	return 0;
> 
> I'm ok with the idea but I don't particularly like the implementation.
> Does this look any better (functionally the same as yours)?

It solves the problem, so sure.
Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index eff1a2f22f09..dc79346689e6 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -346,6 +346,7 @@ static __initdata struct {
>  
>  struct param_info {
>  	int verbose;
> +	int found;
>  	void *params;
>  };
>  
> @@ -362,16 +363,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
>  		return 0;
>  
> -	pr_info("Getting parameters from FDT:\n");
> -
>  	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
>  		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
> -		if (!prop) {
> -			pr_err("Can't find %s in device tree!\n",
> -			       dt_params[i].name);
> +		if (!prop)
>  			return 0;
> -		}
>  		dest = info->params + dt_params[i].offset;
> +		info->found++;
>  
>  		val = of_read_number(prop, len / sizeof(u32));
>  
> @@ -390,10 +387,21 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
>  {
>  	struct param_info info;
> +	int ret;
> +
> +	pr_info("Getting EFI parameters from FDT:\n");
>  
>  	info.verbose = verbose;
> +	info.found = 0;
>  	info.params = params;
>  
> -	return of_scan_flat_dt(fdt_find_uefi_params, &info);
> +	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
> +	if (!info.found)
> +		pr_info("UEFI not found.\n");
> +	else if (!ret)
> +		pr_err("Can't find '%s' in device tree!\n",
> +		       dt_params[info.found].name);
> +
> +	return ret;
>  }
>  #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
