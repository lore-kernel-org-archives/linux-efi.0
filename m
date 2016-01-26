From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Tue, 26 Jan 2016 13:59:26 +0200
Message-ID: <1453809566.2521.239.camel@linux.intel.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453567445.2470.24.camel@HansenPartnership.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295BF3B840@G9W0745.americas.hpqcorp.net>
	 <1453748172.2363.36.camel@HansenPartnership.com>
	 <CAHp75VdYRzC9TcDpKxq=xddA0zgVk=5_25uXaimn1tOMZVeK4Q@mail.gmail.com>
	 <1453751131.2363.54.camel@HansenPartnership.com>
	 <CAHp75VeXHoyOgFSb4vzWBmELH_yJx1mSN+quxue=tSZCh5sTXw@mail.gmail.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295BF3BBD3@G9W0745.americas.hpqcorp.net>
	 <20160126115041.GA7478@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160126115041.GA7478-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-01-26 at 11:50 +0000, Matt Fleming wrote:
> On Mon, 25 Jan, at 08:37:58PM, Elliott, Robert (Persistent Memory)
> wrote:
> >=20
> > For the UEFI memory map, that was indeed my intention.=C2=A0=C2=A0I
> > don't want it silently round to "20 GiB".=C2=A0=C2=A0Even rounding
> > to "19.999 GiB" is imprecise.
>=20
> OK, let's just go with your original patch Robert (minus the @ addr
> bit) since it's pretty small and does what we want for this specific
> case.

However I am against this, but seems reviewers do not leave a chance to
us, I would propose to copy-and-paste table of binary prefixes and use
__ffs64().

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
