From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Wed, 25 Oct 2017 15:46:26 +0100
Message-ID: <20171025144625.5f5me7mpuv4uo7nt@salmiak>
References: <20171002091246.28432-1-jslaby@suse.cz>
 <20171002091246.28432-19-jslaby@suse.cz>
 <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com>
 <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
 <CAKv+Gu-7q_Pr5SoUY_kUstaVusUxvXt9e8xeChQySGZ6h+jdAg@mail.gmail.com>
 <9dfcee94-2058-8986-526c-f7ef9ebada66@suse.cz>
 <20171006132121.GC14023@leverpostej>
 <a506fc39-80d3-56da-a87f-b5e4bef8bad5@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a506fc39-80d3-56da-a87f-b5e4bef8bad5-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 25, 2017 at 04:21:48PM +0200, Jiri Slaby wrote:
> Hi,
> 
> On 10/06/2017, 03:21 PM, Mark Rutland wrote:
> > If the aim of this series is to introduce something that architectures
> > use consistently, then can we please actually poke other architectures
> > about it? e.g. send this to linux-arch, with a cover letter explaining
> > the idea and asking maintainers to take a look.
> 
> Sure, with v5, I will.

Thanks; that's much appreciated, and I look forward to it!

Mark.
