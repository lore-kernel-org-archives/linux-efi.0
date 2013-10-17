From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH v3 0/2] EFI earlyprintk support
Date: Thu, 17 Oct 2013 13:19:13 +0100
Message-ID: <1382012355-8846-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These two patches cleanup the #include <linux/efi.h> duplication and get
rid of the #ifdef CONFIG_X86 in efi.h, and add support for
earlyprintk=efi, which is the only way users can debug early boot
crashes without special hardware.

Matt Fleming (2):
  efi: Add asm-generic/efi.h for non-x86
  x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/ia64/include/asm/efi.h          |   6 ++
 arch/x86/Kconfig.debug               |   9 ++
 arch/x86/boot/compressed/eboot.c     |   1 -
 arch/x86/include/asm/efi.h           |  12 +++
 arch/x86/kernel/early_printk.c       |   6 ++
 arch/x86/kernel/setup.c              |   1 -
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |   1 -
 arch/x86/platform/efi/efi_32.c       |   1 -
 arch/x86/platform/efi/efi_64.c       |   1 -
 arch/x86/platform/uv/bios_uv.c       |   1 -
 include/asm-generic/efi.h            |  17 ++++
 include/linux/efi.h                  |  31 +-----
 15 files changed, 249 insertions(+), 38 deletions(-)
 create mode 100644 arch/ia64/include/asm/efi.h
 create mode 100644 arch/x86/platform/efi/early_printk.c
 create mode 100644 include/asm-generic/efi.h

-- 
1.8.1.4
