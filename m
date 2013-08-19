From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 01/10] Add secure_modules() call
Date: Mon, 19 Aug 2013 12:10:10 -0400
Message-ID: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Provide a single call to allow kernel code to determine whether the system
has been configured to either disable module loading entirely or to load
only modules signed with a trusted key.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 include/linux/module.h | 7 +++++++
 kernel/module.c        | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index 46f1ea0..0c266b2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -509,6 +509,8 @@ int unregister_module_notifier(struct notifier_block * nb);
 
 extern void print_modules(void);
 
+extern bool secure_modules(void);
+
 #else /* !CONFIG_MODULES... */
 
 /* Given an address, look for it in the exception tables. */
@@ -619,6 +621,11 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
 static inline void print_modules(void)
 {
 }
+
+static inline bool secure_modules(void)
+{
+	return false;
+}
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
diff --git a/kernel/module.c b/kernel/module.c
index 2069158..801021e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3852,3 +3852,12 @@ void module_layout(struct module *mod,
 }
 EXPORT_SYMBOL(module_layout);
 #endif
+
+bool secure_modules(void)
+{
+#ifdef CONFIG_MODULE_SIG
+	return (sig_enforce || modules_disabled);
+#else
+	return modules_disabled;
+#endif
+}
-- 
1.8.3.1
