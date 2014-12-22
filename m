From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/8] memblock: introduce memblock_add_phys() and memblock_is_physmem()
Date: Mon, 22 Dec 2014 19:08:38 +0000
Message-ID: <1419275322-29811-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419275322-29811-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This introduces the following functions:
- memblock_add_phys(), that registers regions in the 'physmem' memblock map if
  CONFIG_HAVE_MEMBLOCK_PHYS_MAP is set; otherwise, it is a nop
- memblock_is_physmem(), returns whether a physical address is classified as
  physical memory.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/memblock.h | 10 ++++++++++
 mm/memblock.c            | 15 +++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index e8cc45307f8f..d32fe838c6ca 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -365,6 +365,16 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 #define __initdata_memblock
 #endif
 
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+int memblock_add_phys(phys_addr_t base, phys_addr_t size);
+int memblock_is_physmem(phys_addr_t addr);
+#else
+static inline int memblock_add_phys(phys_addr_t base, phys_addr_t size)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_PHYS_MAP */
+
 #else
 static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
diff --git a/mm/memblock.c b/mm/memblock.c
index c27353beb260..107aa5ee2d7b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -586,6 +586,14 @@ int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 				   MAX_NUMNODES, 0);
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+int __init_memblock memblock_add_phys(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_add_range(&memblock.physmem, base, size,
+				  MAX_NUMNODES, 0);
+}
+#endif
+
 /**
  * memblock_isolate_range - isolate given range into disjoint memblocks
  * @type: memblock type to isolate range for
@@ -1398,6 +1406,13 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+int __init_memblock memblock_is_physmem(phys_addr_t addr)
+{
+	return memblock_search(&memblock.physmem, addr) != -1;
+}
+#endif
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
 			 unsigned long *start_pfn, unsigned long *end_pfn)
-- 
1.8.3.2
