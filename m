From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/8] efi: Pass secure boot mode to kernel [ver #4]
Date: Wed, 07 Dec 2016 11:11:17 +0000
Message-ID: <148110907725.11513.15923870640212286383.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


Here's a set of patches that can determine the secure boot state of the
UEFI BIOS and pass that along to the main kernel image.  This involves
generalising ARM's efi_get_secureboot() function and making it mixed-mode
safe.

Changes:

 Ver 4:

  - Use an enum to tell the kernel whether secure boot mode is enabled,
    disabled, couldn't be determined or wasn't even tried due to not being
    in EFI mode.

  - Support the UEFI-2.6 DeployedMode flag.

  - Don't clear boot_params->secure_boot in x86 sanitize_boot_params().

  - Preclear the boot_params->secure_boot on x86 head_*.S entry if we may
    not go through efi_main().

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-secure-boot

at tag:

	efi-secure-boot-20161207

Note that the patches are not terminal on the branch.

David
---
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


 Documentation/x86/zero-page.txt           |    2 +
 arch/arm/include/asm/efi.h                |    1 
 arch/arm64/include/asm/efi.h              |    1 
 arch/x86/boot/compressed/eboot.c          |    3 +
 arch/x86/boot/compressed/head_32.S        |    7 +-
 arch/x86/boot/compressed/head_64.S        |    9 +--
 arch/x86/include/asm/bootparam_utils.h    |    5 +
 arch/x86/include/asm/efi.h                |    5 +
 arch/x86/include/uapi/asm/bootparam.h     |    3 +
 arch/x86/kernel/asm-offsets.c             |    1 
 arch/x86/kernel/setup.c                   |   15 ++++
 drivers/firmware/efi/libstub/Makefile     |    2 -
 drivers/firmware/efi/libstub/arm-stub.c   |   58 +---------------
 drivers/firmware/efi/libstub/secureboot.c |  102 +++++++++++++++++++++++++++++
 include/linux/efi.h                       |   52 ++++++++++-----
 15 files changed, 182 insertions(+), 84 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c
