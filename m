From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/8] efi: libstub: move Graphics Output Protocol handling
 to generic code
Date: Fri, 18 Mar 2016 11:25:03 +0000
Message-ID: <20160318112503.GP2619@codeblueprint.co.uk>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457588408-19309-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Mar, at 12:40:02PM, Ard Biesheuvel wrote:
> The Graphics Output Protocol code executes in the stub, so create a generic
> version based on the x86 version in libstub so that we can move all archs
> to it in subsequent patches. The new source file gop.c is added to the
> libstub build for all architectures, but is not actually included in any of
> the final images, since this patch does not wire it up yet.
> 
> Note that the generic version uses slightly different ways of casting the
> protocol methods and some other variables to the correct types, since such
> method calls are not loosely typed on ARM and arm64 as they are on x86.
 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/include/asm/efi.h            |   4 +-
>  arch/arm64/include/asm/efi.h          |   4 +-
>  arch/x86/boot/compressed/eboot.h      |  74 ----
>  arch/x86/include/asm/efi.h            |   5 +
>  drivers/firmware/efi/libstub/Makefile |   2 +-
>  drivers/firmware/efi/libstub/gop.c    | 354 ++++++++++++++++++++
>  include/linux/efi.h                   |  87 ++++-
>  7 files changed, 451 insertions(+), 79 deletions(-)
 
I can totally appreciate why you did the gop code move in stages, but
I'd prefer to see the move (deletion from arch/x86 and addition to
drivers/firmware/efi) done as a single patch.

The reason is that git will produce a very nice diff stat that shows
the number of lines that were simply moved from one file to another
without modification.

Which makes it much easier to see which lines *did* change.

As a very quick and dirty example (but this is not what I'm suggesting
you do because it'd be too many changes in one patch) I merged this
patch with the next one, which produces the following diff stat. The
important point are the insertions,

 : $ git show --shortstat --summary -C10% e63c02a98c3c
 :
 : 8 files changed, 133 insertions(+), 1606 deletions(-)
 :  copy arch/x86/boot/compressed/eboot.c => drivers/firmware/efi/libstub/gop.c (20%)

> diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
> index e0eea72deb87..daebcfe6c35a 100644
> --- a/arch/arm/include/asm/efi.h
> +++ b/arch/arm/include/asm/efi.h
> @@ -59,7 +59,9 @@ void efi_virtmap_unload(void);
>  
>  /* arch specific definitions used by the stub code */
>  
> -#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
> +#define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
> +#define __efi_call_early(f, ...)	f(__VA_ARGS__)
> +#define efi_is_64bit()			(0)
  
Is there a specific reason that these can't be boolean? I know some
people hate them, but I've always been a pretty big fan when the
circumstances are right. Plus it is bool on x86. 
