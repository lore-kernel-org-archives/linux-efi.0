From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: [PATCH 1/4] powerpc/include: Override unneeded early ioremap functions
Date: Tue,  2 Apr 2019 15:15:02 -0300
Message-ID: <20190402181505.25037-2-cclaudio@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

When CONFIG_EFI is enabled, the EFI driver includes the generic
early_ioremap header, which assumes that architectures may want to
provide their own early ioremap functions.

This patch overrides the ioremap functions in powerpc because they are
not required for secure boot on powerpc systems.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/include/asm/early_ioremap.h | 41 ++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 arch/powerpc/include/asm/early_ioremap.h

diff --git a/arch/powerpc/include/asm/early_ioremap.h b/arch/powerpc/include/asm/early_ioremap.h
new file mode 100644
index 000000000000..a86a06e9f3b9
--- /dev/null
+++ b/arch/powerpc/include/asm/early_ioremap.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Early ioremap definitions
+ *
+ * Copyright (C) 2019 IBM Corporation
+ * Author: Claudio Carvalho <cclaudio@linux.ibm.com>
+ *
+ */
+#ifndef _ASM_POWERPC_EARLY_IOREMAP_H
+#define _ASM_POWERPC_EARLY_IOREMAP_H
+
+static inline void __iomem *early_ioremap(resource_size_t phys_addr,
+					  unsigned long size)
+{
+	return NULL;
+}
+
+static inline void *early_memremap(resource_size_t phys_addr,
+				   unsigned long size)
+{
+	return NULL;
+}
+
+static inline void *early_memremap_ro(resource_size_t phys_addr,
+				      unsigned long size)
+{
+	return NULL;
+}
+
+static inline void *early_memremap_prot(resource_size_t phys_addr,
+					unsigned long size,
+					unsigned long prot_val)
+{
+	return NULL;
+}
+
+static inline void early_iounmap(void __iomem *addr, unsigned long size) { }
+static inline void early_memunmap(void *addr, unsigned long size) { }
+static inline void early_ioremap_shutdown(void) { }
+
+#endif
-- 
2.20.1
