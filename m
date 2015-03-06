From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] efi/arm64: use UEFI for system reset and poweroff
Date: Fri,  6 Mar 2015 15:49:24 +0100
Message-ID: <1425653364-12591-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If UEFI Runtime Services are available, they are preferred over direct
PSCI calls or other methods to reset the system.

For the reset case, we need to hook into machine_restart(), as the
arm_pm_restart function pointer may be overwritten by modules.

Tested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Reviewed-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c     | 9 +++++++++
 arch/arm64/kernel/process.c | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b42c7b480e1e..2b8d70164428 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -354,3 +354,12 @@ void efi_virtmap_unload(void)
 	efi_set_pgd(current->active_mm);
 	preempt_enable();
 }
+
+/*
+ * UpdateCapsule() depends on the system being shutdown via
+ * ResetSystem().
+ */
+bool efi_poweroff_required(void)
+{
+	return efi_enabled(EFI_RUNTIME_SERVICES);
+}
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index fde9923af859..c6b1f3b96f45 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -21,6 +21,7 @@
 #include <stdarg.h>
 
 #include <linux/compat.h>
+#include <linux/efi.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -150,6 +151,13 @@ void machine_restart(char *cmd)
 	local_irq_disable();
 	smp_send_stop();
 
+	/*
+	 * UpdateCapsule() depends on the system being reset via
+	 * ResetSystem().
+	 */
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_reboot(reboot_mode, NULL);
+
 	/* Now call the architecture specific reboot code. */
 	if (arm_pm_restart)
 		arm_pm_restart(reboot_mode, cmd);
-- 
1.8.3.2
