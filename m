From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 1/3] Convert efi_call_virt to efi_call_virt_generic
Date: Thu, 2 Jun 2016 11:23:35 -0500
Message-ID: <20160602162335.GV242721@stormcage.americas.sgi.com>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
 <1463598701-178201-2-git-send-email-athorlton@sgi.com>
 <20160602154114.GI2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602154114.GI2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 02, 2016 at 04:41:14PM +0100, Matt Fleming wrote:
> Oops, you're missing updates to the 32-bit version and ARM/arm64,
> which results in this,
>=20
> drivers/firmware/efi/runtime-wrappers.c: In function =E2=80=98virt_ef=
i_get_time=E2=80=99:
> arch/x86/include/asm/efi.h:46:4: error: =E2=80=98efi_efi=E2=80=99 und=
eclared (first use in this function)
>   ((efi_##f##_t __attribute__((regparm(0)))*)   \
>     ^
>=20
> but that's easily fixed up.

Oops!  Sorry about that.  I had done a pretty recent pull before I did
my last build, but it was probably before these updates came in.  I'll
rebase my patches onto the latest tip kernel and fix this.

> > +/*
> > + * Wrap around the new efi_call_virt_generic macros so that the
> > + * code doesn't get too cluttered
> > + */
> > +#define efi_call_virt(f, args...)   \
> > +	efi_call_virt_generic(efi.systab->runtime, f, args)
> > +#define __efi_call_virt(f, args...) \
> > +	__efi_call_virt_generic(efi.systab->runtime, f, args)
> > +
> > +void efi_call_virt_check_flags(unsigned long flags, const char *ca=
ll)
> >  {
> >  	unsigned long cur_flags, mismatch;
> > =20
>=20
> I'm not crazy about using "generic" in the name. How about
> efi_call_virt_function() or efi_call_virt_pointer()?

I'm not married to "generic."  I'll change it to efi_call_virt_pointer.
I think efi_call_virt_function is a little confusing/redundant, since a
call is always to a function, right?

I will fix this stuff up and send a v2.

Thanks for looking this over, Matt!

- Alex
