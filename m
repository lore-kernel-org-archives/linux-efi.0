From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
Date: Thu, 09 Jan 2014 13:16:21 +0100
Message-ID: <2612691.m9rj3jIJ1M@vostro.rjw.lan>
References: <1387439515-8926-1-git-send-email-jlee@suse.com> <52CD9139.2070302@zytor.com> <1389239259.24105.2.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1389239259.24105.2.camel@linux-s257.site>
Sender: linux-acpi-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thursday, January 09, 2014 11:47:39 AM joeyli wrote:
> =E6=96=BC =E4=B8=89=EF=BC=8C2014-01-08 =E6=96=BC 09:56 -0800=EF=BC=8C=
H. Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> [...]
> > > Document of Windows XP:
> > >
> > http://www.freelists.org/post/windows_errors/what-error-messages-re=
ally-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP
> > >=20
> > > If just for ACPI TAD testing, we can remove the port protection
> > check of
> > > RTC ports in hwvalid.c. I have read 0x70/0x71 port success after
> > removed
> > > the checking in acpica/hwvalid.c.
> > >=20
> > > I will try to write RTC port in AML after remove acpica check, ma=
ybe
> > > have other unpredictable situation.
> > >=20
> >=20
> > Now *THERE* is a good use of the "no RTC bit".  In the case that bi=
t
> > is
> > set we should presumably remove these ports from the block list.
>=20
> Thanks for your suggestion, I will put a testing patch on this.
>=20
> >=20
> > Otherwise we should use the CMOS address space, not the I/O port
> > address
> > space.
> >=20
> >         -hpa=20
>=20
> Unfortunately current acpica leaks the SystemCMOS handler:
>=20
> ACPI Error: Region SystemCMOS (ID=3D5) has no handler (20131115/exfld=
io-299)

This is not an ACPICA problem.  We have no CMOS address space handler i=
n Linux
and arguably there should be one.  So I'd suggest implementing that to =
start
with or we risk conflicts between kernel code and AML accessing registe=
rs in
that space.

Thanks!

--=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
