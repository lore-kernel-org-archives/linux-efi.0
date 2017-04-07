From: Justin Forbes <jmforbes-a5Mqy2EUIFVAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 00/24] Kernel lockdown
Date: Fri, 7 Apr 2017 11:29:54 -0500
Message-ID: <CAFxkdArD3VpvbCDuoQitg1GmBH6euCu7QThd46qZ=qAQHnLDUg@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <25acabf2-ac99-3c2b-ee9a-53d71b5c77f2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25acabf2-ac99-3c2b-ee9a-53d71b5c77f2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Austin S. Hemmelgarn" <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 7, 2017 at 10:59 AM, Austin S. Hemmelgarn
<ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 2017-04-05 16:14, David Howells wrote:
>>
>>
>> These patches provide a facility by which a variety of avenues by which
>> userspace can feasibly modify the running kernel image can be locked down.
>> These include:
>>
>>  (*) No unsigned modules and no modules for which can't validate the
>>      signature.
>>
>>  (*) No use of ioperm(), iopl() and no writing to /dev/port.
>>
>>  (*) No writing to /dev/mem or /dev/kmem.
>>
>>  (*) No hibernation.
>>
>>  (*) Restrict PCI BAR access.
>>
>>  (*) Restrict MSR access.
>>
>>  (*) No kexec_load().
>>
>>  (*) Certain ACPI restrictions.
>>
>>  (*) Restrict debugfs interface to ASUS WMI.
>>
>> The lock-down can be configured to be triggered by the EFI secure boot
>> status, provided the shim isn't insecure.  The lock-down can be lifted by
>> typing SysRq+x on a keyboard attached to the system.
>
> This has already been mentioned both in response to previous versions of
> this patch set, and by at least 2 people in response to a specific patch in
> this posting, but for any kind of proper security analysis, you need to
> better clarify your threat model.  'Prevent modification to the running
> kernel image' is a decent start on this, but at least some of the patches
> don't explain very well _how_ what you're disabling could be used to modify
> the running kernel image.  Clarifying how something is a threat will help
> with verifying that you're correctly blocking the threat.

It is more than just preventing modification to the running kernel
image.  The idea is that everything is verified, from UEFI through the
bootloader, and into the kernel.

> Furthermore, why is the only way to enable this to boot in UEFI Secure Boot
> mode?  Almost all of the hardening done here has general utility in
> hardening regular systems, and as such I'd suggest adding a command line
> option to enable kernel lock-down (which would greatly simplify testing),
> and a kconfig option to enforce it at build-time.

The problem is, if the hand off doesn't happen from a secure firmware,
there is no guarantee the system has not been compromised. UEFI Secure
Boot mode attempts to give that promise, and an appropriate hand off.
That doesn't mean that there is no value in turning some of this on,
it is just of more limited effectiveness.

> In addition to all that, it would be nice to be able to disable all of the
> following at build time independent of the kernel lock-down state
> * The acpi_rsdp kernel parameter (I could easily see many distros building
> kernels with this disabled, it's insanely use-case specific).
> * IO port and resource reservation module parameters (this would actually be
> easier than having runtime blacklisting, and I could also easily see this
> being turned on by default by a number of distros).
> * TOICSERIAL (this one is more likely than the above two to break systems).
>
> And these would probably be useful as lockable sysctls that would be
> automatically locked disabled when the kernel is locked down:
> * ioperm/iopl (these can technically be blocked by seccomp or other means,
> but that is non-trivial to do).
> * Most of the other ACPI stuff (some of this is useful for troubleshooting,
> but is not normally used during regular operation).
> * PCI BAR access.

There are more patches to do some of these things.   Baby steps.
