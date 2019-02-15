From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI updates for v5.1
Date: Fri, 15 Feb 2019 17:55:50 +0100
Message-ID: <20190215165551.12220-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 69c1f396f25b805aeff08f06d2e992c315ee5b1e:

  efi/x86: Convert x86 EFI earlyprintk into generic earlycon implementation (2019-02-04 08:27:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 0477e8bf4b038bb4211f41868f62ce2005f7efdf:

  efi: fix build error redeclaration of enumerator (2019-02-15 13:38:52 +0100)

----------------------------------------------------------------
Another EFI update for v5.1:
- Fix a enum namespace clash that may occur in -next if EFI and IMA are both
  enabled (Anders)

----------------------------------------------------------------
Anders Roxell (1):
      efi: fix build error redeclaration of enumerator

 arch/x86/platform/efi/quirks.c          |  4 +--
 drivers/firmware/efi/runtime-wrappers.c | 48 ++++++++++++++++-----------------
 include/linux/efi.h                     | 26 +++++++++---------
 3 files changed, 39 insertions(+), 39 deletions(-)
