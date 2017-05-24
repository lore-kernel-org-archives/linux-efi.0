From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Wed, 24 May 2017 15:45:17 +0100
Message-ID: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


Here's a set of patches to institute a "locked-down mode" in the kernel and
to set that mode if the kernel is booted in secure-boot mode.  This can be
enabled with CONFIG_LOCK_DOWN_KERNEL.  If a kernel is locked down, the
lockdown can be lifted by typing SysRq+x on a keyboard attached to the
machine if CONFIG_EFI_ALLOW_SECURE_BOOT_EXIT is enabled.  The exact key can
be configured as 'x' is already taken on some arches.

Inside the kernel, kernel_is_locked_down() is used to check if the kernel
is in lockdown mode.  In lock-down mode, at least the following
restrictions will need to be emplaced:

 (1) No unsigned modules, kexec images or firmware.

 (2) No direct read/write access of the kernel image.  (Shouldn't be able
     to modify it and shouldn't be able to read out crypto data).

 (3) No direct access to devices.  (DMA could be used to access/modify the
     kernel image).

 (4) No manual setting of device register addresses to cause a driver for
     one device to mess around with another device, thereby permitting DMA.

 (5) No storage of unencrypted kernel image to disk (no suspend-to-disk
     without hardware support).

I have patches pending that effect most of the above.  However, the
firmware signature checking is being handled by someone else.  Further, it
has come to light recently that debugfs needs attention, so that isn't done
yet.

Note that the secure boot mode entry doesn't currently work if the kernel
is booted from current i386/x86_64 Grub as there's a bug in Grub whereby it
doesn't initialise the boot_params correctly.  The incorrect initialisation
causes sanitize_boot_params() to be triggered, thereby zapping the secure
boot flag determined by the EFI boot wrapper.

David
---
David Howells (3):
      efi: Move the x86 secure boot switch to generic code
      Add the ability to lock down access to the running kernel image
      efi: Lock down the kernel if booted in secure boot mode

Josh Boyer (1):
      efi: Add EFI_SECURE_BOOT bit

Kyle McMartin (1):
      Add a sysrq option to exit secure boot mode


 arch/x86/include/asm/efi.h        |    2 +
 arch/x86/kernel/setup.c           |   14 ------
 drivers/firmware/efi/Kconfig      |   34 ++++++++++++++++
 drivers/firmware/efi/Makefile     |    1 
 drivers/firmware/efi/secureboot.c |   80 +++++++++++++++++++++++++++++++++++++
 drivers/input/misc/uinput.c       |    1 
 drivers/tty/sysrq.c               |   19 ++++++---
 include/linux/efi.h               |    7 +++
 include/linux/input.h             |    5 ++
 include/linux/kernel.h            |    9 ++++
 include/linux/security.h          |   11 +++++
 include/linux/sysrq.h             |    8 +++-
 kernel/debug/kdb/kdb_main.c       |    2 -
 security/Kconfig                  |   15 +++++++
 security/Makefile                 |    3 +
 security/lock_down.c              |   46 +++++++++++++++++++++
 16 files changed, 236 insertions(+), 21 deletions(-)
 create mode 100644 drivers/firmware/efi/secureboot.c
 create mode 100644 security/lock_down.c
