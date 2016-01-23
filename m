From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Sat, 23 Jan 2016 10:03:11 -0800
Message-ID: <1453572191.2470.52.camel@HansenPartnership.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453567445.2470.24.camel@HansenPartnership.com>
	 <CAHp75Vdc9=uotvaf4pQfRoViyWuEXhXjZH7GVWEG79AquPVi5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHp75Vdc9=uotvaf4pQfRoViyWuEXhXjZH7GVWEG79AquPVi5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2016-01-23 at 19:18 +0200, Andy Shevchenko wrote:
> On Sat, Jan 23, 2016 at 6:44 PM, James Bottomley
> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > On Sat, 2016-01-23 at 16:55 +0200, Andy Shevchenko wrote:
> 
> > > +static char * __init efi_size_format(char *buf, size_t size, u64
> > > bytes)
> > > +{
> > > +     unsigned long i = bytes ? __ffs64(bytes) / 10 : 0;
> > 
> > What if size is zero, which might happen on a UEFI screw up?
> 
> size of what? Of input buffer?

I mean when bytes == 0 ffs is undefined.

> >  Also it gives really odd results for non power of two memory 
> > sizes. 16384MB prints as 16GiB but 16385 prints as 16385MiB.
> 
> Adaptive precision. I don't think the idea is to print a nearby
> numbers here.

Well either there's a point to reducing to the nearest exponent or we
simply print everything in MB as the original did.  Doing it
inconsistently is asking for trouble ... and lots of user queries.  I
mean, supposing there's a range off by one ... now we print a huge
number in B.

I really advise against hacking around like this.  In any event if efi
must have this, please don't involve the parts of the kernel that try
to do this correctly, like lib/string_helpers.h

> > If the goal is to have a clean interface reporting only the first 
> > four significant figures and a size exponent, then a helper would 
> > be much better than trying to open code this ad hoc.
> 
> No. You get it wrong. The initial idea was (actually not mine, see
> authorship) to print an exact number with units and reduce whenever
> it's possible, i.e number is a multiplication of certain unit.

so you must implement the original idea no matter how inconsistent it
leads us to be?  Is it wrong to try to do better?

James
