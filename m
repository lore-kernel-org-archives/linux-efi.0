From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v10 03/17] Xen: xlate: Use page_to_xen_pfn instead of page_to_pfn
Date: Fri,  1 Apr 2016 23:49:01 +0800
Message-ID: <1459525755-36968-4-git-send-email-shannon.zhao@linaro.org>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com
Cc: david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

Make xen_xlate_map_ballooned_pages work with 64K pages. In that case
Kernel pages are 64K in size but Xen pages remain 4K in size. Xen pfns
refer to 4K pages.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/xlate_mmu.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 9692656..23f1387 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -189,6 +189,18 @@ int xen_xlate_unmap_gfn_range(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(xen_xlate_unmap_gfn_range);
 
+struct map_balloon_pages {
+	xen_pfn_t *pfns;
+	unsigned int idx;
+};
+
+static void setup_balloon_gfn(unsigned long gfn, void *data)
+{
+	struct map_balloon_pages *info = data;
+
+	info->pfns[info->idx++] = gfn;
+}
+
 /**
  * xen_xlate_map_ballooned_pages - map a new set of ballooned pages
  * @gfns: returns the array of corresponding GFNs
@@ -205,11 +217,13 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 	struct page **pages;
 	xen_pfn_t *pfns;
 	void *vaddr;
+	struct map_balloon_pages data;
 	int rc;
-	unsigned int i;
+	unsigned long nr_pages;
 
 	BUG_ON(nr_grant_frames == 0);
-	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
+	nr_pages = DIV_ROUND_UP(nr_grant_frames, XEN_PFN_PER_PAGE);
+	pages = kcalloc(nr_pages, sizeof(pages[0]), GFP_KERNEL);
 	if (!pages)
 		return -ENOMEM;
 
@@ -218,22 +232,24 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 		kfree(pages);
 		return -ENOMEM;
 	}
-	rc = alloc_xenballooned_pages(nr_grant_frames, pages);
+	rc = alloc_xenballooned_pages(nr_pages, pages);
 	if (rc) {
-		pr_warn("%s Couldn't balloon alloc %ld pfns rc:%d\n", __func__,
-			nr_grant_frames, rc);
+		pr_warn("%s Couldn't balloon alloc %ld pages rc:%d\n", __func__,
+			nr_pages, rc);
 		kfree(pages);
 		kfree(pfns);
 		return rc;
 	}
-	for (i = 0; i < nr_grant_frames; i++)
-		pfns[i] = page_to_pfn(pages[i]);
 
-	vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
+	data.pfns = pfns;
+	data.idx = 0;
+	xen_for_each_gfn(pages, nr_grant_frames, setup_balloon_gfn, &data);
+
+	vaddr = vmap(pages, nr_pages, 0, PAGE_KERNEL);
 	if (!vaddr) {
-		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
-			nr_grant_frames, rc);
-		free_xenballooned_pages(nr_grant_frames, pages);
+		pr_warn("%s Couldn't map %ld pages rc:%d\n", __func__,
+			nr_pages, rc);
+		free_xenballooned_pages(nr_pages, pages);
 		kfree(pages);
 		kfree(pfns);
 		return -ENOMEM;
-- 
2.1.4
