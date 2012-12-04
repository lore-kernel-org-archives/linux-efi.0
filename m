From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: Random boot fail on 'cannot allocate trampoline' on Intel
 DQ57TM board with B.11 BIOS
Date: Tue, 04 Dec 2012 18:08:40 +0800
Message-ID: <1354615720.21227.1416.camel@linux-s257.site>
References: <1346212111.6836.355.camel@linux-s257.site>
	 <50464BD6.6080106@zytor.com> <1354591095.21227.1355.camel@linux-s257.site>
	 <50BD6E90.5040400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50BD6E90.5040400-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2012-12-03 =E6=96=BC 19:31 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/03/2012 07:18 PM, joeyli wrote:
> > =E6=96=BC =E4=BA=8C=EF=BC=8C2012-09-04 =E6=96=BC 11:43 -0700=EF=BC=8C=
H. Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> >> On 08/28/2012 08:48 PM, joeyli wrote:
> >>> Hi all experts,
> >>>
> >>> I tried the EFI_STUB on v3.6-rc1 kernel on Intel DQ57TM board wit=
h B.11
> >>> BIOS that's the only one sample board on my hand. I found it can'=
t boot
> >>> success most time, fail rate is about 80% (run 6 times only 1 tim=
e boot
> >>> success).
> >>> When issue reproduced, kernel emit a panic message like through s=
erial
> >>> console like the following:
> >>>
> >>
> >> This is odd... there is plenty of low memory which should have bee=
n
> >> available for the trampoline.  The ACPI errors is another issue, o=
f
> >> course...
> >>
> >> 	-hpa
> >>
> >
> > I moved all memory modules (have 2 in this machine) to channel A, t=
hen I
> > didn't reproduce this issue anymore.
> >
> > Just add this information for note to DQ57TM users.
> >
>=20
> That will hurt your performance.

Yes, but it's better then I face to 80% boot fail.

>=20
> You list your BIOS version as "B.11" but that's not the typical=20
> nomenclature for BIOS on this board; the current BIOS version is 0050=
=20
> with the full version string being TMIBX10H.86A.0050.2011.1207.1134.
>=20
> I'm wondering if you may need a BIOS update.  Also, are you booting i=
n=20
> EFI mode or BIOS mode?
>=20
> 	-hpa
>=20
>=20

My BIOS was downloaded from:

UEFI Driver and Application Tool Resources - Intel
http://www.intel.com/content/www/us/en/architecture-and-technology/unif=
ied-extensible-firmware-interface/uefi-driver-and-application-tool-reso=
urces.html

Intel DQ57TM is still the official development board for UEFI, and B.11
is the newest BIOS version. I need update to B.11 for test secure boot
stuff:

SDV.TM.B11: Intel=C2=AE DQ57TM UEFI 2.3.1 Development Kit BIOS Release =
(July 2012)   <=3D=3D=3D newest version
SDV.TM.B10: Intel=C2=AE DQ57TM UEFI 2.3.1 Development Kit BIOS Release =
(May 2012)

In BIOS menu and dmidecode show up the same version string:

Handle 0x0004, DMI type 0, 24 bytes
BIOS Information
        Vendor: Intel Corp.
        Version: Build SDV.TM.B11 Release (CSM Available)

But, as your remind, this issue related to BIOS, I didn't see this prob=
lem before update to B.11.


Thanks a lot!
Joey Lee
