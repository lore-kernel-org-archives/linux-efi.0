From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Draft manpage explaining kernel lockdown
Date: Wed, 18 Oct 2017 10:21:35 +0200
Message-ID: <95c53500-eae9-6c03-8bc5-f1ba62475711@gmail.com>
References: <7969.1507201224@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <7969.1507201224@warthog.procyon.org.uk>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mtk.manpages@gmail.com, mcgrof@kernel.org, johannes@sipsolutions.net, linux-man@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi David,

On 10/05/2017 01:00 PM, David Howells wrote:
> Hi Ard, Michael,
> 
> Attached is a draft for a manual page (kernel_lockdown.7) that I intend to
> point at from messages emitted when the kernel prohibits something because the
> kernel is in 'lockdown' mode, typically triggered by EFI secure boot.
> 
> Let me know what you think.

Thanks for the page proposal. Several people sent feedback. Will you
revise the draft?

Thanks,

Michael


> David
> ---
> .\"
> .\" Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
> .\" Written by David Howells (dhowells@redhat.com)
> .\"
> .\" %%%LICENSE_START(GPLv2+_SW_ONEPARA)
> .\" This program is free software; you can redistribute it and/or
> .\" modify it under the terms of the GNU General Public License
> .\" as published by the Free Software Foundation; either version
> .\" 2 of the License, or (at your option) any later version.
> .\" %%%LICENSE_END
> .\"
> .TH "KERNEL LOCKDOWN" 7 2017-10-05 Linux "Linux Programmer's Manual"
> .SH NAME
> Kernel Lockdown \- Kernel image access prevention feature
> .SH DESCRIPTION
> The Kernel Lockdown feature is designed to prevent both direct and indirect
> access to a running kernel image, attempting to protect against unauthorised
> modification of the kernel image and to prevent access to security and
> cryptographic data located in kernel memory, whilst still permitting driver
> modules to be loaded.
> .P
> Lockdown is typically enabled during boot and may be terminated, if configured,
> by typing a special key combination on a directly attached physical keyboard.
> .P
> If a prohibited or restricted feature is accessed or used, the kernel will emit
> a message that looks like:
> .P
> .RS
> 	Lockdown: X is restricted, see man kernel_lockdown(7)
> .RE
> .P
> where X indicates what is restricted.
> .P
> On an EFI-enabled x86 or arm64 machine, lockdown will be automatically enabled
> if the system boots in EFI Secure Boot mode.
> .P
> If the kernel is appropriately configured, lockdown may be lifted by typing the
> appropriate sequence on a directly attached physical keyboard.  For x86
> machines, this is
> .IR SysRq+x .
> .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> .SH COVERAGE
> When lockdown is in effect, a number of things are disabled or restricted in
> use.  This includes special device files and kernel services that allow direct
> access of the kernel image:
> .P
> .RS
> /dev/mem
> .br
> /dev/kmem
> .br
> /dev/kcore
> .br
> /dev/ioports
> .br
> BPF memory access functions
> .RE
> .P
> and the ability to directly configure and control devices, so as to prevent the
> use of a device to access or modify a kernel image:
> .P
> .RS
> The use of module parameters that directly specify hardware parameters to
> drivers through the kernel command line or when loading a module.
> .P
> The use of direct PCI BAR access.
> .P
> The use of the ioperm and iopl instructions on x86.
> .P
> The use of the KD*IO console ioctls.
> .P
> The use of the TIOCSSERIAL serial ioctl.
> .P
> The alteration of MSR registers on x86.
> .P
> The replacement of the PCMCIA CIS.
> .P
> The overriding of ACPI tables.
> .P
> The use of ACPI error injection.
> .P
> The specification of the ACPI RDSP address.
> .P
> The use of ACPI custom methods.
> .RE
> .P
> The following facilities are restricted:
> .P
> .RS
> Only validly signed modules may be loaded.
> .P
> Only validly signed binaries may be kexec'd.
> .P
> Only validly signed device firmware may be loaded.
> .P
> Only validly signed wifi databases may be use.
> .P
> Unencrypted hibernation/suspend to swap are disallowed as the kernel image is
> saved to a medium that can then be accessed.
> .P
> Use of debugfs is not permitted as this allows a whole range of actions
> including direct configuration of, access to and driving of hardware.
> .RE
> .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
> .SH SEE ALSO
> .ad l
> .nh
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
