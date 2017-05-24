From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] Add the ability to lock down access to the running
 kernel image
Date: Wed, 24 May 2017 15:45:45 +0100
Message-ID: <149563714531.9419.16811189348445249219.stgit@warthog.procyon.org.uk>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Provide a single call to allow kernel code to determine whether the system
should be locked down, thereby disallowing various accesses that might
allow the running kernel image to be changed including the loading of
modules that aren't validly signed with a key we recognise, fiddling with
MSR registers and disallowing hibernation,

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <james.l.morris@oracle.com>
---

 include/linux/kernel.h   |    9 +++++++++
 include/linux/security.h |   11 +++++++++++
 security/Kconfig         |   15 +++++++++++++++
 security/Makefile        |    3 +++
 security/lock_down.c     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 84 insertions(+)
 create mode 100644 security/lock_down.c

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 13bc08aba704..282a1684d6e8 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -276,6 +276,15 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern bool kernel_is_locked_down(void);
+#else
+static inline bool kernel_is_locked_down(void)
+{
+	return false;
+}
+#endif
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/include/linux/security.h b/include/linux/security.h
index af675b576645..8db2d886aa90 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1698,5 +1698,16 @@ static inline void free_secdata(void *secdata)
 { }
 #endif /* CONFIG_SECURITY */
 
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern void __init lock_kernel_down(void);
+#ifdef CONFIG_ALLOW_LOCKDOWN_LIFT
+extern void lift_kernel_lockdown(void);
+#endif
+#else
+static inline void lock_kernel_down(void)
+{
+}
+#endif
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/Kconfig b/security/Kconfig
index 93027fdf47d1..4baac4aab277 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -189,6 +189,21 @@ config STATIC_USERMODEHELPER_PATH
 	  If you wish for all usermode helper programs to be disabled,
 	  specify an empty string here (i.e. "").
 
+config LOCK_DOWN_KERNEL
+	bool "Allow the kernel to be 'locked down'"
+	help
+	  Allow the kernel to be locked down under certain circumstances, for
+	  instance if UEFI secure boot is enabled.  Locking down the kernel
+	  turns off various features that might otherwise allow access to the
+	  kernel image (eg. setting MSR registers).
+
+config ALLOW_LOCKDOWN_LIFT
+	bool
+	help
+	  Allow the lockdown on a kernel to be lifted, thereby restoring the
+	  ability of userspace to access the kernel image (eg. by SysRq+x under
+	  x86).
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/security/Makefile b/security/Makefile
index f2d71cdb8e19..8c4a43e3d4e0 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -29,3 +29,6 @@ obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
 obj-$(CONFIG_INTEGRITY)			+= integrity/
+
+# Allow the kernel to be locked down
+obj-$(CONFIG_LOCK_DOWN_KERNEL)		+= lock_down.o
diff --git a/security/lock_down.c b/security/lock_down.c
new file mode 100644
index 000000000000..dd98422fbda7
--- /dev/null
+++ b/security/lock_down.c
@@ -0,0 +1,46 @@
+/* Lock down the kernel
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/security.h>
+#include <linux/export.h>
+
+#ifdef CONFIG_ALLOW_LOCKDOWN_LIFT
+static __read_mostly bool kernel_locked_down;
+#else
+static __ro_after_init bool kernel_locked_down;
+#endif
+
+/*
+ * Put the kernel into lock-down mode.
+ */
+void __init lock_kernel_down(void)
+{
+	kernel_locked_down = true;
+}
+
+/*
+ * Take the kernel out of lockdown mode.
+ */
+#ifdef CONFIG_ALLOW_LOCKDOWN_LIFT
+void lift_kernel_lockdown(void)
+{
+	kernel_locked_down = false;
+}
+#endif
+
+/**
+ * kernel_is_locked_down - Find out if the kernel is locked down
+ */
+bool kernel_is_locked_down(void)
+{
+	return kernel_locked_down;
+}
+EXPORT_SYMBOL(kernel_is_locked_down);

