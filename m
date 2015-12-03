From: Kosuke Tatsukawa <tatsu-zZGIbrA41Td8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH 0/2] x86: Fix issues when eXecute Disable (XD) bit is
 disabled in uEFI firmware
Date: Thu, 3 Dec 2015 23:58:31 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A0288E2C8@BPXM09GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: ja-JP
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The kernel panics early in boot on a x86_64 server if the eXecute
Disable (XD) bit is set to disabled in the uEFI firmware.

The following patches fix the panic and also fix an error in
kernel_map_pages_in_pgd() which would make the EFI runtime service
unavailable when the XD bit is set to disabled.

Kosuke Tatsukawa (2):
  x86: Fix kernel panic when booting with XD disabled in uEFI firmware
  x86: Fix error in kernel_map_pages_in_pgd() when booting with XD disabled
---
 arch/x86/kernel/setup.c |   18 +++++++++---------
 arch/x86/mm/ioremap.c   |    3 +++
 arch/x86/mm/pageattr.c  |    6 +-----
 3 files changed, 13 insertions(+), 14 deletions(-)
