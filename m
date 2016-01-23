From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v3 02/17] xen/grant-table: Move
	xlated_setup_gnttab_pages to common place
Date: Sat, 23 Jan 2016 11:19:29 +0800
Message-ID: <1453519184-11908-3-git-send-email-zhaoshenglong@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Move xlated_setup_gnttab_pages to common place, so it can be reused by
ARM to setup grant table.

Rename it to xen_xlate_map_ballooned_pages.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/grant-table.c | 57 +++++--------------------------------------
 drivers/xen/xlate_mmu.c    | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h      |  2 ++
 3 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index e079500..de4144c 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -111,63 +111,18 @@ int arch_gnttab_init(unsigned long nr_shared)
 }
 
 #ifdef CONFIG_XEN_PVH
-#include <xen/balloon.h>
 #include <xen/events.h>
-#include <linux/slab.h>
-static int __init xlated_setup_gnttab_pages(void)
-{
-	struct page **pages;
-	xen_pfn_t *pfns;
-	void *vaddr;
-	int rc;
-	unsigned int i;
-	unsigned long nr_grant_frames = gnttab_max_grant_frames();
-
-	BUG_ON(nr_grant_frames == 0);
-	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
-	if (!pages)
-		return -ENOMEM;
-
-	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
-	if (!pfns) {
-		kfree(pages);
-		return -ENOMEM;
-	}
-	rc = alloc_xenballooned_pages(nr_grant_frames, pages);
-	if (rc) {
-		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
-			nr_grant_frames, rc);
-		kfree(pages);
-		kfree(pfns);
-		return rc;
-	}
-	for (i = 0; i < nr_grant_frames; i++)
-		pfns[i] = page_to_pfn(pages[i]);
-
-	vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
-	if (!vaddr) {
-		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
-			nr_grant_frames, rc);
-		free_xenballooned_pages(nr_grant_frames, pages);
-		kfree(pages);
-		kfree(pfns);
-		return -ENOMEM;
-	}
-	kfree(pages);
-
-	xen_auto_xlat_grant_frames.pfn = pfns;
-	xen_auto_xlat_grant_frames.count = nr_grant_frames;
-	xen_auto_xlat_grant_frames.vaddr = vaddr;
-
-	return 0;
-}
-
+#include <xen/xen-ops.h>
 static int __init xen_pvh_gnttab_setup(void)
 {
 	if (!xen_pvh_domain())
 		return -ENODEV;
 
-	return xlated_setup_gnttab_pages();
+	xen_auto_xlat_grant_frames.count = gnttab_max_grant_frames();
+
+	return xen_xlate_map_ballooned_pages(&xen_auto_xlat_grant_frames.pfn,
+					     &xen_auto_xlat_grant_frames.vaddr,
+					     xen_auto_xlat_grant_frames.count);
 }
 /* Call it _before_ __gnttab_init as we need to initialize the
  * xen_auto_xlat_grant_frames first. */
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 5063c5e..9692656 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -29,6 +29,8 @@
  */
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -37,6 +39,7 @@
 #include <xen/page.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
+#include <xen/balloon.h>
 
 typedef void (*xen_gfn_fn_t)(unsigned long gfn, void *data);
 
@@ -185,3 +188,61 @@ int xen_xlate_unmap_gfn_range(struct vm_area_struct *vma,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_xlate_unmap_gfn_range);
+
+/**
+ * xen_xlate_map_ballooned_pages - map a new set of ballooned pages
+ * @gfns: returns the array of corresponding GFNs
+ * @virt: returns the virtual address of the mapped region
+ * @nr_grant_frames: number of GFNs
+ * @return 0 on success, error otherwise
+ *
+ * This allocates a set of ballooned pages and maps them into the
+ * kernel's address space.
+ */
+int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
+					 unsigned long nr_grant_frames)
+{
+	struct page **pages;
+	xen_pfn_t *pfns;
+	void *vaddr;
+	int rc;
+	unsigned int i;
+
+	BUG_ON(nr_grant_frames == 0);
+	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	pfns = kcalloc(nr_grant_frames, sizeof(pfns[0]), GFP_KERNEL);
+	if (!pfns) {
+		kfree(pages);
+		return -ENOMEM;
+	}
+	rc = alloc_xenballooned_pages(nr_grant_frames, pages);
+	if (rc) {
+		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
+			nr_grant_frames, rc);
+		kfree(pages);
+		kfree(pfns);
+		return rc;
+	}
+	for (i = 0; i < nr_grant_frames; i++)
+		pfns[i] = page_to_pfn(pages[i]);
+
+	vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
+	if (!vaddr) {
+		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
+			nr_grant_frames, rc);
+		free_xenballooned_pages(nr_grant_frames, pages);
+		kfree(pages);
+		kfree(pfns);
+		return -ENOMEM;
+	}
+	kfree(pages);
+
+	*gfns = pfns;
+	*virt = vaddr;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xen_xlate_map_ballooned_pages);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index e4e214a..42be31a 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -80,6 +80,8 @@ int xen_xlate_remap_gfn_array(struct vm_area_struct *vma,
 			      struct page **pages);
 int xen_xlate_unmap_gfn_range(struct vm_area_struct *vma,
 			      int nr, struct page **pages);
+int xen_xlate_map_ballooned_pages(xen_pfn_t **pfns, void **vaddr,
+				  unsigned long nr_grant_frames);
 
 bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
 
-- 
2.0.4
