From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: General protection fault in efivarfs
Date: Wed, 26 Dec 2012 14:02:12 +0800
Message-ID: <1356501732.6113.213.camel@linux-s257.site>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <50D44279.7010008@redhat.com> <1356346840.6113.45.camel@linux-s257.site>
	 <50D90E61.40702@redhat.com>  <1356408784.6113.68.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356408784.6113.68.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, glin-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2012-12-25 =E6=96=BC 12:13 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
>=20
> > This is what efivarfs_unlink is doing but I wanted to avoid its
> > underflowing when reproducing this.
> >=20
> > This still reproduces the bug and passes the check in your patch:
> >=20
> > echo -en "\x07\0\0\0" >$p/test-12341234-1234-1234-1234-123412341234
>=20
> I can NOT reproduce issue by feeding "\x07\0\0\0" to variable on my
> system, the test variable was been deleted normally.
>=20
> My 2 testing environment:=20
>         + qemu-kvm with OVMF-0.1+r13902-1.1.x86_64 on openSUSE
>         + Intel DQ57TM board (Tunnel Mountain) with B.11 UEFI BIOS
>=20
> Kernel version is:
>         + latest commit is 54e37b8dbe on Linus kernel tree
>           with
>           my patch for check attributes need define bootservice and
> runtime access
>          =20
> I can not reproduce on OVMF and Intel DQ57TM board. After I delete
> variable, I also umount/mount filesystem a couple of times and
> write/delete again, didn't reproduce issue.
>=20
> Maybe you can try v3.8-rc1 kernel.=20

hm... I just re-test and do more times, I also can reproduce on v3.8-rc=
1
and 54e37b8dbe branch now.


Thanks
Joey Lee
