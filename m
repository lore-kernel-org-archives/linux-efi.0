From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/7] efi: Get the secure boot status [ver #7]
Date: Thu, 2 Feb 2017 21:34:29 +0000
Message-ID: <20170202213429.GP31613@codeblueprint.co.uk>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587562967.4026.18171897997650345605.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <148587562967.4026.18171897997650345605.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 31 Jan, at 03:13:49PM, David Howells wrote:
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index f99978db6b6f..57c2c9c71e53 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -988,6 +988,12 @@ struct boot_params *efi_main(struct efi_config *c,
>  	else
>  		setup_boot_services32(efi_early);
>  
> +	/* If the boot loader gave us a value for secure_boot then we use that,
> +	 * otherwise we ask the BIOS.
> +	 */
> +	if (boot_params->secure_boot == efi_secureboot_mode_unset)
> +		boot_params->secure_boot = efi_get_secureboot(sys_table);
> +
>  	setup_graphics(boot_params);
>  
>  	setup_efi_pci(boot_params);

It's not a big deal, but this multi-line comment format isn't correct.
Either Ard or I will fix it up when applying this patch. Same goes for
the comment in patch 5.

Otherwise this patch looks fine.
