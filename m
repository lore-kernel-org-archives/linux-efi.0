From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] efi: Pass secure boot mode to kernel
Date: Thu, 08 Dec 2016 11:45:17 +0000
Message-ID: <4561.1481197517@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <4560.1481197517.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt, Ard,

Is it too late to request this for the upcoming merge window?  Also, I've made
Lukas's requested changes and reposted just that patch in my reply to him.  Do
you want me to repost the lot?

Here's a set of patches that can determine the secure boot state of the
UEFI BIOS and pass that along to the main kernel image.  This involves
generalising ARM's efi_get_secureboot() function and making it mixed-mode
safe.

Changes:

 Ver 6:
  - Removed unnecessary variable init and trimmed comment.
  - Return efi_secureboot_mode_disabled directly rather than going to a
    place that just returns it.
  - Switched the last two patches.

 Ver 5:
  - Fix i386 compilation error (rsi should've been changed to esi).
  - Fix arm64 compilation error ('sys_table_arg' is a hidden macro parameter).

 Ver 4:
  - Use an enum to tell the kernel whether secure boot mode is enabled,
    disabled, couldn't be determined or wasn't even tried due to not being
    in EFI mode.
  - Support the UEFI-2.6 DeployedMode flag.
  - Don't clear boot_params->secure_boot in x86 sanitize_boot_params().
  - Preclear the boot_params->secure_boot on x86 head_*.S entry if we may
    not go through efi_main().

David
---
The following changes since commit 018edcfac4c3b140366ad51b0907f3becb5bb624:

  efi/libstub: Make efi_random_alloc() allocate below 4 GB on 32-bit (2016-11-25 07:15:23 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/efi-secure-boot-20161208

for you to fetch changes up to e71dd6bffca41faf7b4458c230e5c3d3c2b16d3e:

  efi: Add EFI_SECURE_BOOT bit (2016-12-08 08:19:04 +0000)

----------------------------------------------------------------
EFI secure boot

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: use typed function pointers for runtime services table

David Howells (5):
      x86/efi: Allow invocation of arbitrary runtime services
      arm/efi: Allow invocation of arbitrary runtime services
      efi: Add SHIM and image security database GUID definitions
      efi: Get the secure boot status
      efi: Handle secure boot from UEFI-2.6

Josh Boyer (2):
      efi: Disable secure boot if shim is in insecure mode
      efi: Add EFI_SECURE_BOOT bit

 Documentation/x86/zero-page.txt           |  2 +
 arch/arm/include/asm/efi.h                |  1 +
 arch/arm64/include/asm/efi.h              |  1 +
 arch/x86/boot/compressed/eboot.c          |  3 +
 arch/x86/boot/compressed/head_32.S        |  7 ++-
 arch/x86/boot/compressed/head_64.S        |  9 +--
 arch/x86/include/asm/bootparam_utils.h    |  5 +-
 arch/x86/include/asm/efi.h                |  5 ++
 arch/x86/include/uapi/asm/bootparam.h     |  3 +-
 arch/x86/kernel/asm-offsets.c             |  1 +
 arch/x86/kernel/setup.c                   | 15 +++++
 drivers/firmware/efi/libstub/Makefile     |  2 +-
 drivers/firmware/efi/libstub/arm-stub.c   | 63 ++------------------
 drivers/firmware/efi/libstub/secureboot.c | 99 +++++++++++++++++++++++++++++++
 include/linux/efi.h                       | 52 ++++++++++------
 15 files changed, 182 insertions(+), 86 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c
