From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in efi_print_memmap
Date: Mon, 25 Jan 2016 21:28:37 +0200
Message-ID: <CAHp75VdYRzC9TcDpKxq=xddA0zgVk=5_25uXaimn1tOMZVeK4Q@mail.gmail.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453567445.2470.24.camel@HansenPartnership.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BF3B840@G9W0745.americas.hpqcorp.net>
	<1453748172.2363.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453748172.2363.36.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 25, 2016 at 8:56 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Mon, 2016-01-25 at 18:02 +0000, Elliott, Robert (Persistent Memory)
> wrote:

>  Using ffs leads to precision runaway

How exactly?!

> and
> exporting an array from string_helpers.c is simply the wrong way to do
> it.

This part I didn't object.

> Since we've now spent more time arguing about this than it would take
> to do a correct patch, this is what I was thinking.  It extracts the
> precision reduction core from string_helpers.c and exposes it to all
> users who want to convert to units.  I added a nozeros option becuase I
> think you want it to print 1 GiB rather than 1.00 GiB for exact powers
> of two.  (OK, and I fixed a bug where it will report small amounts as
> 1.00 B instead of whole number of bytes).  Absent the nozero option,
> you could simply have used string_get_size(), with a block size of 1.

It's good you are doing this better, but I still vote for __ffs64(),
since it would be faster on binary units.

Also, in one version I tried to convert couple of other users which
are using only KM (in general whatever range it would be) units. Any
ideas how to modify to support them?

-- 
With Best Regards,
Andy Shevchenko
