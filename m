From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 13:38:36 +0800
Message-ID: <1387517916.3539.4446.camel@linux-s257.site>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>
	 <52B3C5F0.1060303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B3C5F0.1060303-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 20:22 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/19/2013 08:05 PM, joeyli wrote:
> >=20
> > Then that means the priority of PNP0B0x is higher then "CMOS RTC No=
t
> > Present" flag. ACPI spec doesn't have clear definition on this.
> >=20
>=20
> According to the Microsoft requirements documents, such a platform is
> broken and shouldn't exist.

OK~~

>=20
> > I look forward to Borislav's "EFI runtime mapping" to fix the physi=
cal
> > address accessing issue of EFI time service on x86_64 machines. I t=
ested
> > his patches on a issue machine and it works for walk around BIOS bu=
g.
> >=20
> > Can we use EFI time services on x86_64 after Borislav's patches acc=
epted
> > to mainline?
> >=20
>=20
> No.
>=20
> 	-hpa

If don't use EFI time, then the first priority is using ACPI TAD if it
present. Due to ACPI TAD is a generic acpi device that's need OS parsin=
g
DSDT table before set system time.

Either move DSDT parser from subsystem initial stage to start_kernel or
move timekeeping initial to after DSDT be parsed. Which one you think i=
s
more possible and risk less? Then I will try that way.


Thanks a lot!
Joey Lee
