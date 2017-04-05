From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/24] Add the ability to lock down access to the running
 kernel image
Date: Wed, 05 Apr 2017 18:07:18 +0100
Message-ID: <149141203819.30815.6193126225725328652.stgit@warthog.procyon.org.uk>
References: <149141201983.30815.1240162780237131881.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149141201983.30815.1240162780237131881.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Provide a single call to allow kernel code to determine whether the system
should be locked down, thereby disallowing various accesses that might
allow the running kernel image to be changed including the loading of
modules that aren't validly signed with a key we recognise, fiddling with
MSR registers and disallowing hibernation,

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/kernel.h   |    9 +++++++++
 include/linux/security.h |   11 +++++++++++
 security/Kconfig         |   15 +++++++++++++++
 security/Makefile        |    3 +++
 security/lock_down.c     |   40 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 78 insertions(+)
 create mode 100644 security/lock_down.c

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c26dc3a8295..b820a80dc949 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -275,6 +275,15 @@ extern int oops_may_print(void);
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
index af675b576645..68bab18ddd57 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1698,5 +1698,16 @@ static inline void free_secdata(void *secdata)
 { }
 #endif /* CONFIG_SECURITY */
 
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern void lock_kernel_down(void);
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
index 3ff1bf91080e..e3830171bdcb 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -198,6 +198,21 @@ config STATIC_USERMODEHELPER_PATH
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
index 000000000000..5788c60ff4e1
--- /dev/null
+++ b/security/lock_down.c
@@ -0,0 +1,40 @@
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
+static __read_mostly bool kernel_locked_down;
+
+/*
+ * Put the kernel into lock-down mode.
+ */
+void lock_kernel_down(void)
+{
+	kernel_locked_down = true;
+}
+
+/*
+ * Take the kernel out of lockdown mode.
+ */
+void lift_kernel_lockdown(void)
+{
+	kernel_locked_down = false;
+}
+
+/**
+ * kernel_is_locked_down - Find out if the kernel is locked down
+ */
+bool kernel_is_locked_down(void)
+{
+	return kernel_locked_down;
+}
+EXPORT_SYMBOL(kernel_is_locked_down);

