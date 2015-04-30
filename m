From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] efi: dmi: List SMBIOS3 table before SMBIOS table
Date: Thu, 30 Apr 2015 13:09:12 +0200
Message-ID: <1430392152.4445.76.camel@chaos.site>
References: <20150428093012.4c859240@endymion.delvare>
	 <20150430103006.GA3014@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150430103006.GA3014-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

Le Thursday 30 April 2015 =C3=A0 11:30 +0100, Matt Fleming a =C3=A9crit=
 :
> On Tue, 28 Apr, at 09:30:12AM, Jean Delvare wrote:
> > The SMBIOS3 table should appear before the SMBIOS table in
> > /sys/firmware/efi/systab. This allows user-space utilities which
> > support both to pick the SMBIOS3 table with a single pass on system=
s
> > where both are implemented. The SMBIOS3 entry point is more capable
> > than the SMBIOS entry point so it should be preferred.
> >=20
> > This follows the same logic as the ACPI20 table being listed before
> > the ACPI table.
> =20
> Now we need to ask the reverse question: Do any userspace utils use t=
he
> last SMBIOS table entry as the preferred one? I suspect not because
> SMBIOS3 is so new but we need to highlight the risk of breaking
> functionality since this file forms an ABI.

I'd be surprised. Either you stop parsing after the first match, or you
parse the whole file and pick what you prefer. Parsing the whole file
and then arbitrarily choosing the last match wouldn't make much sense.

> Anyone aware of such a tool?

I am not, but then again the only tool I am familiar with which parses
this file is dmidecode. Developers more familiar with EFI-based systems
will know better.

> Also Jean, this patch could do with a new comment describing the
> importance of the table entry order so we don't break it in the futur=
e.

Good idea, thanks for the suggestion. Version 2 of the patch is coming.

>=20
> > Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/firmware/efi/efi.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > --- linux-4.1-rc1.orig/drivers/firmware/efi/efi.c	2015-04-27 02:59:=
10.000000000 +0200
> > +++ linux-4.1-rc1/drivers/firmware/efi/efi.c	2015-04-28 09:19:20.91=
0416344 +0200
> > @@ -85,10 +85,10 @@ static ssize_t systab_show(struct kobjec
> >  		str +=3D sprintf(str, "ACPI20=3D0x%lx\n", efi.acpi20);
> >  	if (efi.acpi !=3D EFI_INVALID_TABLE_ADDR)
> >  		str +=3D sprintf(str, "ACPI=3D0x%lx\n", efi.acpi);
> > -	if (efi.smbios !=3D EFI_INVALID_TABLE_ADDR)
> > -		str +=3D sprintf(str, "SMBIOS=3D0x%lx\n", efi.smbios);
> >  	if (efi.smbios3 !=3D EFI_INVALID_TABLE_ADDR)
> >  		str +=3D sprintf(str, "SMBIOS3=3D0x%lx\n", efi.smbios3);
> > +	if (efi.smbios !=3D EFI_INVALID_TABLE_ADDR)
> > +		str +=3D sprintf(str, "SMBIOS=3D0x%lx\n", efi.smbios);
> >  	if (efi.hcdp !=3D EFI_INVALID_TABLE_ADDR)
> >  		str +=3D sprintf(str, "HCDP=3D0x%lx\n", efi.hcdp);
> >  	if (efi.boot_info !=3D EFI_INVALID_TABLE_ADDR)


--=20
Jean Delvare
SUSE L3 Support
