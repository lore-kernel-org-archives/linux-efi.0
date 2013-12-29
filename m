From: Matt Fleming <matt@console-pimps.org>
Subject: [GIT PULL] EFI kexec patches for v3.14
Date: Sun, 29 Dec 2013 13:14:10 +0000
Message-ID: <20131229131410.GB2618@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

Hi Peter,

Please pull the following patches into a separate tip branch for some
testing. These patches add kexec support for EFI systems.

---

The following changes since commit 61d066977583803d333f1e7266b8ba772162dda4:

  Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/efi (2013-11-26 12:23:04 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git kexec

for you to fetch changes up to 518548abd61808ea1e31614ccbdae34d3c32dfa4:

  x86/efi: Delete superfluous global variables (2013-12-29 13:09:08 +0000)

----------------------------------------------------------------
Dave Young (10):
      x86/efi: Remove unused variables in __map_region()
      x86/efi: Add a wrapper function efi_map_region_fixed()
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation
      x86/efi: Cleanup efi_enter_virtual_mode() function
      efi: Export more EFI table variables to sysfs
      efi: Export EFI runtime memory mapping to sysfs
      x86/efi: Pass necessary EFI data for kexec via setup_data
      x86: Add xloadflags bit for EFI runtime support on kexec
      x86: Export x86 boot_params to sysfs
      x86: Reserve setup_data ranges late after parsing memmap cmdline

Matt Fleming (1):
      x86/efi: Delete superfluous global variables

 Documentation/ABI/testing/sysfs-firmware-efi       |  20 ++
 .../ABI/testing/sysfs-firmware-efi-runtime-map     |  34 +++
 Documentation/ABI/testing/sysfs-kernel-boot_params |  38 +++
 Documentation/x86/boot.txt                         |   3 +
 arch/x86/boot/header.S                             |   9 +-
 arch/x86/include/asm/efi.h                         |  13 +
 arch/x86/include/uapi/asm/bootparam.h              |   2 +
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/ksysfs.c                           | 339 +++++++++++++++++++++
 arch/x86/kernel/setup.c                            |   7 +-
 arch/x86/platform/efi/efi.c                        | 308 ++++++++++++++-----
 arch/x86/platform/efi/efi_32.c                     |   3 +
 arch/x86/platform/efi/efi_64.c                     |  21 +-
 drivers/firmware/efi/Kconfig                       |  11 +
 drivers/firmware/efi/Makefile                      |   1 +
 drivers/firmware/efi/efi.c                         |  45 ++-
 drivers/firmware/efi/runtime-map.c                 | 181 +++++++++++
 include/linux/efi.h                                |  16 +
 18 files changed, 970 insertions(+), 82 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-boot_params
 create mode 100644 arch/x86/kernel/ksysfs.c
 create mode 100644 drivers/firmware/efi/runtime-map.c

-- 
Matt Fleming, Intel Open Source Technology Center
