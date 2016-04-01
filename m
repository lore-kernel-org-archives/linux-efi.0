From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v10 16/17] FDT: Add a helper to get the subnode by given name
Date: Fri,  1 Apr 2016 23:49:14 +0800
Message-ID: <1459525755-36968-17-git-send-email-shannon.zhao@linaro.org>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com
Cc: david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, shannon.zhao@linaro.org, Rob Herring <robh@kernel.org>
List-Id: linux-efi@vger.kernel.org

Sometimes it needs to check if there is a subnode of given node in FDT
by given name. Introduce this helper to get the subnode if it exists.

CC: Rob Herring <robh@kernel.org>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 drivers/of/fdt.c       | 13 +++++++++++++
 include/linux/of_fdt.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 3349d2a..5c8b2f2 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -645,6 +645,19 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 }
 
 /**
+ * of_get_flat_dt_subnode_by_name - get the subnode by given name
+ *
+ * @node: the parent node
+ * @uname: the name of subnode
+ * @return offset of the subnode, or -FDT_ERR_NOTFOUND if there is none
+ */
+
+int of_get_flat_dt_subnode_by_name(unsigned long node, const char *uname)
+{
+	return fdt_subnode_offset(initial_boot_params, node, uname);
+}
+
+/**
  * of_get_flat_dt_root - find the root node in the flat blob
  */
 unsigned long __init of_get_flat_dt_root(void)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 2fbe868..2c3707e 100644
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
2.1.4
