From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: Cannot add new efi boot entry
Date: Tue, 16 Apr 2013 17:56:08 +0800
Message-ID: <1366106168.23707.9.camel@linux-s257.site>
References: <516B1ED3.9040900@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516B1ED3.9040900-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Jiri,=20

=E6=96=BC =E6=97=A5=EF=BC=8C2013-04-14 =E6=96=BC 23:25 +0200=EF=BC=8CJi=
ri Slaby =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi,
>=20
> after update to 3.8, every update of the kernel ends up in an unboota=
ble
> machine. It is due to the following commit:
> commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
> Author: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Date:   Sat Mar 2 19:40:17 2013 -0500
>=20
>     efi: be more paranoid about available space when creating variabl=
es
>=20
> efibootmgr which tries to add an entry and silently fails when writin=
g
> to /sys/firmware/efi/vars/new_var with -ENOSPC.
>=20
> There are many entries in there:
> # efibootmgr
> BootCurrent: 000D
> Timeout: 0 seconds
> BootOrder:
> 0018,0000,0001,0002,0003,0007,0008,0009,000A,000B,000C,000D,000E,000F=
,0010,0011,0012
> Boot0000  Setup
> Boot0001  Boot Menu
> Boot0002  Diagnostic Splash Screen
> Boot0003  Lenovo Diagnostics
> Boot0004  Startup Interrupt Menu
> Boot0005  ME Configuration Menu
> Boot0006  Rescue and Recovery
> Boot0007* USB CD
> Boot0008* USB FDD
> Boot0009* ATAPI CD0
> Boot000A* ATA HDD0
> Boot000B* ATA HDD1
> Boot000C* ATA HDD2
> Boot000D* USB HDD
> Boot000E* PCI LAN
> Boot000F* ATAPI CD1
> Boot0010  Other CD
> Boot0011* ATA HDD3
> Boot0012  Other HDD
> Boot0013* IDER BOOT CDROM
> Boot0014* IDER BOOT Floppy
> Boot0015* ATA HDD
> Boot0016* ATAPI CD:
> Boot0017* PCI LAN
> Boot0018* Linux
>=20
>=20
> Remaining size is about 20k, added entry size is hundreds bytes, stor=
e
> size is 64k.
>=20
> Obviously lowering the limitation from 1/2 to 1/4 fixes the problem f=
or
> me because it always worked on my setup to store a new entry...
>=20
> Any ideas how to overcome that? It would be better to blacklist bad
> machines rather than whitelist good ones, right?
>=20
> thanks,

I think I just got the same situation on my side with Acer machine. I a=
m
trying Matthew's new patchset hope can avoid this situation:

https://lkml.org/lkml/2013/4/15/473


Thanks a  lot!
Joey Lee
