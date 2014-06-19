From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 0/3] EFI reboot/poweroff support
Date: Thu, 19 Jun 2014 14:40:22 +0100
Message-ID: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Aubrey Li <aubrey.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Both x86 and ARM need a way to reboot/poweroff machines using the EFI
runtime services.

For x86, we want to really, really restrict this support to those
platforms that absolultely have no other method because EfiResetSystem()
doesn't generally work very well in the wild. The ARM folks probably
need to be less picky.

This series is against the EFI 'next' branch.

Matt Fleming (3):
  efi/reboot: Add generic wrapper around EfiResetSystem()
  efi/reboot: Allow powering off machines using EFI
  x86/reboot: Add EFI reboot quirk for ACPI Hardware Reduced flag

 arch/ia64/kernel/process.c     |  2 +-
 arch/x86/include/asm/efi.h     |  6 +++++
 arch/x86/kernel/reboot.c       | 24 ++++++++++++------
 arch/x86/platform/efi/quirks.c | 23 ++++++++++++++++++
 drivers/firmware/efi/Makefile  |  2 +-
 drivers/firmware/efi/reboot.c  | 55 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |  7 ++++++
 7 files changed, 110 insertions(+), 9 deletions(-)
 create mode 100644 drivers/firmware/efi/reboot.c

-- 
1.9.0
