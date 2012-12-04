From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: Random boot fail on 'cannot allocate trampoline' on Intel
 DQ57TM board with B.11 BIOS
Date: Tue, 04 Dec 2012 11:18:15 +0800
Message-ID: <1354591095.21227.1355.camel@linux-s257.site>
References: <1346212111.6836.355.camel@linux-s257.site>
	 <50464BD6.6080106@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50464BD6.6080106-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2012-09-04 =E6=96=BC 11:43 -0700=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 08/28/2012 08:48 PM, joeyli wrote:
> > Hi all experts,=20
> >=20
> > I tried the EFI_STUB on v3.6-rc1 kernel on Intel DQ57TM board with =
B.11
> > BIOS that's the only one sample board on my hand. I found it can't =
boot
> > success most time, fail rate is about 80% (run 6 times only 1 time =
boot
> > success).
> > When issue reproduced, kernel emit a panic message like through ser=
ial
> > console like the following:
> >=20
>=20
> This is odd... there is plenty of low memory which should have been
> available for the trampoline.  The ACPI errors is another issue, of
> course...
>=20
> 	-hpa
>=20

I moved all memory modules (have 2 in this machine) to channel A, then =
I
didn't reproduce this issue anymore.=20

Just add this information for note to DQ57TM users.


Thanks a lot!
Joey Lee
