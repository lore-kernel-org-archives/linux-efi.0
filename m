From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI fix for v4.18
Date: Fri, 20 Jul 2018 10:28:45 +0900
Message-ID: <20180720012846.23560-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 9d3cce1e8b8561fed5f383d22a4d6949db4eadbe:

  Linux 4.18-rc5 (2018-07-15 12:49:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-urgent

for you to fetch changes up to b0d2fc41203d3712585b71d8f14914ff6a266278:

  x86/efi: Access EFI MMIO data as unencrypted when SEV is active (2018-07-17 11:10:56 +0800)

----------------------------------------------------------------
Apply a fix from Brijesh to prevent the [unencrypted] SPI flash from
being mapped with the encryption bit set when running with SEV enabled.

----------------------------------------------------------------
Brijesh Singh (1):
      x86/efi: Access EFI MMIO data as unencrypted when SEV is active

 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
