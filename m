From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 04/16] arm/xen: Use xen_xlate_map_ballooned_pages to setup grant table
Date: Fri, 15 Jan 2016 14:55:17 +0800
Message-ID: <1452840929-19612-5-git-send-email-zhaoshenglong@huawei.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452840929-19612-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Use xen_xlate_map_ballooned_pages to setup grant table. Then it doesn't
rely on DT or ACPI to pass the start address and size of grant table.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/xen/enlighten.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index afe6175..6d90a62 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -266,18 +266,10 @@ static int __init xen_guest_init(void)
 {
 	struct xen_add_to_physmap xatp;
 	struct shared_info *shared_info_page = NULL;
-	struct resource res;
-	phys_addr_t grant_frames;
 
 	if (!xen_domain())
 		return 0;
 
-	if (of_address_to_resource(xen_node, GRANT_TABLE_PHYSADDR, &res)) {
-		pr_err("Xen grant table base address not found\n");
-		return -ENODEV;
-	}
-	grant_frames = res.start;
-
 	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
 	if (!xen_events_irq) {
 		pr_err("Xen event channel interrupt not found\n");
@@ -312,7 +304,10 @@ static int __init xen_guest_init(void)
 	if (xen_vcpu_info == NULL)
 		return -ENOMEM;
 
-	if (gnttab_setup_auto_xlat_frames(grant_frames)) {
+	xen_auto_xlat_grant_frames.count = gnttab_max_grant_frames();
+	if (xen_xlate_map_ballooned_pages(&xen_auto_xlat_grant_frames.pfn,
+					  &xen_auto_xlat_grant_frames.vaddr,
+					  xen_auto_xlat_grant_frames.count)) {
 		free_percpu(xen_vcpu_info);
 		return -ENOMEM;
 	}
-- 
2.0.4
