From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI updates for v4.17
Date: Mon, 2 Apr 2018 12:41:48 +0200
Message-ID: <20180402104148.m3hhkhjhdb5y7gyu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 03781e40890c18bdea40092355b61431d0073c1d x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3

NOTE: this tree depends on the x86/mm tree - if you have not pulled that tree
      then please disregard this pull request.

The main EFI changes in this cycle were:

 - Fix the apple-properties code                 (Andy Shevchenko)

 - Add WARN() on arm64 if UEFI Runtime Services corrupt the
   reserved x18 register
                                                 (Ard Biesheuvel)

 - Use efi_switch_mm() on x86 instead of manipulating %cr3 directly

                                                 (Sai Praneeth)

 - Fix early memremap leak in ESRT code          (Ard Biesheuvel)

 - Switch to L"xxx" notation for wide string literals

                                                 (Ard Biesheuvel)

 - ... plus misc other cleanups and bugfixes

 Thanks,

	Ingo

------------------>
Andy Shevchenko (2):
      efi/apple-properties: Remove redundant attribute initialization from unmarshal_key_value_pairs()
      efi/apple-properties: Use memremap() instead of ioremap()

Ard Biesheuvel (5):
      efi/arm*: Stop printing addresses of virtual mappings
      efi/arm64: Check whether x18 is preserved by runtime services calls
      efi: Reorder pr_notice() with add_device_randomness() call
      efi/esrt: Fix handling of early ESRT table mapping
      efi: Use string literals for efi_char16_t variable initializers

Colin Ian King (1):
      efi: Make const array 'apple' static

Ingo Molnar (1):
      Merge branch 'x86/mm' into efi/core

Jia-Ju Bai (1):
      x86/efi: Replace GFP_ATOMIC with GFP_KERNEL in efi_query_variable_store()

Mark Rutland (1):
      efi/arm*: Only register page tables when they exist

Sai Praneeth (3):
      efi: Use efi_mm in x86 as well as ARM
      x86/efi: Replace efi_pgd with efi_mm.pgd
      x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3

 arch/arm64/include/asm/efi.h              |  4 +++-
 arch/arm64/kernel/Makefile                |  3 ++-
 arch/arm64/kernel/efi-rt-wrapper.S        | 41 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/efi.c                   |  6 ++++++
 arch/x86/boot/compressed/eboot.c          |  3 ++-
 arch/x86/include/asm/efi.h                | 26 +++++++++++---------------
 arch/x86/mm/debug_pagetables.c            |  6 +++---
 arch/x86/platform/efi/efi_64.c            | 60 +++++++++++++++++++++++++++++++++---------------------------
 arch/x86/platform/efi/efi_thunk_64.S      |  2 +-
 arch/x86/platform/efi/quirks.c            | 10 ++++++----
 drivers/firmware/efi/apple-properties.c   | 20 +++++++-------------
 drivers/firmware/efi/arm-runtime.c        | 17 ++++-------------
 drivers/firmware/efi/efi.c                | 11 ++++++++++-
 drivers/firmware/efi/esrt.c               | 17 ++++-------------
 drivers/firmware/efi/libstub/Makefile     |  2 +-
 drivers/firmware/efi/libstub/secureboot.c | 12 +++---------
 drivers/firmware/efi/libstub/tpm.c        |  7 ++-----
 include/linux/efi.h                       |  2 ++
 18 files changed, 141 insertions(+), 108 deletions(-)
 create mode 100644 arch/arm64/kernel/efi-rt-wrapper.S
