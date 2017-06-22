From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] xen/efi: Fixes
Date: Thu, 22 Jun 2017 12:51:35 +0200
Message-ID: <1498128697-12943-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jgross-IBi9RG/b67k@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hey,

Two small fixes (v2, minor cleanup) for Xen dom0 running on x86_64 EFI platforms.

I am CC-ing stable maintainers because similar stuff is needed for various
stable kernels too. Unfortunately, almost every version needs a bit different
set of fixes. So, please treat this email more as head up than real set of
patches for your kernel. If you wish to get Xen EFI stuff fixed just drop me
a line. Then I will prepare set of patches for your kernel (if needed).

Ard, Andrew, Ingo, thank you for looking at the patches.

Daniel

 arch/x86/xen/efi.c         |   45 ++++++++++++---------------------------------
 drivers/firmware/efi/efi.c |    3 ++-
 2 files changed, 14 insertions(+), 34 deletions(-)

Daniel Kiper (2):
      efi: Process MEMATTR table only if EFI_MEMMAP
      x86/xen/efi: Init only efi struct members used by Xen
