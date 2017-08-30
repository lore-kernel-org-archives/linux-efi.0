From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/14] x86/efi: Force EFI reboot to process pending capsules
Date: Wed, 30 Aug 2017 21:13:45 +0200
Message-ID: <5bf9526467655ef151fd8ce59c91f5473f8f86e5.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

commit 87615a34d561ef59bd0cffc73256a21220dfdffd upstream.

If an EFI capsule has been sent to the firmware we must match the type
of EFI reset against that required by the capsule to ensure it is
processed correctly.

Force an EFI reboot if a capsule is pending for the next reset.

Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1461614832-17633-29-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/kernel/reboot.c | 9 +++++++++
 include/linux/efi.h      | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f660d63f40fe..01d9e1edda07 100644
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
index 4899c679622d..5a0b8f7a54c8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1004,6 +1004,12 @@ static inline bool efi_enabled(int feature)
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
2.12.3
