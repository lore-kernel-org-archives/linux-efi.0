From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCHv2 2/5] arm64/efi: move to generic {__,}efi_call_virt
Date: Thu, 21 Apr 2016 17:58:18 +0100
Message-ID: <20160421165648.GA3078@leverpostej>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
 <1461238529-12810-3-git-send-email-mark.rutland@arm.com>
 <20160421164840.GO929@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421164840.GO929-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 21, 2016 at 05:48:40PM +0100, Will Deacon wrote:
> On Thu, Apr 21, 2016 at 12:35:26PM +0100, Mark Rutland wrote:
> > Now there's a common template for {__,}efi_call_virt, remove the
> > duplicate logic from the arm64 efi code.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> > Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> > Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >  arch/arm64/include/asm/efi.h | 21 +++++++--------------
> >  1 file changed, 7 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> > index 8e88a69..f4f71224 100644
> > --- a/arch/arm64/include/asm/efi.h
> > +++ b/arch/arm64/include/asm/efi.h
> > @@ -14,28 +14,21 @@ extern void efi_init(void);
> >  
> >  int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
> >  
> > -#define efi_call_virt(f, ...)						\
> > +#define arch_efi_call_virt_setup()					\
> >  ({									\
> > -	efi_##f##_t *__f;						\
> > -	efi_status_t __s;						\
> > -									\
> >  	kernel_neon_begin();						\
> >  	efi_virtmap_load();						\
> > -	__f = efi.systab->runtime->f;					\
> > -	__s = __f(__VA_ARGS__);						\
> > -	efi_virtmap_unload();						\
> > -	kernel_neon_end();						\
> > -	__s;								\
> >  })
> >  
> > -#define __efi_call_virt(f, ...)						\
> > +#define arch_efi_call_virt(f, args...)					\
> >  ({									\
> >  	efi_##f##_t *__f;						\
> > -									\
> > -	kernel_neon_begin();						\
> > -	efi_virtmap_load();						\
> >  	__f = efi.systab->runtime->f;					\
> > -	__f(__VA_ARGS__);						\
> > +	__f(args);							\
> 
> Any reason to change this to a named argument? This patch is hard enough
> to review as it is, given the way the diff has been generated!

That was to enforce consistency across arm/arm64/x86 for this.

It seemed nicer to make them all use a named argument than it did to
make them all use __VA_ARGS__, either of which was nice than each of
them doing something slightly different.

Sorry for the pain that evidently caused!

> Either way:
> 
> Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

Cheers!

Mark.
