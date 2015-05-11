From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/8] arm64: override early_init_dt_add_memory_arch()
Date: Mon, 11 May 2015 08:41:55 +0200
Message-ID: <1431326520-17331-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1431326520-17331-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431326520-17331-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Override the __weak early_init_dt_add_memory_arch() with our own
version. This allows us to relax the imposed restrictions at memory
discovery time, which is needed if we want to defer the assignment
of PHYS_OFFSET and make it independent of where the kernel Image
is placed in physical memory.

So copy the generic original, but only retain the check against
regions whose sizes become zero when clipped to page alignment.

For now, we will remove the range below PHYS_OFFSET explicitly
until we rework that logic in a subsequent patch. Any memory that
we will not be able to map due to insufficient size of the linear
region is also removed.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/init.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 597831bdddf3..64480b65ef17 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -158,6 +158,15 @@ early_param("mem", early_mem);
 
 void __init arm64_memblock_init(void)
 {
+	/*
+	 * Remove the memory that we will not be able to cover
+	 * with the linear mapping.
+	 */
+	const s64 linear_region_size = -(s64)PAGE_OFFSET;
+
+	memblock_remove(0, memstart_addr);
+	memblock_remove(memstart_addr + linear_region_size, ULLONG_MAX);
+
 	memblock_enforce_memory_limit(memory_limit);
 
 	/*
@@ -374,3 +383,19 @@ static int __init keepinitrd_setup(char *__unused)
 
 __setup("keepinitrd", keepinitrd_setup);
 #endif
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	if (!PAGE_ALIGNED(base)) {
+		if (size < PAGE_SIZE - (base & ~PAGE_MASK)) {
+			pr_warn("Ignoring memory block 0x%llx - 0x%llx\n",
+				base, base + size);
+			return;
+		}
+		size -= PAGE_SIZE - (base & ~PAGE_MASK);
+		base = PAGE_ALIGN(base);
+	}
+	size &= PAGE_MASK;
+
+	memblock_add(base, size);
+}
-- 
1.9.1
