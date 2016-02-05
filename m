From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 16/17] FDT: Add a helper to get specified name subnode
Date: Fri, 5 Feb 2016 11:05:51 +0800
Message-ID: <1454641552-12576-17-git-send-email-zhaoshenglong@huawei.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Rob Herring <robh@kernel.org>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Sometimes it needs to check if there is a node in FDT by full path.
Introduce this helper to get the specified name subnode if it exists.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
CC: Rob Herring <robh@kernel.org>
---
 drivers/of/fdt.c       | 25 +++++++++++++++++++++++++
 include/linux/of_fdt.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 655f79d..eacb188 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -645,6 +645,31 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 }
 
 /**
+ * of_get_flat_dt_subnode_by_name - get subnode of specified node by name
+ *
+ * @node: the parent node
+ * @uname: the name of subnode
+ * @return offset of the subnode, or -FDT_ERR_NOTFOUND if there is none
+ */
+
+int of_get_flat_dt_subnode_by_name(unsigned long node, const char *uname)
+{
+	const void *blob = initial_boot_params;
+	int offset;
+	const char *pathp;
+
+	for (offset = fdt_first_subnode(blob, node);
+	     offset >= 0;
+	     offset = fdt_next_subnode(blob, offset)) {
+		pathp = fdt_get_name(blob, offset, NULL);
+		if (strcmp(pathp, uname) == 0)
+			return offset;
+	}
+
+	return -FDT_ERR_NOTFOUND;
+}
+
+/**
  * of_get_flat_dt_root - find the root node in the flat blob
  */
 unsigned long __init of_get_flat_dt_root(void)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index df9ef38..fc28162 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -52,6 +52,8 @@ extern char __dtb_end[];
 extern int of_scan_flat_dt(int (*it)(unsigned long node, const char *uname,
 				     int depth, void *data),
 			   void *data);
+extern int of_get_flat_dt_subnode_by_name(unsigned long node,
+					  const char *uname);
 extern const void *of_get_flat_dt_prop(unsigned long node, const char *name,
 				       int *size);
 extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
-- 
2.0.4
