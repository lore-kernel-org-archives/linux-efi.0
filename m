From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: efi: Auto-load the efi-pstore module
Date: Wed, 7 Oct 2015 22:16:32 +0100
Message-ID: <20151007211632.GC3249@codeblueprint.co.uk>
References: <1443401056.2517.27.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443401056.2517.27.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 28 Sep, at 01:44:16AM, Ben Hutchings wrote:
> efi-pstore should be auto-loaded on EFI systems, same as efivars.
> 
> Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
> ---
> This was included in Debian 8 "jessie" with no complaints so far
> (and without CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE set), so it seems
> to be safe to do.
> 
> Ben.
> 
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -400,3 +400,4 @@ module_exit(efivars_pstore_exit);
>  
>  MODULE_DESCRIPTION("EFI variable backend for pstore");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:efivars");

I'm OK with this change because it still relies on distributions to
actually enable the Kconfig option too, before it works.

Folks on Cc, please let me know if you have concerns.

-- 
Matt Fleming, Intel Open Source Technology Center
