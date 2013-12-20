From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 03/14] rtc: block registration of rtc-cmos when CMOS RTC
 Not Present
Date: Thu, 19 Dec 2013 20:20:54 -0800
Message-ID: <52B3C5A6.3070805@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <1387439053-8711-4-git-send-email-jlee@suse.com>	 <6fc9a2f9-eae7-4588-a092-f338053ec96a@email.android.com> <1387511650.3539.4294.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1387511650.3539.4294.camel@linux-s257.site>
Sender: linux-acpi-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 12/19/2013 07:54 PM, joeyli wrote:
> Hi hpa,=20
>=20
> =E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 06:38 -0800=EF=BC=8C=
H. Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
>> Where did you find a platform with "no CMOS" set and a PNP RTC? I fi=
nd the expect behavior in that case to be quite ambiguous and it is not=
 at all clear to me that what you have here is the right thing.
>=20
> Actually there doesn't have the box both with "No CMOS" and PNP devic=
e.=20
> I choice to totally block rtc-cmos driver when "No CMOS RTC" because =
the
> definition in ACPI spec:
>=20
> CMOS RTC Not Present
>=20
> If set, indicates that the CMOS RTC is either not implemented, or
> does not exist at the legacy addresses. OSPM uses the Control
> Method Time and Alarm Namespace device instead.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> It suggest us using ACPI TAD interface when this flag present. But, I
> agreed your point for this is ambiguous due to ACPI spec didn't clear
> define the relationship between PNP0B0x.
>=20
> Maybe we can do more detail check in cmos_init when "No CMOS RTC" set=
:
>  + check if have ACPI TAD device, then block rtc-cmos
>  + check if no ACPI TAD device, but have PNP0B0x, then we use PNP0b0x=
=2E
>=20

I think the only thing we should use that bit for is to inhibit the
last-resort probing of I/O ports 0x70-0x73... if at all.

	-hpa


--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
