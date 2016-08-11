From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Thu, 11 Aug 2016 10:48:44 +0200
Message-ID: <20160811084844.GA4343@gmail.com>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
 <20160810125201.GA9028@gmail.com>
 <120791470839405@web16h.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <120791470839405-TUpq1W2QCG9xpj1cXAZ9Bg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org> wrote:

> 
> 
> 10.08.2016, 20:52, "Ingo Molnar" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > * Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org> wrote:
> >
> >>  Some broken firmwares have a wrongly filled version field in BGRT table.
> >>  (See http://wiki.osdev.org/Broken_UEFI_implementations )
> >>
> >>  As we know, these firmwares can also provide correct BGRT image, although
> >>  the table is wrong.
> >>
> >>  After removing the check of the version field, the kernel can now extract
> >>  the image correctly, and the information is also correct.
> >>
> >>  Tested on a Thinkpad E531 (68854UC).
> >
> > What's the practical effects of the bug - what problems does a missing
> > /sys/firmware/acpi/bgrt/ cause?
> 
> Currently nothing uses this featues. However, one of my friend is trying to
> develop a splash screen which uses ACPI BGRT, like the splash screen
> of Windows 8 and above.
> Without the directory, there won't be any way to retrieve the vendor splash
> logo.

Ok - please add this information to the changelog.

Acked-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,

	Ingo
