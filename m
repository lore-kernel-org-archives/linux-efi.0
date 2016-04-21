From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 1/5] efi/runtime-wrappers: add {__,}efi_call_virt
 templates
Date: Thu, 21 Apr 2016 12:42:56 +0100
Message-ID: <20160421114256.GP2904@bivouac.eciton.net>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
 <1461238529-12810-2-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461238529-12810-2-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 21, 2016 at 12:35:25PM +0100, Mark Rutland wrote:
> Currently each architecture must implement two macros, efi_call_virt and
> __efi_call_virt, which only differ by the presence or absence of a
> return type. Otherwise, the logic surrounding the call is identical.
> 
> As each architecture must define the entire body of each, we can't place
> any generic manipulation (e.g. irq flag validation) in the middle.
> 
> This patch adds template implementations of these macros. With these,
> arch code can implement three template macros, avoiding reptition for
> the void/non-void return cases:
> 
> * arch_efi_call_virt_setup
> 
>   Sets up the environment for the call (e.g. switching page tables,
>   allowing kernel-mode use of floating point, if required).
> 
> * arch_efi_call_virt
> 
>   Performs the call. The last expression in the macro must be the call
>   itself, allowing the logic to be shared by the void and non-void
>   cases.
> 
> * arch_efi_call_virt_teardown
> 
>   Restores the usual kernel environment once the call has returned.
> 
> While the savings from repition are minimal, we additionally gain the
> ability to add common code around the call with the call enviroment set
> up. This can be used to detect common firmware issues (e.g. bad irq mask
> management).
> 
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index de69530..1b9fa54 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -20,6 +20,27 @@
>  #include <linux/spinlock.h>
>  #include <asm/efi.h>
>  
> +
> +#ifndef efi_call_virt

So ... not a strong complaint, but I would prefer if these weren't
ifdefd. I presume this is because ia64?
Could that be given a dummy pass-through version instead? If not,
could a comment be added that this is to retain compatibility with
ia64 (so that if that architecture was to mysteriously disappear from
the tree, someone might remember to deconditionalise it)?

> +#define efi_call_virt(f, args...)					\
> +({									\
> +	efi_status_t __s;						\
> +	arch_efi_call_virt_setup();					\
> +	__s = arch_efi_call_virt(f, args);				\
> +	arch_efi_call_virt_teardown();					\
> +	__s;								\
> +})
> +#endif
> +
> +#ifndef __efi_call_virt
> +#define __efi_call_virt(f, args...)					\
> +({									\
> +	arch_efi_call_virt_setup();					\
> +	arch_efi_call_virt(f, args);					\
> +	arch_efi_call_virt_teardown();					\
> +})
> +#endif
> +
>  /*
>   * According to section 7.1 of the UEFI spec, Runtime Services are not fully
>   * reentrant, and there are particular combinations of calls that need to be
> -- 
> 1.9.1
> 
