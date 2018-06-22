From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI fix for v4.18
Date: Fri, 22 Jun 2018 08:42:21 +0200
Message-ID: <20180622064222.11633-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 9cd00e314dee25f9b2e2c47759988cb353165011:

  efi/libstub/tpm: Initialize efi_physical_addr_t vars to zero for mixed mode (2018-06-22 08:36:20 +0200)

----------------------------------------------------------------
EFI fix for v4.18:
- initialize some efi_physical_addr_t variables to 0 so that buggy 32-bit
  TPM UEFI code that only sets the lower 32 bits will work as expected.

----------------------------------------------------------------
Hans de Goede (1):
      efi/libstub/tpm: Initialize efi_physical_addr_t vars to zero for mixed mode

 drivers/firmware/efi/libstub/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
