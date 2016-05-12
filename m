From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] Create UV efi_call macros
Date: Thu, 12 May 2016 10:17:39 +0200
Message-ID: <20160512081739.GA25826@gmail.com>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-2-git-send-email-athorlton@sgi.com>
 <20160512064606.GA30717@gmail.com>
 <CAKv+Gu8Z0faffrN8Jnz9fQPkyn6K69cFaRD348w+m_Lv4Jgynw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8Z0faffrN8Jnz9fQPkyn6K69cFaRD348w+m_Lv4Jgynw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> On 12 May 2016 at 08:46, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > * Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org> wrote:
> >
> >> +#define efi_call_virt(f, args...)                                    \
> >> +({                                                                   \
> >> +     efi_status_t __s;                                               \
> >> +     unsigned long flags;                                            \
> >> +     arch_efi_call_virt_setup();                                     \
> >> +     local_save_flags(flags);                                        \
> >> +     __s = arch_efi_call_virt(f, args);                              \
> >> +     efi_call_virt_check_flags(flags, __stringify(f));               \
> >> +     arch_efi_call_virt_teardown();                                  \
> >> +     __s;                                                            \
> >> +})
> >> +
> >> +#define __efi_call_virt(f, args...)                                  \
> >> +({                                                                   \
> >> +     unsigned long flags;                                            \
> >> +     arch_efi_call_virt_setup();                                     \
> >> +     local_save_flags(flags);                                        \
> >> +     arch_efi_call_virt(f, args);                                    \
> >> +     efi_call_virt_check_flags(flags, __stringify(f));               \
> >> +     arch_efi_call_virt_teardown();                                  \
> >> +})
> >> +
> >> +#define uv_call_virt(f, args...)                                     \
> >> +({                                                                   \
> >> +     efi_status_t __s;                                               \
> >> +     unsigned long flags;                                            \
> >> +     arch_efi_call_virt_setup();                                     \
> >> +     local_save_flags(flags);                                        \
> >> +     __s = uv_efi_call_virt(f, args);                                \
> >> +     efi_call_virt_check_flags(flags, __stringify(f));               \
> >> +     arch_efi_call_virt_teardown();                                  \
> >> +     __s;                                                            \
> >> +})
> >
> > Btw., a very (very!) small stylistic nit that caught my eyes, and I realize that
> > you just moved code, but could you please improve these macros a bit and make it
> > look like regular kernel code? I.e. something like:
> >
> > #define efi_call_virt(f, args...)                                       \
> > ({                                                                      \
> >         efi_status_t __s;                                               \
> >         unsigned long flags;                                            \
> >                                                                         \
> >         arch_efi_call_virt_setup();                                     \
> >                                                                         \
> >         local_save_flags(flags);                                        \
> >         __s = arch_efi_call_virt(f, args);                              \
> >         efi_call_virt_check_flags(flags, __stringify(f));               \
> >         arch_efi_call_virt_teardown();                                  \
> >                                                                         \
> >         __s;                                                            \
> > })
> >
> > This delineates the various blocks of code: variables, setup, the saving/calling
> > block plus the return code.
> >
> > (Assuming the EFI folks like the whole approach.)
> >
> 
> Fine by me, although having a newline after arch_efi_call_virt_setup()
> but not before arch_efi_call_virt_teardown() seems rather arbitrary

It's an oversight! :-)

#define efi_call_virt(f, args...)					\
({									\
	efi_status_t __s;						\
	unsigned long flags;						\
									\
	arch_efi_call_virt_setup();					\
									\
	local_save_flags(flags);					\
	__s = arch_efi_call_virt(f, args);				\
	efi_call_virt_check_flags(flags, __stringify(f));		\
									\
	arch_efi_call_virt_teardown();					\
									\
	__s;								\
})

But if it's too segmented this is fine too:

#define efi_call_virt(f, args...)					\
({									\
	efi_status_t __s;						\
	unsigned long flags;						\
									\
	arch_efi_call_virt_setup();					\
	local_save_flags(flags);					\
	__s = arch_efi_call_virt(f, args);				\
	efi_call_virt_check_flags(flags, __stringify(f));		\
	arch_efi_call_virt_teardown();					\
									\
	__s;								\
})

Thanks,

	Ingo
