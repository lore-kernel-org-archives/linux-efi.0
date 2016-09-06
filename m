From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Optimize away setup_gop32/64 if unused
Date: Tue, 6 Sep 2016 08:10:09 +0200
Message-ID: <20160906061009.GA27735@wunner.de>
References: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas@wunner.de>
 <20160905123725.GF32579@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905123725.GF32579-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 05, 2016 at 01:37:25PM +0100, Matt Fleming wrote:
> On Mon, 22 Aug, at 12:01:21PM, Lukas Wunner wrote:
> > Eliminate the 64 bit code path when compiling for x86_32, and vice-versa
> > the 32 bit code path when compiling for x86_64 with mixed mode disabled.
> > 
> > Size of gop.o text section:
> > CONFIG_X86_32:                         1758 before, 1299 after
> > CONFIG_X86_64 && !CONFIG_EFI_MIXED:    2201 before, 1406 after
> > CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    2201 before and after
> > 
> > Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/x86/include/asm/efi.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> > index 6b06939..1bda245 100644
> > --- a/arch/x86/include/asm/efi.h
> > +++ b/arch/x86/include/asm/efi.h
> > @@ -207,14 +207,16 @@ struct efi_config {
> >  
> >  __pure const struct efi_config *__efi_early(void);
> >  
> > +#define efi_is_64bit()							\
> > +	(IS_ENABLED(CONFIG_X86_64) && (!IS_ENABLED(CONFIG_EFI_MIXED)	\
> > +				       || __efi_early()->is64))
> > +
> >  #define efi_call_early(f, ...)						\
> >  	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
> >  
> >  #define __efi_call_early(f, ...)					\
> >  	__efi_early()->call((unsigned long)f, __VA_ARGS__);
> >  
> > -#define efi_is_64bit()		__efi_early()->is64
> > -
> >  extern bool efi_reboot_required(void);
> >  
> >  #else
> 
> Could you make this into a more readable static inline? e.g. something
> like this,
> 
> static inline bool efi_is_64bit(void)
> {
> 	if (!IS_ENABLED(CONFIG_X86_64))
> 		return false;
> 
> 	if (!IS_ENABLED(CONFIG_EFI_MIXED) || __efi_early()->is64)
> 		return true;
> 
> 	return false;
> }

Indeed this is much better. I've just sent out an updated version
in-reply-to the original patch.

Thanks a lot,

Lukas
