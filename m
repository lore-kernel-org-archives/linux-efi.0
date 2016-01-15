From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 14/16] Xen: EFI: Parse DT parameters for Xen
	specific UEFI
Date: Fri, 15 Jan 2016 14:55:27 +0800
Message-ID: <1452840929-19612-15-git-send-email-zhaoshenglong@huawei.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a new function to parse DT parameters for Xen specific UEFI just
like the way for normal UEFI. Then it could reuse the existing codes.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 drivers/firmware/efi/efi.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 027ca21..2dbc2ac 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -24,6 +24,7 @@
 #include <linux/of_fdt.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <xen/xen.h>
 
 struct efi __read_mostly efi = {
 	.mps			= EFI_INVALID_TABLE_ADDR,
@@ -498,12 +499,14 @@ device_initcall(efi_load_efivars);
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
@@ -511,6 +514,14 @@ static __initdata struct {
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
@@ -520,15 +531,28 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info = data;
+	struct params *dt_params;
+	unsigned int size;
 	const void *prop;
 	void *dest;
 	u64 val;
 	int i, len;
 
-	if (depth != 1 || strcmp(uname, "chosen") != 0)
-		return 0;
+	if (efi_enabled(EFI_PARAVIRT)) {
+		if (depth != 2 || strcmp(uname, "uefi") != 0)
+			return 0;
 
-	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
+		dt_params = xen_fdt_params;
+		size = ARRAY_SIZE(xen_fdt_params);
+	} else {
+		if (depth != 1 || strcmp(uname, "chosen") != 0)
+			return 0;
+
+		dt_params = fdt_params;
+		size = ARRAY_SIZE(fdt_params);
+	}
+
+	for (i = 0; i < size; i++) {
 		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
 		if (!prop)
 			return 0;
@@ -552,6 +576,7 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 int __init efi_get_fdt_params(struct efi_fdt_params *params)
 {
 	struct param_info info;
+	struct params *dt_params;
 	int ret;
 
 	pr_info("Getting EFI parameters from FDT:\n");
@@ -559,12 +584,18 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params)
 	info.found = 0;
 	info.params = params;
 
+	if (efi_enabled(EFI_PARAVIRT))
+		dt_params = xen_fdt_params;
+	else
+		dt_params = fdt_params;
+
 	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
-	if (!info.found)
+	if (!info.found) {
 		pr_info("UEFI not found.\n");
-	else if (!ret)
+	} else if (!ret) {
 		pr_err("Can't find '%s' in device tree!\n",
 		       dt_params[info.found].name);
+	}
 
 	return ret;
 }
-- 
2.0.4
