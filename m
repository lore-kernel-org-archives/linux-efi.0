From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v11 12/17] ARM64: ACPI: Check if it runs on Xen to enable or disable ACPI
Date: Thu, 7 Apr 2016 20:03:29 +0800
Message-ID: <1460030614-16112-13-git-send-email-zhaoshenglong@huawei.com>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, david.vrabel@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
a /hypervisor node in DT. So check if it needs to enable ACPI.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/acpi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index d1ce8e2..57ee317 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -67,10 +67,15 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
 {
 	/*
 	 * Return 1 as soon as we encounter a node at depth 1 that is
-	 * not the /chosen node.
+	 * not the /chosen node, or /hypervisor node with compatible
+	 * string "xen,xen".
 	 */
-	if (depth == 1 && (strcmp(uname, "chosen") != 0))
-		return 1;
+	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
+		if (strcmp(uname, "hypervisor") != 0 ||
+		    !of_flat_dt_is_compatible(node, "xen,xen"))
+			return 1;
+	}
+
 	return 0;
 }
 
@@ -184,7 +189,8 @@ void __init acpi_boot_table_init(void)
 	/*
 	 * Enable ACPI instead of device tree unless
 	 * - ACPI has been disabled explicitly (acpi=off), or
-	 * - the device tree is not empty (it has more than just a /chosen node)
+	 * - the device tree is not empty (it has more than just a /chosen node,
+	 *   and a /hypervisor node when running on Xen)
 	 *   and ACPI has not been force enabled (acpi=force)
 	 */
 	if (param_acpi_off ||
-- 
2.0.4
