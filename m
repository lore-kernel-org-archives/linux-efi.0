From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 17/17] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Thu, 24 Mar 2016 22:44:36 +0800
Message-ID: <1458830676-27075-18-git-send-email-shannon.zhao@linaro.org>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458830676-27075-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add a new function to parse DT parameters for Xen specific UEFI just
like the way for normal UEFI. Then it could reuse the existing codes.

If Xen supports EFI, initialize runtime services.

CC: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
---
 arch/arm/xen/enlighten.c           |  6 +++++
 drivers/firmware/efi/arm-runtime.c | 17 +++++++++-----
 drivers/firmware/efi/efi.c         | 45 ++++++++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index c43617f..9d52342b 100644
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
2.1.4
