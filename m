From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 3/4] x86/efi: Force EFI reboot to process pending capsules
Date: Thu, 17 Mar 2016 12:57:10 +0000
Message-ID: <1458219431-24741-4-git-send-email-matt@codeblueprint.co.uk>
References: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: joeyli <jlee@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

If an EFI capsule has been sent to the firmware we must match the type
of EFI reset against that required by the capsule to ensure it is
processed correctly.

Force an EFI reboot if a capsule is pending for the next reset.

Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/kernel/reboot.c | 9 +++++++++
 include/linux/efi.h      | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ab0adc0fa5db..a9b31eb815f2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -535,6 +535,15 @@ static void native_machine_emergency_restart(void)
 	mode = reboot_mode == REBOOT_WARM ? 0x1234 : 0;
 	*((unsigned short *)__va(0x472)) = mode;
 
+	/*
+	 * If an EFI capsule has been registered with the firmware then
+	 * override the reboot= parameter.
+	 */
+	if (efi_capsule_pending(NULL)) {
+		pr_info("EFI capsule is pending, forcing EFI reboot.\n");
+		reboot_type = BOOT_EFI;
+	}
+
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a28053e71e99..290aa5673119 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1028,6 +1028,12 @@ static inline bool efi_enabled(int feature)
 }
 static inline void
 efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
+
+static inline bool
+efi_capsule_pending(int *reset_type)
+{
+	return false;
+}
 #endif
 
 extern int efi_status_to_err(efi_status_t status);
-- 
2.6.2
