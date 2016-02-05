From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 11/17] ARM: XEN: Move xen_early_init() before
	efi_init()
Date: Fri, 5 Feb 2016 11:05:46 +0800
Message-ID: <1454641552-12576-12-git-send-email-zhaoshenglong@huawei.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Move xen_early_init() before efi_init(), then when calling efi_init()
could initialize Xen specific UEFI.

Check if it runs on Xen hypervisor through the flat dts.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c  | 56 ++++++++++++++++++++++++++++++++++-------------
 arch/arm64/kernel/setup.c |  2 +-
 2 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 807a93e..0e542b8 100644
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
index 8119479..a4a2878 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -313,6 +313,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	local_async_enable();
 
+	xen_early_init();
 	efi_init();
 	arm64_memblock_init();
 
@@ -334,7 +335,6 @@ void __init setup_arch(char **cmdline_p)
 	} else {
 		psci_acpi_init();
 	}
-	xen_early_init();
 
 	cpu_read_bootcpu_ops();
 	smp_init_cpus();
-- 
2.0.4
