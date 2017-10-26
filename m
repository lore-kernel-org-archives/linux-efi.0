From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 26 Oct 2017 17:37:38 +0100
Message-ID: <29447.1509035858@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <29446.1509035858.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi James,

Can you pull this patchset into security/next please?

It adds kernel lockdown support for EFI secure boot.  Note that it doesn't yet
cover:

	bpf	- No agreement as to how
	ftrace	- Recently suggested, query sent to maintainer
	perf	- Not looked at yet.

and there are some changes recently proposed that make it work with IMA that
I'll pass on as a follow up when we've fully worked them out.

There's a manual page (kernel_lockdown.7) associated with this:

.\"
.\" Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
.\" Written by David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
.\"
.\" %%%LICENSE_START(GPLv2+_SW_ONEPARA)
.\" This program is free software; you can redistribute it and/or
.\" modify it under the terms of the GNU General Public License
.\" as published by the Free Software Foundation; either version
.\" 2 of the License, or (at your option) any later version.
.\" %%%LICENSE_END
.\"
.TH "KERNEL LOCKDOWN" 7 2017-10-05 Linux "Linux Programmer's Manual"
.SH NAME
Kernel Lockdown \- Kernel image access prevention feature
.SH DESCRIPTION
The Kernel Lockdown feature is designed to prevent both direct and indirect
access to a running kernel image, attempting to protect against unauthorised
modification of the kernel image and to prevent access to security and
cryptographic data located in kernel memory, whilst still permitting driver
modules to be loaded.
.P
Lockdown is typically enabled during boot and may be terminated, if configured,
by typing a special key combination on a directly attached physical keyboard.
.P
If a prohibited or restricted feature is accessed or used, the kernel will emit
a message that looks like:
.P
.RS
	Lockdown: X is restricted, see man kernel_lockdown.7
.RE
.P
where X indicates what is restricted.
.P
On an EFI-enabled x86 or arm64 machine, lockdown will be automatically enabled
if the system boots in EFI Secure Boot mode.
.P
If the kernel is appropriately configured, lockdown may be lifted by typing the
appropriate sequence on a directly attached physical keyboard.  For x86
machines, this is
.IR SysRq+x .
.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH COVERAGE
When lockdown is in effect, a number of things are disabled or restricted in
use.  This includes special device files and kernel services that allow direct
access of the kernel image:
.P
.RS
/dev/mem
.br
/dev/kmem
.br
/dev/kcore
.br
/dev/ioports
.RE
.P
and the ability to directly configure and control devices, so as to prevent the
use of a device to access or modify a kernel image:
.P
.RS
The use of module parameters that directly specify hardware parameters to
drivers through the kernel command line or when loading a module.
.P
The use of direct PCI BAR access.
.P
The use of the ioperm and iopl instructions on x86.
.P
The use of the KD*IO console ioctls.
.P
The use of the TIOCSSERIAL serial ioctl.
.P
The alteration of MSR registers on x86.
.P
The replacement of the PCMCIA CIS.
.P
The overriding of ACPI tables.
.P
The use of ACPI error injection.
.P
The specification of the ACPI RDSP address.
.P
The use of ACPI custom methods.
.RE
.P
The following facilities are restricted:
.P
.RS
Only validly signed modules may be loaded.
.P
Only validly signed binaries may be kexec'd.
.P
Only validly signed device firmware may be loaded.
.P
Unencrypted hibernation/suspend to swap are disallowed as the kernel image is
saved to a medium that can then be accessed.
.P
Use of debugfs is not permitted as this allows a whole range of actions
including direct configuration of, access to and driving of hardware.
.RE
.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH SEE ALSO
.ad l
.nh


David
---
The following changes since commit 25eabb13c7d67ae32298015c5e28d00f604f412c:

  Merge tag 'v4.14-rc2' into next-general (2017-09-24 22:41:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/lockdown-20171026

for you to fetch changes up to 163d6a313399a4d50c5c7e42e3dd642ca8d495d7:

  efi: Lock down the kernel if booted in secure boot mode (2017-10-26 16:03:19 +0100)

----------------------------------------------------------------
Kernel lockdown

----------------------------------------------------------------
Chun-Yi Lee (1):
      kexec_file: Disable at runtime if the kernel is locked down

Dave Young (1):
      Copy secure_boot flag in boot params across kexec reboot

David Howells (11):
      Add the ability to lock down access to the running kernel image
      Enforce module signatures if the kernel is locked down
      scsi: Lock down the eata driver
      Prohibit PCMCIA CIS storage when the kernel is locked down
      Lock down TIOCSSERIAL
      Lock down module params that specify hardware parameters (eg. ioport)
      x86/mmiotrace: Lock down the testmmiotrace module
      debugfs: Disallow use of debugfs files when the kernel is locked down
      Lock down /proc/kcore
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

 arch/x86/include/asm/setup.h      |   2 +
 arch/x86/kernel/ioport.c          |   6 ++-
 arch/x86/kernel/kexec-bzimage64.c |   1 +
 arch/x86/kernel/msr.c             |  10 ++++
 arch/x86/kernel/setup.c           |  18 ++-----
 arch/x86/mm/testmmiotrace.c       |   3 ++
 drivers/acpi/apei/einj.c          |   3 ++
 drivers/acpi/custom_method.c      |   3 ++
 drivers/acpi/osl.c                |   2 +-
 drivers/acpi/tables.c             |   5 ++
 drivers/char/mem.c                |   2 +
 drivers/firmware/efi/Makefile     |   1 +
 drivers/firmware/efi/secureboot.c |  38 ++++++++++++++
 drivers/input/misc/uinput.c       |   1 +
 drivers/pci/pci-sysfs.c           |   9 ++++
 drivers/pci/proc.c                |   9 +++-
 drivers/pci/syscall.c             |   3 +-
 drivers/pcmcia/cistpl.c           |   3 ++
 drivers/platform/x86/asus-wmi.c   |   9 ++++
 drivers/scsi/eata.c               |   5 +-
 drivers/tty/serial/serial_core.c  |   6 +++
 drivers/tty/sysrq.c               |  19 ++++---
 fs/debugfs/file.c                 |   6 +++
 fs/proc/kcore.c                   |   2 +
 include/linux/efi.h               |  16 +++---
 include/linux/input.h             |   5 ++
 include/linux/kernel.h            |  17 ++++++
 include/linux/security.h          |   8 +++
 include/linux/sysrq.h             |   8 ++-
 kernel/debug/kdb/kdb_main.c       |   2 +-
 kernel/kexec.c                    |   7 +++
 kernel/kexec_file.c               |   7 +++
 kernel/module.c                   |   3 +-
 kernel/params.c                   |  26 +++++++--
 kernel/power/hibernate.c          |   2 +-
 kernel/power/user.c               |   3 ++
 security/Kconfig                  |  30 +++++++++++
 security/Makefile                 |   3 ++
 security/lock_down.c              | 108 ++++++++++++++++++++++++++++++++++++++
 39 files changed, 370 insertions(+), 41 deletions(-)
 create mode 100644 drivers/firmware/efi/secureboot.c
 create mode 100644 security/lock_down.c
