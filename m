From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
Date: Thu, 09 Jan 2014 11:47:39 +0800
Message-ID: <1389239259.24105.2.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>
	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>
	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>
	 <52CC2CDF.3000100@zytor.com> <1389193142.3539.6123.camel@linux-s257.site>
	 <52CD9139.2070302@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52CD9139.2070302-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2014-01-08 =E6=96=BC 09:56 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
[...]
> > Document of Windows XP:
> >
> http://www.freelists.org/post/windows_errors/what-error-messages-real=
ly-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP
> >=20
> > If just for ACPI TAD testing, we can remove the port protection
> check of
> > RTC ports in hwvalid.c. I have read 0x70/0x71 port success after
> removed
> > the checking in acpica/hwvalid.c.
> >=20
> > I will try to write RTC port in AML after remove acpica check, mayb=
e
> > have other unpredictable situation.
> >=20
>=20
> Now *THERE* is a good use of the "no RTC bit".  In the case that bit
> is
> set we should presumably remove these ports from the block list.

Thanks for your suggestion, I will put a testing patch on this.

>=20
> Otherwise we should use the CMOS address space, not the I/O port
> address
> space.
>=20
>         -hpa=20

Unfortunately current acpica leaks the SystemCMOS handler:

ACPI Error: Region SystemCMOS (ID=3D5) has no handler (20131115/exfldio=
-299)


Regards
Joey Lee
