From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: efivarfs: unlinking open files results in spinlock corruption
Date: Wed, 26 Dec 2012 18:16:02 +0800
Message-ID: <1356516962.6113.232.camel@linux-s257.site>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <50D44279.7010008@redhat.com> <1356346840.6113.45.camel@linux-s257.site>
	 <50D90E61.40702@redhat.com>  <1356408784.6113.68.camel@linux-s257.site>
	 <1356501732.6113.213.camel@linux-s257.site>  <50DAC19A.8060500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50DAC19A.8060500-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, glin-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2012-12-26 =E6=96=BC 17:21 +0800=EF=BC=8CLi=
ngzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/26/2012 02:02 PM, joeyli wrote:
> >> Maybe you can try v3.8-rc1 kernel.
> >
> > hm... I just re-test and do more times, I also can reproduce on
> v3.8-rc1
> > and 54e37b8dbe branch now.
>=20
> Good news you reproduce it. I manage to isolate the following
> reproducer.
>=20
> This reproducer causes general protection fault, NULL dereference or
> just
> hanging on QEMU/OVMF (OVMF-0.1+r13902-1.1) with 3.8-rc1 vanilla
> kernel.
>=20
> With a logging point in efivarfs_file_write checking &efivars->lock,
> it
> looks like the spinlock is corrupted before call trace kicks in.
>=20
> Currently deletion with efivarfs_file_write just does the same thing
> of
> unlinking an file while it's open.
>=20
> Steps to reproduce:
> $ gcc efivarfs-unlink-open-file.c -o efivarfs-unlink-open-file
> # mount -t efivarfs - /sys/firmware/efi/efivars
> # ./efivarfs-unlink-open-file
> [   74.893152] BUG: unable to handle kernel NULL pointer dereference
> at=20
>            (null)
> [   74.894131] IP: [<ffffffff81646b4e>] _raw_spin_lock+0xe/0x30
> [   74.894131] PGD 78b3d067 PUD 3f91b067 PMD 0
> [   74.894131] Oops: 0002 [#1] SMP
> (...)=20

I am checking the write/umount/mount/read problem on v3.8-rc1.

The issue also can trigger by read the GHOST test file. When issue
happen, the size of test file is zero. The 'var->efivars' already set t=
o
NULL when issue reproduced, that's why we always got NULL pointer
dereference when try to spin lock it.

If we don't do umount/mount step, then everything is OK for we can
create/delete test file many times. But, if we umount/mount efivarfs
then more easy to trigger issue.

When issue happen, inode of test file didn't removed but efivars alread=
y
set to NULL. I think there have race condition between maintain efivars
and vars. Still tracing...


Thanks a lot!
Joey Lee
