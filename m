From: Calvin Walton <calvin.walton-08yNtVAFnCuw5LPnMra/2Q@public.gmane.org>
Subject: [bisected, regression] 3.17-rc2 kernel doesn't load initramfs with
 EFI stub boot
Date: Wed, 27 Aug 2014 12:02:37 -0400
Message-ID: <1409155357.1084.1.camel@kepstin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

When I tried booting the 3.17-rc2 kernel on my Lenovo ThinkPad T440p 
(16gb ram) via Gummiboot/EFI stub, it failed with an error saying that 
it could not mount root. A little investigation revealed that the 
initramfs did not load, so mounting by filesystem UUID failed.

A video of the failed boot is available here, if you're curious:
https://www.youtube.com/watch?v=wOHTvg8Tico

I've bisected the change, and it has led me to:

4bf7111f50167133a71c23530ca852a41355e739 is the first bad commit
commit 4bf7111f50167133a71c23530ca852a41355e739
Author: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Sat Jun 14 12:23:41 2014 -0700

    x86/efi: Support initrd loaded above 4G

    For boot efi kernel directly without bootloader.
    If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
    not limit initrd under hdr->initrd_add_max.

    Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This commit reverts cleanly on top of 3.17-rc2, and the resulting 
kernel boots correctly.

Note that testing was done during bisect with the EFI PE/COFF 
alignment fix by Michael Brown on top for kernels where it was not 
already included (this laptop requires that fix).


Full bisect log:
git bisect start
# bad: [52addcf9d6669fa439387610bc65c92fa0980cef] 
Linux 3.17-rc2
git bisect bad 52addcf9d6669fa439387610bc65c92fa0980cef
# 
good: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
git bisect 
good 19583ca584d6f574384e17fe7613dfaeadcdc4a6
# bad: 
[ae045e2455429c418a418a3376301a9e5753a0a8] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect 
bad ae045e2455429c418a418a3376301a9e5753a0a8
# bad: 
[53ee983378ff23e8f3ff95ecf99dea7c6c221900] Merge tag 
'staging-3.17-rc1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect 
bad 53ee983378ff23e8f3ff95ecf99dea7c6c221900
# good: 
[2042088cd67d0064d18c52c13c69af2499907bb1] staging: comedi: ni_labpc: 
tidy up labpc_ai_scan_mode()
git bisect good 
2042088cd67d0064d18c52c13c69af2499907bb1
# good: 
[98959948a7ba33cf8c708626e0d2a1456397e1c6] Merge branch 
'sched-core-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 
98959948a7ba33cf8c708626e0d2a1456397e1c6
# good: 
[6f929b4e5a022c3ca806c1675ccb833c42086853] staging: comedi: 
amplc_pc236: move static board data
git bisect good 
6f929b4e5a022c3ca806c1675ccb833c42086853
# bad: 
[2521129a6d2fd8a81f99cf95055eddea3df914ff] Merge tag 
'char-misc-3.17-rc1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git 
bisect bad 2521129a6d2fd8a81f99cf95055eddea3df914ff
# good: 
[7b9d1f0b7a18b86db0ac1de628fa91c0994fefbe] misc: bh1780: Introduce the 
use of devm_kzalloc
git bisect good 
7b9d1f0b7a18b86db0ac1de628fa91c0994fefbe
# bad: 
[ce4747963252a30613ebf1c1df3d83b9526a342e] Merge branch 
'x86-mm-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 
ce4747963252a30613ebf1c1df3d83b9526a342e
# bad: 
[fb86b2440de0ec10fe0272eb19d262ae7a01adb8] x86/efi: Add better error 
logging to EFI boot stub
git bisect bad 
fb86b2440de0ec10fe0272eb19d262ae7a01adb8
# bad: 
[0c5ed61adbdbf2ca5de934642d5be1e971c498c1] efi/reboot: Allow powering 
off machines using EFI
git bisect bad 
0c5ed61adbdbf2ca5de934642d5be1e971c498c1
# bad: 
[e15dd4949a937d8e8482f37f8fe493357417f203] efi/arm64: Preserve FP/SIMD 
registers on UEFI runtime services calls
git bisect bad 
e15dd4949a937d8e8482f37f8fe493357417f203
# bad: 
[4bf7111f50167133a71c23530ca852a41355e739] x86/efi: Support initrd 
loaded above 4G
git bisect bad 4bf7111f50167133a71c23530ca852a41355e739

# good: [98a716b66cab993e15001c7ec06f637ca6f1079b] x86/efi: Use 
early_memunmap() to squelch sparse errors
git bisect good 
98a716b66cab993e15001c7ec06f637ca6f1079b
# first bad commit: 
[4bf7111f50167133a71c23530ca852a41355e739] x86/efi: Support initrd 
loaded above 4G


-- 
Calvin Walton <calvin.walton-08yNtVAFnCuw5LPnMra/2Q@public.gmane.org>
