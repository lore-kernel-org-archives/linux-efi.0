From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 01/16] PM / hibernate: define HMAC algorithm and digest size of hibernation
Date: Tue, 11 Aug 2015 14:16:21 +0800
Message-ID: <1439273796-25359-2-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Using HMAC-SHA1 to be the HMAC algorithm of signing hibernate
snapshot image. The digest size of HMAC-SHA1 is 160 bits (20 bytes),
this size will be also applied to the length of HMAC key.

In addition, moved swsusp_info struct definition into CONFIG_HIBERNATION
ifdef block because only hibernate code uses it.
Add HIBERNATE_VERIFICATION kernel config for using by later hibernate
signature verification code.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 include/linux/suspend.h |  5 +++++
 kernel/power/Kconfig    | 13 +++++++++++++
 kernel/power/power.h    |  3 ++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5efe743..56c6de9 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -327,6 +327,11 @@ struct platform_hibernation_ops {
 };
 
 #ifdef CONFIG_HIBERNATION
+
+/* HMAC Algorithm of Hibernate Signature */
+#define HIBERNATION_HMAC	"hmac(sha1)"
+#define HIBERNATION_DIGEST_SIZE	20
+
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void __init register_nosave_region(unsigned long b, unsigned long e)
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 9e30231..8608b3b 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -66,6 +66,19 @@ config HIBERNATION
 
 	  For more information take a look at <file:Documentation/power/swsusp.txt>.
 
+config HIBERNATE_VERIFICATION
+	bool "Hibernate verification"
+	depends on HIBERNATION
+	depends on EFI_STUB
+	depends on X86
+	select CRYPTO_HMAC
+	select CRYPTO_SHA1
+	help
+	  This option provides support for generating and verifying the
+	  signature of memory snapshot image by HMAC-SHA1. Current mechanism
+	  relies on UEFI secure boot environment, EFI stub generates HMAC
+	  key for hibernate verification.
+
 config ARCH_SAVE_PAGE_KEYS
 	bool
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index caadb56..6ea5c78 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -4,6 +4,7 @@
 #include <linux/freezer.h>
 #include <linux/compiler.h>
 
+#ifdef CONFIG_HIBERNATION
 struct swsusp_info {
 	struct new_utsname	uts;
 	u32			version_code;
@@ -12,9 +13,9 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
+	u8                      signature[HIBERNATION_DIGEST_SIZE];
 } __aligned(PAGE_SIZE);
 
-#ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void __init hibernate_reserved_size_init(void);
 extern void __init hibernate_image_size_init(void);
-- 
2.1.4
