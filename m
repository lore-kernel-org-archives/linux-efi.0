From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 0/2] EFI earlyprintk support
Date: Fri, 11 Oct 2013 15:33:55 +0100
Message-ID: <1381502037-22225-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These two patches cleanup the #include <linux/efi.h> duplication and add
support for earlyprintk=efi, which is the only way users can debug early
boot crashes without special hardware.

Matt Fleming (2):
  x86/efi: Include linux/efi.h in asm/efi.h
  x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/x86/Kconfig.debug               |   9 ++
 arch/x86/boot/compressed/eboot.c     |   1 -
 arch/x86/include/asm/efi.h           |   4 +
 arch/x86/kernel/early_printk.c       |   6 ++
 arch/x86/kernel/setup.c              |   1 -
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |   1 -
 arch/x86/platform/efi/efi_32.c       |   1 -
 arch/x86/platform/efi/efi_64.c       |   1 -
 arch/x86/platform/uv/bios_uv.c       |   1 -
 12 files changed, 216 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/platform/efi/early_printk.c

-- 
1.8.1.4
