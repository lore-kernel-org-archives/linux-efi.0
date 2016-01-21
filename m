From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v1 2/2] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Thu, 21 Jan 2016 14:05:31 +0000
Message-ID: <20160121140531.GD2510@codeblueprint.co.uk>
References: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1452604386-13673-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAHp75VfNttKVfVMdNO6EGcBiQmL+uY6QUEU1u4FV9Yi=3o=OGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHp75VfNttKVfVMdNO6EGcBiQmL+uY6QUEU1u4FV9Yi=3o=OGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 19 Jan, at 09:32:26AM, Andy Shevchenko wrote:
> On Tue, Jan 12, 2016 at 3:13 PM, Andy Shevchenko
> <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> >
> > Print the base address for each range in decimal alongside the size.
> > Use a "(size @ base)" format similar to the fake_memmap kernel parameter.
> >
> > Print the range and base in the best-fit B, KiB, MiB, etc. units rather than
> > always MiB. This avoids rounding, which can be misleading.
> >
> > Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
> > decimal units (KB, MB, etc.).
> >
> > old:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> >
> > new:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB @ 34 GiB)
> >
> > Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Matt, seems another approach is not in favour, which means we rather
> stick with this one. But see one comment below.
 
Thanks Andy. I like the below patch (with the included space), but as
I said when reviewing Robert's version, I'm really not in favour of
the "@ address" portition of the string.

Andy, could you submit a v2 with the space fix and without the @
<addr> bit?
