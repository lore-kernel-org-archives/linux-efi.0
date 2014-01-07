From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
Date: Tue, 07 Jan 2014 18:40:44 +0800
Message-ID: <1389091244.3539.6095.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>
	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>
	 <52CB929C.6050403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <52CB929C.6050403@zytor.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2014-01-06 =E6=96=BC 21:37 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 01/06/2014 12:58 AM, joeyli wrote:
> > =E6=96=BC =E4=BA=8C=EF=BC=8C2013-12-31 =E6=96=BC 16:42 -0800=EF=BC=8C=
H. Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> >> On 12/19/2013 09:41 PM, joeyli wrote:
> >>>>
> >>>> What platform do you have that has TAD support?  I am wondering =
how this
> >>>> was tested.
> >>>>
> >>>
> >>> It's a testing platform that's only support get/set time function=
s of
> >>> ACPI TAD.
> >>>
> >>
> >> It would be really, really good to get this into Qemu (either SeaB=
IOS or
> >> OVMF, or ideally both) so we can have anyone test.
> >>
> >> 	-hpa
> >=20
> > I will try to add to OVMF first.
> >=20
>=20
> For the record, I posted a patch to Qemu about a year ago to store th=
e
> timezone in the CMOS, which might be useful for this implementation. =
 It
> was rejected because of no firmware support, so if you implement it f=
or
> OVMF we can (update and) push this patch again.
>=20
> 	-hpa
>=20

Thanks for your patch.=20

Due to accessing CMOS through ASL need enable SMM support in OVMF, I am
looking Laszlo's OVMF S3 patches:

https://www.mail-archive.com/edk2-devel@lists.sourceforge.net/msg04969.=
html

Honestly I am not good on this area, I need to spend more time to
understand it.


Regards
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
