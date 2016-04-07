From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v11 11/17] ARM: XEN: Move xen_early_init() before efi_init()
Date: Thu, 7 Apr 2016 20:03:28 +0800
Message-ID: <1460030614-16112-12-git-send-email-zhaoshenglong@huawei.com>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, david.vrabel@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Russell King <linux@arm.linux.org.uk>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Move xen_early_init() before efi_init(), then when calling efi_init()
could initialize Xen specific UEFI.

Check if it runs on Xen hypervisor through the flat dts.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm/kernel/setup.c   |  2 +-
 arch/arm/xen/enlighten.c  | 56 ++++++++++++++++++++++++++++++++++-------------
 arch/arm64/kernel/setup.c |  2 +-
 3 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 139791e..5bc7516 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1035,6 +1035,7 @@ void __init setup_arch(char **cmdline_p)
 	early_paging_init(mdesc);
 #endif
 	setup_dma_zone(mdesc);
+	xen_early_init();
 	efi_init();
 	sanity_check_meminfo();
 	arm_memblock_init(mdesc);
@@ -1051,7 +1052,6 @@ void __init setup_arch(char **cmdline_p)
 
 	arm_dt_init_cpu_maps();
 	psci_dt_init();
-	xen_early_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
 		if (!mdesc->smp_init || !mdesc->smp_init()) {
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 06bd61a..13e3e9f 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -20,6 +20,7 @@
 #include <linux/irqreturn.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/cpuidle.h>
@@ -53,8 +54,6 @@ struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
 
 static __read_mostly unsigned int xen_events_irq;
 
-static __initdata struct device_node *xen_node;
-
 int xen_remap_domain_gfn_array(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       xen_pfn_t *gfn, int nr,
@@ -238,6 +237,33 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static __initdata struct {
+	const char *compat;
+	const char *prefix;
+	const char *version;
+	bool found;
+} hyper_node = {"xen,xen", "xen,xen-", NULL, false};
+
+static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
+				      int depth, void *data)
+{
+	const void *s = NULL;
+	int len;
+
+	if (depth != 1 || strcmp(uname, "hypervisor") != 0)
+		return 0;
+
+	if (of_flat_dt_is_compatible(node, hyper_node.compat))
+		hyper_node.found = true;
+
+	s = of_get_flat_dt_prop(node, "compatible", &len);
+	if (strlen(hyper_node.prefix) + 3  < len &&
+	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
+		hyper_node.version = s + strlen(hyper_node.prefix);
+
+	return 0;
+}
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
@@ -245,26 +271,18 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
 #define GRANT_TABLE_PHYSADDR 0
 void __init xen_early_init(void)
 {
-	int len;
-	const char *s = NULL;
-	const char *version = NULL;
-	const char *xen_prefix = "xen,xen-";
-
-	xen_node = of_find_compatible_node(NULL, NULL, "xen,xen");
-	if (!xen_node) {
+	of_scan_flat_dt(fdt_find_hyper_node, NULL);
+	if (!hyper_node.found) {
 		pr_debug("No Xen support\n");
 		return;
 	}
-	s = of_get_property(xen_node, "compatible", &len);
-	if (strlen(xen_prefix) + 3  < len &&
-			!strncmp(xen_prefix, s, strlen(xen_prefix)))
-		version = s + strlen(xen_prefix);
-	if (version == NULL) {
+
+	if (hyper_node.version == NULL) {
 		pr_debug("Xen version not found\n");
 		return;
 	}
 
-	pr_info("Xen %s support found\n", version);
+	pr_info("Xen %s support found\n", hyper_node.version);
 
 	xen_domain_type = XEN_HVM_DOMAIN;
 
@@ -305,6 +323,14 @@ static void __init xen_acpi_guest_init(void)
 
 static void __init xen_dt_guest_init(void)
 {
+	struct device_node *xen_node;
+
+	xen_node = of_find_compatible_node(NULL, NULL, "xen,xen");
+	if (!xen_node) {
+		pr_err("Xen support was detected before, but it has disappeared\n");
+		return;
+	}
+
 	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
 }
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 9dc6776..7cf992f 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -320,6 +320,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	cpu_uninstall_idmap();
 
+	xen_early_init();
 	efi_init();
 	arm64_memblock_init();
 
@@ -341,7 +342,6 @@ void __init setup_arch(char **cmdline_p)
 	} else {
 		psci_acpi_init();
 	}
-	xen_early_init();
 
 	cpu_read_bootcpu_ops();
 	smp_init_cpus();
-- 
2.0.4
