From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: BGRT warns again on my system
Date: Sun, 19 Jun 2016 07:38:40 -0700
Message-ID: <20160619143840.GA18605@x>
References: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
 <20160528222531.GA10687@x>
 <574A6B5D.60200@moshe.nl>
 <20160602092438.GD2658@codeblueprint.co.uk>
 <57669AC0.7010905@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57669AC0.7010905-A/3C56C7qwM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Jun 19, 2016 at 03:14:40PM +0200, M=F4she van der Sterre wrote:
> On 06/02/2016 11:24 AM, Matt Fleming wrote:
> > On Sun, 29 May, at 06:09:01AM, M=F4she van der Sterre wrote:
> > > ---
> > >   arch/x86/platform/efi/efi-bgrt.c | 7 +++++++
> > >   1 file changed, 7 insertions(+)
> > >=20
> > > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform=
/efi/efi-bgrt.c
> > > index 6a2f569..a7fdb61 100644
> > > --- a/arch/x86/platform/efi/efi-bgrt.c
> > > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > > @@ -19,6 +19,8 @@
> > >   #include <linux/efi.h>
> > >   #include <linux/efi-bgrt.h>
> > > +#include "../../mm/physaddr.h"
> > > +
> > >   struct acpi_table_bgrt *bgrt_tab;
> > >   void *__initdata bgrt_image;
> > >   size_t __initdata bgrt_image_size;
> > > @@ -67,6 +69,11 @@ void __init efi_bgrt_init(void)
> > >   		return;
> > >   	}
> > > +	if (!phys_addr_valid(bgrt_tab->image_address)) {
> > > +		pr_notice("Ignoring BGRT: image address is bogus\n");
> > > +		return;
> > > +	}
> > > +
> > >   	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header)=
, MEMREMAP_WB);
> > >   	if (!image) {
> > >   		pr_notice("Ignoring BGRT: failed to map image header memory\n=
");
> > > --=20
> > > 2.4.3
> > >=20
> > If this does indeed fix Andy's immediate issue (and it looks like
> > it would) I'm happy to apply this as an interim solution.
> I have tested that this does indeed fix the warning for Andy's value =
of
> ->image_address, but off course I can't test this with the actual har=
dware
> that Andy has. Do you want me to resend this with a commit message so=
 it can
> be applied?

With a commit message and a clearer pr_notice than "is bogus", yes. How
about "image address not a valid physical memory address"?
