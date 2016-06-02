From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 3/3] Update efi_thunk to use efi_call_virt_generic
Date: Thu, 2 Jun 2016 16:25:15 -0500
Message-ID: <20160602212515.GE242721@stormcage.americas.sgi.com>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
 <1463598701-178201-4-git-send-email-athorlton@sgi.com>
 <20160602201949.GL2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602201949.GL2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 02, 2016 at 09:19:49PM +0100, Matt Fleming wrote:
> On Wed, 18 May, at 02:11:41PM, Alex Thorlton wrote:
> > +#define arch_efi_call_virt(p, f, ...)					\
> > +({									\
> > +	u32 func = runtime_service32(f);				\
> > +	efi64_thunk(func, __VA_ARGS__);					\
> > +})
> > +
> 
> This isn't correct because you're turning the runtime decision of
> whether we're executing the thunking code into a build time one.

Ahh, yep, you're absolutely correct.  That's not what I intended to do,
but that's definitely the effect that this change has.

> Would something like this work instead? It's not as neat as your
> suggestion but it's a damn sight better than what we have today.
> 
> ---
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 6e7242be1c87..b976084e56ef 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -469,18 +469,13 @@ extern efi_status_t efi64_thunk(u32, ...);
>  	unsigned long flags;						\
>  	u32 func;							\
>  									\
> -	efi_sync_low_kernel_mappings();					\
>  	local_irq_save(flags);						\
> -									\
> -	efi_scratch.prev_cr3 = read_cr3();				\
> -	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
> -	__flush_tlb_all();						\
> +	arch_efi_call_virt_setup();					\
>  									\
>  	func = runtime_service32(f);					\
>  	__s = efi64_thunk(func, __VA_ARGS__);			\
>  									\
> -	write_cr3(efi_scratch.prev_cr3);				\
> -	__flush_tlb_all();						\
> +	arch_efi_call_virt_teardown();					\
>  	local_irq_restore(flags);					\
>  									\
>  	__s;								\

This looks good to me.  We're at least making use of the
arch_efi_call_virt_* stuff where possible, and only using the special
thunk code where necessary.  I think it's a good middle ground between
the two approaches (especially considering the fact that mine won't
work :) 

I will re-work that last patch to include this change instead of my
original, broken one.

Thanks, Matt!

- Alex
