From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/2] EFI fixes for v4.11-rc
Date: Wed,  1 Mar 2017 19:04:34 +0000
Message-ID: <1488395076-29712-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

The following changes since commit 6053dc981449718d90a429933e99b441e1adaea6:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2017-03-01 10:32:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 2f0db11e7e12538bfe5483f7f113481c3443f151:

  efi: arm: Fix boot crash with CONFIG_CPUMASK_OFFSTACK=y (2017-03-01 18:45:02 +0000)

Please pull.

----------------------------------------------------------------
Two bug fixes for UEFI:
- don't complain about the Secure Boot status being undetectable on systems
  that are not Secure Boot capable to begin with,
- for stable: fix a panic when booting Fedora's 32-bit ARM kernel in UEFI mode,
  caused by an unexpected interaction with CONFIG_CPUMASK_OFFSTACK=y.

----------------------------------------------------------------
Ard Biesheuvel (2):
      efi: libstub: Treat missing SecureBoot variable as S/B disabled
      efi: arm: Fix boot crash with CONFIG_CPUMASK_OFFSTACK=y

 drivers/firmware/efi/arm-runtime.c        | 1 +
 drivers/firmware/efi/libstub/secureboot.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)
