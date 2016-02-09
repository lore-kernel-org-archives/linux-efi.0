From: Robert Richter <rrichter@caviumnetworks.com>
Subject: [PATCH v4 3/6] efi: move FDT handling to separate object file
Date: Tue, 9 Feb 2016 14:53:43 +0100
Message-ID: <1455026026-11571-4-git-send-email-rrichter@caviumnetworks.com>
References: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Robert Richter <rrichter@cavium.com>, Mark Salter <msalter@redhat.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The EFI specific FDT handling is compiled conditionally, and is
logically independent of the rest of efi.o. So move it to a separate
file before making changes to it in subsequent patches.

Acked-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Message-Id: <1442881288-13962-4-git-send-email-ard.biesheuvel@linaro.org>
[ rric: Ported to v4.5-rc1 ]
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 drivers/firmware/efi/Makefile  |  1 +
 drivers/firmware/efi/efi-fdt.c | 91 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c     | 84 --------------------------------------
 3 files changed, 92 insertions(+), 84 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-fdt.c

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 62e654f255f4..bb7ec2fac25c 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
+obj-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= efi-fdt.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/efi-fdt.c b/drivers/firmware/efi/efi-fdt.c
new file mode 100644
index 000000000000..8f3ce66e2b02
--- /dev/null
+++ b/drivers/firmware/efi/efi-fdt.c
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2013 - 2015 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/efi.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+
+#define UEFI_PARAM(name, prop, field)			   \
+	{						   \
+		{ name },				   \
+		{ prop },				   \
+		offsetof(struct efi_fdt_params, field),    \
+		FIELD_SIZEOF(struct efi_fdt_params, field) \
+	}
+
+static __initdata struct {
+	const char name[32];
+	const char propname[32];
+	int offset;
+	int size;
+} dt_params[] = {
+	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
+	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
+	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
+	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
+	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
+};
+
+struct param_info {
+	int found;
+	void *params;
+};
+
+static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
+				       int depth, void *data)
+{
+	struct param_info *info = data;
+	const void *prop;
+	void *dest;
+	u64 val;
+	int i, len;
+
+	if (depth != 1 || strcmp(uname, "chosen") != 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
+		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
+		if (!prop)
+			return 0;
+		dest = info->params + dt_params[i].offset;
+		info->found++;
+
+		val = of_read_number(prop, len / sizeof(u32));
+
+		if (dt_params[i].size == sizeof(u32))
+			*(u32 *)dest = val;
+		else
+			*(u64 *)dest = val;
+
+		if (efi_enabled(EFI_DBG))
+			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
+				dt_params[i].size * 2, val);
+	}
+	return 1;
+}
+
+int __init efi_get_fdt_params(struct efi_fdt_params *params)
+{
+	struct param_info info;
+	int ret;
+
+	pr_info("Getting EFI parameters from FDT:\n");
+
+	info.found = 0;
+	info.params = params;
+
+	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
+	if (!info.found)
+		pr_info("UEFI not found.\n");
+	else if (!ret)
+		pr_err("Can't find '%s' in device tree!\n",
+		       dt_params[info.found].name);
+
+	return ret;
+}
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2cd37dad67a6..7c41c4284814 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -20,8 +20,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/efi.h>
-#include <linux/of.h>
-#include <linux/of_fdt.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
@@ -490,88 +488,6 @@ static int __init efi_load_efivars(void)
 device_initcall(efi_load_efivars);
 #endif
 
-#ifdef CONFIG_EFI_PARAMS_FROM_FDT
-
-#define UEFI_PARAM(name, prop, field)			   \
-	{						   \
-		{ name },				   \
-		{ prop },				   \
-		offsetof(struct efi_fdt_params, field),    \
-		FIELD_SIZEOF(struct efi_fdt_params, field) \
-	}
-
-static __initdata struct {
-	const char name[32];
-	const char propname[32];
-	int offset;
-	int size;
-} dt_params[] = {
-	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
-	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
-	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
-	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
-	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
-};
-
-struct param_info {
-	int found;
-	void *params;
-};
-
-static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
-				       int depth, void *data)
-{
-	struct param_info *info = data;
-	const void *prop;
-	void *dest;
-	u64 val;
-	int i, len;
-
-	if (depth != 1 || strcmp(uname, "chosen") != 0)
-		return 0;
-
-	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
-		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
-		if (!prop)
-			return 0;
-		dest = info->params + dt_params[i].offset;
-		info->found++;
-
-		val = of_read_number(prop, len / sizeof(u32));
-
-		if (dt_params[i].size == sizeof(u32))
-			*(u32 *)dest = val;
-		else
-			*(u64 *)dest = val;
-
-		if (efi_enabled(EFI_DBG))
-			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
-				dt_params[i].size * 2, val);
-	}
-	return 1;
-}
-
-int __init efi_get_fdt_params(struct efi_fdt_params *params)
-{
-	struct param_info info;
-	int ret;
-
-	pr_info("Getting EFI parameters from FDT:\n");
-
-	info.found = 0;
-	info.params = params;
-
-	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
-	if (!info.found)
-		pr_info("UEFI not found.\n");
-	else if (!ret)
-		pr_err("Can't find '%s' in device tree!\n",
-		       dt_params[info.found].name);
-
-	return ret;
-}
-#endif /* CONFIG_EFI_PARAMS_FROM_FDT */
-
 static __initdata char memory_type_name[][20] = {
 	"Reserved",
 	"Loader Code",
-- 
2.7.0.rc3
