From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Sat, 23 Jan 2016 10:12:55 -0800
Message-ID: <1453572775.2470.56.camel@HansenPartnership.com>
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
> > Not an attack on you patch per-se, but I really hate the IEC
> > convention
> > that was essentially a ploy by disk manufacturers to inflate their
> > disk
> > sizes by 10% simply by relabelling them.
> 
> >  Everyone was happy when a GB was 2^30,
> 
> No, not everyone. It was a misspelling done by some first storage
> producer.

No, it was the adopted convention in computer science to use units in
2^10 since all sizes were usually binary.  It actually began with
memory sizes.  So a GB never meant 10^9 bytes before 2007 because the
classical unit users had no idea what a byte was.  The first bytes were
counted in powers of 2.

>  Try to look at the problem from physics point of view. Units
> are essential part of a value. There is an agreement how to use
> multipliers and their code names. 1000 x Unit means kiloUnit. As per
> agreement.

It's not about physics (and certainly astronomers, who often take pi to
be 1 would be happy with 2^10 = 10^3) it's about politics: disk
manufacturers wanted a way to report bigger sizes, so they made a huge
fuss about the "inconsistency" of computer science using units in
increments of 2^10 and forced through this IEC standard.

> > now everyone's simply confused whenever they see GB.  We had
> > to pander to this in block devices because people got annoyed when 
> > we reported a size that was different from the label but are you 
> > sure we have to extend the madness to memory?
> 
> I actually don't know who is from us is being more conservative. I
> could call a madness to mess things from ancient (classical
> mathematics and physics) with something which has less than hundred
> years in development.

In engineering terms, counting in powers of 2 makes a lot of sense for
quantites using binary address busses and the IEC even recognised that
by inventing a new unit for it.  Having GB mean 2^30 up to 2007 and
10^9 after it is confusing for everyone born before about 1990.

James
