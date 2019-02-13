From: Hedi Berriche <hedi.berriche@hpe.com>
Subject: [Patch v3 0/4] Protect against concurrent calls into UV BIOS
Date: Wed, 13 Feb 2019 19:34:09 +0000
Message-ID: <20190213193413.25560-1-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, x86@kernel.org, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

- Changes since v2
  Addressed comments from Ard Biesheuvel:
 * expose efi_runtime_lock to UV platform only instead of globally
 * remove unnecessary #ifdef CONFIG_EFI from bios_uv.c

- Changes since v1:
  Addressed comments from Bhupesh Sharma, Thomas Gleixner, and Ard Biesheuvel:
 * made __uv_bios_call() static
 * moved the efi_enabled() cleanup to its own patchlet
 * explained the reason for renaming the efi_runtime_lock semaphore
 * dropped the reviewed-bys as they should be given on the mailing list
 * Cc'ng stable@vger.kernel.org given the nature of the problem addressed by the patches

---

Calls into UV BIOS were not being serialised which is wrong as it violates EFI
runtime rules, and bad as it does result in all sorts of potentially hard to
track down hangs and panics when efi_scratch.prev_mm gets clobbered whenever
efi_switch_mm() gets called concurrently from two different CPUs.

Patch #1 removes an unnecessary #ifdef CONFIG_EFI guard from bios_uv.c.

Patch #2 removes uv_bios_call_reentrant() because it's dead code.

Patch #3 is a cleanup that drops test_bit() in favour of the ad hoc efi_enabled().

Patch #4 makes uv_bios_call() variants use the efi_runtime_lock semaphore to
protect against concurrency.

Cc: Russ Anderson <rja@hpe.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Dimitri Sivanich <sivanich@hpe.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: stable@vger.kernel.org # v4.9+

Hedi Berriche (4):
  x86/platform/UV: remove unnecessary #ifdef CONFIG_EFI
  x86/platform/UV: kill uv_bios_call_reentrant() as it has no callers
  x86/platform/UV: use efi_enabled() instead of test_bit()
  x86/platform/UV: use efi_runtime_lock to serialise BIOS calls

 arch/x86/include/asm/uv/bios.h          | 13 ++++-----
 arch/x86/platform/uv/bios_uv.c          | 35 ++++++++++++++-----------
 drivers/firmware/efi/runtime-wrappers.c |  7 +++++
 3 files changed, 34 insertions(+), 21 deletions(-)

-- 
2.20.1
