From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 07/14] rtc-efi: add GMTOFF support to rtc_efi
Date: Sat, 21 Dec 2013 11:56:01 +0800
Message-ID: <1387598161.3539.5058.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-8-git-send-email-jlee@suse.com>
	 <1387552304.17961.0.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387552304.17961.0.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org" <samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org" <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "Elliott-VXdhtT5mjnY@public.gmane.org" <Elliott-VXdhtT5mjnY@public.gmane.org>, "werner-IBi9RG/b67k@public.gmane.org" <werner-IBi9RG/b67k@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "trenn-l3A5Bk7waGM@public.gmane.org" <trenn-l3A5Bk7waGM@public.gmane.org>, "JBeulich-IBi9RG/b67k@public.gmane.org" <JBeulich-IBi9RG/b67k@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2013-12-20 =E6=96=BC 15:11 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 2013-12-19 at 15:51 +0800, Lee, Chun-Yi wrote:
> > This patch adds 2 new iotrl: RTC_RD_GMTOFF and RTC_SET_GMTOFF to
> > rtc_efi support get/set gmt offset that mapping to the GUN's tm_gmt=
off
> > extension (Seconds east of UTC).
>=20
> Shouldn't this information also be exported via the rtc-sysfs interfa=
ce?
>=20

Thanks for your suggestion, I will also export it to rtc-sysfs.

Joey Lee
