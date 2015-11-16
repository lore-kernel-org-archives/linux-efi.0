From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 10/12] ARM: only consider memblocks with NOMAP cleared for linear mapping
Date: Mon, 16 Nov 2015 19:32:35 +0100
Message-ID: <1447698757-8762-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447698757-8762-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Take the new memblock attribute MEMBLOCK_NOMAP into account when
deciding whether a certain region is or should be covered by the
kernel direct mapping.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/mm/init.c | 5 ++++-
 arch/arm/mm/mmu.c  | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8a63b4cdc0f2..16104b1e2661 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -191,7 +191,7 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 #ifdef CONFIG_HAVE_ARCH_PFN_VALID
 int pfn_valid(unsigned long pfn)
 {
-	return memblock_is_memory(__pfn_to_phys(pfn));
+	return memblock_is_map_memory(__pfn_to_phys(pfn));
 }
 EXPORT_SYMBOL(pfn_valid);
 #endif
@@ -432,6 +432,9 @@ static void __init free_highpages(void)
 		if (end <= max_low)
 			continue;
 
+		if (memblock_is_nomap(mem))
+			continue;
+
 		/* Truncate partial highmem entries */
 		if (start < max_low)
 			start = max_low;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 0b7b61e31bc3..094e550144b3 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1429,6 +1429,9 @@ static void __init map_lowmem(void)
 		phys_addr_t end = start + reg->size;
 		struct map_desc map;
 
+		if (memblock_is_nomap(reg))
+			continue;
+
 		if (end > arm_lowmem_limit)
 			end = arm_lowmem_limit;
 		if (start >= end)
-- 
1.9.1
