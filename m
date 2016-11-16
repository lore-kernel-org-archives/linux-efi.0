From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/16] Add the ability to lock down access to the running
 kernel image
Date: Wed, 16 Nov 2016 21:47:24 +0000
Message-ID: <147933284407.19316.17886320817060158597.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Provide a single call to allow kernel code to determine whether the system
should be locked down, thereby disallowing various accesses that might
allow the running kernel image to be changed including the loading of
modules that aren't validly signed with a key we recognise, fiddling with
MSR registers and disallowing hibernation,

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/security.h |   16 ++++++++++++++++
 security/Kconfig         |   16 +++++++++++++++-
 security/Makefile        |    3 +++
 security/lock_down.c     |   40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 security/lock_down.c

diff --git a/include/linux/security.h b/include/linux/security.h
index c2125e9093e8..785868b44364 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1685,5 +1685,21 @@ static inline void free_secdata(void *secdata)
 { }
 #endif /* CONFIG_SECURITY */
 
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern void lock_kernel_down(void);
+extern bool kernel_is_locked_down(void);
+#ifdef CONFIG_ALLOW_LOCKDOWN_LIFT
+extern void lift_kernel_lockdown(void);
+#endif
+#else
+static inline void lock_kernel_down(void)
+{
+}
+static inline bool kernel_is_locked_down(void)
+{
+	return false;
+}
+#endif
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/Kconfig b/security/Kconfig
index 118f4549404e..21fac88e3062 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -158,6 +158,21 @@ config HARDENED_USERCOPY_PAGESPAN
 	  been removed. This config is intended to be used only while
 	  trying to find such users.
 
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
@@ -205,4 +220,3 @@ config DEFAULT_SECURITY
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
-
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
index 000000000000..d63d12fdbba1
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
+EXPORT_SYMBOL(kernel_locked_down);
