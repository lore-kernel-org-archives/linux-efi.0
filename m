From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 13/16] PM / hibernate: Add configuration to enforce signature verification
Date: Tue, 11 Aug 2015 14:16:33 +0800
Message-ID: <1439273796-25359-14-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Like kernel module signature checking, there's both a config option and
a boot parameter which control whether we accept or fail with unsigned
hibernate image and image that are signed with an unknown key.

If hibernate signing is enabled, the kernel will be tainted if a snapshot
image is restored that is unsigned or has a signature for which we don't
have the key. When the enforce flag is enabled, then the hibernate
restoring process will be failed and boot as normal.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 Documentation/kernel-parameters.txt |  5 +++++
 arch/x86/power/hibernate_keys.c     | 19 +++++++++++++++++--
 include/linux/kernel.h              |  1 +
 include/linux/suspend.h             |  3 +++
 kernel/panic.c                      |  2 ++
 kernel/power/Kconfig                |  8 ++++++++
 kernel/power/hibernate.c            |  7 +++++++
 kernel/power/snapshot.c             |  6 +++++-
 8 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1d6f045..86a6916 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3318,6 +3318,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		noresume	Don't check if there's a hibernation image
 				present during boot.
 		nocompress	Don't compress/decompress hibernation images.
+		sigenforce	When CONFIG_HIBERNATE_VERIFICATION is set, this
+				menas that snapshot image without (valid)
+				signature will fail to restore. Note that if
+				HIBERNATE_VERIFICATION_FORCE is set, that is
+				always true, so this option does nothing.
 		no		Disable hibernation and resume.
 
 	retain_initrd	[RAM] Keep initrd memory after extraction
diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
index 5e92101..51e808a 100644
--- a/arch/x86/power/hibernate_keys.c
+++ b/arch/x86/power/hibernate_keys.c
@@ -89,6 +89,7 @@ void fill_forward_info(void *forward_buff_page, int verify_ret)
 	memset(forward_buff_page, 0, PAGE_SIZE);
 	info = (struct forward_info *)forward_buff_page;
 	info->sig_verify_ret = verify_ret;
+	info->sig_enforce = sigenforce;
 
 	if (hibernation_keys && !hibernation_keys->hkey_status) {
 		info->hibernation_keys = *hibernation_keys;
@@ -106,10 +107,24 @@ void restore_sig_forward_info(void)
 		return;
 	}
 
-	if (forward_buff->sig_verify_ret)
-		pr_warn("PM: Signature verifying failed: %d\n",
+	sigenforce = forward_buff->sig_enforce;
+	if (sigenforce)
+		pr_info("PM: Enforce hibernate signature verifying\n");
+
+	if (forward_buff->sig_verify_ret) {
+		pr_warn("PM: Hibernate signature verifying failed: %d\n",
 			forward_buff->sig_verify_ret);
 
+		/* taint kernel */
+		if (!sigenforce) {
+			pr_warn("PM: System restored from unsafe snapshot - "
+				"tainting kernel\n");
+			add_taint(TAINT_UNSAFE_HIBERNATE, LOCKDEP_STILL_OK);
+			pr_info("%s\n", print_tainted());
+		}
+	} else
+		pr_info("PM: Signature verifying pass\n");
+
 	if (hibernation_keys) {
 		memset(hibernation_keys, 0, PAGE_SIZE);
 		*hibernation_keys = forward_buff->hibernation_keys;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5582410..a620786 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -489,6 +489,7 @@ extern enum system_states {
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
 #define TAINT_LIVEPATCH			15
+#define TAINT_UNSAFE_HIBERNATE		16
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index aa88b3b..d318b72 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -335,6 +335,9 @@ struct platform_hibernation_ops {
 #define HIBERNATION_HMAC	"hmac(sha1)"
 #define HIBERNATION_DIGEST_SIZE	20
 
+/* kernel/power/hibernate.c */
+extern int sigenforce;
+
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void __init register_nosave_region(unsigned long b, unsigned long e)
diff --git a/kernel/panic.c b/kernel/panic.c
index 04e91ff..a53da16 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -228,6 +228,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
 	{ TAINT_LIVEPATCH,		'K', ' ' },
+	{ TAINT_UNSAFE_HIBERNATE,	'H', ' ' },
 };
 
 /**
@@ -249,6 +250,7 @@ static const struct tnt tnts[] = {
  *  'E' - Unsigned module has been loaded.
  *  'L' - A soft lockup has previously occurred.
  *  'K' - Kernel has been live patched.
+ *  'H' - System restored from unsafe hibernate snapshot image.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 8608b3b..f2a7e21 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -79,6 +79,14 @@ config HIBERNATE_VERIFICATION
 	  relies on UEFI secure boot environment, EFI stub generates HMAC
 	  key for hibernate verification.
 
+config HIBERNATE_VERIFICATION_FORCE
+	bool "Require hibernate snapshot image to be validly signed"
+	depends on HIBERNATE_VERIFICATION
+	help
+	  Reject hibernate resuming from unsigned snapshot image or signed
+	  snapshot image for which we don't have a key. Without this, such
+	  snapshot image will simply taint the kernel when resuming.
+
 config ARCH_SAVE_PAGE_KEYS
 	bool
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 640ca8a..2c2cc90 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -43,6 +43,11 @@ static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 __visible int in_suspend __nosavedata;
+#ifdef CONFIG_HIBERNATE_VERIFICATION_FORCE
+int sigenforce = 1;
+#else
+int sigenforce;
+#endif
 
 enum {
 	HIBERNATION_INVALID,
@@ -1119,6 +1124,8 @@ static int __init hibernate_setup(char *str)
 		noresume = 1;
 	else if (!strncmp(str, "nocompress", 10))
 		nocompress = 1;
+	else if (!strncmp(str, "sigenforce", 10))
+		sigenforce = 1;
 	else if (!strncmp(str, "no", 2)) {
 		noresume = 1;
 		nohibernate = 1;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 3629249..486dd73 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1469,7 +1469,11 @@ error_digest:
 forward_ret:
 	if (ret)
 		pr_warn("PM: Signature verifying failed: %d\n", ret);
-	snapshot_fill_sig_forward_info(ret);
+	/* forward check result when verifying pass or not enforce verifying */
+	if (!ret || !sigenforce) {
+		snapshot_fill_sig_forward_info(ret);
+		ret = 0;
+	}
 	return ret;
 }
 
-- 
2.1.4
