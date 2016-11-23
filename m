From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/7] efi: Pass secure boot mode to kernel [ver #3]
Date: Wed, 23 Nov 2016 12:53:33 +0000
Message-ID: <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: lukas@wunner.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org


Here's a set of patches that can determine the secure boot state of the
UEFI BIOS and pass that along to the main kernel image.  This involves
generalising ARM's efi_get_secureboot() function and making it mixed-mode
safe.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-secure-boot

at tag:

	efi-secure-boot-20161123-2

Note that the patches are not terminal on the branch.

David
---
Ard Biesheuvel (1):
      efi: use typed function pointers for runtime services table

David Howells (4):
      x86/efi: Allow invocation of arbitrary runtime services
      arm/efi: Allow invocation of arbitrary runtime services
      efi: Add SHIM and image security database GUID definitions
      efi: Get the secure boot status

Josh Boyer (2):
      efi: Disable secure boot if shim is in insecure mode
      efi: Add EFI_SECURE_BOOT bit


 Documentation/x86/zero-page.txt           |    2 +
 arch/arm/include/asm/efi.h                |    1 
 arch/arm64/include/asm/efi.h              |    1 
 arch/x86/boot/compressed/eboot.c          |    3 +
 arch/x86/boot/compressed/head_32.S        |    6 +-
 arch/x86/boot/compressed/head_64.S        |    8 +-
 arch/x86/include/asm/efi.h                |    5 ++
 arch/x86/include/uapi/asm/bootparam.h     |    3 +
 arch/x86/kernel/setup.c                   |    5 ++
 drivers/firmware/efi/libstub/Makefile     |    2 -
 drivers/firmware/efi/libstub/arm-stub.c   |   46 --------------
 drivers/firmware/efi/libstub/secureboot.c |   93 +++++++++++++++++++++++++++++
 include/linux/efi.h                       |   42 +++++++------
 13 files changed, 144 insertions(+), 73 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c

