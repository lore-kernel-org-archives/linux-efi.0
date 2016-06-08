From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Auto enable EFI memmap on SGI UV systems
Date: Wed, 8 Jun 2016 13:12:23 +0200
Message-ID: <20160608111223.GA5772@gmail.com>
References: <1464900635-11957-1-git-send-email-jthelen@sgi.com>
 <1464900635-11957-2-git-send-email-jthelen@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464900635-11957-2-git-send-email-jthelen-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org> wrote:

>  static int __init setup_add_efi_memmap(char *arg)
>  {
> +	static bool arg_as_bool;

Why hidden inside local variables as static?

> +	int ret = strtobool(arg, &arg_as_bool);
> +
> +	/* check for a non-existent arg, to maintain backward compatibility */
> +	if (!arg) {
> +		add_efi_memmap = EFI_MEMMAP_ENABLED;
> +	} else {
> +		if (ret) {
> +			/* a bad argument was passed... */
> +			return ret;
> +		} else {
> +			if (arg_as_bool)
> +				add_efi_memmap = EFI_MEMMAP_ENABLED;
> +			else
> +				add_efi_memmap = EFI_MEMMAP_DISABLED;
> +		}
> +	}
> +
>  	return 0;

And that's a really weird code flow!

How about something straightforward:

	int val = 0;
	int ret;

	/* Check for a non-existent arg, to maintain backward compatibility: */
	if (!arg) {
		add_efi_memmap = EFI_MEMMAP_ENABLED;
		return 0;
	}

	ret = strtobool(arg, &val);

	/* Was a bad argument passed? */
	if (ret)
		return ret;

	if (val)
		add_efi_memmap = EFI_MEMMAP_ENABLED;
	else
		add_efi_memmap = EFI_MEMMAP_DISABLED;

	return 0;

?

Also note the rename to 'val'.

Thanks,

	Ingo
