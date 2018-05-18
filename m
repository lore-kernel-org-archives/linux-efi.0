From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/1] efi/libstub/arm64: handle randomized TEXT_OFFSET
Date: Fri, 18 May 2018 16:08:41 +0200
Message-ID: <20180518140841.9731-2-ard.biesheuvel@linaro.org>
References: <20180518140841.9731-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518140841.9731-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

When CONFIG_RANDOMIZE_TEXT_OFFSET=y, TEXT_OFFSET is an arbitrary
multiple of PAGE_SIZE in the interval [0, 2MB).

The EFI stub does not account for the potential misalignment of
TEXT_OFFSET relative to EFI_KIMG_ALIGN, and produces a randomized
physical offset which is always a round multiple of EFI_KIMG_ALIGN.
This may result in statically allocated objects whose alignment exceeds
PAGE_SIZE to appear misaligned in memory. This has been observed to
result in spurious stack overflow reports and failure to make use of
the IRQ stacks, and theoretically could result in a number of other
issues.

We can OR in the low bits of TEXT_OFFSET to ensure that we have the
necessary offset (and hence preserve the misalignment of TEXT_OFFSET
relative to EFI_KIMG_ALIGN), so let's do that.

Fixes: 6f26b3671184c36d ("arm64: kaslr: increase randomization granularity")
Reported-by: Kim Phillips <kim.phillips@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Kim Phillips <kim.phillips@arm.com>
[ardb: clarify comment and commit log, drop unneeded parens]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index b9bd827caa22..1b4d465cc5d9 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -97,6 +97,16 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 		u32 offset = !IS_ENABLED(CONFIG_DEBUG_ALIGN_RODATA) ?
 			     (phys_seed >> 32) & mask : TEXT_OFFSET;
 
+		/*
+		 * With CONFIG_RANDOMIZE_TEXT_OFFSET=y, TEXT_OFFSET may not
+		 * be a multiple of EFI_KIMG_ALIGN, and we must ensure that
+		 * we preserve the misalignment of 'offset' relative to
+		 * EFI_KIMG_ALIGN so that statically allocated objects whose
+		 * alignment exceeds PAGE_SIZE appear correctly aligned in
+		 * memory.
+		 */
+		offset |= TEXT_OFFSET % EFI_KIMG_ALIGN;
+
 		/*
 		 * If KASLR is enabled, and we have some randomness available,
 		 * locate the kernel at a randomized offset in physical memory.
-- 
2.17.0
