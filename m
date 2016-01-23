From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v3 15/17] ARM64: XEN: Add a function to
	initialize Xen specific UEFI runtime services
Date: Sat, 23 Jan 2016 11:19:42 +0800
Message-ID: <1453519184-11908-16-git-send-email-zhaoshenglong@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

When running on Xen hypervisor, runtime services are supported through
hypercall. Add a Xen specific function to initialize runtime services.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/xen/xen-ops.h |  6 ++++++
 arch/arm64/xen/Makefile              |  1 +
 arch/arm64/xen/efi.c                 | 40 ++++++++++++++++++++++++++++++++++++
 drivers/xen/Kconfig                  |  2 +-
 4 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/xen/xen-ops.h
 create mode 100644 arch/arm64/xen/efi.c

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
index 74a8d87..62e6fe2 100644
--- a/arch/arm64/xen/Makefile
+++ b/arch/arm64/xen/Makefile
@@ -1,2 +1,3 @@
 xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o mm.o)
 obj-y		:= xen-arm.o hypercall.o
+obj-$(CONFIG_XEN_EFI) += efi.o
diff --git a/arch/arm64/xen/efi.c b/arch/arm64/xen/efi.c
new file mode 100644
index 0000000..b9cae65
--- /dev/null
+++ b/arch/arm64/xen/efi.c
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
+/* Set XEN EFI runtime services function pointers. Other fileds of struct efi,
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
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 73708ac..27d216a 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -268,7 +268,7 @@ config XEN_HAVE_PVMMU
 
 config XEN_EFI
 	def_bool y
-	depends on X86_64 && EFI
+	depends on (ARM64 || X86_64) && EFI
 
 config XEN_AUTO_XLATE
 	def_bool y
-- 
2.0.4
