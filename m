From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Fri, 6 May 2016 16:32:06 +0800
Message-ID: <1462523526-3172-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stefano-yd54mjeZNzVBDgjK7y7TUQ@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Add a new function to parse DT parameters for Xen specific UEFI just
like the way for normal UEFI. Then it could reuse the existing codes.

If Xen supports EFI, initialize runtime services.

CC: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
Drop using of EFI_PARAVIRT. Discussion can be found from [1].
[1] https://lkml.org/lkml/2016/4/29/8
---
 arch/arm/include/asm/efi.h         |  2 +
 arch/arm/xen/enlighten.c           | 16 ++++++++
 arch/arm64/include/asm/efi.h       |  2 +
 drivers/firmware/efi/arm-runtime.c | 70 +++++++++++++++++++++++---------
 drivers/firmware/efi/efi.c         | 81 ++++++++++++++++++++++++++++++--------
 5 files changed, 137 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e0eea72..5ba4343 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -52,9 +52,11 @@ static inline void efi_set_pgd(struct mm_struct *mm)
 
 void efi_virtmap_load(void);
 void efi_virtmap_unload(void);
+int xen_arm_enable_runtime_services(void);
 
 #else
 #define efi_init()
+#define xen_arm_enable_runtime_services() (0)
 #endif /* CONFIG_EFI */
 
 /* arch specific definitions used by the stub code */
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 13e3e9f..3362870 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -16,6 +16,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <asm/system_misc.h>
+#include <asm/efi.h>
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/module.h>
@@ -261,6 +262,13 @@ static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
 	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
 		hyper_node.version = s + strlen(hyper_node.prefix);
 
+	if (IS_ENABLED(CONFIG_XEN_EFI)) {
+		/* Check if Xen supports EFI */
+		if ((of_get_flat_dt_subnode_by_name(node, "uefi") > 0) &&
+		    !efi_runtime_disabled())
+			set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	}
+
 	return 0;
 }
 
@@ -338,6 +346,7 @@ static int __init xen_guest_init(void)
 {
 	struct xen_add_to_physmap xatp;
 	struct shared_info *shared_info_page = NULL;
+	int ret;
 
 	if (!xen_domain())
 		return 0;
@@ -352,6 +361,13 @@ static int __init xen_guest_init(void)
 		return -ENODEV;
 	}
 
+	if (IS_ENABLED(CONFIG_XEN_EFI) && efi_enabled(EFI_BOOT) &&
+	    efi_enabled(EFI_RUNTIME_SERVICES)) {
+		ret = xen_arm_enable_runtime_services();
+		if (ret)
+			return ret;
+	}
+
 	shared_info_page = (struct shared_info *)get_zeroed_page(GFP_KERNEL);
 
 	if (!shared_info_page) {
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8e88a69..574bee5 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -8,8 +8,10 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
+int xen_arm_enable_runtime_services(void);
 #else
 #define efi_init()
+#define xen_arm_enable_runtime_services() (0)
 #endif
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 6ae21e4..211ec10 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -27,6 +27,7 @@
 #include <asm/mmu.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm/xen/xen-ops.h>
 
 extern u64 efi_system_table;
 
@@ -39,6 +40,33 @@ static struct mm_struct efi_mm = {
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 };
 
+static int __init efi_remap_init(void)
+{
+	u64 mapsize;
+
+	pr_info("Remapping and enabling EFI services.\n");
+
+	mapsize = memmap.map_end - memmap.map;
+	memmap.map = (__force void *)ioremap_cache(memmap.phys_map,
+						   mapsize);
+	if (!memmap.map) {
+		pr_err("Failed to remap EFI memory map\n");
+		return -ENOMEM;
+	}
+	memmap.map_end = memmap.map + mapsize;
+	efi.memmap = &memmap;
+
+	efi.systab = (__force void *)ioremap_cache(efi_system_table,
+						   sizeof(efi_system_table_t));
+	if (!efi.systab) {
+		pr_err("Failed to remap EFI System Table\n");
+		return -ENOMEM;
+	}
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
+	return 0;
+}
+
 static bool __init efi_virtmap_init(void)
 {
 	efi_memory_desc_t *md;
@@ -75,7 +103,7 @@ static bool __init efi_virtmap_init(void)
  */
 static int __init arm_enable_runtime_services(void)
 {
-	u64 mapsize;
+	int ret;
 
 	if (!efi_enabled(EFI_BOOT)) {
 		pr_info("EFI services will not be available.\n");
@@ -87,25 +115,14 @@ static int __init arm_enable_runtime_services(void)
 		return 0;
 	}
 
-	pr_info("Remapping and enabling EFI services.\n");
-
-	mapsize = memmap.map_end - memmap.map;
-	memmap.map = (__force void *)ioremap_cache(memmap.phys_map,
-						   mapsize);
-	if (!memmap.map) {
-		pr_err("Failed to remap EFI memory map\n");
-		return -ENOMEM;
+	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_info("EFI runtime services access via paravirt.\n");
+		return 0;
 	}
-	memmap.map_end = memmap.map + mapsize;
-	efi.memmap = &memmap;
 
-	efi.systab = (__force void *)ioremap_cache(efi_system_table,
-						   sizeof(efi_system_table_t));
-	if (!efi.systab) {
-		pr_err("Failed to remap EFI System Table\n");
-		return -ENOMEM;
-	}
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+	ret = efi_remap_init();
+	if (ret)
+		return ret;
 
 	if (!efi_virtmap_init()) {
 		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
@@ -122,6 +139,23 @@ static int __init arm_enable_runtime_services(void)
 }
 early_initcall(arm_enable_runtime_services);
 
+int __init xen_arm_enable_runtime_services(void)
+{
+	int ret;
+
+	ret = efi_remap_init();
+	if (ret)
+		return ret;
+
+	if (IS_ENABLED(CONFIG_XEN_EFI)) {
+		/* Set up runtime services function pointers for Xen Dom0 */
+		xen_efi_runtime_setup();
+		efi.runtime_version = efi.systab->hdr.revision;
+	}
+
+	return 0;
+}
+
 void efi_virtmap_load(void)
 {
 	preempt_disable();
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3a69ed5..f586e1e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -469,12 +469,14 @@ device_initcall(efi_load_efivars);
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
+static __initdata struct params fdt_params[] = {
 	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
 	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
 	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
@@ -482,44 +484,91 @@ static __initdata struct {
 	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
 };
 
+static __initdata struct params xen_fdt_params[] = {
+	UEFI_PARAM("System Table", "xen,uefi-system-table", system_table),
+	UEFI_PARAM("MemMap Address", "xen,uefi-mmap-start", mmap),
+	UEFI_PARAM("MemMap Size", "xen,uefi-mmap-size", mmap_size),
+	UEFI_PARAM("MemMap Desc. Size", "xen,uefi-mmap-desc-size", desc_size),
+	UEFI_PARAM("MemMap Desc. Version", "xen,uefi-mmap-desc-ver", desc_ver)
+};
+
+#define EFI_FDT_PARAMS_SIZE	ARRAY_SIZE(fdt_params)
+
+static __initdata struct {
+	const char *uname;
+	const char *subnode;
+	struct params *params;
+} dt_params[] = {
+	{ "hypervisor", "uefi", xen_fdt_params },
+	{ "chosen", NULL, fdt_params },
+};
+
 struct param_info {
 	int found;
 	void *params;
+	const char *missing;
 };
 
-static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
-				       int depth, void *data)
+static int __init __find_uefi_params(unsigned long node,
+				     struct param_info *info,
+				     struct params *params)
 {
-	struct param_info *info = data;
 	const void *prop;
 	void *dest;
 	u64 val;
 	int i, len;
 
-	if (depth != 1 || strcmp(uname, "chosen") != 0)
-		return 0;
-
-	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
-		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
-		if (!prop)
+	for (i = 0; i < EFI_FDT_PARAMS_SIZE; i++) {
+		prop = of_get_flat_dt_prop(node, params[i].propname, &len);
+		if (!prop) {
+			info->missing = params[i].name;
 			return 0;
-		dest = info->params + dt_params[i].offset;
+		}
+
+		dest = info->params + params[i].offset;
 		info->found++;
 
 		val = of_read_number(prop, len / sizeof(u32));
 
-		if (dt_params[i].size == sizeof(u32))
+		if (params[i].size == sizeof(u32))
 			*(u32 *)dest = val;
 		else
 			*(u64 *)dest = val;
 
 		if (efi_enabled(EFI_DBG))
-			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
-				dt_params[i].size * 2, val);
+			pr_info("  %s: 0x%0*llx\n", params[i].name,
+				params[i].size * 2, val);
 	}
+
 	return 1;
 }
 
+static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
+				       int depth, void *data)
+{
+	struct param_info *info = data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
+		const char *subnode = dt_params[i].subnode;
+
+		if (depth != 1 || strcmp(uname, dt_params[i].uname) != 0) {
+			info->missing = dt_params[i].params[0].name;
+			continue;
+		}
+
+		if (subnode) {
+			node = of_get_flat_dt_subnode_by_name(node, subnode);
+			if (node < 0)
+				return 0;
+		}
+
+		return __find_uefi_params(node, info, dt_params[i].params);
+	}
+
+	return 0;
+}
+
 int __init efi_get_fdt_params(struct efi_fdt_params *params)
 {
 	struct param_info info;
@@ -535,7 +584,7 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params)
 		pr_info("UEFI not found.\n");
 	else if (!ret)
 		pr_err("Can't find '%s' in device tree!\n",
-		       dt_params[info.found].name);
+		       info.missing);
 
 	return ret;
 }
-- 
2.0.4
