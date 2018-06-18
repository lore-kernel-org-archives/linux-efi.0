From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.16 274/279] efi/libstub/arm64: Handle randomized TEXT_OFFSET
Date: Mon, 18 Jun 2018 10:14:19 +0200
Message-ID: <20180618080620.010224233@linuxfoundation.org>
References: <20180618080608.851973560@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618080608.851973560@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Kim Phillips <kim.phillips@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-efi@vger.kernel.org

4.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 4f74d72aa7067e75af92fbab077e6d7d0210be66 ]

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

Reported-by: Kim Phillips <kim.phillips@arm.com>
Tested-by: Kim Phillips <kim.phillips@arm.com>
[ardb: clarify comment and commit log, drop unneeded parens]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 6f26b3671184c36d ("arm64: kaslr: increase randomization granularity")
Link: http://lkml.kernel.org/r/20180518140841.9731-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -98,6 +98,16 @@ efi_status_t handle_kernel_image(efi_sys
 			     (phys_seed >> 32) & mask : TEXT_OFFSET;
 
 		/*
+		 * With CONFIG_RANDOMIZE_TEXT_OFFSET=y, TEXT_OFFSET may not
+		 * be a multiple of EFI_KIMG_ALIGN, and we must ensure that
+		 * we preserve the misalignment of 'offset' relative to
+		 * EFI_KIMG_ALIGN so that statically allocated objects whose
+		 * alignment exceeds PAGE_SIZE appear correctly aligned in
+		 * memory.
+		 */
+		offset |= TEXT_OFFSET % EFI_KIMG_ALIGN;
+
+		/*
 		 * If KASLR is enabled, and we have some randomness available,
 		 * locate the kernel at a randomized offset in physical memory.
 		 */
