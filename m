From: Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Tue, 1 Nov 2016 17:55:44 +0100
Message-ID: <20161101165544.GP22012@rric.localdomain>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="veXX9dWIonWZEC6h"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475747527-32387-1-git-send-email-rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

--veXX9dWIonWZEC6h
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On 06.10.16 11:52:07, Robert Richter wrote:
> There is a memory setup problem on ThunderX systems with certain
> memory configurations. The symptom is
> 
>  kernel BUG at mm/page_alloc.c:1848!
> 
> This happens for some configs with 64k page size enabled. The bug
> triggers for page zones with some pages in the zone not assigned to
> this particular zone. In my case some pages that are marked as nomap
> were not reassigned to the new zone of node 1, so those are still
> assigned to node 0.
> 
> The reason for the mis-configuration is a change in pfn_valid() which
> reports pages marked nomap as invalid:
> 
>  68709f45385a arm64: only consider memblocks with NOMAP cleared for linear mapping
> 
> This causes pages marked as nomap being no long reassigned to the new
> zone in memmap_init_zone() by calling __init_single_pfn().
> 
> Fixing this by restoring the old behavior of pfn_valid() to use
> memblock_is_memory(). Also changing users of pfn_valid() in arm64 code
> to use memblock_is_map_memory() where necessary. This only affects
> code in ioremap.c. The code in mmu.c still can use the new version of
> pfn_valid().

Below a reproducer for non-numa systems. Note that invalidating the
node id just simulates a different node in reality.

The patch injects a (pageblock_order) unaligned NOMAP mem range at the
end of a memory block and then tries to free that area. This causes a
BUG_ON() (log attached).

-Robert



>From 20d853e300c99be5420c7ee3f072c318804cac1b Mon Sep 17 00:00:00 2001
From: root <root-Vr5RZmvqObNE+7tKeQX6HA@public.gmane.org>
Date: Tue, 1 Nov 2016 15:04:43 +0000
Subject: [PATCH] mm-fault-reproducer

Signed-off-by: root <root-Vr5RZmvqObNE+7tKeQX6HA@public.gmane.org>
---
 arch/arm64/mm/init.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c      |  4 ++-
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 21c489bdeb4e..feaa7ab97551 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -36,6 +36,7 @@
 #include <linux/efi.h>
 #include <linux/swiotlb.h>
 #include <linux/vmalloc.h>
+#include <linux/page-isolation.h>
 
 #include <asm/boot.h>
 #include <asm/fixmap.h>
@@ -301,6 +302,80 @@ void __init arm64_memblock_init(void)
 	memblock_allow_resize();
 }
 
+static struct page *inject_pageblock;
+
+static void __init inject_nomap_create(void)
+{
+	phys_addr_t start, end;
+	unsigned long start_pfn, end_pfn;
+	u64 i;
+	int ret = -ENOMEM;
+
+	pr_info("%s: PAGES_PER_SECTION=%08lx pageblock_nr_pages=%08lx PAGE_SIZE=%08lx\n",
+		__func__, PAGES_PER_SECTION, pageblock_nr_pages, PAGE_SIZE);
+
+	/*
+	 * find a mem range with a complet pageblock in it
+	 */
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, NULL) {
+		start_pfn = PFN_DOWN(start);
+		end_pfn = PFN_UP(end);
+		if  (end_pfn - (start_pfn & ~(pageblock_nr_pages-1)) > 2 * pageblock_nr_pages)
+			break;
+	}
+
+	if (i == ULLONG_MAX)
+		goto fail;
+
+	start = PFN_PHYS(start_pfn);
+	end = PFN_PHYS(end_pfn) - 1;
+
+	pr_info("%s: Injecting into range: [%pa-%pa]\n", __func__, &start, &end);
+
+	/* mark the upper 5 pages nomap of a complete pageblock */
+	start_pfn = end_pfn & ~(pageblock_nr_pages-1);
+	start_pfn -= 5;			/* unalign by 5 pages */
+
+	start = PFN_PHYS(start_pfn);
+	end = PFN_PHYS(end_pfn) - 1;
+
+	ret = memblock_mark_nomap(start, end - start + 1);
+	if (ret)
+		goto fail;
+
+	inject_pageblock = pfn_to_page(start_pfn & ~(pageblock_nr_pages-1));
+
+	pr_info("%s: Injected nomap range at: [%pa-%pa] zones: %p %p\n", __func__,
+		&start, &end, page_zone(inject_pageblock),
+		page_zone(inject_pageblock + pageblock_nr_pages - 1));
+
+	return;
+fail:
+	pr_err("%s: Could not inject_unaligned_range: %d\n", __func__, ret);
+}
+
+static void __init inject_nomap_move(void)
+{
+	phys_addr_t start, end;
+	int ret;
+
+	if (!inject_pageblock)
+		return;
+
+	start = PFN_PHYS(page_to_pfn(inject_pageblock));
+	end = PFN_PHYS(page_to_pfn(inject_pageblock) + pageblock_nr_pages) - 1;
+
+	pr_info("%s: Moving [%pa-%pa] zones: %p %p\n", __func__,
+		&start, &end, page_zone(inject_pageblock),
+		page_zone(inject_pageblock + pageblock_nr_pages - 1));
+
+	ret = move_freepages_block(page_zone(inject_pageblock),
+				inject_pageblock,
+				gfpflags_to_migratetype(GFP_KERNEL));
+
+	pr_info("%s: Moved %d pages\n", __func__, ret);
+}
+
 void __init bootmem_init(void)
 {
 	unsigned long min, max;
@@ -320,6 +395,7 @@ void __init bootmem_init(void)
 	arm64_memory_present();
 
 	sparse_init();
+	inject_nomap_create();
 	zone_sizes_init(min, max);
 
 	high_memory = __va((max << PAGE_SHIFT) - 1) + 1;
@@ -479,6 +555,8 @@ void __init mem_init(void)
 		 */
 		sysctl_overcommit_memory = OVERCOMMIT_ALWAYS;
 	}
+
+	inject_nomap_move();
 }
 
 void free_initmem(void)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2b3bf6767d54..19d74637e242 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5077,8 +5077,10 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		if (context != MEMMAP_EARLY)
 			goto not_early;
 
-		if (!early_pfn_valid(pfn))
+		if (!early_pfn_valid(pfn)) {
+			set_page_node(pfn_to_page(pfn), NUMA_NO_NODE);
 			continue;
+		}
 		if (!early_pfn_in_nid(pfn, nid))
 			continue;
 		if (!update_defer_init(pgdat, pfn, end_pfn, &nr_initialised))
-- 
2.9.3


--veXX9dWIonWZEC6h
Content-Type: application/x-xz
Content-Disposition: attachment;
	filename="typescript-crb2s-test21-201611010941-trigger-mm-fault.xz"
Content-Transfer-Encoding: base64

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

--veXX9dWIonWZEC6h--
