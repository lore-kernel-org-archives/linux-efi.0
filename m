From: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Subject: [PATCH 13/13] ARM: XEN: Move xen_early_init() before efi_init()
Date: Tue, 17 Nov 2015 17:57:11 +0800
Message-ID: <1447754231-7772-14-git-send-email-shannon.zhao@linaro.org>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Move xen_early_init() before efi_init(), then when calling efi_init()
could initialize Xen specific UEFI.

Check if it runs on Xen hypervisor through the flat dts.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/xen/enlighten.c  | 62 ++++++++++++++++++++++++++++++++++++-----------
 arch/arm64/kernel/setup.c |  2 +-
 2 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index b8e9db8..d4f884c 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -19,6 +19,7 @@
 #include <linux/irqreturn.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/cpuidle.h>
@@ -48,8 +49,6 @@ struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
 
 static __read_mostly unsigned int xen_events_irq;
 
-static __initdata struct device_node *xen_node;
-
 int xen_remap_domain_gfn_array(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       xen_pfn_t *gfn, int nr,
@@ -142,6 +141,34 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+struct xen_node_info {
+	const char *compat;
+	const char *prefix;
+	const char *version;
+	bool found;
+};
+
+static int __init fdt_find_xen_node(unsigned long node, const char *uname,
+				    int depth, void *data)
+{
+	struct xen_node_info *info = data;
+	const void *s = NULL;
+	int len;
+
+	if (depth != 1 || strcmp(uname, "hypervisor") != 0)
+		return 0;
+
+	if (of_flat_dt_is_compatible(node, info->compat))
+		info->found = true;
+
+	s = of_get_flat_dt_prop(node, "compatible", &len);
+	if (strlen(info->prefix) + 3  < len &&
+                        !strncmp(info->prefix, s, strlen(info->prefix)))
+                info->version = s + strlen(info->prefix);
+
+	return 0;
+}
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
@@ -149,26 +176,25 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
 #define GRANT_TABLE_PHYSADDR 0
 void __init xen_early_init(void)
 {
-	int len;
-	const char *s = NULL;
-	const char *version = NULL;
-	const char *xen_prefix = "xen,xen-";
+	struct xen_node_info info;
+
+	info.compat = "xen,xen";
+	info.prefix = "xen,xen-";
+	info.version = NULL;
+	info.found = false;
 
-	xen_node = of_find_compatible_node(NULL, NULL, "xen,xen");
-	if (!xen_node) {
+	of_scan_flat_dt(fdt_find_xen_node, &info);
+	if (!info.found) {
 		pr_debug("No Xen support\n");
 		return;
 	}
-	s = of_get_property(xen_node, "compatible", &len);
-	if (strlen(xen_prefix) + 3  < len &&
-			!strncmp(xen_prefix, s, strlen(xen_prefix)))
-		version = s + strlen(xen_prefix);
-	if (version == NULL) {
+
+	if (info.version == NULL) {
 		pr_debug("Xen version not found\n");
 		return;
 	}
 
-	pr_info("Xen %s support found\n", version);
+	pr_info("Xen %s support found\n", info.version);
 
 	xen_domain_type = XEN_HVM_DOMAIN;
 
@@ -204,6 +230,14 @@ static int __init xen_guest_init(void)
 		}
 		xen_events_irq = a.value & 0xff;
 	} else {
+		struct device_node *xen_node;
+
+		xen_node = of_find_compatible_node(NULL, NULL, "xen,xen");
+		if (!xen_node) {
+			pr_debug("No Xen support\n");
+			return -ENODEV;
+		}
+
 		xen_events_irq = irq_of_parse_and_map(xen_node, 0);
 		if (!xen_events_irq) {
 			pr_err("Xen event channel interrupt not found\n");
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 2322479..ee95593 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -428,6 +428,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	local_async_enable();
 
+	xen_early_init();
 	efi_init();
 	arm64_memblock_init();
 
@@ -446,7 +447,6 @@ void __init setup_arch(char **cmdline_p)
 	} else {
 		psci_acpi_init();
 	}
-	xen_early_init();
 
 	cpu_read_bootcpu_ops();
 	smp_init_cpus();
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
