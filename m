From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/12] first batch of EFI changes for v4.17
Date: Thu,  8 Mar 2018 08:00:08 +0000
Message-ID: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Colin Ian King <colin.king@canonical.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, "Lee, Chun-Yi" <jlee@suse.com>, Leif Lindholm <leif.lindholm@linaro.org>, Luis de Bethencourt <luisbg@kernel.org>, Lukas Wunner <lukas@wunner.de>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S . Tsirkin" <mst@redhat.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Ricardo Neri <ricardo.neri@intel.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Tony Luck <tony.luck@intel.com>, Will
List-Id: linux-efi@vger.kernel.org

The following changes since commit 7928b2cbe55b2a410a0f5c1f154610059c57b1b2:

  Linux 4.16-rc1 (2018-02-11 15:04:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-next

for you to fetch changes up to 67a2152c7362bd9ee3ba6d218e435a04c27c32aa:

  efi: make const array 'apple' static (2018-03-08 07:54:10 +0000)

----------------------------------------------------------------
First batch of EFI changes for v4.17:
- use efi_switch_mm() on x86 instead of manipulating %cr3 directly (Sai)
- some fixes for the apple-properties code (Andy)
- add WARN() on arm64 if UEFI Runtime Services corrupt the reserved x18
  register (Ard)
- other minor cleanups and bugfixes

----------------------------------------------------------------
Andy Shevchenko (2):
      efi/apple-properties: Device core takes care of empty properties
      efi/apple-properties: Use memremap() instead of ioremap()

Ard Biesheuvel (3):
      efi/arm*: Stop printing addresses of virtual mappings
      efi: arm64: Check whether x18 is preserved by runtime services calls
      efi: reorder pr_notice() with add_device_randomness() call

Colin Ian King (1):
      efi: make const array 'apple' static

Jia-Ju Bai (1):
      x86: efi: Replace GFP_ATOMIC with GFP_KERNEL in efi_query_variable_store

Luis de Bethencourt (1):
      efi/x86: Fix trailing semicolons

Mark Rutland (1):
      efi/arm*: Only register page tables when they exist

Sai Praneeth (3):
      efi: Use efi_mm in x86 as well as ARM
      x86/efi: Replace efi_pgd with efi_mm.pgd
      x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3

 arch/arm64/include/asm/efi.h            |  4 ++-
 arch/arm64/kernel/Makefile              |  3 +-
 arch/arm64/kernel/efi-rt-wrapper.S      | 41 +++++++++++++++++++++++
 arch/arm64/kernel/efi.c                 |  6 ++++
 arch/x86/boot/compressed/eboot.c        |  6 ++--
 arch/x86/include/asm/efi.h              | 29 ++++++++---------
 arch/x86/platform/efi/efi_64.c          | 58 ++++++++++++++++++---------------
 arch/x86/platform/efi/efi_thunk_64.S    |  2 +-
 arch/x86/platform/efi/quirks.c          |  2 +-
 drivers/firmware/efi/apple-properties.c | 20 ++++--------
 drivers/firmware/efi/arm-runtime.c      | 17 +++-------
 drivers/firmware/efi/efi.c              | 11 ++++++-
 include/linux/efi.h                     |  2 ++
 13 files changed, 125 insertions(+), 76 deletions(-)
 create mode 100644 arch/arm64/kernel/efi-rt-wrapper.S
