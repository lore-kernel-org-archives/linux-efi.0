From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Wed, 24 Aug 2016 15:30:13 +0800
Message-ID: <20160824073013.GC13137@dhcp-128-65.nay.redhat.com>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
 <20160815125643.GG30909@codeblueprint.co.uk>
 <20160817054413.GB5498@dhcp-128-65.nay.redhat.com>
 <20160818204130.GQ30909@codeblueprint.co.uk>
 <20160822072841.GB32673@dhcp-128-65.nay.redhat.com>
 <388401471855799@web30j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <388401471855799-X2xH9E7M2qxxpj1cXAZ9Bg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/22/16 at 04:49pm, Icenowy Zheng wrote:
> 
> 
> 22.08.2016, 15:28, "Dave Young" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On 08/18/16 at 09:41pm, Matt Fleming wrote:
> >>  On Wed, 17 Aug, at 01:44:13PM, Dave Young wrote:
> >>  >
> >>  > Could we add some quirk for these broken hardware instead of changing
> >>  > the normal code?
> >>
> >>  I'd prefer not to do that if possible. Due to the way that the BIOS
> >>  ecosystem works, this kind of broken firmware spreads across the
> >>  industry, appearing in newer versions of products from the same vendor
> >>  and even products from different vendors.
> >>
> >>  Continuously updating a quirks table as additional broken platforms
> >>  are discovered simply does not scale.
> >
> > Ok, I assumed that they are limited like one point in the web url
> > http://wiki.osdev.org/Broken_UEFI_implementations
> 
> At least I think all Thinkpads suffer from this.

Icenowy, sorry for late reply, I missed it. I'm not sure other version, but my
T440s does work well.

> 
> >
> > But I arm probably wrong like you said. Please ignore the comment then.
> >

Thanks
Dave
