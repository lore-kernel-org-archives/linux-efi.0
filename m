From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Mon, 25 Jan 2016 10:31:53 +0200
Message-ID: <1453710713.2521.200.camel@linux.intel.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453567445.2470.24.camel@HansenPartnership.com>
	 <CAHp75Vdc9=uotvaf4pQfRoViyWuEXhXjZH7GVWEG79AquPVi5A@mail.gmail.com>
	 <1453572191.2470.52.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453572191.2470.52.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2016-01-23 at 10:03 -0800, James Bottomley wrote:
> On Sat, 2016-01-23 at 19:18 +0200, Andy Shevchenko wrote:
> > On Sat, Jan 23, 2016 at 6:44 PM, James Bottomley
> > <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > > On Sat, 2016-01-23 at 16:55 +0200, Andy Shevchenko wrote:
> >=20
> > > > +static char * __init efi_size_format(char *buf, size_t size,
> > > > u64
> > > > bytes)
> > > > +{
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long i =3D bytes ? __ff=
s64(bytes) / 10 : 0;
> > >=20
> > > What if size is zero, which might happen on a UEFI screw up?
> >=20
> > size of what? Of input buffer?
>=20
> I mean when bytes =3D=3D 0 ffs is undefined.

Well, someone misread the above code ;-)

There is ternary operator exactly to serve this purpose.

>=20
> > > =C2=A0Also it gives really odd results for non power of two memor=
y=C2=A0
> > > sizes. 16384MB prints as 16GiB but 16385 prints as 16385MiB.
> >=20
> > Adaptive precision. I don't think the idea is to print a nearby
> > numbers here.
>=20
> Well either there's a point to reducing to the nearest exponent or we
> simply print everything in MB as the original did.=C2=A0=C2=A0Doing i=
t
> inconsistently is asking for trouble ... and lots of user queries.=C2=
=A0=C2=A0I
> mean, supposing there's a range off by one ... now we print a huge
> number in B.

> I really advise against hacking around like this.=C2=A0=C2=A0In any e=
vent if
> efi
> must have this, please don't involve the parts of the kernel that try
> to do this correctly, like lib/string_helpers.h

>=20
> > > If the goal is to have a clean interface reporting only the
> > > first=C2=A0
> > > four significant figures and a size exponent, then a helper
> > > would=C2=A0
> > > be much better than trying to open code this ad hoc.
> >=20
> > No. You get it wrong. The initial idea was (actually not mine, see
> > authorship) to print an exact number with units and reduce whenever
> > it's possible, i.e number is a multiplication of certain unit.
>=20
> so you must implement the original idea no matter how inconsistent it
> leads us to be?=C2=A0=C2=A0Is it wrong to try to do better?

=46or both comments I prefer to hear Matt's opinion as he is maintainer
of EFI stuff.

My role in this all is to reduce the code base by avoiding 'not
invented here' syndrome.

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
