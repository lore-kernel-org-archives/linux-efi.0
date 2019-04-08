From: Nayna Jain <nayna@linux.ibm.com>
Subject: [PATCH v2 2/3] powerpc/powernv: detect the secure boot mode of the system
Date: Mon,  8 Apr 2019 18:52:33 -0400
Message-ID: <1554763954-11795-3-git-send-email-nayna@linux.ibm.com>
References: <1554763954-11795-1-git-send-email-nayna@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554763954-11795-1-git-send-email-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Mimi Zohar <zohar@linux.ibm.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

PowerNV secure boot defines different IMA policies based on the secure
boot state of the system.

This patch defines a function to detect the secure boot state of the
system.

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
---
 arch/powerpc/include/asm/secboot.h       | 21 +++++++++
 arch/powerpc/platforms/powernv/Makefile  |  3 +-
 arch/powerpc/platforms/powernv/secboot.c | 54 ++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/secboot.h
 create mode 100644 arch/powerpc/platforms/powernv/secboot.c

diff --git a/arch/powerpc/include/asm/secboot.h b/arch/powerpc/include/asm/secboot.h
new file mode 100644
index 000000000000..1904fb4a3352
--- /dev/null
+++ b/arch/powerpc/include/asm/secboot.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * PowerPC secure boot definitions
+ *
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Nayna Jain <nayna@linux.ibm.com>
+ *
+ */
+#ifndef POWERPC_SECBOOT_H
+#define POWERPC_SECBOOT_H
+
+#if defined(CONFIG_OPAL_SECVAR)
+extern bool get_powerpc_sb_mode(void);
+#else
+static inline bool get_powerpc_sb_mode(void)
+{
+	return false;
+}
+#endif
+
+#endif
diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
index 1511d836fd19..e3224f1019eb 100644
--- a/arch/powerpc/platforms/powernv/Makefile
+++ b/arch/powerpc/platforms/powernv/Makefile
@@ -4,6 +4,7 @@ obj-y			+= idle.o opal-rtc.o opal-nvram.o opal-lpc.o opal-flash.o
 obj-y			+= rng.o opal-elog.o opal-dump.o opal-sysparam.o opal-sensor.o
 obj-y			+= opal-msglog.o opal-hmi.o opal-power.o opal-irqchip.o
 obj-y			+= opal-kmsg.o opal-powercap.o opal-psr.o opal-sensor-groups.o
+obj-y			+= secboot.o
 
 obj-$(CONFIG_SMP)	+= smp.o subcore.o subcore-asm.o
 obj-$(CONFIG_PCI)	+= pci.o pci-ioda.o npu-dma.o pci-ioda-tce.o
@@ -16,4 +17,4 @@ obj-$(CONFIG_PERF_EVENTS) += opal-imc.o
 obj-$(CONFIG_PPC_MEMTRACE)	+= memtrace.o
 obj-$(CONFIG_PPC_VAS)	+= vas.o vas-window.o vas-debug.o
 obj-$(CONFIG_OCXL_BASE)	+= ocxl.o
-obj-$(CONFIG_OPAL_SECVAR)	+= opal-secvar.o
+obj-$(CONFIG_OPAL_SECVAR)	+= opal-secvar.o secboot.o
diff --git a/arch/powerpc/platforms/powernv/secboot.c b/arch/powerpc/platforms/powernv/secboot.c
new file mode 100644
index 000000000000..a9c5717bb78e
--- /dev/null
+++ b/arch/powerpc/platforms/powernv/secboot.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Nayna Jain <nayna@linux.ibm.com>
+ *
+ * secboot.c
+ *      - util functions to get powerpc secboot state
+ */
+#include <linux/efi.h>
+#include <asm/secboot.h>
+#include <asm/opal-secvar.h>
+
+bool get_powerpc_sb_mode(void)
+{
+	efi_char16_t efi_SecureBoot_name[] = L"SecureBoot";
+	efi_char16_t efi_SetupMode_name[] = L"SetupMode";
+	efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
+	efi_status_t status;
+	u8 secboot, setupmode;
+	unsigned long size = sizeof(secboot);
+
+	status = opal_get_variable(efi_SecureBoot_name, &efi_variable_guid,
+				  NULL, &size, &secboot);
+
+	/*
+	 * For now assume all failures reading the SecureBoot variable implies
+	 * secure boot is not enabled. Later differentiate failure types.
+	 */
+	if (status != EFI_SUCCESS) {
+		secboot = 0;
+		setupmode = 0;
+		goto out;
+	}
+
+	size = sizeof(setupmode);
+	status = opal_get_variable(efi_SetupMode_name, &efi_variable_guid,
+				  NULL, &size, &setupmode);
+
+	/*
+	 * Failure to read the SetupMode variable does not prevent
+	 * secure boot mode
+	 */
+	if (status != EFI_SUCCESS)
+		setupmode = 0;
+
+out:
+	if ((secboot == 0) || (setupmode == 1)) {
+		pr_info("secboot: secureboot mode disabled\n");
+		return false;
+	}
+
+	pr_info("secboot: secureboot mode enabled\n");
+	return true;
+}
-- 
2.20.1
