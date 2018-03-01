From: David Howells <dhowells@redhat.com>
Subject: linux-next: UEFI Secure boot lockdown patchset
Date: Thu, 01 Mar 2018 11:06:55 +0000
Message-ID: <26787.1519902415@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sfr@canb.auug.org.au
Cc: dhowells@redhat.com, jmorris@namei.org, jforbes@redhat.com, mjg59@google.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
List-Id: linux-efi@vger.kernel.org

--=-=-=
Content-Type: text/plain


Hi Stephen,

Can you pull the following branch into linux-next please?  It does three
things:

 (1) It restricts various accesses userspace may make upon the kernel when the
     kernel is locked down.

 (2) It engages the lockdown if UEFI Secure Boot mode is detected.

 (3) It passes the UEFI Secure Boot mode indication across kexec.

The restrictions include:

 - Enforcing the use of module signatures
 - Enforcing the use of kexec image signatures
 - Requring IMA to use secure boot rules
 - Disabling:
   - The kexec_load() syscall
   - Use of /dev/{mem,kmem,port,kcore}
   - Hibernation
   - PCI BAR access
   - Direct I/O port access
 - Preventing direct port specification in drivers:
   - SCSI EATA
   - TIOCSSERIAL
   - Module parameters
 - Restricting:
   - MSR access
   - Certain ACPI features
   - kprobes
   - BPF
   - Perf
   - Debugfs

The aim of the restrictions is twofold:

  (1) Prevent userspace from altering the kernel image directly (eg. by
      /dev/mem) or indirectly (eg. by manipulating a device to do DMA);

  (2) Prevent userspace from accessing crypto data stored in the kernel
      (eg. filesystem keys).

A warning is logged if a restriction is triggered for which I've written a
manpage that is referenced in the message (see attached).

David


--=-=-=
Content-Type: text/troff
Content-Disposition: attachment; filename=kernel_lockdown.7
Content-Description: Lockdown manpage

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

--=-=-=--
