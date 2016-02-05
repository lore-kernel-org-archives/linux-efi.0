From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 03/17] Xen: xlate: Use page_to_xen_pfn instead of page_to_pfn
Date: Fri, 5 Feb 2016 11:05:38 +0800
Message-ID: <1454641552-12576-4-git-send-email-zhaoshenglong@huawei.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454641552-12576-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Make xen_xlate_map_ballooned_pages work with 64K pages. In that case
Kernel pages are 64K in size but Xen pages remain 4K in size. Xen pfns
refer to 4K pages.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
---
 drivers/xen/xlate_mmu.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 9692656..28f728b 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -207,9 +207,12 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 	void *vaddr;
 	int rc;
 	unsigned int i;
+	unsigned long nr_pages;
+	xen_pfn_t xen_pfn = 0;
 
 	BUG_ON(nr_grant_frames == 0);
-	pages = kcalloc(nr_grant_frames, sizeof(pages[0]), GFP_KERNEL);
+	nr_pages = DIV_ROUND_UP(nr_grant_frames, XEN_PFN_PER_PAGE);
+	pages = kcalloc(nr_pages, sizeof(pages[0]), GFP_KERNEL);
 	if (!pages)
 		return -ENOMEM;
 
@@ -218,22 +221,25 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
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
+	for (i = 0; i < nr_grant_frames; i++) {
+		if ((i % XEN_PFN_PER_PAGE) == 0)
+			xen_pfn = page_to_xen_pfn(pages[i / XEN_PFN_PER_PAGE]);
+		pfns[i] = pfn_to_gfn(xen_pfn++);
+	}
 
-	vaddr = vmap(pages, nr_grant_frames, 0, PAGE_KERNEL);
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
2.0.4
