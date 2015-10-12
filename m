From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 00/11] EFI changes for v4.4
Date: Mon, 12 Oct 2015 14:56:03 +0100
Message-ID: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ben Hutchings <ben@decadent.org.uk>, Borislav Petkov <bp@suse.de>, Catalin Marinas <catalin.marinas@arm.com>, Chad Page <chad.page@znyx.com>, Dave Young <dyoung@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, "Lee, Chun-Yi" <jlee@suse.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Pete Hawkins <pete.hawkins@znyx.com>, Peter Jones <pjones@redhat.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Xishi Qiu <qiuxishi@huawei.com>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Folks, please pull the below patches. The largest thing is probably
the introduction of Taku's "efi_fake_mem" kernel option which allows
the EFI memory map passed from the firmware to the kernel to be
modified with additional memory map attributes.

There's also the ground work from Ard for supporting the
EFI_PROPERTIES_TABLE feature, which allows us to use more strict page
mapping attributes for the EFI runtime services regions (such as RO
for code and NX for data). Actually doing that will come in the
future.

Other than that, it's small changes and cleanups.

The following changes since commit 0ce423b6492a02be11662bfaa837dd16945aad3e:

  efi: Use the generic efi.memmap instead of 'memmap' (2015-10-11 11:04:18 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 0f96a99dab366333439e110d6ad253bc7c557c09:

  efi: Add "efi_fake_mem" boot option (2015-10-12 14:20:09 +0100)

----------------------------------------------------------------
 * Make the EFI System Resource Table (ESRT) driver explicitly
   non-modular by ripping out the module_* code since Kconfig doesn't
   allow it to be built as a module anyway - Paul Gortmaker

 * Make the x86 efi=debug kernel parameter, which enables EFI debug
   code and output, generic and usable by arm64 - Leif Lindholm

 * Add support to the x86 EFI boot stub for 64-bit Graphics Output
   Protocol frame buffer addresses - Matt Fleming

 * Detect when the UEFI v2.5 EFI_PROPERTIES_TABLE feature is enabled
   in the firmware and set an efi.flags bit so the kernel knows when
   it can apply more strict runtime mapping attributes - Ard Biesheuvel

 * Auto-load the efi-pstore module on EFI systems, just like we
   currently do for the efivars module - Ben Hutchings

 * Add "efi_fake_mem" kernel parameter which allows the system's EFI
   memory map to be updated with additional attributes for specific
   memory ranges. This is useful for testing the kernel code that handles
   the EFI_MEMORY_MORE_RELIABLE memmap bit even if your firmware
   doesn't include support - Taku Izumi

----------------------------------------------------------------
Ard Biesheuvel (2):
      efi: Add support for UEFIv2.5 Properties table
      efi: Introduce EFI_NX_PE_DATA bit and set it from properties table

Ben Hutchings (1):
      efi: Auto-load the efi-pstore module

Leif Lindholm (3):
      efi/x86: Move efi=debug option parsing to core
      arm64: Use core efi=debug instead of uefi_debug command line parameter
      efi/arm64: Clean up efi_get_fdt_params() interface

Matt Fleming (1):
      efifb: Add support for 64-bit frame buffer addresses

Paul Gortmaker (1):
      drivers/firmware: Make efi/esrt.c driver explicitly non-modular

Taku Izumi (3):
      efi: Add EFI_MEMORY_MORE_RELIABLE support to efi_md_typeattr_format()
      x86/efi: Rename print_efi_memmap() to efi_print_memmap()
      efi: Add "efi_fake_mem" boot option

 Documentation/arm/uefi.txt          |   2 -
 Documentation/kernel-parameters.txt |  15 +++
 arch/arm64/kernel/efi.c             |  19 +--
 arch/x86/boot/compressed/eboot.c    |  24 +++-
 arch/x86/include/asm/efi.h          |   1 +
 arch/x86/kernel/setup.c             |   4 +-
 arch/x86/platform/efi/efi.c         |   6 +-
 drivers/firmware/efi/Kconfig        |  22 ++++
 drivers/firmware/efi/Makefile       |   1 +
 drivers/firmware/efi/efi-pstore.c   |   1 +
 drivers/firmware/efi/efi.c          |  62 +++++++---
 drivers/firmware/efi/esrt.c         |  19 +--
 drivers/firmware/efi/fake_mem.c     | 238 ++++++++++++++++++++++++++++++++++++
 drivers/video/fbdev/efifb.c         |  24 +++-
 include/linux/efi.h                 |  22 +++-
 include/uapi/linux/screen_info.h    |   5 +-
 16 files changed, 400 insertions(+), 65 deletions(-)
 create mode 100644 drivers/firmware/efi/fake_mem.c
