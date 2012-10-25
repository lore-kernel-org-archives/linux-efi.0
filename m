From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Add syste-firmware-efi-efivars.mount for support
 automount EFI variable filesystem
Date: Thu, 25 Oct 2012 12:12:07 +0800
Message-ID: <1351138327.30067.34.camel@linux-s257.site>
References: <1351075322-3824-1-git-send-email-jlee@suse.com>
	 <20121024140401.GA19778@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121024140401.GA19778-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2012-10-24 =E6=96=BC 16:04 +0200=EF=BC=8CLe=
nnart Poettering =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 24.10.12 18:42, Lee, Chun-Yi (joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org) wrote:
>=20
> > Add units/sys-firmware-efi-efivars.mount rule for support automount
> > EFI variable filesystem
>=20
> Good in principle, but as Kay mentioned we probably should not expose
> this as units, but just mount it from PID1's C code. More specificall=
y
> add it to the table in src/core/mount-setup.c, but make sure to set t=
he
> "fatal" bool in the table to false for this entry, to clarify that th=
is
> is not a reason to fail.
>=20
> You probably also want to add the kmod to the table in
> src/core/kmod-setup.c since the mount point is not available if the k=
mod
> is not loaded.
>=20
> Thanks!
>=20
> Lennart
>=20

Thanks for all systemd experts' review and comments.

I will follow the above suggestions to create new patch and send it
after tested success.


Thanks a lot!
Joey Lee
