From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/5] Non-ARM-specific EFI patches needed for ARM ports
Date: Fri,  4 Apr 2014 13:25:45 +0100
Message-ID: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is the set of patches from the arm/arm64 UEFI support that are not
in fact architecture specific. This set depends on other EFI patches
already in linux-next.

H. Peter Anvin (1):
  efi: x86: Improve cmdline conversion

Leif Lindholm (1):
  efi: efi-stub-helper cleanup

Mark Salter (1):
  efi: create memory map iteration helper

Roy Franz (2):
  efi: Add shared printk wrapper for consistent prefixing
  efi: Add get_dram_base() helper function

 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/efi-stub-helper.c |  148 +++++++++++++++++++++++---------
 include/linux/efi.h                    |    6 ++
 3 files changed, 116 insertions(+), 41 deletions(-)

-- 
1.7.10.4
