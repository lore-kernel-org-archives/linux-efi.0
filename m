From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/7] efi: Pass secure boot mode to kernel [ver #7]
Date: Tue, 31 Jan 2017 15:13:07 +0000
Message-ID: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org


Here's a set of patches that can determine the secure boot state of the
UEFI BIOS and pass that along to the main kernel image.  This involves
generalising ARM's efi_get_secureboot() function and making it mixed-mode
safe.

Changes:

 Ver 7:

  - Rebased on efi/next.
  - Remove the EFI_SECURE_BOOT flag bit and defer it for later.  Don't
  - Preclear boot_params->secure_boot and don't clear it in
    sanitize_boot_params()[*]
  - Don't probe for the secure-boot mode if the boot loader gives us this
    mode (ie. if boot_params->secure_boot is non-zero).
  
    [*] There's a bug in grub2 whereby it copies too much, sets the sentinel
    	byte and triggers the sanitisation.

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

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-secure-boot

at tag:

	efi-secure-boot-20170131

David
---
David Howells (6):
      x86/efi: Allow invocation of arbitrary runtime services
      arm/efi: Allow invocation of arbitrary runtime services
      efi: Add SHIM and image security database GUID definitions
      efi: Get the secure boot status
      efi: Handle secure boot from UEFI-2.6
      efi: Print the secure boot status in x86 setup_arch()

Josh Boyer (1):
      efi: Disable secure boot if shim is in insecure mode


 Documentation/x86/zero-page.txt           |    2 +
 arch/arm/include/asm/efi.h                |    1 
 arch/arm64/include/asm/efi.h              |    1 
 arch/x86/boot/compressed/eboot.c          |    7 ++
 arch/x86/boot/compressed/head_32.S        |    6 +-
 arch/x86/boot/compressed/head_64.S        |    8 +-
 arch/x86/include/asm/efi.h                |    5 +
 arch/x86/include/uapi/asm/bootparam.h     |    3 +
 arch/x86/kernel/asm-offsets.c             |    1 
 arch/x86/kernel/setup.c                   |   14 ++++
 drivers/firmware/efi/libstub/Makefile     |    2 -
 drivers/firmware/efi/libstub/arm-stub.c   |   63 ++----------------
 drivers/firmware/efi/libstub/secureboot.c |   99 +++++++++++++++++++++++++++++
 include/linux/efi.h                       |   15 ++++
 14 files changed, 161 insertions(+), 66 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c

