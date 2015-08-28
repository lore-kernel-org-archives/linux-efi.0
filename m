From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, efi, kasan: #undef memset/memcpy/memmove per
 arch.
Date: Fri, 28 Aug 2015 09:39:41 +0100
Message-ID: <20150828083941.GN10728@bivouac.eciton.net>
References: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
 <1440605707-8325-2-git-send-email-ryabinin.a.a@gmail.com>
 <20150828062745.GB1928@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828062745.GB1928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 28, 2015 at 08:27:45AM +0200, Ingo Molnar wrote:
> 
> * Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > In not-instrumented code KASAN replaces instrumented
> > memset/memcpy/memmove with not-instrumented analogues
> > __memset/__memcpy/__memove.
> > However, on x86 EFI stub is not linked with kernel.
> 
> s/with the kernel
> 
> > It uses not-instrumented mem*() functions from
> > arch/x86/boot/compressed/string.c
> > So we don't replace them with __mem*() variants in EFI stub.
> > 
> > In ARM64 EFI stub is linked with the kernel, so we should
> 
> s/In ARM64 EFI stub/On ARM64 the EFI stub/.
> 
> > replace mem*() functions with __mem*(), because EFI stub
> 
> s/the EFI stub
> 
> > runs before KASAN setup early shadow.
> 
> s/before KASAN sets up the early shadow
> 
> ?
> 
> > So let's move these #undef mem* into arch's asm/efi.h which is
> 
> s/lets

No, that one is actually correct. Abbreviation of let us.
 
> > also included by EFI stub.
> 
> s/by the EFI stub
> 
> > 
> > Signed-off-by: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  arch/x86/include/asm/efi.h             | 8 ++++++++
> >  drivers/firmware/efi/libstub/efistub.h | 4 ----
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> > index 155162e..d821ce2 100644
> > --- a/arch/x86/include/asm/efi.h
> > +++ b/arch/x86/include/asm/efi.h
> > @@ -25,6 +25,14 @@
> >  #define EFI32_LOADER_SIGNATURE	"EL32"
> >  #define EFI64_LOADER_SIGNATURE	"EL64"
> >  
> > +/*
> > + * Use memcpy/memset from arch/x86/boot/compressed/string.c
> > + * for EFI stub.
> > + */
> > +#undef memcpy
> > +#undef memset
> > +#undef memmove
> 
> This comment should also mention why it's done, not what is done.
> 
> Also:
> 
>     s/for EFI stub/for the EFI stub
> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
