From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4] efi: implement mandatory locking for UEFI Runtime
 Services
Date: Tue, 5 Aug 2014 13:03:32 +0100
Message-ID: <20140805120332.GO15082@console-pimps.org>
References: <1407168960-30128-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1407168960-30128-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 04 Aug, at 06:16:00PM, Ard Biesheuvel wrote:
> According to section 7.1 of the UEFI spec, Runtime Services are not fully
> reentrant, and there are particular combinations of calls that need to be
> serialized. Use a spinlock to serialize all Runtime Services with respect
> to all others, even if this is more than strictly needed.

I think we should include something that explains how we've managed to
get away without an explicit runtime lock for so long,

  We've managed to get away without requiring a runtime services lock
  until now because most of the interactions with EFI involve EFI
  variables, and those operations are already serialised with
  __efivars->lock.

and then a little bit of blurb about why that's no longer good enough.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h              |   2 +
>  drivers/firmware/efi/runtime-wrappers.c | 154 +++++++++++++++++++++++++++++---
>  2 files changed, 146 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 044a2fd3c5fe..b39ee5f2c02d 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -86,6 +86,8 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
>  
>  #endif /* CONFIG_X86_32 */
>  
> +#define efi_in_nmi()	in_nmi()
> +

Remind me why this is needed for x86 but not for arm again?

The rest looks good. I'm just running it through some tests now.

Thanks Ard.

-- 
Matt Fleming, Intel Open Source Technology Center
