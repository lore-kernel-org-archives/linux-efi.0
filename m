From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Mon, 22 Aug 2016 15:28:41 +0800
Message-ID: <20160822072841.GB32673@dhcp-128-65.nay.redhat.com>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
 <20160815125643.GG30909@codeblueprint.co.uk>
 <20160817054413.GB5498@dhcp-128-65.nay.redhat.com>
 <20160818204130.GQ30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160818204130.GQ30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/18/16 at 09:41pm, Matt Fleming wrote:
> On Wed, 17 Aug, at 01:44:13PM, Dave Young wrote:
> > 
> > Could we add some quirk for these broken hardware instead of changing
> > the normal code?
> 
> I'd prefer not to do that if possible. Due to the way that the BIOS
> ecosystem works, this kind of broken firmware spreads across the
> industry, appearing in newer versions of products from the same vendor
> and even products from different vendors.
> 
> Continuously updating a quirks table as additional broken platforms
> are discovered simply does not scale.

Ok, I assumed that they are limited like one point in the web url
http://wiki.osdev.org/Broken_UEFI_implementations 

But I arm probably wrong like you said. Please ignore the comment then.

Thanks
Dave
