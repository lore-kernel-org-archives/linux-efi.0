From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI fix for v4.20
Date: Fri, 23 Nov 2018 22:51:31 +0100
Message-ID: <20181123215132.7951-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Jan Glauber <jglauber@cavium.com>, John Garry <john.garry@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 63eb322d89c8505af9b4a3d703e85e42281ebaa0:

  efi: Permit calling efi_mem_reserve_persistent() from atomic context (2018-11-15 10:04:47 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 57e56580724370056aadd0e4e331ec5445ebf9e1:

  efi: prevent GICv3 WARN() by mapping memreserve table before first use (2018-11-23 20:21:12 +0100)

----------------------------------------------------------------
Apply a fix on top of the efi_mem_reserve_persistent() fix that was
merged last week to allow the function to be called earlier.

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: prevent GICv3 WARN() by mapping memreserve table before first use

 drivers/firmware/efi/efi.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)
