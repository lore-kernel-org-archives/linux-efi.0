From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 04/17] arm/xen: Use xen_xlate_map_ballooned_pages to setup grant table
Date: Thu, 24 Mar 2016 22:44:23 +0800
Message-ID: <1458830676-27075-5-git-send-email-shannon.zhao@linaro.org>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458830676-27075-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Use xen_xlate_map_ballooned_pages to setup grant table. Then it doesn't
rely on DT or ACPI to pass the start address and size of grant table.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
---
 arch/arm/xen/enlighten.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 75cd734..d94f726 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -282,18 +282,10 @@ static int __init xen_guest_init(void)
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
@@ -328,7 +320,10 @@ static int __init xen_guest_init(void)
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
2.1.4
