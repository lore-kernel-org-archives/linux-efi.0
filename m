From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 01/16] PM / hibernate: define HMAC algorithm and digest size of swsusp
Date: Thu, 16 Jul 2015 22:25:15 +0800
Message-ID: <1437056730-15247-2-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Using HMAC-SHA1 to be the HMAC algorithm of signing hibernate
snapshot image. The digest size of HMAC-SHA1 is 160 bits (20 bytes),
this size will be also applied to the length of HMAC key.

In addition, add HIBERNATE_VERIFICATION kernel config.

Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 include/linux/suspend.h |  5 +++++
 kernel/power/Kconfig    | 13 +++++++++++++
 kernel/power/power.h    |  1 +
 3 files changed, 19 insertions(+)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5efe743..6cd2a48 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -327,6 +327,11 @@ struct platform_hibernation_ops {
 };
 
 #ifdef CONFIG_HIBERNATION
+
+/* HMAC Algorithm of Hibernate Signature */
+#define SWSUSP_HMAC		"hmac(sha1)"
+#define SWSUSP_DIGEST_SIZE	20
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
index caadb56..f65fcf7 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -12,6 +12,7 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
+	u8                      signature[SWSUSP_DIGEST_SIZE];
 } __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_HIBERNATION
-- 
1.8.4.5
