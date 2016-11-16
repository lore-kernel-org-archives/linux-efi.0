From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/16] Kernel lockdown
Date: Wed, 16 Nov 2016 21:47:16 +0000
Message-ID: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


These patches provide a facility by which a variety of avenues by which
userspace can feasibly modify the running kernel image can be locked down.
These include:

 (*) No unsigned modules and no modules for which can't validate the
     signature.

 (*) No use of ioperm(), iopl() and no writing to /dev/port.

 (*) No writing to /dev/mem or /dev/kmem.

 (*) No hibernation.

 (*) Restrict PCI BAR access.

 (*) Restrict MSR access.

 (*) No kexec_load().

 (*) Certain ACPI restrictions.

 (*) Restrict debugfs interface to ASUS WMI.

The lock-down can be configured to be triggered by the EFI secure boot
status, provided the shim isn't insecure.  The lock-down can be lifted by
typing SysRq+x on a keyboard attached to the system.


The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-lockdown

They are dependent for some EFI definitions on the keys-uefi branch.

David
---
Dave Young (1):
      Copy secure_boot flag in boot params across kexec reboot

David Howells (3):
      Add the ability to lock down access to the running kernel image
      efi: Get the secure boot status
      efi: Lock down the kernel if booted in secure boot mode

Josh Boyer (4):
      efi: Disable secure boot if shim is in insecure mode
      efi: Add EFI_SECURE_BOOT bit
      hibernate: Disable when the kernel is locked down
      acpi: Ignore acpi_rsdp kernel param when the kernel has been locked down

Kyle McMartin (1):
      Add a sysrq option to exit secure boot mode

Matthew Garrett (7):
      kexec: Disable at runtime if the kernel is locked down
      PCI: Lock down BAR access when the kernel is locked down
      x86: Lock down IO port access when the kernel is locked down
      ACPI: Limit access to custom_method when the kernel is locked down
      asus-wmi: Restrict debugfs interface when the kernel is locked down
      Restrict /dev/mem and /dev/kmem when the kernel is locked down
      x86: Restrict MSR access when the kernel is locked down


 Documentation/x86/zero-page.txt       |    2 +
 arch/x86/Kconfig                      |   22 ++++++++++++++
 arch/x86/boot/compressed/eboot.c      |   53 +++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |    3 +-
 arch/x86/kernel/ioport.c              |    5 ++-
 arch/x86/kernel/kexec-bzimage64.c     |    1 +
 arch/x86/kernel/msr.c                 |    8 +++++
 arch/x86/kernel/setup.c               |   39 ++++++++++++++++++++++++
 drivers/acpi/custom_method.c          |    3 ++
 drivers/acpi/osl.c                    |    3 +-
 drivers/char/mem.c                    |   10 ++++++
 drivers/input/misc/uinput.c           |    1 +
 drivers/pci/pci-sysfs.c               |   10 ++++++
 drivers/pci/proc.c                    |    9 +++++-
 drivers/pci/syscall.c                 |    3 +-
 drivers/platform/x86/asus-wmi.c       |    9 ++++++
 drivers/tty/sysrq.c                   |   19 ++++++++----
 include/linux/efi.h                   |    1 +
 include/linux/input.h                 |    5 +++
 include/linux/security.h              |   16 ++++++++++
 include/linux/sysrq.h                 |    8 ++++-
 kernel/debug/kdb/kdb_main.c           |    2 +
 kernel/kexec.c                        |    8 +++++
 kernel/module.c                       |    2 +
 kernel/power/hibernate.c              |    3 +-
 security/Kconfig                      |   16 +++++++++-
 security/Makefile                     |    3 ++
 security/lock_down.c                  |   40 +++++++++++++++++++++++++
 28 files changed, 287 insertions(+), 17 deletions(-)
 create mode 100644 security/lock_down.c
