From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 15/17] ARM64: XEN: Add a function to initialize Xen specific UEFI runtime services
Date: Fri, 4 Mar 2016 14:37:33 +0800
Message-ID: <1457073455-11516-16-git-send-email-zhaoshenglong@huawei.com>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, hangaohuai@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

When running on Xen hypervisor, runtime services are supported through
hypercall. Add a Xen specific function to initialize runtime services.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/xen-ops.h   |  6 ++++++
 arch/arm/xen/Makefile                |  1 +
 arch/arm/xen/efi.c                   | 40 ++++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/xen/xen-ops.h |  6 ++++++
 arch/arm64/xen/Makefile              |  1 +
 drivers/xen/Kconfig                  |  2 +-
 6 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/xen/xen-ops.h
 create mode 100644 arch/arm/xen/efi.c
 create mode 100644 arch/arm64/include/asm/xen/xen-ops.h

diff --git a/arch/arm/include/asm/xen/xen-ops.h b/arch/arm/include/asm/xen/xen-ops.h
new file mode 100644
index 0000000..ec154e7
--- /dev/null
+++ b/arch/arm/include/asm/xen/xen-ops.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_XEN_OPS_H
+#define _ASM_XEN_OPS_H
+
+void xen_efi_runtime_setup(void);
+
+#endif /* _ASM_XEN_OPS_H */
diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 1296952..2279521 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1,2 @@
 obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o mm.o
+obj-$(CONFIG_XEN_EFI) += efi.o
diff --git a/arch/arm/xen/efi.c b/arch/arm/xen/efi.c
new file mode 100644
index 0000000..16db419
--- /dev/null
+++ b/arch/arm/xen/efi.c
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2015, Linaro Limited, Shannon Zhao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/efi.h>
+#include <xen/xen-ops.h>
+#include <asm/xen/xen-ops.h>
+
+/* Set XEN EFI runtime services function pointers. Other fields of struct efi,
+ * e.g. efi.systab, will be set like normal EFI.
+ */
+void __init xen_efi_runtime_setup(void)
+{
+	efi.get_time                 = xen_efi_get_time;
+	efi.set_time                 = xen_efi_set_time;
+	efi.get_wakeup_time          = xen_efi_get_wakeup_time;
+	efi.set_wakeup_time          = xen_efi_set_wakeup_time;
+	efi.get_variable             = xen_efi_get_variable;
+	efi.get_next_variable        = xen_efi_get_next_variable;
+	efi.set_variable             = xen_efi_set_variable;
+	efi.query_variable_info      = xen_efi_query_variable_info;
+	efi.update_capsule           = xen_efi_update_capsule;
+	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
+	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
+	efi.reset_system             = NULL; /* Functionality provided by Xen. */
+}
+EXPORT_SYMBOL_GPL(xen_efi_runtime_setup);
diff --git a/arch/arm64/include/asm/xen/xen-ops.h b/arch/arm64/include/asm/xen/xen-ops.h
new file mode 100644
index 0000000..ec154e7
--- /dev/null
+++ b/arch/arm64/include/asm/xen/xen-ops.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_XEN_OPS_H
+#define _ASM_XEN_OPS_H
+
+void xen_efi_runtime_setup(void);
+
+#endif /* _ASM_XEN_OPS_H */
diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
index 74a8d87..8ff8aa9 100644
--- a/arch/arm64/xen/Makefile
+++ b/arch/arm64/xen/Makefile
@@ -1,2 +1,3 @@
 xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o mm.o)
 obj-y		:= xen-arm.o hypercall.o
+obj-$(CONFIG_XEN_EFI) += $(addprefix ../../arm/xen/, efi.o)
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 73708ac..d50571c 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -268,7 +268,7 @@ config XEN_HAVE_PVMMU
 
 config XEN_EFI
 	def_bool y
-	depends on X86_64 && EFI
+	depends on (ARM || ARM64 || X86_64) && EFI
 
 config XEN_AUTO_XLATE
 	def_bool y
-- 
2.0.4
