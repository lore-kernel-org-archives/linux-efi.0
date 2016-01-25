From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Mon, 25 Jan 2016 07:25:34 -0800
Message-ID: <1453735534.2363.7.camel@HansenPartnership.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453567445.2470.24.camel@HansenPartnership.com>
	 <CAHp75Vdc9=uotvaf4pQfRoViyWuEXhXjZH7GVWEG79AquPVi5A@mail.gmail.com>
	 <1453572191.2470.52.camel@HansenPartnership.com>
	 <1453710713.2521.200.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453710713.2521.200.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-01-25 at 10:31 +0200, Andy Shevchenko wrote:
> On Sat, 2016-01-23 at 10:03 -0800, James Bottomley wrote:
> > On Sat, 2016-01-23 at 19:18 +0200, Andy Shevchenko wrote:
> > > > If the goal is to have a clean interface reporting only the
> > > > first 
> > > > four significant figures and a size exponent, then a helper
> > > > would 
> > > > be much better than trying to open code this ad hoc.
> > > 
> > > No. You get it wrong. The initial idea was (actually not mine,
> > > see
> > > authorship) to print an exact number with units and reduce
> > > whenever
> > > it's possible, i.e number is a multiplication of certain unit.
> > 
> > so you must implement the original idea no matter how inconsistent
> > it
> > leads us to be?  Is it wrong to try to do better?
> 
> For both comments I prefer to hear Matt's opinion as he is maintainer
> of EFI stuff.
> 
> My role in this all is to reduce the code base by avoiding 'not
> invented here' syndrome.

To get up to the starting blocks on that one, you need a usable
interface.  Neither of the series has that for lib/string_helper.c, so
this is a NAK to both of those parts.

I already told you how to do it in a way that creates a maintainable
interface.  It looks obvious to me and I was politely waiting for you
to produce it, but if you're saying your not able to, I suppose I can
produce the patch.

James
