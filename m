From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
Date: Wed, 24 Apr 2013 18:59:33 +0800
Message-ID: <1366801173.23707.323.camel@linux-s257.site>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
	 <1366798111.23707.293.camel@linux-s257.site>
	 <1366798497.13667.25.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366798497.13667.25.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-04-24 =E6=96=BC 10:14 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 2013-04-24 at 18:08 +0800, joeyli wrote:
>=20
> > It causes the garbage size increased and remaining_size decreased. =
But
> > we still can create new variable because active_size doesn't increa=
se
> > due to we delete variable before create new. So, the condition
> > "remaining_size - size < storage_size / 2" will not really hit beca=
use
> > active_size condition is pass.
>=20
> That's fine - the (limited) information we have from Samsung is that
> there's no problem if all the space is dirty, only if all the space i=
s
> marked as active.
>=20
> --=20
> Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org

Got it! Thanks for your explanation!

Then why we don't just remove the "remaining_size" condition but only
monitor the active_size should not larger then 1/2 storage_size?

Does that because we allow one and only one VAR_METADATA_SIZE beyond th=
e
1/2 storage? If so, why we don't just give ( 1/2 storage_size +
VAR_METADATA_SIZ) space for active_size using?


Thanks a lot!
Joey Lee
