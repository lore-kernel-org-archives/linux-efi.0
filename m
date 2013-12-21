From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Sat, 21 Dec 2013 10:43:25 +0800
Message-ID: <1387593805.3539.4983.camel@linux-s257.site>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <1387517916.3539.4446.camel@linux-s257.site> <52B4B242.5010002@zytor.com>
	 <2787644.ytU7M33B4r@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2787644.ytU7M33B4r-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2013-12-20 =E6=96=BC 22:45 +0100=EF=BC=8CRa=
fael J. Wysocki =E6=8F=90=E5=88=B0=EF=BC=9A
> On Friday, December 20, 2013 01:10:26 PM H. Peter Anvin wrote:
> > On 12/19/2013 09:38 PM, joeyli wrote:
> > >=20
> > > If don't use EFI time, then the first priority is using ACPI TAD =
if it
> > > present. Due to ACPI TAD is a generic acpi device that's need OS =
parsing
> > > DSDT table before set system time.
> > >=20
> > > Either move DSDT parser from subsystem initial stage to start_ker=
nel or
> > > move timekeeping initial to after DSDT be parsed. Which one you t=
hink is
> > > more possible and risk less? Then I will try that way.
> > >=20
> >=20
> > I discussed the DSDT/SSDT parsing issue with Rafael and he claims i=
t
> > would require a lot of restructuring.  Unfortunately ACPI is at thi=
s
> > point done rather late, as I understand.  All of this is a big prob=
lem.
>=20
> My understanding, however, is that to use the TAD, we don't actually =
need to
> create a struct acpi_device for it.  We just need a handle to the ACP=
ICA
> object which can be found using acpi_get_devices() as soon as the nam=
espace
> has been extracted from the DSDT and friends.  That in turn happens i=
n
> acpi_early_init(), which is called from start_kernel() right before
> efi_late_init().
>=20
> Is that early enough?
>=20
> Rafael
>=20

Thanks for your good suggestion, then I have a direction on using ACPI
TAD earlier.

Joey Lee
