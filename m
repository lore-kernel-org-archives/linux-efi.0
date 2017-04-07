From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH 00/24] Kernel lockdown
Date: Fri, 7 Apr 2017 11:59:22 -0400
Message-ID: <25acabf2-ac99-3c2b-ee9a-53d71b5c77f2@gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 2017-04-05 16:14, David Howells wrote:
>
> These patches provide a facility by which a variety of avenues by which
> userspace can feasibly modify the running kernel image can be locked down.
> These include:
>
>  (*) No unsigned modules and no modules for which can't validate the
>      signature.
>
>  (*) No use of ioperm(), iopl() and no writing to /dev/port.
>
>  (*) No writing to /dev/mem or /dev/kmem.
>
>  (*) No hibernation.
>
>  (*) Restrict PCI BAR access.
>
>  (*) Restrict MSR access.
>
>  (*) No kexec_load().
>
>  (*) Certain ACPI restrictions.
>
>  (*) Restrict debugfs interface to ASUS WMI.
>
> The lock-down can be configured to be triggered by the EFI secure boot
> status, provided the shim isn't insecure.  The lock-down can be lifted by
> typing SysRq+x on a keyboard attached to the system.
This has already been mentioned both in response to previous versions of 
this patch set, and by at least 2 people in response to a specific patch 
in this posting, but for any kind of proper security analysis, you need 
to better clarify your threat model.  'Prevent modification to the 
running kernel image' is a decent start on this, but at least some of 
the patches don't explain very well _how_ what you're disabling could be 
used to modify the running kernel image.  Clarifying how something is a 
threat will help with verifying that you're correctly blocking the threat.

Furthermore, why is the only way to enable this to boot in UEFI Secure 
Boot mode?  Almost all of the hardening done here has general utility in 
hardening regular systems, and as such I'd suggest adding a command line 
option to enable kernel lock-down (which would greatly simplify 
testing), and a kconfig option to enforce it at build-time.

In addition to all that, it would be nice to be able to disable all of 
the following at build time independent of the kernel lock-down state
* The acpi_rsdp kernel parameter (I could easily see many distros 
building kernels with this disabled, it's insanely use-case specific).
* IO port and resource reservation module parameters (this would 
actually be easier than having runtime blacklisting, and I could also 
easily see this being turned on by default by a number of distros).
* TOICSERIAL (this one is more likely than the above two to break systems).

And these would probably be useful as lockable sysctls that would be 
automatically locked disabled when the kernel is locked down:
* ioperm/iopl (these can technically be blocked by seccomp or other 
means, but that is non-trivial to do).
* Most of the other ACPI stuff (some of this is useful for 
troubleshooting, but is not normally used during regular operation).
* PCI BAR access.
