From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 02/17] xen/grant-table: Move xlated_setup_gnttab_pages to common place
Date: Fri, 4 Mar 2016 14:37:20 +0800
Message-ID: <1457073455-11516-3-git-send-email-zhaoshenglong@huawei.com>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457073455-11516-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Move xlated_setup_gnttab_pages to common place, so it can be reused by
ARM to setup grant table.

Rename it to xen_xlate_map_ballooned_pages.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
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
index 86abe07..072be1c 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -85,6 +85,8 @@ int xen_xlate_remap_gfn_array(struct vm_area_struct *vma,
 			      struct page **pages);
 int xen_xlate_unmap_gfn_range(struct vm_area_struct *vma,
 			      int nr, struct page **pages);
+int xen_xlate_map_ballooned_pages(xen_pfn_t **pfns, void **vaddr,
+				  unsigned long nr_grant_frames);
 
 bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
 
-- 
2.0.4
