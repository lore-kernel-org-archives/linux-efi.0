From: David Howells <dhowells@redhat.com>
Subject: [GIT PULL] Kernel lockdown for secure boot
Date: Sat, 31 Mar 2018 00:29:44 +0100
Message-ID: <4136.1522452584@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-ID: <4135.1522452584.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: dhowells@redhat.com, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, mjg59@google.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Date: Thu, 26 Oct 2017 17:37:38 +0100

Hi James,

Can you pull this patchset into security/next please?  It has been in
linux-next since the beginning of March.

It adds kernel lockdown support for EFI secure boot.

There's a manual page (kernel_lockdown.7) associated with this:

.\"
.\" Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
.\" Written by David Howells (dhowells@redhat.com)
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
	Lockdown: X: Y is restricted, see man kernel_lockdown.7
.RE
.P
where X indicates the process name and Y indicates what is restricted.
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
When lockdown is in effect, a number of features are disabled or have their use
restricted.  This includes special device files and kernel services that allow
direct access of the kernel image:
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
BPF
.br
kprobes
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
Certain facilities are restricted:
.P
.RS
Only validly signed modules may be loaded (waived if the module file being
loaded is vouched for by IMA appraisal).
.P
Only validly signed binaries may be kexec'd (waived if the binary image file to
be executed is vouched for by IMA appraisal).
.P
Unencrypted hibernation/suspend to swap are disallowed as the kernel image is
saved to a medium that can then be accessed.
.P
Use of debugfs is not permitted as this allows a whole range of actions
including direct configuration of, access to and driving of hardware.
.P
IMA requires the addition of the "secure_boot" rules to the policy, whether or
not they are specified on the command line, for both the builtin and custom
policies in secure boot lockdown mode.
.RE


David
---
The following changes since commit 6f70eb2b00eb416146247c65003d31f4df983ce0:

  Merge branch 'idr-2018-02-06' of git://git.infradead.org/users/willy/linux-dax (2018-02-26 13:22:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/lockdown-20180330

for you to fetch changes up to 89bcd5b02f125335f74289c5f4ae03e9b893ab7f:

  lockdown: Print current->comm in restriction messages (2018-02-28 14:43:03 +0000)

----------------------------------------------------------------
Kernel lockdown

----------------------------------------------------------------
Dave Young (1):
      Copy secure_boot flag in boot params across kexec reboot

David Howells (15):
      Add the ability to lock down access to the running kernel image
      Enforce module signatures if the kernel is locked down
      scsi: Lock down the eata driver
      Prohibit PCMCIA CIS storage when the kernel is locked down
      Lock down TIOCSSERIAL
      Lock down module params that specify hardware parameters (eg. ioport)
      x86/mmiotrace: Lock down the testmmiotrace module
      Lock down /proc/kcore
      Lock down kprobes
      bpf: Restrict kernel image access functions when the kernel is locked down
      Lock down perf
      debugfs: Restrict debugfs when the kernel is locked down
      efi: Add an EFI_SECURE_BOOT flag to indicate secure boot mode
      efi: Lock down the kernel if booted in secure boot mode
      lockdown: Print current->comm in restriction messages

Jiri Bohac (2):
      kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE
      kexec_file: Restrict at runtime if the kernel is locked down

Josh Boyer (2):
      hibernate: Disable when the kernel is locked down
      acpi: Ignore acpi_rsdp kernel param when the kernel has been locked down

Kyle McMartin (1):
      Add a SysRq option to lift kernel lockdown

Linn Crosetto (2):
      acpi: Disable ACPI table override if the kernel is locked down
      acpi: Disable APEI error injection if the kernel is locked down

Matthew Garrett (7):
      Restrict /dev/{mem,kmem,port} when the kernel is locked down
      kexec_load: Disable at runtime if the kernel is locked down
      uswsusp: Disable when the kernel is locked down
      PCI: Lock down BAR access when the kernel is locked down
      x86: Lock down IO port access when the kernel is locked down
      x86/msr: Restrict MSR access when the kernel is locked down
      ACPI: Limit access to custom_method when the kernel is locked down

Mimi Zohar (1):
      ima: require secure_boot rules in lockdown mode

 arch/x86/Kconfig                       |  20 ++++--
 arch/x86/include/asm/setup.h           |   2 +
 arch/x86/kernel/ioport.c               |   6 +-
 arch/x86/kernel/kexec-bzimage64.c      |   1 +
 arch/x86/kernel/machine_kexec_64.c     |   2 +-
 arch/x86/kernel/msr.c                  |  10 +++
 arch/x86/kernel/setup.c                |  18 ++----
 arch/x86/mm/testmmiotrace.c            |   3 +
 crypto/asymmetric_keys/verify_pefile.c |   4 +-
 drivers/acpi/apei/einj.c               |   3 +
 drivers/acpi/custom_method.c           |   3 +
 drivers/acpi/osl.c                     |   2 +-
 drivers/acpi/tables.c                  |   5 ++
 drivers/char/mem.c                     |   2 +
 drivers/firmware/efi/Makefile          |   1 +
 drivers/firmware/efi/secureboot.c      |  38 ++++++++++++
 drivers/input/misc/uinput.c            |   1 +
 drivers/pci/pci-sysfs.c                |   9 +++
 drivers/pci/proc.c                     |   9 ++-
 drivers/pci/syscall.c                  |   3 +-
 drivers/pcmcia/cistpl.c                |   3 +
 drivers/scsi/eata.c                    |   5 +-
 drivers/tty/serial/serial_core.c       |   6 ++
 drivers/tty/sysrq.c                    |  19 ++++--
 fs/debugfs/file.c                      |  28 +++++++++
 fs/debugfs/inode.c                     |  30 ++++++++-
 fs/proc/kcore.c                        |   2 +
 include/linux/efi.h                    |  16 +++--
 include/linux/input.h                  |   5 ++
 include/linux/kernel.h                 |  17 ++++++
 include/linux/kexec.h                  |   4 +-
 include/linux/security.h               |   8 +++
 include/linux/sysrq.h                  |   8 ++-
 kernel/bpf/syscall.c                   |   3 +
 kernel/debug/kdb/kdb_main.c            |   2 +-
 kernel/events/core.c                   |   5 ++
 kernel/kexec.c                         |   7 +++
 kernel/kexec_file.c                    |  56 ++++++++++++++---
 kernel/kprobes.c                       |   3 +
 kernel/module.c                        |  56 +++++++++++++----
 kernel/params.c                        |  26 ++++++--
 kernel/power/hibernate.c               |   2 +-
 kernel/power/user.c                    |   3 +
 security/Kconfig                       |  32 ++++++++++
 security/Makefile                      |   3 +
 security/integrity/ima/ima_policy.c    |  39 +++++++++---
 security/lock_down.c                   | 108 +++++++++++++++++++++++++++++++++
 47 files changed, 557 insertions(+), 81 deletions(-)
 create mode 100644 drivers/firmware/efi/secureboot.c
 create mode 100644 security/lock_down.c
