From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 17/17] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Fri, 5 Feb 2016 11:05:52 +0800
Message-ID: <1454641552-12576-18-git-send-email-zhaoshenglong@huawei.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a new function to parse DT parameters for Xen specific UEFI just
like the way for normal UEFI. Then it could reuse the existing codes.

If Xen supports EFI, initialize runtime services.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
CC: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm/xen/enlighten.c           |  6 +++++
 drivers/firmware/efi/arm-runtime.c | 17 +++++++++-----
 drivers/firmware/efi/efi.c         | 45 ++++++++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 0e542b8..026b5a7 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -261,6 +261,12 @@ static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
 	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
 		hyper_node.version = s + strlen(hyper_node.prefix);
 
+	if (IS_ENABLED(CONFIG_XEN_EFI)) {
+		/* Check if Xen supports EFI */
+		if (of_get_flat_dt_subnode_by_name(node, "uefi") > 0)
+			set_bit(EFI_PARAVIRT, &efi.flags);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 6ae21e4..ac609b9 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -27,6 +27,7 @@
 #include <asm/mmu.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm/xen/xen-ops.h>
 
 extern u64 efi_system_table;
 
@@ -107,13 +108,19 @@ static int __init arm_enable_runtime_services(void)
 	}
 	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
-	if (!efi_virtmap_init()) {
-		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
-		return -ENOMEM;
+	if (IS_ENABLED(CONFIG_XEN_EFI) && efi_enabled(EFI_PARAVIRT)) {
+		/* Set up runtime services function pointers for Xen Dom0 */
+		xen_efi_runtime_setup();
+	} else {
+		if (!efi_virtmap_init()) {
+			pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
+			return -ENOMEM;
+		}
+
+		/* Set up runtime services function pointers */
+		efi_native_runtime_setup();
 	}
 
-	/* Set up runtime services function pointers */
-	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
 	efi.runtime_version = efi.systab->hdr.revision;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2cd37da..1328cb7 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -500,12 +500,14 @@ device_initcall(efi_load_efivars);
 		FIELD_SIZEOF(struct efi_fdt_params, field) \
 	}
 
-static __initdata struct {
+struct params {
 	const char name[32];
 	const char propname[32];
 	int offset;
 	int size;
-} dt_params[] = {
+};
+
+static struct params fdt_params[] __initdata = {
 	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
 	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
 	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
@@ -513,24 +515,45 @@ static __initdata struct {
 	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
 };
 
+static struct params xen_fdt_params[] __initdata = {
+	UEFI_PARAM("System Table", "xen,uefi-system-table", system_table),
+	UEFI_PARAM("MemMap Address", "xen,uefi-mmap-start", mmap),
+	UEFI_PARAM("MemMap Size", "xen,uefi-mmap-size", mmap_size),
+	UEFI_PARAM("MemMap Desc. Size", "xen,uefi-mmap-desc-size", desc_size),
+	UEFI_PARAM("MemMap Desc. Version", "xen,uefi-mmap-desc-ver", desc_ver)
+};
+
 struct param_info {
 	int found;
 	void *params;
+	struct params *dt_params;
+	int size;
 };
 
 static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info = data;
+	struct params *dt_params = info->dt_params;
 	const void *prop;
 	void *dest;
 	u64 val;
-	int i, len;
+	int i, len, offset;
 
-	if (depth != 1 || strcmp(uname, "chosen") != 0)
-		return 0;
+	if (efi_enabled(EFI_PARAVIRT)) {
+		if (depth != 1 || strcmp(uname, "hypervisor") != 0)
+			return 0;
 
-	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
+		offset = of_get_flat_dt_subnode_by_name(node, "uefi");
+		if (offset < 0)
+			return 0;
+		node = offset;
+	} else {
+		if (depth != 1 || strcmp(uname, "chosen") != 0)
+			return 0;
+	}
+
+	for (i = 0; i < info->size; i++) {
 		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
 		if (!prop)
 			return 0;
@@ -561,12 +584,20 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params)
 	info.found = 0;
 	info.params = params;
 
+	if (efi_enabled(EFI_PARAVIRT)) {
+		info.dt_params = xen_fdt_params;
+		info.size = ARRAY_SIZE(xen_fdt_params);
+	} else {
+		info.dt_params = fdt_params;
+		info.size = ARRAY_SIZE(fdt_params);
+	}
+
 	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
 	if (!info.found)
 		pr_info("UEFI not found.\n");
 	else if (!ret)
 		pr_err("Can't find '%s' in device tree!\n",
-		       dt_params[info.found].name);
+		       info.dt_params[info.found].name);
 
 	return ret;
 }
-- 
2.0.4
