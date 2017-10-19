From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Thu, 19 Oct 2017 15:50:32 +0100
Message-ID: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
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
amongst other things.

I'm aware there may be things that aren't yet handled, but we can add those
later.

====================
PROPOSED MANUAL PAGE
====================

.\"
.\" Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
.\" Written by David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
.\"
.\" % % %LICENSE_START(GPLv2+_SW_ONEPARA)
.\" This program is free software; you can redistribute it and/or
.\" modify it under the terms of the GNU General Public License
.\" as published by the Free Software Foundation; either version
.\" 2 of the License, or (at your option) any later version.
.\" % % %LICENSE_END
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
.br
BPF memory access functions
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


The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-lock-down

Tagged thusly:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	lockdown-20171019

David
---
Chun-Yi Lee (2):
      kexec_file: Disable at runtime if securelevel has been set
      bpf: Restrict kernel image access functions when the kernel is locked down

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
      Restrict /dev/mem and /dev/kmem when the kernel is locked down
      kexec: Disable at runtime if the kernel is locked down
      uswsusp: Disable when the kernel is locked down
      PCI: Lock down BAR access when the kernel is locked down
      x86: Lock down IO port access when the kernel is locked down
      x86/msr: Restrict MSR access when the kernel is locked down
      asus-wmi: Restrict debugfs interface when the kernel is locked down
      ACPI: Limit access to custom_method when the kernel is locked down


 arch/x86/include/asm/setup.h      |    2 +
 arch/x86/kernel/ioport.c          |    6 +-
 arch/x86/kernel/kexec-bzimage64.c |    1 
 arch/x86/kernel/msr.c             |    7 ++
 arch/x86/kernel/setup.c           |   18 +-----
 arch/x86/mm/testmmiotrace.c       |    3 +
 drivers/acpi/apei/einj.c          |    3 +
 drivers/acpi/custom_method.c      |    3 +
 drivers/acpi/osl.c                |    2 -
 drivers/acpi/tables.c             |    5 ++
 drivers/char/mem.c                |    8 +++
 drivers/firmware/efi/Makefile     |    1 
 drivers/firmware/efi/secureboot.c |   37 +++++++++++++
 drivers/input/misc/uinput.c       |    1 
 drivers/pci/pci-sysfs.c           |    9 +++
 drivers/pci/proc.c                |    9 +++
 drivers/pci/syscall.c             |    3 +
 drivers/pcmcia/cistpl.c           |    3 +
 drivers/platform/x86/asus-wmi.c   |    9 +++
 drivers/scsi/eata.c               |    5 +-
 drivers/tty/serial/serial_core.c  |    6 ++
 drivers/tty/sysrq.c               |   19 ++++--
 fs/debugfs/file.c                 |    6 ++
 fs/proc/kcore.c                   |    2 +
 include/linux/efi.h               |   16 +++--
 include/linux/input.h             |    5 ++
 include/linux/kernel.h            |   17 ++++++
 include/linux/security.h          |    8 +++
 include/linux/sysrq.h             |    8 ++-
 kernel/debug/kdb/kdb_main.c       |    2 -
 kernel/kexec.c                    |    7 ++
 kernel/kexec_file.c               |    7 ++
 kernel/module.c                   |    3 +
 kernel/params.c                   |   26 +++++++--
 kernel/power/hibernate.c          |    2 -
 kernel/power/user.c               |    3 +
 kernel/trace/bpf_trace.c          |   11 ++++
 security/Kconfig                  |   37 +++++++++++++
 security/Makefile                 |    3 +
 security/lock_down.c              |  109 +++++++++++++++++++++++++++++++++++++
 40 files changed, 391 insertions(+), 41 deletions(-)
 create mode 100644 drivers/firmware/efi/secureboot.c
 create mode 100644 security/lock_down.c
