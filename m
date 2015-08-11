From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 15/16] PM / hibernate: Bypass verification logic on legacy BIOS
Date: Tue, 11 Aug 2015 14:16:35 +0800
Message-ID: <1439273796-25359-16-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Current hibernate signature verification solution relies on EFI stub
and efi boot service variable on x86 architecture. So the verification
logic was bypassed on legacy BIOS through checking EFI_BOOT flag.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efi/efi-hibernate_keys.c | 3 +++
 kernel/power/Kconfig                      | 3 ++-
 kernel/power/snapshot.c                   | 8 ++++++--
 kernel/power/user.c                       | 6 +++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi-hibernate_keys.c b/drivers/firmware/efi/efi-hibernate_keys.c
index 8a50bf1..2125302 100644
--- a/drivers/firmware/efi/efi-hibernate_keys.c
+++ b/drivers/firmware/efi/efi-hibernate_keys.c
@@ -17,6 +17,9 @@ void create_hibernation_key_regen_flag(void)
 	struct efivar_entry *entry = NULL;
 	int err = 0;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return;
+
 	if (!set_hibernation_key_regen_flag)
 		return;
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 1a03777..c30598e 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -78,7 +78,8 @@ config HIBERNATE_VERIFICATION
 	  This option provides support for generating and verifying the
 	  signature of memory snapshot image by HMAC-SHA1. Current mechanism
 	  relies on UEFI secure boot environment, EFI stub generates HMAC
-	  key for hibernate verification.
+	  key for hibernate verification. So, the verification logic will be
+	  bypassed on legacy BIOS.
 
 config HIBERNATE_VERIFICATION_FORCE
 	bool "Require hibernate snapshot image to be validly signed"
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 486dd73..22b80b7 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/compiler.h>
 #include <linux/ktime.h>
+#include <linux/efi.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1469,8 +1470,11 @@ error_digest:
 forward_ret:
 	if (ret)
 		pr_warn("PM: Signature verifying failed: %d\n", ret);
-	/* forward check result when verifying pass or not enforce verifying */
-	if (!ret || !sigenforce) {
+	if (ret == -ENODEV && !efi_enabled(EFI_BOOT)) {
+		pr_warn("PM: Bypass verification on non-EFI machine\n");
+		ret = 0;
+	} else if (!ret || !sigenforce) {
+		/* forward check result when verifying pass or not enforce verifying */
 		snapshot_fill_sig_forward_info(ret);
 		ret = 0;
 	}
diff --git a/kernel/power/user.c b/kernel/power/user.c
index a183abd..686d095 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/efi.h>
 
 #include <asm/uaccess.h>
 
@@ -393,7 +394,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_REGENERATE_KEY:
-		set_hibernation_key_regen_flag = !!arg;
+		if (!efi_enabled(EFI_BOOT))
+			error = -ENODEV;
+		else
+			set_hibernation_key_regen_flag = !!arg;
 		break;
 
 	default:
-- 
2.1.4
