From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi/x86: move UEFI Runtime Services wrappers to
 generic code
Date: Tue, 1 Jul 2014 14:30:33 +0100
Message-ID: <20140701133033.GD7539@console-pimps.org>
References: <1403777346-28629-1-git-send-email-ard.biesheuvel@linaro.org>
 <1403777346-28629-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403777346-28629-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, olivier.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Jun, at 12:09:05PM, Ard Biesheuvel wrote:
> In order for other archs (such as arm64) to be able to reuse the virtual mode
> function call wrappers, move them to drivers/firmware/efi/runtime-wrappers.c.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

[...]

> @@ -54,6 +54,13 @@ config EFI_PARAMS_FROM_FDT
>  	  the EFI runtime support gets system table address, memory
>            map address, and other parameters from the device tree.
>  
> +config EFI_RUNTIME_WRAPPERS
> +	bool
> +	help
> +	  Selected by the arch if it needs to wrap UEFI Runtime Services calls,
> +	  in which case it needs to provide #definitions of efi_call_virt and
> +	  __efi_call_virt in <asm/efi.h>
> +
>  endmenu

Actually, could we drop this help text?

That may seem like a backwards step, but I have concerns that we'll fail
to keep this help text in sync with the code. Furthermore, by providing
help text that kinda says, "casual users need the help text to
understand when to enable this feature". Clearly that's not what this
Kconfig symbol is for.

Most of the other guard Kconfig symbols don't provide this kind of text,
and I think there's good reason to follow suit.

What do you think?

-- 
Matt Fleming, Intel Open Source Technology Center
