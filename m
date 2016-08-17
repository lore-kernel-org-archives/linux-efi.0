From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Wed, 17 Aug 2016 13:44:13 +0800
Message-ID: <20160817054413.GB5498@dhcp-128-65.nay.redhat.com>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
 <20160815125643.GG30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160815125643.GG30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/15/16 at 01:56pm, Matt Fleming wrote:
> On Tue, 09 Aug, at 01:25:46PM, Icenowy Zheng wrote:
> > Some broken firmwares have a wrongly filled version field in BGRT table.
> > (See http://wiki.osdev.org/Broken_UEFI_implementations )
> > 
> > As we know, these firmwares can also provide correct BGRT image, although
> > the table is wrong.
> > 
> > After removing the check of the version field, the kernel can now extract
> > the image correctly, and the information is also correct.
> > 
> > Tested on a Thinkpad E531 (68854UC).
> > 
> > Signed-off-by: Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi-bgrt.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> > index 6a2f569..f492ea0 100644
> > --- a/arch/x86/platform/efi/efi-bgrt.c
> > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > @@ -47,11 +47,6 @@ void __init efi_bgrt_init(void)
> >  		       bgrt_tab->header.length, sizeof(*bgrt_tab));
> >  		return;
> >  	}
> > -	if (bgrt_tab->version != 1) {
> > -		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
> > -		       bgrt_tab->version);
> > -		return;
> > -	}
> >  	if (bgrt_tab->status & 0xfe) {
> >  		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
> >  		       bgrt_tab->status);
> 
> This would be less scary if we checked for known broken and known good
> version values instead of removing the check altogether, i.e. 0 and 1.

Could we add some quirk for these broken hardware instead of changing
the normal code?

> 
> The whole point of the version field is that it tells us about the
> layout of the BGRT table, so it's not exactly a useless check.

Agreed.

Thanks
Dave
