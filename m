From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/2] Final EFI fixes for v4.20
Date: Mon, 17 Dec 2018 19:02:12 +0100
Message-ID: <20181217180214.9436-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>, Qian Cai <cai@gmx.us>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 7566ec393f4161572ba6f11ad5171fd5d59b0fbd:

  Linux 4.20-rc7 (2018-12-16 15:46:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 7b671e6a4917594a4e9ffd64111b8ac2e0323837:

  efi: efi_guid_t must be 64-bit aligned (2018-12-17 10:42:26 +0100)

Note that applying Qian's patch will result in a conflict with the EFI
changes queued for the next window - the solution is to simply drop the
kmemleak_ignore() call since it is not required for page based
allocations.

----------------------------------------------------------------
Final EFI fixes for v4.20:
- prevent false positives from kmemleak for persistent memory reservations
- use the correct alignment for EFI GUIDs, preventing potential crashes in
  firmware calls on 32-bit ARM

----------------------------------------------------------------
Heinrich Schuchardt (1):
      efi: efi_guid_t must be 64-bit aligned

Qian Cai (1):
      efi: let kmemleak ignore false positives

 drivers/firmware/efi/efi.c | 3 +++
 include/linux/efi.h        | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)
