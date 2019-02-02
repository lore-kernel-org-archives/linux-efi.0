From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI fix for v5.0
Date: Sat,  2 Feb 2019 10:50:16 +0100
Message-ID: <20190202095017.13799-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 1c7fc5cbc33980acd13d668f1c8f0313d6ae9fd8:

  Linux 5.0-rc2 (2019-01-14 10:41:12 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 10faccaef2b72b28961b1917719cf6a39c63f0cb:

  efi/arm64: add a terminator for ptdump marker (2019-02-02 10:44:40 +0100)

----------------------------------------------------------------
A single EFI fix for v5.0:
- Fix an out of bounds memory access in the EFI page table dumping routine.

----------------------------------------------------------------
Qian Cai (1):
      efi/arm64: add a terminator for ptdump marker

 drivers/firmware/efi/arm-runtime.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
