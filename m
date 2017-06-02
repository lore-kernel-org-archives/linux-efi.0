From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/13] First batch of EFI updates for v4.13
Date: Fri,  2 Jun 2017 13:51:54 +0000
Message-ID: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Borislav Petkov <bp@alien8.de>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Fabian Frederick <fabf@skynet.be>, Geliang Tang <geliangtang@gmail.com>, Ivan Hu <ivan.hu@canonical.com>, Jan Kiszka <jan.kiszka@siemens.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ravi Shankar <ravi.v.shankar@intel.com>, Ricardo Neri <ricardo.neri@intel.com>, Russell King <rmk+kernel@armlinux.org.uk>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 5ed02dbb497422bf225783f46e6eadd237d23d6b:

  Linux 4.12-rc3 (2017-05-28 17:20:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 3acbd5a24ab9d9a82c56d9018f4d340fa574b91d:

  efi: arm: enable DMI/SMBIOS (2017-06-02 13:38:56 +0000)

----------------------------------------------------------------
First batch of EFI changes for v4.13:
- rework the EFI capsule loader to allow for workarounds for non-compliant
  firmware to be implemented more easily and in a more self contained
  manner (Ard)
- implement a capsule loader quirk for Quark X102x, which prepends a
  security header in a non-compliant way (Jan Kiszka)
- enable SMBIOS/DMI support for the ARM architecture (Ard)
- add EFI_PGT_DUMP support for x86_32 and kexec (Sai Praneeth)
- some other cleanups

----------------------------------------------------------------
Andy Lutomirski (1):
      x86/efi: Clean up efi CR3 save/restore

Ard Biesheuvel (4):
      efi/capsule-loader: Use a cached copy of the capsule header
      efi/capsule-loader: Redirect calls to efi_capsule_setup_info via weak alias
      efi/capsule-loader: Use page addresses rather than struct page pointers
      efi: arm: enable DMI/SMBIOS

Fabian Frederick (1):
      efi/capsule: Remove NULL test on kmap()

Geliang Tang (1):
      efi/efi_test: Use memdup_user() helper

Jan Kiszka (5):
      efi/capsule: Fix return code on failing kmap/vmap
      efi/capsule: Remove pr_debug on ENOMEM or EFAULT
      efi/capsule: Clean up pr_err/info messages
      efi/capsule: Adjust return type of efi_capsule_setup_info
      efi/capsule: Add support for Quark security header

Sai Praneeth (1):
      x86/efi: Add EFI_PGT_DUMP support for x86_32 and kexec

 arch/arm/Kconfig                      |  17 +++++
 arch/arm/include/asm/dmi.h            |  19 +++++
 arch/arm64/kernel/efi.c               |  15 ----
 arch/x86/include/asm/efi.h            |  17 ++++-
 arch/x86/platform/efi/efi.c           |   9 ++-
 arch/x86/platform/efi/efi_32.c        |  21 ++++--
 arch/x86/platform/efi/efi_64.c        |  27 ++++---
 arch/x86/platform/efi/quirks.c        | 137 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/Kconfig          |   9 +++
 drivers/firmware/efi/arm-runtime.c    |  16 ++++
 drivers/firmware/efi/capsule-loader.c | 117 ++++++++++++-----------------
 drivers/firmware/efi/capsule.c        |  11 +--
 drivers/firmware/efi/test/efi_test.c  |  11 +--
 include/linux/efi.h                   |  14 +++-
 14 files changed, 317 insertions(+), 123 deletions(-)
 create mode 100644 arch/arm/include/asm/dmi.h
