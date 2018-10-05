From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v5 5/5] x86/ima: define arch_get_ima_policy() for x86
Date: Fri,  5 Oct 2018 23:10:15 +0530
Message-ID: <20181005174015.21939-6-nayna@linux.vnet.ibm.com>
References: <20181005174015.21939-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005174015.21939-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, Eric Richter <erichte@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

From: Eric Richter <erichte@linux.ibm.com>

On x86, there are two methods of verifying a kexec'ed kernel image
signature being loaded via the kexec_file_load syscall - an architecture
specific implementaton or a IMA KEXEC_KERNEL_CHECK appraisal rule. Neither
of these methods verify the kexec'ed kernel image signature being loaded
via the kexec_load syscall.

Secure boot enabled systems require kexec images to be signed. Therefore,
this patch loads an IMA KEXEC_KERNEL_CHECK policy rule on secure boot
enabled systems not configured with CONFIG_KEXEC_VERIFY_SIG enabled.

When IMA_APPRAISE_BOOTPARAM is configured, different IMA appraise modes
(eg. fix, log) can be specified on the boot command line, allowing unsigned
or invalidly signed kernel images to be kexec'ed. This patch permits
enabling IMA_APPRAISE_BOOTPARAM or IMA_ARCH_POLICY, but not both.

Signed-off-by: Eric Richter <erichte@linux.ibm.com>
- Removed the policy KEXEC_ORIG_KERNEL_CHECK which was defined to
  disable the kexec_load syscall.
- arch_get_ima_policy() uses arch_ima_get_secureboot() to get secureboot
  state
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
---
 arch/x86/kernel/ima_arch.c     | 18 ++++++++++++++++++
 include/linux/ima.h            |  4 ++++
 security/integrity/ima/Kconfig | 10 +++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

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
index 13b446328dda..a18f8c6d13b5 100644
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
@@ -217,7 +225,7 @@ config IMA_APPRAISE_REQUIRE_POLICY_SIGS
 
 config IMA_APPRAISE_BOOTPARAM
 	bool "ima_appraise boot parameter"
-	depends on IMA_APPRAISE
+	depends on IMA_APPRAISE && !IMA_ARCH_POLICY
 	default y
 	help
 	  This option enables the different "ima_appraise=" modes
-- 
2.13.6
