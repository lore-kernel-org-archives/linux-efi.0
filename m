From: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH 14/14] x86/efi: Print size in binary units in
 efi_print_memmap
Date: Wed, 3 Feb 2016 15:25:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BF72A9F@G4W3202.americas.hpqcorp.net>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
 <56B0756E.9010603@redhat.com> <20160203104045.GB7310@gmail.com>
 <20160203112829.GC2597@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203112829.GC2597-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> -----Original Message-----
> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> Sent: Wednesday, February 3, 2016 5:28 AM
> To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; H . Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>;
> Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elliott, Robert (Persistent Memory)
> <elliott-ZPxbGqLxI0U@public.gmane.org>; Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>;
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>; Taku Izumi
> <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>; Linus Torvalds <torvalds@linux-
> foundation.org>; Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
> efi_print_memmap
...
> OK, this patch has caused enough headaches. Let's drop it from this
> series.
> 
> Robert, Andy, feel free to resubmit it after you've addressed
> everyone's concerns and we can discuss it in isolation.

We could just delete the size print altogether - better to print
nothing than a silently rounded number.  The end address already
communicates the size - it's just not as readable.  

The e820 table prints don't bother with a size print. 

That would also shorten these extremely wide prints to 116
characters (131 if printk time is enabled).

[    0.000000] BIOS-e820: [mem 0x0000001880000000-0x000000207fffffff] reserved
vs.
[    0.000000] efi: mem62: [Reserved           |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001880000000-0x000000207fffffff] (32 GiB)

---
Robert Elliott, HPE Persistent Memory
