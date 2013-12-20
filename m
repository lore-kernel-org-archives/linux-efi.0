From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 03/14] rtc: block registration of rtc-cmos when CMOS
 RTC Not Present
Date: Fri, 20 Dec 2013 11:54:10 +0800
Message-ID: <1387511650.3539.4294.camel@linux-s257.site>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <1387439053-8711-4-git-send-email-jlee@suse.com>
	 <6fc9a2f9-eae7-4588-a092-f338053ec96a@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6fc9a2f9-eae7-4588-a092-f338053ec96a-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi hpa,=20

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 06:38 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> Where did you find a platform with "no CMOS" set and a PNP RTC? I fin=
d the expect behavior in that case to be quite ambiguous and it is not =
at all clear to me that what you have here is the right thing.

Actually there doesn't have the box both with "No CMOS" and PNP device.=
=20
I choice to totally block rtc-cmos driver when "No CMOS RTC" because th=
e
definition in ACPI spec:

CMOS RTC Not Present

If set, indicates that the CMOS RTC is either not implemented, or
does not exist at the legacy addresses. OSPM uses the Control
Method Time and Alarm Namespace device instead.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


It suggest us using ACPI TAD interface when this flag present. But, I
agreed your point for this is ambiguous due to ACPI spec didn't clear
define the relationship between PNP0B0x.

Maybe we can do more detail check in cmos_init when "No CMOS RTC" set:
 + check if have ACPI TAD device, then block rtc-cmos
 + check if no ACPI TAD device, but have PNP0B0x, then we use PNP0b0x.

>=20
> "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >We should not acess CMOS address when CMOS RTC Not Present bit set i=
n
> >FADT. The ee5872be patch didn't avoid rtc-cmos driver loaded when
> >system support
> >ACPI PNP PNP0B0* devices.
> >So this patch block the registion of rtc-cmos driver to avoid
> >user space access RTC through CMOS interface.
> >
> >Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> >---
> > arch/x86/kernel/rtc.c  |   20 ++++++++++++++++----
> > drivers/rtc/rtc-cmos.c |    9 +++++++++
> > 2 files changed, 25 insertions(+), 4 deletions(-)
> >
=2E..
> >--- a/drivers/rtc/rtc-cmos.c
> >+++ b/drivers/rtc/rtc-cmos.c
> >@@ -28,6 +28,9 @@
> >  * interrupts disabled, holding the global rtc_lock, to exclude tho=
se
> >  * other drivers and utilities on correctly configured systems.
> >  */
> >+
> >+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >+
> > #include <linux/kernel.h>
> > #include <linux/module.h>
> > #include <linux/init.h>
> >@@ -1144,6 +1147,12 @@ static int __init cmos_init(void)
> > {
> > 	int retval =3D 0;
> >=20
> >+	if (acpi_gbl_FADT.header.revision >=3D 5 &&
> >+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
> >+		pr_info("ACPI CMOS RTC Not Present detected - not loading\n");
> >+		return 0;
> >+	}
> >+
> > #ifdef	CONFIG_PNP
> > 	retval =3D pnp_register_driver(&cmos_pnp_driver);
> > 	if (retval =3D=3D 0)
>=20

Thanks a lot!
Joey Lee
