From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Draft manpage explaining kernel lockdown
Date: Thu, 5 Oct 2017 14:53:17 +0100
Message-ID: <CAKv+Gu8D15QBYR16W0hhfdHiA-Uj2YMx-z_D2yVik6SqrDsCeA@mail.gmail.com>
References: <7969.1507201224@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7969.1507201224@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: mtk.manpages@gmail.com, "Luis R. Rodriguez" <mcgrof@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, linux-man@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 5 October 2017 at 12:00, David Howells <dhowells@redhat.com> wrote:
> Hi Ard, Michael,
>
> Attached is a draft for a manual page (kernel_lockdown.7) that I intend to
> point at from messages emitted when the kernel prohibits something because the
> kernel is in 'lockdown' mode, typically triggered by EFI secure boot.
>
> Let me know what you think.
>

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
>         Lockdown: X is restricted, see man kernel_lockdown(7)
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

Hello David,

Thanks for putting this together. I will let others comment on the
details, but in general, this fully addresses my concern regarding the
unrealistic expectations one might create when printing 'your kernel
is in lockdown mode' into the kernel log without any clarification
what this might mean for your particular system.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
