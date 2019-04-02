From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: [PATCH 4/4] powerpc: Add support to initialize ima policy rules
Date: Tue,  2 Apr 2019 15:15:05 -0300
Message-ID: <20190402181505.25037-5-cclaudio@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

From: Nayna Jain <nayna@linux.ibm.com>

PowerNV secure boot relies on the kernel IMA security subsystem to
perform the OS kernel image signature verification. Since each secure
boot mode has different IMA policy requirements, dynamic definition of
the policy rules based on the runtime secure boot mode of the system is
required. On systems that support secure boot, but have it disabled,
only measurement policy rules of the kernel image and modules are
defined.

This patch defines the arch-specific implementation to retrieve the
secure boot mode of the system and accordingly configures the IMA policy
rules.

This patch will provide arch-specific IMA policies if PPC_SECURE_BOOT
config is enabled.

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
---
 arch/powerpc/Kconfig           | 12 ++++++++
 arch/powerpc/kernel/Makefile   |  1 +
 arch/powerpc/kernel/ima_arch.c | 54 ++++++++++++++++++++++++++++++++++
 include/linux/ima.h            |  3 +-
 4 files changed, 69 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/kernel/ima_arch.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2d0be82c3061..e0ba9a9114b3 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -901,6 +901,18 @@ config PPC_MEM_KEYS
 
 	  If unsure, say y.
 
+config PPC_SECURE_BOOT
+	prompt "Enable PowerPC Secure Boot"
+	bool
+	default n
+	depends on IMA
+	depends on IMA_ARCH_POLICY
+	help
+	  Linux on POWER with firmware secure boot enabled needs to define
+	  security policies to extend secure boot to the OS.
+	  This config allows user to enable OS Secure Boot on PowerPC systems
+	  that have firmware secure boot support.
+
 endmenu
 
 config ISA_DMA_API
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index cddadccf551d..0f08ed7dfd1b 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -119,6 +119,7 @@ ifdef CONFIG_IMA
 obj-y				+= ima_kexec.o
 endif
 endif
+obj-$(CONFIG_IMA)		+= ima_arch.o
 
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
diff --git a/arch/powerpc/kernel/ima_arch.c b/arch/powerpc/kernel/ima_arch.c
new file mode 100644
index 000000000000..871b321656fb
--- /dev/null
+++ b/arch/powerpc/kernel/ima_arch.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Nayna Jain <nayna@linux.ibm.com>
+ *
+ * ima_arch.c
+ *      - initialize ima policies for PowerPC Secure Boot
+ */
+
+#include <linux/ima.h>
+#include <asm/secboot.h>
+
+bool arch_ima_get_secureboot(void)
+{
+	bool sb_mode;
+
+	sb_mode = get_powerpc_sb_mode();
+	if (sb_mode)
+		return true;
+	else
+		return false;
+}
+
+/*
+ * File signature verification is not needed, include only measurements
+ */
+static const char *const default_arch_rules[] = {
+	"measure func=KEXEC_KERNEL_CHECK",
+	"measure func=MODULE_CHECK",
+	NULL
+};
+
+/* Both file signature verification and measurements are needed */
+static const char *const sb_arch_rules[] = {
+	"measure func=KEXEC_KERNEL_CHECK",
+	"measure func=MODULE_CHECK",
+	"appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig",
+#if !IS_ENABLED(CONFIG_MODULE_SIG)
+	"appraise func=MODULE_CHECK appraise_type=imasig",
+#endif
+	NULL
+};
+
+/*
+ * On PowerPC, file measurements are to be added to the IMA measurement list
+ * irrespective of the secure boot state of the system. Signature verification
+ * is conditionally enabled based on the secure boot state.
+ */
+const char *const *arch_get_ima_policy(void)
+{
+	if (IS_ENABLED(CONFIG_IMA_ARCH_POLICY) && arch_ima_get_secureboot())
+		return sb_arch_rules;
+	return default_arch_rules;
+}
diff --git a/include/linux/ima.h b/include/linux/ima.h
index dc12fbcf484c..32f46d69ebd7 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -31,7 +31,8 @@ extern void ima_post_path_mknod(struct dentry *dentry);
 extern void ima_add_kexec_buffer(struct kimage *image);
 #endif
 
-#if defined(CONFIG_X86) && defined(CONFIG_EFI)
+#if defined(CONFIG_X86) && defined(CONFIG_EFI) \
+			|| defined(CONFIG_PPC_SECURE_BOOT)
 extern bool arch_ima_get_secureboot(void);
 extern const char * const *arch_get_ima_policy(void);
 #else
-- 
2.20.1
