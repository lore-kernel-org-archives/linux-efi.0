From: Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>
Subject: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table" breaks boot on thinkpad t440s
Date: Thu, 10 Apr 2014 12:43:43 +0200
Message-ID: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org List" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

After updating from 3.14-rc7 to a recent git the kernel fails to boot o=
n my thinkpad t440s and displays:

	Failed to get file info size
	Failed to alloc highmem for files

After a morning of running git bisect and rebooting, the bad commit see=
ms to be:

	54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI =
services pointer table

It doesn't revert cleanly, so I can't test current git without it to se=
e if that fixes it or not. I'm using gummiboot as bootloader:

Boot Loader Binaries:
          ESP: /dev/disk/by-partuuid/47cab2d9-0641-476c-bc74-166b122fca=
15
         File: =E2=94=94=E2=94=80/EFI/gummiboot/gummibootx64.efi (gummi=
boot 44)
         File: =E2=94=94=E2=94=80/EFI/Boot/BOOTX64.EFI (gummiboot 44)

Boot Loader Entries in EFI Variables:
        Title: Linux Boot Manager
           ID: 0x0016
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/b7b4fad3-3d19-40fd-b341-0ec7f2152b=
81
         File: =E2=94=94=E2=94=80/EFI/gummiboot/gummibootx64.efi

        Title: Linux Boot Manager
           ID: 0x0015
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/47cab2d9-0641-476c-bc74-166b122fca=
15
         File: =E2=94=94=E2=94=80/EFI/gummiboot/gummibootx64.efi

        Title: Fedora
           ID: 0x0014
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/47cab2d9-0641-476c-bc74-166b122fca=
15
         File: =E2=94=94=E2=94=80/EFI/fedora/shim.efi

        Title: Windows Boot Manager
           ID: 0x0013
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/56dff960-86b5-4846-89d3-fed0620f47=
1a
         File: =E2=94=94=E2=94=80/EFI/Microsoft/Boot/bootmgfw.efi

thanks,

Koen

Bisect log:

git bisect start
# good: [dcb99fd9b08cfe1afe426af4d8d3cbc429190f15] Linux 3.14-rc7
git bisect good dcb99fd9b08cfe1afe426af4d8d3cbc429190f15
# bad: [39de65aa2c3eee901db020a4f1396998e09602a3] Merge branch 'i2c/for=
-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect bad 39de65aa2c3eee901db020a4f1396998e09602a3
# bad: [ec0159503ae74aeb834e78366bdf4b9663ca1129] hwmon: (k10temp) Add =
support for AMD F16 M30h processor
git bisect bad ec0159503ae74aeb834e78366bdf4b9663ca1129
# bad: [675c354a95d5375153b8bb80a0448cab916c7991] Merge tag 'char-misc-=
3.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-=
misc
git bisect bad 675c354a95d5375153b8bb80a0448cab916c7991
# bad: [3786075b5ebc8c4eaefd9e3ebf72883934fb64b3] Merge tag 'regulator-=
v3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulat=
or
git bisect bad 3786075b5ebc8c4eaefd9e3ebf72883934fb64b3
# bad: [1ce235faa8fefa4eb7199cad890944c1d2ba1b3e] Merge tag 'arm64-upst=
ream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect bad 1ce235faa8fefa4eb7199cad890944c1d2ba1b3e
# good: [8c292f11744297dfb3a69f4a0bccbe4a6417b50d] Merge branch 'perf-c=
ore-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 8c292f11744297dfb3a69f4a0bccbe4a6417b50d
# bad: [e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0] Merge branch 'x86-kas=
lr-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0
# good: [971eae7c99212dd67b425a603f1fe3b763359907] Merge branch 'sched-=
core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/ti=
p
git bisect good 971eae7c99212dd67b425a603f1fe3b763359907
# bad: [204b0a1a4b92612c957a042df1a3be0e9cc79391] x86, efi: Abstract x8=
6 efi_early calls
git bisect bad 204b0a1a4b92612c957a042df1a3be0e9cc79391
# bad: [3db4cafdfd05717dc939780134e53023a3c1f15f] x86/boot: Fix non-EFI=
 build
git bisect bad 3db4cafdfd05717dc939780134e53023a3c1f15f
# bad: [0154416a71c2a84c3746c8dd8ed25287e36934d3] x86/efi: Add early th=
unk code to go from 64-bit to 32-bit
git bisect bad 0154416a71c2a84c3746c8dd8ed25287e36934d3
# good: [426e34cc4f6094cefe4f3175764cdf583128e7cd] x86/mm/pageattr: Alw=
ays dump the right page table in an oops
git bisect good 426e34cc4f6094cefe4f3175764cdf583128e7cd
# good: [677703cef0a148ba07d37ced649ad25b1cda2f78] efi: Add separate 32=
-bit/64-bit definitions
git bisect good 677703cef0a148ba07d37ced649ad25b1cda2f78

Build command line:

cp defconfig-3.13 .config ; yes '' | make oldconfig ; make bzImage -j4 =
&& sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-3.14 && sudo reboot--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
