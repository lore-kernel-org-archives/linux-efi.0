From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Tue, 30 May 2017 18:57:35 +0000
Message-ID: <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 24 May 2017 at 14:45, David Howells <dhowells@redhat.com> wrote:
>
> Here's a set of patches to institute a "locked-down mode" in the kernel and
> to set that mode if the kernel is booted in secure-boot mode.  This can be
> enabled with CONFIG_LOCK_DOWN_KERNEL.  If a kernel is locked down, the
> lockdown can be lifted by typing SysRq+x on a keyboard attached to the
> machine if CONFIG_EFI_ALLOW_SECURE_BOOT_EXIT is enabled.  The exact key can
> be configured as 'x' is already taken on some arches.
>
> Inside the kernel, kernel_is_locked_down() is used to check if the kernel
> is in lockdown mode.  In lock-down mode, at least the following
> restrictions will need to be emplaced:
>
>  (1) No unsigned modules, kexec images or firmware.
>
>  (2) No direct read/write access of the kernel image.  (Shouldn't be able
>      to modify it and shouldn't be able to read out crypto data).
>
>  (3) No direct access to devices.  (DMA could be used to access/modify the
>      kernel image).
>
>  (4) No manual setting of device register addresses to cause a driver for
>      one device to mess around with another device, thereby permitting DMA.
>
>  (5) No storage of unencrypted kernel image to disk (no suspend-to-disk
>      without hardware support).
>
> I have patches pending that effect most of the above.  However, the
> firmware signature checking is being handled by someone else.  Further, it
> has come to light recently that debugfs needs attention, so that isn't done
> yet.
>
> Note that the secure boot mode entry doesn't currently work if the kernel
> is booted from current i386/x86_64 Grub as there's a bug in Grub whereby it
> doesn't initialise the boot_params correctly.  The incorrect initialisation
> causes sanitize_boot_params() to be triggered, thereby zapping the secure
> boot flag determined by the EFI boot wrapper.
>

Hello David,

By itself, this series looks in reasonable shape to me. But I do have
a few remaining concerns, apologies if it includes issues that I could
have brought up earlier.

- The series conflates 'UEFI secure boot support' with 'kernel lock
down support'. I think this has been brought up before, but I really
think we should have a cleaner separation between the feature (locking
down various bits of the kernel if lockdown is in effect) from the
policy 'enable lockdown if UEFI secure boot is enabled'. The latter
does not need to be configurable at all: on any UEFI system, we could
detect whether UEFI secure boot is in effect and report it. The only
tunable we need is in the lockdown context, whether lockdown needs to
take effect automatically when UEFI secure boot is detected (but there
could be other ways to enable lockdown, including a kernel cmdline
param or a sysfs node). Similarly, whether lockdown can be lifted or
not has *nothing* to do with whether it was enabled due to UEFI secure
boot, so I don't see the point of having
CONFIG_EFI_ALLOW_SECURE_BOOT_EXIT at all.

- The current series enables lockdown, but does not lock anything
down. Even if the code is in good shape otherwise, I am reluctant to
ack and/or merge anything right now, given that it provides a false
sense of security. This also ties in to my more general concerns with
this code (and I am aware I never replied to your email explaining it,
my apologies [again]): without any sense of how large the attack
surface is now, and how much we reduced it by implementing the items
on your list above, we should really not be making claims of security,
given that we really have no idea how much more secure we are. That
said, I do subscribe to the effort, in the sense that moving towards
the goal is strictly better than moving away from it, or not at all.

- Patch 5/5 breaks the build on non-x86. Please build test EFI-related
patches on arm64 and/or ARM before submitting patches. And if
possible, could we find a magic SysRq key that works on all
architectures? I know we discussed this at some point (I think?) but I
don't remember the conclusion.

Regards,
Ard.


> ---
> David Howells (3):
>       efi: Move the x86 secure boot switch to generic code
>       Add the ability to lock down access to the running kernel image
>       efi: Lock down the kernel if booted in secure boot mode
>
> Josh Boyer (1):
>       efi: Add EFI_SECURE_BOOT bit
>
> Kyle McMartin (1):
>       Add a sysrq option to exit secure boot mode
>
>
>  arch/x86/include/asm/efi.h        |    2 +
>  arch/x86/kernel/setup.c           |   14 ------
>  drivers/firmware/efi/Kconfig      |   34 ++++++++++++++++
>  drivers/firmware/efi/Makefile     |    1
>  drivers/firmware/efi/secureboot.c |   80 +++++++++++++++++++++++++++++++++++++
>  drivers/input/misc/uinput.c       |    1
>  drivers/tty/sysrq.c               |   19 ++++++---
>  include/linux/efi.h               |    7 +++
>  include/linux/input.h             |    5 ++
>  include/linux/kernel.h            |    9 ++++
>  include/linux/security.h          |   11 +++++
>  include/linux/sysrq.h             |    8 +++-
>  kernel/debug/kdb/kdb_main.c       |    2 -
>  security/Kconfig                  |   15 +++++++
>  security/Makefile                 |    3 +
>  security/lock_down.c              |   46 +++++++++++++++++++++
>  16 files changed, 236 insertions(+), 21 deletions(-)
>  create mode 100644 drivers/firmware/efi/secureboot.c
>  create mode 100644 security/lock_down.c
>
