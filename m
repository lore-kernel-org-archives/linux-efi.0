From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 5/5] efi/runtime-wrappers: remove ARCH_EFI_IRQ_FLAGS_MASK ifdef
Date: Mon, 25 Apr 2016 14:46:34 +0100
Message-ID: <1461591994-14918-6-git-send-email-mark.rutland@arm.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

Now that arm, arm64, and x86 all provide ARCH_EFI_IRQ_FLAGS_MASK, we can
get rid of the trivial and now unused implementation of
efi_call_virt_check_flags.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/firmware/efi/runtime-wrappers.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 1f0277e..a51b2c3 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -22,10 +22,6 @@
 #include <linux/stringify.h>
 #include <asm/efi.h>
 
-/*
- * Temporary scaffolding until all users provide ARCH_EFI_IRQ_FLAGS_MASK.
- */
-#ifdef ARCH_EFI_IRQ_FLAGS_MASK
 static void efi_call_virt_check_flags(unsigned long flags, const char *call)
 {
 	unsigned long cur_flags;
@@ -42,9 +38,6 @@ static void efi_call_virt_check_flags(unsigned long flags, const char *call)
 			   flags, cur_flags, call);
 	local_irq_restore(flags);
 }
-#else /* ARCH_EFI_IRQ_FLAGS_MASK */
-static inline void efi_call_virt_check_flags(unsigned long flags, const char *call) {}
-#endif /* ARCH_EFI_IRQ_FLAGS_MASK */
 
 #define efi_call_virt(f, args...)					\
 ({									\
-- 
1.9.1
