From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v4 6/6] x86/ima: define arch_get_ima_policy() for x86
Date: Wed, 26 Sep 2018 17:52:10 +0530
Message-ID: <20180926122210.14642-7-nayna@linux.vnet.ibm.com>
References: <20180926122210.14642-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926122210.14642-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, Eric Richter <erichte@linux.vnet.ibm.com>, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

From: Eric Richter <erichte@linux.vnet.ibm.com>

This patch implements an example arch-specific IMA policy for x86 to
enable measurement and appraisal of any kernel image loaded for kexec,
when CONFIG_KEXEC_VERIFY_SIG is not enabled.

For systems with CONFIG_KEXEC_VERIFY_SIG enabled, only the measurement
rule is enabled, not the IMA-appraisal rule.

Signed-off-by: Eric Richter <erichte@linux.vnet.ibm.com>
- Removed the policy KEXEC_ORIG_KERNEL_CHECK which was defined to
  disable the kexec_load syscall.
- arch_get_ima_policy() uses arch_ima_get_secureboot() to get secureboot
  state
Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 arch/x86/kernel/ima_arch.c     | 18 ++++++++++++++++++
 include/linux/ima.h            |  4 ++++
 security/integrity/ima/Kconfig |  8 ++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/kernel/ima_arch.c b/arch/x86/kernel/ima_arch.c
index bb5a88d2b271..245976e49a55 100644
--- a/arch/x86/kernel/ima_arch.c
+++ b/arch/x86/kernel/ima_arch.c
@@ -15,3 +15,21 @@ bool arch_ima_get_secureboot(void)
 	else
 		return false;
 }
+
+/* arch rules for audit and user mode */
+static const char * const sb_arch_rules[] = {
+#ifndef CONFIG_KEXEC_VERIFY_SIG
+	"appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig",
+#endif /* CONFIG_KEXEC_VERIFY_SIG */
+	"measure func=KEXEC_KERNEL_CHECK",
+	NULL
+};
+
+#ifdef CONFIG_IMA_ARCH_POLICY
+const char * const *arch_get_ima_policy(void)
+{
+	if (arch_ima_get_secureboot())
+		return sb_arch_rules;
+	return NULL;
+}
+#endif
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 350fa957f8a6..dabd3abdf671 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -39,10 +39,14 @@ static inline bool arch_ima_get_secureboot(void)
 }
 #endif
 
+#if defined(CONFIG_X86) && defined(CONFIG_IMA_ARCH_POLICY)
+extern const char * const *arch_get_ima_policy(void);
+#else
 static inline const char * const *arch_get_ima_policy(void)
 {
 	return NULL;
 }
+#endif
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 13b446328dda..97609a76aa14 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -157,6 +157,14 @@ config IMA_APPRAISE
 	  <http://linux-ima.sourceforge.net>
 	  If unsure, say N.
 
+config IMA_ARCH_POLICY
+        bool "Enable loading an IMA architecture specific policy"
+        depends on KEXEC_VERIFY_SIG || IMA_APPRAISE && INTEGRITY_ASYMMETRIC_KEYS
+        default n
+        help
+          This option enables loading an IMA architecture specific policy
+          based on run time secure boot flags.
+
 config IMA_APPRAISE_BUILD_POLICY
 	bool "IMA build time configured policy rules"
 	depends on IMA_APPRAISE && INTEGRITY_ASYMMETRIC_KEYS
-- 
2.13.6
