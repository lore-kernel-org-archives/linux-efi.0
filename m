From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 40/40] efi/runtime-wrappers: Remove ARCH_EFI_IRQ_FLAGS_MASK ifdef
Date: Mon, 25 Apr 2016 21:07:12 +0100
Message-ID: <1461614832-17633-41-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Now that arm, arm64, and x86 all provide ARCH_EFI_IRQ_FLAGS_MASK, we can
get rid of the trivial and now unused implementation of
efi_call_virt_check_flags.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/runtime-wrappers.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 89dcdb3a16a2..23bef6bb73ee 100644
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
 	unsigned long cur_flags, mismatch;
@@ -41,9 +37,6 @@ static void efi_call_virt_check_flags(unsigned long flags, const char *call)
 			   flags, cur_flags, call);
 	local_irq_restore(flags);
 }
-#else /* ARCH_EFI_IRQ_FLAGS_MASK */
-static inline void efi_call_virt_check_flags(unsigned long flags, const char *call) {}
-#endif /* ARCH_EFI_IRQ_FLAGS_MASK */
 
 /*
  * Arch code can implement the following three template macros, avoiding
-- 
2.7.3
