From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 15/16] PM / hibernate: Bypass verification logic on legacy BIOS
Date: Thu, 16 Jul 2015 22:25:29 +0800
Message-ID: <1437056730-15247-16-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Current hibernate signature verification solution relies on EFI stub
and efi boot service variable on x86 architecture. So the verification
logic was bypassed on legacy BIOS through checking EFI_BOOT flag.

Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efi/efi-hibernate_keys.c | 3 +++
 kernel/power/Kconfig                      | 3 ++-
 kernel/power/snapshot.c                   | 8 ++++++--
 kernel/power/user.c                       | 6 +++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi-hibernate_keys.c b/drivers/firmware/efi/efi-hibernate_keys.c
index 90ae912..f33bf70 100644
--- a/drivers/firmware/efi/efi-hibernate_keys.c
+++ b/drivers/firmware/efi/efi-hibernate_keys.c
@@ -21,6 +21,9 @@ void create_swsusp_key_regen_flag(void)
 	struct efivar_entry *entry = NULL;
 	int err = 0;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return;
+
 	if (!set_swsusp_key_regen_flag)
 		return;
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 7a64bda..5b04ab9 100644
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
index 3eda715..0d64c3a 100644
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
index 8bcb051..d7407ef 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/efi.h>
 
 #include <asm/uaccess.h>
 
@@ -390,7 +391,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_REGENERATE_KEY:
-		set_swsusp_key_regen_flag = !!arg;
+		if (!efi_enabled(EFI_BOOT))
+			error = -ENODEV;
+		else
+			set_swsusp_key_regen_flag = !!arg;
 		break;
 
 	default:
-- 
1.8.4.5
