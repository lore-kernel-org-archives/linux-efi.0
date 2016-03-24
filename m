From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 12/17] ARM64: ACPI: Check if it runs on Xen to enable or disable ACPI
Date: Thu, 24 Mar 2016 22:44:31 +0800
Message-ID: <1458830676-27075-13-git-send-email-shannon.zhao@linaro.org>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458830676-27075-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
a /hypervisor node in DT. So check if it needs to enable ACPI.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/acpi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index d1ce8e2..4e92be0 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -67,10 +67,13 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
 {
 	/*
 	 * Return 1 as soon as we encounter a node at depth 1 that is
-	 * not the /chosen node.
+	 * not the /chosen node, or /hypervisor node when running on Xen.
 	 */
-	if (depth == 1 && (strcmp(uname, "chosen") != 0))
-		return 1;
+	if (depth == 1 && (strcmp(uname, "chosen") != 0)) {
+		if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
+			return 1;
+	}
+
 	return 0;
 }
 
@@ -184,7 +187,8 @@ void __init acpi_boot_table_init(void)
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
2.1.4
