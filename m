From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v6 1/2] mm:memblock Add new infrastructure to address the mem limit issue
Date: Thu, 14 Jul 2016 13:43:55 +0800
Message-ID: <1468475036-5852-2-git-send-email-dennis.chen@arm.com>
References: <1468475036-5852-1-git-send-email-dennis.chen@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468475036-5852-1-git-send-email-dennis.chen-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: nd-5wv7dgnIgG8@public.gmane.org, steve.capper-5wv7dgnIgG8@public.gmane.org, dennis.chen-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, kaly.xin-5wv7dgnIgG8@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

In some cases, memblock is queried by kernel to determine whether a
specified address is RAM or not. For example, the ACPI core needs this
information to determine which attributes to use when mapping ACPI
regions(acpi_os_ioremap). Use of incorrect memory types can result in
faults, data corruption, or other issues.

Removing memory with memblock_enforce_memory_limit() throws away this
information, and so a kernel booted with 'mem=' may suffers from the
issues described above. To avoid this, we need to keep those NOMAP
regions instead of removing all above the limit, which preserves the
information we need while preventing other use of those regions.

This patch adds new infrastructure to retain all NOMAP memblock regions
while removing others, to cater for this.

Acked-by: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>

Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Tang Chen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rafael J. Wysocki <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Kaly Xin <kaly.xin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 57 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6c14b61..2925da2 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -332,6 +332,7 @@ phys_addr_t memblock_mem_size(unsigned long limit_pfn);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
+void memblock_mem_limit_remove_map(phys_addr_t limit);
 bool memblock_is_memory(phys_addr_t addr);
 int memblock_is_map_memory(phys_addr_t addr);
 int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index 0fc0fa1..02b68eb 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1465,15 +1465,16 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 	return (memblock.memory.regions[idx].base + memblock.memory.regions[idx].size);
 }
 
-void __init memblock_enforce_memory_limit(phys_addr_t limit)
+static phys_addr_t __init_memblock __find_max_addr(phys_addr_t limit)
 {
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
 	struct memblock_region *r;
 
-	if (!limit)
-		return;
-
-	/* find out max address */
+	/*
+	 * translate the memory @limit size into the max address within one of
+	 * the memory memblock regions, if the @limit exceeds the total size
+	 * of those regions, max_addr will keep original value ULLONG_MAX
+	 */
 	for_each_memblock(memory, r) {
 		if (limit <= r->size) {
 			max_addr = r->base + limit;
@@ -1482,6 +1483,22 @@ void __init memblock_enforce_memory_limit(phys_addr_t limit)
 		limit -= r->size;
 	}
 
+	return max_addr;
+}
+
+void __init memblock_enforce_memory_limit(phys_addr_t limit)
+{
+	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
+
+	if (!limit)
+		return;
+
+	max_addr = __find_max_addr(limit);
+
+	/* @limit exceeds the total size of the memory, do nothing */
+	if (max_addr == (phys_addr_t)ULLONG_MAX)
+		return;
+
 	/* truncate both memory and reserved regions */
 	memblock_remove_range(&memblock.memory, max_addr,
 			      (phys_addr_t)ULLONG_MAX);
@@ -1489,6 +1506,36 @@ void __init memblock_enforce_memory_limit(phys_addr_t limit)
 			      (phys_addr_t)ULLONG_MAX);
 }
 
+void __init memblock_mem_limit_remove_map(phys_addr_t limit)
+{
+	struct memblock_type *type = &memblock.memory;
+	phys_addr_t max_addr;
+	int i, ret, start_rgn, end_rgn;
+
+	if (!limit)
+		return;
+
+	max_addr = __find_max_addr(limit);
+
+	/* @limit exceeds the total size of the memory, do nothing */
+	if (max_addr == (phys_addr_t)ULLONG_MAX)
+		return;
+
+	ret = memblock_isolate_range(type, max_addr, (phys_addr_t)ULLONG_MAX,
+				&start_rgn, &end_rgn);
+	if (ret)
+		return;
+
+	/* remove all the MAP regions above the limit */
+	for (i = end_rgn - 1; i >= start_rgn; i--) {
+		if (!memblock_is_nomap(&type->regions[i]))
+			memblock_remove_region(type, i);
+	}
+	/* truncate the reserved regions */
+	memblock_remove_range(&memblock.reserved, max_addr,
+			      (phys_addr_t)ULLONG_MAX);
+}
+
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
 	unsigned int left = 0, right = type->cnt;
-- 
2.7.4
