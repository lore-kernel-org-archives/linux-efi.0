From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
Date: Wed, 24 Apr 2013 21:23:56 +0800
Message-ID: <1366809836.23707.331.camel@linux-s257.site>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
	 <1366798111.23707.293.camel@linux-s257.site>
	 <1366798497.13667.25.camel@x230.lan>
	 <1366801173.23707.323.camel@linux-s257.site>
	 <1366804640.13667.27.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366804640.13667.27.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-04-24 =E6=96=BC 11:57 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 2013-04-24 at 18:59 +0800, joeyli wrote:
>=20
> > Then why we don't just remove the "remaining_size" condition but on=
ly
> > monitor the active_size should not larger then 1/2 storage_size?
>=20
> If we calculate active_size as using more than 50% of the storage spa=
ce
> but remaining_size says we still have more than 50% available, we sho=
uld
> trust remaining_size instead of active_size.
>=20
> --=20
> Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org

That makes sense because BIOS base on remaining_size to trigger garbage
collection.

Thanks for your clarification!

Joey Lee
