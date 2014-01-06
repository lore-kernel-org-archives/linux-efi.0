From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
Date: Mon, 06 Jan 2014 17:20:53 +0800
Message-ID: <1389000053.3539.6078.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <CAOLK0pynyv2CjA-Jb-0cUMkdnXY8KD2QForsk5ygM1mrRtXOyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAOLK0pynyv2CjA-Jb-0cUMkdnXY8KD2QForsk5ygM1mrRtXOyg@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2014-01-02 =E6=96=BC 16:09 +0800=EF=BC=8CLa=
n Tianyu =E6=8F=90=E5=88=B0=EF=BC=9A
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index bba9b72..3f7a075 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -689,6 +689,9 @@ static int __init acpi_init(void)
> >         pci_mmcfg_late_init();
> >         acpi_scan_init();
> >         acpi_ec_init();
> > +#ifdef CONFIG_X86
> > +       acpi_tad_init();
> > +#endif
>=20
> Why calling acpi_tad_init() directly here rather than using
> module_initcall?
> Is there dependency?
>=20

The rtc-acpitad RTC driver depend on acpi_read/set_time functions in
acpi_tad.

On the other hand, if we adapt to ACPI time device when "CMOS RTC Not
Present" set, then acpi_read/set_time will used to replace CMOS
functions that's called by other drivers. So, I direct call
acpi_tad_init() here.


Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
