From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/15] MODSIGN: Always enforce module signing in a Secure Boot environment
Date: Mon, 28 Jan 2013 11:42:39 -0500
Message-ID: <1359391359-25783-16-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

If a machine is booted into a Secure Boot environment, we need to
protect the trust model.  This requires that all modules be signed
with a key that is in the kernel's _modsign keyring.  The checks for
this are already done via the 'sig_enforce' module parameter.  Make
this visible within the kernel and force it to be true.

Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cred.c   | 8 ++++++++
 kernel/module.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index c3f4e3e..c5554e0 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -565,11 +565,19 @@ void __init cred_init(void)
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
 
+#ifdef CONFIG_MODULE_SIG
+extern bool sig_enforce;
+#endif
+
 void __init secureboot_enable()
 {
 	pr_info("Secure boot enabled\n");
 	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
 	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
+#ifdef CONFIG_MODULE_SIG
+	/* Enable module signature enforcing */
+	sig_enforce = true;
+#endif
 }
 
 /* Dummy Secure Boot enable option to fake out UEFI SB=1 */
diff --git a/kernel/module.c b/kernel/module.c
index eab0827..93a16dc 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -109,9 +109,9 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 
 #ifdef CONFIG_MODULE_SIG
 #ifdef CONFIG_MODULE_SIG_FORCE
-static bool sig_enforce = true;
+bool sig_enforce = true;
 #else
-static bool sig_enforce = false;
+bool sig_enforce = false;
 
 static int param_set_bool_enable_only(const char *val,
 				      const struct kernel_param *kp)
-- 
1.8.0.2
