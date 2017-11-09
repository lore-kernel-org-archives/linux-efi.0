From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/30] security, efi: Add kernel lockdown
Date: Thu,  9 Nov 2017 17:30:36 +0000
Message-ID: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, dhowells@redhat.com, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org


Here's a set of patches to institute a "locked-down mode" in the kernel and
to trigger that mode if the kernel is booted in secure-boot mode or through
the command line.

Enabling CONFIG_LOCK_DOWN_KERNEL makes lockdown mode available.

Enabling CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ will allow a SysRq combination
to lift the lockdown.  On x86 this is SysRq+x.  The keys must be pressed on
an attached keyboard.

Enabling CONFIG_LOCK_DOWN_IN_EFI_SECURE_BOOT will cause EFI secure boot to
trigger kernel lockdown.

Inside the kernel, kernel_is_locked_down() is used to check if the kernel
is in lockdown mode.

Note that the secure boot mode entry doesn't work if the kernel is booted
from older versions of i386/x86_64 Grub as there's a bug in Grub whereby it
doesn't initialise the boot_params correctly.  The incorrect initialisation
causes sanitize_boot_params() to be triggered, thereby zapping the secure
boot flag determined by the EFI boot wrapper.

A manual page, kernel_lockdown.7, is proposed, to which people will be
directed by messages in dmesg.  This lists the features that are restricted
amongst other things.  [Note: I need to update this to mention IMA, so I'll
reply with that later].

Changes:

 (*) Made /dev/mem and /dev/kmem explicitly unopenable in lockdown mode,
     rather than being unopenable as a side effect of /dev/port being made
     unopenable.

 (*) Added lockdowns for ftrace and kprobes.

 (*) Made the bpf lockdown prohibit the use of sys_bpf entirely.

 (*) Made IMA require secure_boot rules in lockdown mode.

 (*) Made module signing and kexec allow unsigned images if IMA has been
     used to validate the image.


The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-lock-down

David
---
Chun-Yi Lee (1):
      kexec_file: Restrict at runtime if the kernel is locked down

Dave Young (1):
      Copy secure_boot flag in boot params across kexec reboot

David Howells (14):
      Add the ability to lock down access to the running kernel image
      Enforce module signatures if the kernel is locked down
      scsi: Lock down the eata driver
      Prohibit PCMCIA CIS storage when the kernel is locked down
      Lock down TIOCSSERIAL
      Lock down module params that specify hardware parameters (eg. ioport)
      x86/mmiotrace: Lock down the testmmiotrace module
      debugfs: Disallow use of debugfs files when the kernel is locked down
      Lock down /proc/kcore
      Lock down ftrace
      Lock down kprobes
      bpf: Restrict kernel image access functions when the kernel is locked down
      efi: Add an EFI_SECURE_BOOT flag to indicate secure boot mode
      efi: Lock down the kernel if booted in secure boot mode

Josh Boyer (2):
      hibernate: Disable when the kernel is locked down
      acpi: Ignore acpi_rsdp kernel param when the kernel has been locked down

Kyle McMartin (1):
      Add a SysRq option to lift kernel lockdown

Linn Crosetto (2):
      acpi: Disable ACPI table override if the kernel is locked down
      acpi: Disable APEI error injection if the kernel is locked down

Matthew Garrett (8):
      Restrict /dev/{mem,kmem,port} when the kernel is locked down
      kexec: Disable at runtime if the kernel is locked down
      uswsusp: Disable when the kernel is locked down
      PCI: Lock down BAR access when the kernel is locked down
      x86: Lock down IO port access when the kernel is locked down
      x86/msr: Restrict MSR access when the kernel is locked down
      asus-wmi: Restrict debugfs interface when the kernel is locked down
      ACPI: Limit access to custom_method when the kernel is locked down

Mimi Zohar (1):
      ima: require secure_boot rules in lockdown mode


 arch/x86/include/asm/setup.h        |    2 +
 arch/x86/kernel/ioport.c            |    6 +-
 arch/x86/kernel/kexec-bzimage64.c   |    1 
 arch/x86/kernel/msr.c               |   10 +++
 arch/x86/kernel/setup.c             |   18 +-----
 arch/x86/mm/testmmiotrace.c         |    3 +
 drivers/acpi/apei/einj.c            |    3 +
 drivers/acpi/custom_method.c        |    3 +
 drivers/acpi/osl.c                  |    2 -
 drivers/acpi/tables.c               |    5 ++
 drivers/char/mem.c                  |    2 +
 drivers/firmware/efi/Makefile       |    1 
 drivers/firmware/efi/secureboot.c   |   38 ++++++++++++
 drivers/input/misc/uinput.c         |    1 
 drivers/pci/pci-sysfs.c             |    9 +++
 drivers/pci/proc.c                  |    9 +++
 drivers/pci/syscall.c               |    3 +
 drivers/pcmcia/cistpl.c             |    3 +
 drivers/platform/x86/asus-wmi.c     |    9 +++
 drivers/scsi/eata.c                 |    5 +-
 drivers/tty/serial/serial_core.c    |    6 ++
 drivers/tty/sysrq.c                 |   19 ++++--
 fs/debugfs/file.c                   |    6 ++
 fs/proc/kcore.c                     |    2 +
 include/linux/efi.h                 |   16 +++--
 include/linux/input.h               |    5 ++
 include/linux/kernel.h              |   17 ++++++
 include/linux/security.h            |    8 +++
 include/linux/sysrq.h               |    8 ++-
 kernel/bpf/syscall.c                |    3 +
 kernel/debug/kdb/kdb_main.c         |    2 -
 kernel/kexec.c                      |    7 ++
 kernel/kexec_file.c                 |    8 +++
 kernel/kprobes.c                    |    3 +
 kernel/module.c                     |   19 ++++--
 kernel/params.c                     |   26 +++++++-
 kernel/power/hibernate.c            |    2 -
 kernel/power/user.c                 |    3 +
 kernel/trace/ftrace.c               |   22 +++++++
 security/Kconfig                    |   32 ++++++++++
 security/Makefile                   |    3 +
 security/integrity/ima/ima_policy.c |   39 +++++++++----
 security/lock_down.c                |  108 +++++++++++++++++++++++++++++++++++
 43 files changed, 440 insertions(+), 57 deletions(-)
 create mode 100644 drivers/firmware/efi/secureboot.c
 create mode 100644 security/lock_down.c
