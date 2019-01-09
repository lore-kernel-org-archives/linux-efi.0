From: Hedi Berriche <hedi.berriche@hpe.com>
Subject: [PATCH 0/3] Protect against concurrent calls into UV BIOS
Date: Wed,  9 Jan 2019 10:45:38 +0000
Message-ID: <20190109104541.25733-1-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Hedi Berriche <hedi.berriche@hpe.com>
List-Id: linux-efi@vger.kernel.org

Calls into UV BIOS were not being serialised which is wrong as it violates
EFI runtime rules, and bad as it does result in all sorts of potentially
hard to track down hangs and panics when efi_scratch gets clobbered.

Patch #1 makes the efi_runtime_lock semaphore visible to EFI runtime
callers defined outside drivers/firmware/efi/runtime-wrappers.c in
preparation for using it to serialise calls into UV BIOS.

Patch #2 removes uv_bios_call_reentrant() because it's dead code.

Patch #3 makes uv_bios_call() variants use efi_runtime_sem to protect
against concurrency.

Hedi Berriche (3):
  efi/x86: turn EFI runtime semaphore into a global lock
  x86/platform/UV: kill uv_bios_call_reentrant() as it has no callers
  x86/platform/UV: use efi_runtime_sem to serialise BIOS calls

 arch/x86/include/asm/uv/bios.h          |    4 +-
 arch/x86/platform/uv/bios_uv.c          |   37 +++++++++++--------
 drivers/firmware/efi/runtime-wrappers.c |   60 ++++++++++++++++----------------
 include/linux/efi.h                     |    3 +
 4 files changed, 57 insertions(+), 47 deletions(-)

-- 
2.20.0
