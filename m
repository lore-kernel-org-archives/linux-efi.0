From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 36/40] efi/runtime-wrappers: Detect firmware irq flag corruption
Date: Mon, 25 Apr 2016 21:07:08 +0100
Message-ID: <1461614832-17633-37-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Robin Murphy <robin.murphy@arm.com>, Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

The UEFI spec allows runtime services to be called with interrupts
masked or unmasked, and if a runtime service function needs to mask
interrupts, it must restore the mask to its original state before
returning (i.e. from the PoV of the OS, this does not change across a
call). Firmware should never unmask exceptions, as these may then be
taken by the OS unexpectedly.

Unfortunately, some firmware has been seen to unmask IRQs (and
potentially other maskable exceptions) across runtime services calls,
leaving irq flags corrupted after returning from a runtime services
function call. This may be detected by the IRQ tracing code, but often
goes unnoticed, leaving a potentially disastrous bug hidden.

This patch detects when the irq flags are corrupted by an EFI runtime
services call, logging the call and specific corruption to the console.
While restoring the expected value of the flags is insufficient to avoid
problems, we do so to avoid redundant warnings from elsewhere (e.g. IRQ
tracing).

The set of bits in flags which we want to check is architecture-specific
(e.g. we want to check FIQ on arm64, but not the zero flag on x86), so
each arch must provide ARCH_EFI_IRQ_FLAGS_MASK to describe those. In the
absence of this mask, the check is a no-op, and we redundantly save the
flags twice, but that will be short-lived as subsequent patches
will implement this and remove the scaffolding.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/runtime-wrappers.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b9ece374d4d3..89dcdb3a16a2 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -16,11 +16,36 @@
 
 #include <linux/bug.h>
 #include <linux/efi.h>
+#include <linux/irqflags.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/stringify.h>
 #include <asm/efi.h>
 
 /*
+ * Temporary scaffolding until all users provide ARCH_EFI_IRQ_FLAGS_MASK.
+ */
+#ifdef ARCH_EFI_IRQ_FLAGS_MASK
+static void efi_call_virt_check_flags(unsigned long flags, const char *call)
+{
+	unsigned long cur_flags, mismatch;
+
+	local_save_flags(cur_flags);
+
+	mismatch = flags ^ cur_flags;
+	if (!WARN_ON_ONCE(mismatch & ARCH_EFI_IRQ_FLAGS_MASK))
+		return;
+
+	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_NOW_UNRELIABLE);
+	pr_err_ratelimited(FW_BUG "IRQ flags corrupted (0x%08lx=>0x%08lx) by EFI %s\n",
+			   flags, cur_flags, call);
+	local_irq_restore(flags);
+}
+#else /* ARCH_EFI_IRQ_FLAGS_MASK */
+static inline void efi_call_virt_check_flags(unsigned long flags, const char *call) {}
+#endif /* ARCH_EFI_IRQ_FLAGS_MASK */
+
+/*
  * Arch code can implement the following three template macros, avoiding
  * reptition for the void/non-void return cases of {__,}efi_call_virt:
  *
@@ -43,16 +68,22 @@
 #define efi_call_virt(f, args...)					\
 ({									\
 	efi_status_t __s;						\
+	unsigned long flags;						\
 	arch_efi_call_virt_setup();					\
+	local_save_flags(flags);					\
 	__s = arch_efi_call_virt(f, args);				\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
 	arch_efi_call_virt_teardown();					\
 	__s;								\
 })
 
 #define __efi_call_virt(f, args...)					\
 ({									\
+	unsigned long flags;						\
 	arch_efi_call_virt_setup();					\
+	local_save_flags(flags);					\
 	arch_efi_call_virt(f, args);					\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
 	arch_efi_call_virt_teardown();					\
 })
 
-- 
2.7.3
