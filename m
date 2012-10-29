From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] systemd: mount the EFI variable filesystem
Date: Mon, 29 Oct 2012 10:21:30 +0800
Message-ID: <1351477290.21227.7.camel@linux-s257.site>
References: <1351308202-14628-1-git-send-email-jlee@suse.com>
	 <20121028130025.GD7904@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121028130025.GD7904-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Mantas Mikul <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zbigniew J <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E6=97=A5=EF=BC=8C2012-10-28 =E6=96=BC 14:00 +0100=EF=BC=8CLe=
nnart Poettering =E6=8F=90=E5=88=B0=EF=BC=9A
> On Sat, 27.10.12 11:23, Lee, Chun-Yi (joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org) wrote:
>=20
> > Add efivarfs to the mount_table in mount-setup.c, so the EFI variab=
le
> > filesystem will be mounted when systemd executed.
> >=20
> > The EFI variable filesystem will merge in v3.7 or v3.8 linux kernel=
=2E
>=20
> I can't really test this, but looks reasonably simple, and I assume t=
his
> has been tested, so I merged this.
>=20
> Thanks!
>=20
> Lennart
>=20

I tested this patch on my UEFI notebook with latest EFI kernel git tree=
,
the efivarfs mounted normally after system boot and I can delete/add EF=
I
variable through /sys/firmware/efi/efivars.

Thanks for your review and merged.


Thanks a lot!
Joey Lee
