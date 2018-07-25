From: Eric Richter <erichte@linux.vnet.ibm.com>
Subject: [PATCH 4/4] x86/ima: define arch_get_ima_policy() for x86
Date: Wed, 25 Jul 2018 18:32:00 -0500
Message-ID: <20180725233200.761-5-erichte@linux.vnet.ibm.com>
References: <20180725233200.761-1-erichte@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725233200.761-1-erichte@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity <linux-integrity@vger.kernel.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Justin Forbes <jforbes@redhat.com>, Eric Richter <erichte@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

This patch implements an example arch-specific IMA policy for x86 to enable
measurement and appraisal of any kernel images loaded for kexec, and
disables the kexec_load syscall.

To avoid conflicting with the existing CONFIG_KERNEL_VERIFY_SIG option, the
policy only "appraises" the target image on kexec_load. Without this, the
target kexec image would have to be verified by both the above option as
well as by IMA appraisal.

Since signature verification for kexec_load is not possible via appraisal
(or VERIFY_SIG), this results in a failure and thus effectively prevents
the kexec_load syscall from succeeding when set.

Signed-off-by: Eric Richter <erichte@linux.vnet.ibm.com>
---
 arch/x86/kernel/Makefile       |  2 ++
 arch/x86/kernel/ima_arch.c     | 27 +++++++++++++++++++++++++++
 include/linux/ima.h            |  8 ++++++++
 security/integrity/ima/Kconfig |  8 ++++++++
 4 files changed, 45 insertions(+)
 create mode 100644 arch/x86/kernel/ima_arch.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 02d6f5cf4e7..f3e1d76ed9b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -149,3 +149,5 @@ ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_MMCONF_FAM10H)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
 endif
+
+obj-$(CONFIG_IMA_ARCH_POLICY) += ima_arch.o
diff --git a/arch/x86/kernel/ima_arch.c b/arch/x86/kernel/ima_arch.c
new file mode 100644
index 00000000000..5eb10e29db0
--- /dev/null
+++ b/arch/x86/kernel/ima_arch.c
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (C) 2018 IBM Corporation
+ */
+#include <linux/efi.h>
+#include <linux/ima.h>
+
+extern struct boot_params boot_params;
+
+/* arch rules for audit and user mode */
+static const char * const sb_arch_rules[] = {
+#ifdef CONFIG_KEXEC_VERIFY_SIG
+	"appraise func=KEXEC_ORIG_KERNEL_CHECK appraise_type=imasig",
+#else
+	"appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig",
+#endif /* CONFIG_KEXEC_VERIFY_SIG */
+	"measure func=KEXEC_KERNEL_CHECK",
+	NULL
+};
+
+const char * const *arch_get_ima_policy(void)
+{
+	if (efi_enabled(EFI_BOOT) &&
+	    (boot_params.secure_boot == efi_secureboot_mode_enabled))
+		return sb_arch_rules;
+	return NULL;
+}
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 7fd272f0b1f..495fa290b14 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -30,10 +30,14 @@ extern void ima_post_path_mknod(struct dentry *dentry);
 extern void ima_add_kexec_buffer(struct kimage *image);
 #endif
 
+#if defined(CONFIG_IMA_ARCH_POLICY) && defined(CONFIG_X86)
+extern const char * const *arch_get_ima_policy(void);
+#else
 static inline const char * const *arch_get_ima_policy(void)
 {
 	return NULL;
 }
+#endif
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -77,6 +81,10 @@ static inline void ima_post_path_mknod(struct dentry *dentry)
 	return;
 }
 
+static inline const char * const *arch_get_ima_policy(void)
+{
+	return NULL;
+}
 #endif /* CONFIG_IMA */
 
 #ifndef CONFIG_IMA_KEXEC
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 13b446328dd..18de132bbda 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -157,6 +157,14 @@ config IMA_APPRAISE
 	  <http://linux-ima.sourceforge.net>
 	  If unsure, say N.
 
+config IMA_ARCH_POLICY
+	bool "Enable loading an IMA architecture specific policy"
+	depends on IMA_APPRAISE && INTEGRITY_ASYMMETRIC_KEYS
+	default n
+	help
+	  This option enables loading an IMA architecture specific policy
+	  based on run time secure boot flags.
+
 config IMA_APPRAISE_BUILD_POLICY
 	bool "IMA build time configured policy rules"
 	depends on IMA_APPRAISE && INTEGRITY_ASYMMETRIC_KEYS
-- 
2.14.4
