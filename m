From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BGRT warns again on my system
Date: Mon, 20 Jun 2016 13:38:19 +0800
Message-ID: <20160620053819.GB13633@dhcp-128-65.nay.redhat.com>
References: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
 <20160528222531.GA10687@x>
 <574A6B5D.60200@moshe.nl>
 <20160602092438.GD2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602092438.GD2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/02/16 at 10:24am, Matt Fleming wrote:
> On Sun, 29 May, at 06:09:01AM, M=F4she van der Sterre wrote:
> > ---
> >  arch/x86/platform/efi/efi-bgrt.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/e=
fi/efi-bgrt.c
> > index 6a2f569..a7fdb61 100644
> > --- a/arch/x86/platform/efi/efi-bgrt.c
> > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > @@ -19,6 +19,8 @@
> >  #include <linux/efi.h>
> >  #include <linux/efi-bgrt.h>
> > =20
> > +#include "../../mm/physaddr.h"
> > +
> >  struct acpi_table_bgrt *bgrt_tab;
> >  void *__initdata bgrt_image;
> >  size_t __initdata bgrt_image_size;
> > @@ -67,6 +69,11 @@ void __init efi_bgrt_init(void)
> >  		return;
> >  	}
> > =20
> > +	if (!phys_addr_valid(bgrt_tab->image_address)) {
> > +		pr_notice("Ignoring BGRT: image address is bogus\n");
> > +		return;
> > +	}
> > +
> >  	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), M=
EMREMAP_WB);
> >  	if (!image) {
> >  		pr_notice("Ignoring BGRT: failed to map image header memory\n");
> > --=20
> > 2.4.3
> >=20
>=20
> If this does indeed fix Andy's immediate issue (and it looks like
> it would) I'm happy to apply this as an interim solution.
>=20
> Once we have a persistent EFI memmap available at runtime on x86 we
> should attempt to see whether the physical address in ->image_address
> is covered by some region in that table. The persistent EFI memmap
> patches should be posted in the coming weeks.

I may missed the background but I worry about who knows if it is meant
to be used for BGRT image. Some vendors could respect the BGRT valid
bit and just leave the address as a random address. And the random
address could be a valid physical address though. It is possible to
leak memory infomation.=20

Could we reconsider about below commit? It may be a Windows 10 bug?

commit 66dbe99cfe30e113d2e571e68b9b6a1a8985a157
Author: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Date:   Mon Feb 1 22:07:03 2016 +0000

    x86/efi/bgrt: Don't ignore the BGRT if the 'valid' bit is 0

Thanks
Dave
