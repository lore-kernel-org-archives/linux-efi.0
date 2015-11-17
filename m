From: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Subject: [PATCH 10/13] ARM64: ACPI: Check if it runs on Xen to enable or disable ACPI
Date: Tue, 17 Nov 2015 17:57:08 +0800
Message-ID: <1447754231-7772-11-git-send-email-shannon.zhao@linaro.org>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

When it's a Xen domain0 booting with ACPI, it will supply a /chosen and
a /hypervisor node in DT. So check if it needs to enable ACPI.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/acpi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 19de753..7b67426 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -62,10 +62,13 @@ static int __init dt_scan_depth1_nodes(unsigned long node,
 {
 	/*
 	 * Return 1 as soon as we encounter a node at depth 1 that is
-	 * not the /chosen node.
+	 * not the /chosen node or to Xen initial domain that is not
+	 * either /chosen or /hypervisor node.
 	 */
 	if (depth == 1 && (strcmp(uname, "chosen") != 0))
-		return 1;
+		if (!xen_initial_domain() || (strcmp(uname, "hypervisor") != 0))
+			return 1;
+
 	return 0;
 }
 
@@ -179,8 +182,9 @@ void __init acpi_boot_table_init(void)
 	/*
 	 * Enable ACPI instead of device tree unless
 	 * - ACPI has been disabled explicitly (acpi=off), or
-	 * - the device tree is not empty (it has more than just a /chosen node)
-	 *   and ACPI has not been force enabled (acpi=force)
+	 * - the device tree is not empty (it has more than just a /chosen node
+	 *   or to Xen initial domain it has more than a /chosen node and
+	 *   /hypervisor node) and ACPI has not been force enabled (acpi=force)
 	 */
 	if (param_acpi_off ||
 	    (!param_acpi_force && of_scan_flat_dt(dt_scan_depth1_nodes, NULL)))
-- 
2.1.0
