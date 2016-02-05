From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 04/17] arm/xen: Use
	xen_xlate_map_ballooned_pages to setup grant table
Date: Fri, 5 Feb 2016 11:05:39 +0800
Message-ID: <1454641552-12576-5-git-send-email-zhaoshenglong@huawei.com>
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

Use xen_xlate_map_ballooned_pages to setup grant table. Then it doesn't
rely on DT or ACPI to pass the start address and size of grant table.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
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
2.0.4
