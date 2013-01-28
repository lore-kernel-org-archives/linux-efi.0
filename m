From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/15] Secure boot: Add a dummy kernel parameter that will switch on Secure Boot mode
Date: Mon, 28 Jan 2013 11:42:27 -0500
Message-ID: <1359391359-25783-4-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
in the init_cred struct, which everything else inherits from.  This works on
any machine and can be used to develop even if the box doesn't have UEFI.

Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/kernel-parameters.txt |  7 +++++++
 kernel/cred.c                       | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..832b39b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2654,6 +2654,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Note: increases power consumption, thus should only be
 			enabled if running jitter sensitive (HPC/RT) workloads.
 
+	secureboot_enable=
+			[KNL] Enables an emulated UEFI Secure Boot mode.  This
+			locks down various aspects of the kernel guarded by the
+			CAP_COMPROMISE_KERNEL capability.  This includes things
+			like /dev/mem, IO port access, and other areas.  It can
+			be used on non-UEFI machines for testing purposes.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..c3f4e3e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -565,6 +565,23 @@ void __init cred_init(void)
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
 
+void __init secureboot_enable()
+{
+	pr_info("Secure boot enabled\n");
+	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
+	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
+}
+
+/* Dummy Secure Boot enable option to fake out UEFI SB=1 */
+static int __init secureboot_enable_opt(char *str)
+{
+	int sb_enable = !!simple_strtol(str, NULL, 0);
+	if (sb_enable)
+		secureboot_enable();
+	return 1;
+}
+__setup("secureboot_enable=", secureboot_enable_opt);
+
 /**
  * prepare_kernel_cred - Prepare a set of credentials for a kernel service
  * @daemon: A userspace daemon to be used as a reference
-- 
1.8.0.2
