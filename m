From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 6/6] efi/runtime-wrappers: detect FW irq flag corruption
Date: Fri, 22 Apr 2016 14:51:23 +0100
Message-ID: <1461333083-15529-7-git-send-email-mark.rutland@arm.com>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

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

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/firmware/efi/runtime-wrappers.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

I'm not sure about the LOCKDEP_NOW_UNRELIABLE here. If FW unmasks IRQs there's
the potential for deadlock, but arguably by the time we've detected the flag
corruption the danger has passed. I'm erring on the side of caution here
setting it, but perhaps that's not the best idea?

Mark.

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index a2c8e70..19e30b7 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -16,23 +16,45 @@
 
 #include <linux/bug.h>
 #include <linux/efi.h>
+#include <linux/irqflags.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/stringify.h>
 #include <asm/efi.h>
 
+static void efi_call_virt_check_flags(unsigned long flags, const char *call)
+{
+	unsigned long cur_flags;
+
+	local_save_flags(cur_flags);
+	if (!WARN_ON_ONCE(cur_flags != flags))
+		return;
+
+	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_NOW_UNRELIABLE);
+	pr_err_ratelimited(FW_BUG "IRQ flags corrupted (0x%08lx=>0x%08lx) by EFI %s\n",
+			   flags, cur_flags, call);
+	local_irq_restore(flags);
+}
+
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
1.9.1
