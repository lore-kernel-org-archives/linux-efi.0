From: David Howells <dhowells@redhat.com>
Subject: Why kernel lockdown?
Date: Tue, 11 Apr 2017 00:15:31 +0100
Message-ID: <8559.1491866131@warthog.procyon.org.uk>
References: <25acabf2-ac99-3c2b-ee9a-53d71b5c77f2@gmail.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <25acabf2-ac99-3c2b-ee9a-53d71b5c77f2@gmail.com>
Content-ID: <8558.1491866131.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, alexei.starovoitov@gmail.com, ard.biesheuvel@linaro.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, jlee@suse.com
List-Id: linux-efi@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> Also is there a description of what this lockdown trying to accomplish?

Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:

> ... but for any kind of proper security analysis, you need to better clarify
> your threat model.  'Prevent modification to the running kernel image' is a
> decent start on this, but at least some of the patches don't explain very
> well _how_ what you're disabling could be used to modify the running kernel
> image.  Clarifying how something is a threat will help with verifying that
> you're correctly blocking the threat.

The idea is to properly implement UEFI Secure Boot mode such that we can kexec
another operating system (Linux, Windows, etc.) and pass on the Secure Boot
flag with a guarantee that we haven't been compromised.

This assumes the following:

 (1) Someone wanting to compromise your machine can't get physical access to
     the running hardware.  I think pretty much all bets are off if someone
     gets their hands on your computer.

 (2) Whatever boots our kernel is not itself compromised.  If it is, there's
     pretty much nothing we can do about it.

 (3) Whatever boots our kernel can prove that our kernel is what it says it
     is.


Now, (2) has to start with security right from the system booting, and likely
involves the firmware being checked by the hardware.  The firmware then has to
validate anything it runs, and the things it runs have to validate anything
they run, etc. up to our kernel being booted.

With regard to (3), take the example of booting Fedora Linux on a UEFI PC in
secure boot mode: the UEFI BIOS boots the Fedora SHIM, which boots Grub, which
boots the kernel.  The SHIM is signed by the UEFI signing authority and is
checked against the UEFI key database; Grub and the kernel are signed by a key
built into the SHIM.

[Note that in secure boot mode, Grub loads the kernel image asks the SHIM to
 verify it; further, the SHIM will catch anyone trying to boot without
 verification and halt the machine.]

[Note that we do verification with cryptographic signatures, but compiled-in
 hash whitelists would also work.]

In order to maintain the security guarantee, the kernel then needs to prevent
unauthorised modification of code and data in the running kernel (module
loading is permissible) and also it needs to protect any private keys or other
security data it may hold within the image.  We try to do this by the
following means:

 (1) Refuse to use any key or hash that UEFI has in its blacklist.

 (2) Refuse to load any module that isn't signed/hashed.

 (3) Refuse to load any firmware that isn't signed/hashed.

 (4) Refuse to kexec any image that isn't signed/hashed.

 (5) Refuse to dump a kernel image for software suspend/hibernation if it's
     not encrypted.  Further, if it is encrypted, the key must be protected.

 (6) Refuse to load a dumped kernel image that isn't encrypted with a
     protected key.

 (7) Refuse to allow userspace direct access to kernel memory (no /dev/mem,
     /dev/kmem, /proc/kcore).

 (8) Refuse to allow userspace direct, unsupervised access to hardware (no
     iopl, /dev/ioports, MSRs, etc.).  It might be feasible to open PCI BARs
     through dedicated device files for certain functions though (eg. X
     servers), but unconstrained DMA must be disallowed.

 (9) Refuse to let userspace configure a driver to use a piece of hardware to
     muck around with system RAM, possibly by mismatching driver and device.

> 'Prevent modification to the running kernel image' is a decent start on
> this, but at least some of the patches don't explain very well _how_ what
> you're disabling could be used to modify the running kernel image.

To be honest, I don't know in all cases since I'm taking a collection of
patches not all of which are written by me.  I can see how most of them work,
but some of the more esoteric things, like ACPI...

> Furthermore, why is the only way to enable this to boot in UEFI Secure Boot
> mode?

There's no reason that this need be the case, but it's the one I'm interested
in.  But do note assumption (2) above.  I can provide kernel lockdown in other
situations, but can't forward the guarantee if I wasn't given one to begin
with.

David
