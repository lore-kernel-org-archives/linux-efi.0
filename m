From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 28/40] x86/efi: Force EFI reboot to process pending capsules
Date: Mon, 25 Apr 2016 21:07:00 +0100
Message-ID: <1461614832-17633-29-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, joeyli <jlee@suse.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>
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
Cc: joeyli <jlee@suse.com>
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
index a3b4c1ec38c0..aa36fb8bea4b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1085,6 +1085,12 @@ static inline bool efi_enabled(int feature)
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
2.7.3
