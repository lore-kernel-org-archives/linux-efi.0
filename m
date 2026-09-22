Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0BE3ACF0F;
	Tue, 22 Sep 2026 04:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050434; cv=none; b=qQuGoJ28X8weZ+LFRiCh+9df68rGu1dklxEB45q0lguaY3J+1YPoZ3NRGmR2snluGUHUIYVBVL2PuA/sAh/a0/x2foDla4s8w7HPgYLQvF0bf0MRacKkNb+xMT5sWwN2LZnZtzAylagTgB3zGaOdld9lMgSfm68ESCoDFitnv10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050434; c=relaxed/simple;
	bh=+hvUVqszMwQXp+VSxGTHXJkeChhyNaeuM+JflOFialM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhLGjMmct9Hr+8bqfCGHmSzQYXYnOQNEzjTWft7NKH6VnZ/XWxooH19FtFEeV6Ne5Q4K+pyodx/UZzqBpbBwD0eEOlCnddA0vMS3A43LGIjJ4JXR5y4T544elxw4za4CfDyXVg6GyTWTm4qi0Hgs1qhowDzBEMxUvzATOzXMZV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVqv4SwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVqv4SwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547BA1F000FF;
	Tue, 22 Sep 2026 04:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050429;
	bh=ztoHkzSakhlgEUc7G/LHxksYMrAIZTyBYMa2Uf2Hlbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVqv4SwS3M/13d0XbLVjgC9iKlv6RYkfuAu6SSvxOVXC2YqtiBhE9BJXnPRqP/cUR
	 huM6zC9L0BemJBUbZaWzqKnYDhFV155rpGk6RyhNzBveJu/Z2qUtZDItXgARcluOVk
	 jOD20tJtw+CHfR6E9EiqX7fhuXvVrPWXIAcQr+bDh2oZb6F4UMzMsNdnNX1kz1VO7w
	 Pxd+SLQ2ZybkJav7qabpF+G7RWN0Til9Na/0uu6Dv+J3p8UtTChxICL2Oj9qupRkkn
	 S7jvAm76sznfUM9vxVl19e0PhNv3gj/U/ZOqj1NMsQr9yDfKIsfVafMMKyiChx6pvn
	 KF+x7AAUbZXgw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v3 2/4] memblock: rename KHO_SCRATCH to KHO_NOPRSRV
Date: Tue, 22 Sep 2026 06:13:14 +0200
Message-ID: <20260922041321.233986-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260922041321.233986-1-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The term "KHO scratch" is vague. It does not accurately describe what
the memory is for. Generally, scratch is for things that don't contain
anything useful. This is not true.

For memblock, KHO_SCRATCH is the _only_ useful memory during a KHO boot.
It is memory passed by the previous kernel that is guaranteed to have no
preserved pages, and so is the only thing safe to allocate from early in
boot.

In addition, KHO now has the ability to discover other "scratch" areas.
These aren't directly passed by the previous kernel. Instead, they are
found by searching the KHO preserved memory map.

Memblock does not care about the difference between the two. From
memblock's perspective, both are memory areas with no preservations and
so they are safe to allocate from before KHO fully initializes.

Rename MEMBLOCK_KHO_SCRATCH to MEMBLOCK_KHO_NOPRSRV. This name clearly
shows what the memory is for from memblock's perspective. Update
memblock functions and comments that refer to scratch to use noprsrv.

There are no functional changes apart from the flag name change in
debugfs.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 arch/x86/kernel/e820.c             | 11 ++++----
 arch/x86/realmode/init.c           |  2 +-
 drivers/firmware/efi/efi-init.c    |  2 +-
 include/linux/memblock.h           | 28 +++++++++----------
 kernel/liveupdate/kexec_handover.c |  8 +++---
 mm/memblock.c                      | 44 +++++++++++++++---------------
 6 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index eb72537bc0b1..0967b485f38b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1352,18 +1352,17 @@ __init void e820__memblock_setup(void)
 	 * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
 	 * up in init_mem_mapping().
 	 *
-	 * KHO kernels are special and use only scratch memory for memblock
+	 * KHO kernels are special and use only NOPRSRV memory for memblock
 	 * allocations, but memory below 1M is ignored by kernel after early
-	 * boot and cannot be naturally marked as scratch.
+	 * boot and cannot be naturally marked as NOPRSRV.
 	 *
 	 * To allow allocation of the real-mode trampoline and a few (if any)
 	 * other very early allocations from below 1M forcibly mark the memory
-	 * below 1M as scratch.
+	 * below 1M as NOPRSRV.
 	 *
-	 * After real mode trampoline is allocated, we clear that scratch
-	 * marking.
+	 * After real mode trampoline is allocated, we clear that marking.
 	 */
-	memblock_mark_kho_scratch(0, SZ_1M);
+	memblock_mark_kho_noprsrv(0, SZ_1M);
 
 	/*
 	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 694d80a5c68e..65110b2ee1a1 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -66,7 +66,7 @@ void __init reserve_real_mode(void)
 	 */
 	memblock_reserve(0, SZ_1M);
 
-	memblock_clear_kho_scratch(0, SZ_1M);
+	memblock_clear_kho_noprsrv(0, SZ_1M);
 }
 
 static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 6103b1a082d2..a2edaf3766eb 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -178,7 +178,7 @@ static __init void reserve_regions(void)
 
 		/* Remove all non-KHO regions */
 		for_each_mem_region(r) {
-			if (!memblock_is_kho_scratch(r)) {
+			if (!memblock_is_kho_noprsrv(r)) {
 				memblock_remove(r->base, r->size);
 				r--;
 			}
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index db3b106c6335..aaa11a589843 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -46,11 +46,11 @@ extern unsigned long long max_possible_pfn;
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
- * @MEMBLOCK_KHO_SCRATCH: memory region that kexec can pass to the next
- * kernel in handover mode. During early boot, we do not know about all
- * memory reservations yet, so we get scratch memory from the previous
- * kernel that we know is good to use. It is the only memory that
- * allocations may happen from in this phase.
+ * @MEMBLOCK_KHO_NOPRSRV: memory region with no preservation from kexec
+ * handover. During early boot, we do not know about all memory preservations
+ * yet, so we get memory with no preservations from the previous kernel that we
+ * know is good to use. It is the only memory that allocations may happen from
+ * in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
  */
 enum memblock_flags {
@@ -61,7 +61,7 @@ enum memblock_flags {
 	MEMBLOCK_DRIVER_MANAGED = 0x8,	/* always detected via a driver */
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
-	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
+	MEMBLOCK_KHO_NOPRSRV	= 0x40,	/* memory with no KHO preservations */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
 };
 
@@ -158,8 +158,8 @@ int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
-int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
-int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_kho_noprsrv(phys_addr_t base, phys_addr_t size);
+int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 void reset_all_zones_managed_pages(void);
@@ -301,9 +301,9 @@ static inline bool memblock_is_driver_managed(struct memblock_region *m)
 	return m->flags & MEMBLOCK_DRIVER_MANAGED;
 }
 
-static inline bool memblock_is_kho_scratch(struct memblock_region *m)
+static inline bool memblock_is_kho_noprsrv(struct memblock_region *m)
 {
-	return m->flags & MEMBLOCK_KHO_SCRATCH;
+	return m->flags & MEMBLOCK_KHO_NOPRSRV;
 }
 
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
@@ -615,11 +615,11 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
 #ifdef CONFIG_KEXEC_HANDOVER
-void memblock_set_kho_scratch_only(void);
-void memblock_clear_kho_scratch_only(void);
+void memblock_set_kho_noprsrv_only(void);
+void memblock_clear_kho_noprsrv_only(void);
 #else
-static inline void memblock_set_kho_scratch_only(void) { }
-static inline void memblock_clear_kho_scratch_only(void) { }
+static inline void memblock_set_kho_noprsrv_only(void) { }
+static inline void memblock_clear_kho_noprsrv_only(void) { }
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3c87c2a3d6f0..7f45cecf2c2c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -958,7 +958,7 @@ static int __init kho_ext_mark_scratch(unsigned long key, void *data)
 	int err;
 
 	if (start > *prev_end) {
-		err = memblock_mark_kho_scratch(*prev_end, start - *prev_end);
+		err = memblock_mark_kho_noprsrv(*prev_end, start - *prev_end);
 		if (err)
 			return err;
 	}
@@ -1031,7 +1031,7 @@ static void __init kho_extend_scratch(void)
 
 	/* Mark everything from last busy block to end of DRAM. */
 	if (prev_end < memblock_end_of_DRAM())
-		err = memblock_mark_kho_scratch(prev_end, memblock_end_of_DRAM() - prev_end);
+		err = memblock_mark_kho_noprsrv(prev_end, memblock_end_of_DRAM() - prev_end);
 
 	/* fallthrough */
 out:
@@ -2002,7 +2002,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		u64 size = area->size;
 
 		memblock_add(area->addr, size);
-		err = memblock_mark_kho_scratch(area->addr, size);
+		err = memblock_mark_kho_noprsrv(area->addr, size);
 		if (err) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
@@ -2020,7 +2020,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	 * we initialize the page tables which we will need to ingest all
 	 * memory reservations from the previous kernel.
 	 */
-	memblock_set_kho_scratch_only();
+	memblock_set_kho_noprsrv_only();
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
diff --git a/mm/memblock.c b/mm/memblock.c
index 197d854c18d5..947d8767d7ec 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -114,10 +114,10 @@ unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
 #ifdef CONFIG_KEXEC_HANDOVER
-/* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
-static bool kho_scratch_only;
+/* When set to true, only allocate from MEMBLOCK_KHO_NOPRSRV ranges */
+static bool kho_noprsrv_only;
 #else
-#define kho_scratch_only false
+#define kho_noprsrv_only false
 #endif
 
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_MEMORY_REGIONS] __initdata_memblock;
@@ -179,9 +179,9 @@ bool __init_memblock memblock_has_mirror(void)
 
 static enum memblock_flags __init_memblock choose_memblock_flags(void)
 {
-	/* skip non-scratch memory for kho early boot allocations */
-	if (kho_scratch_only)
-		return MEMBLOCK_KHO_SCRATCH;
+	/* only use KHO_NOPRSRV memory for kho early boot allocations */
+	if (kho_noprsrv_only)
+		return MEMBLOCK_KHO_NOPRSRV;
 
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
@@ -1175,33 +1175,33 @@ int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t si
 }
 
 /**
- * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
+ * memblock_mark_kho_noprsrv - Mark a memory region as MEMBLOCK_KHO_NOPRSRV.
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
+ * Only memory regions marked with %MEMBLOCK_KHO_NOPRSRV will be considered
  * for allocations during early boot with kexec handover.
  *
  * Return: 0 on success, -errno on failure.
  */
-__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
+__init int memblock_mark_kho_noprsrv(phys_addr_t base, phys_addr_t size)
 {
 	return memblock_setclr_flag(&memblock.memory, base, size, 1,
-				    MEMBLOCK_KHO_SCRATCH);
+				    MEMBLOCK_KHO_NOPRSRV);
 }
 
 /**
- * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
+ * memblock_clear_kho_noprsrv - Clear MEMBLOCK_KHO_NOPRSRV flag for a
  * specified region.
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
  * Return: 0 on success, -errno on failure.
  */
-__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
+__init int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size)
 {
 	return memblock_setclr_flag(&memblock.memory, base, size, 0,
-				    MEMBLOCK_KHO_SCRATCH);
+				    MEMBLOCK_KHO_NOPRSRV);
 }
 
 static bool should_skip_region(struct memblock_type *type,
@@ -1237,9 +1237,9 @@ static bool should_skip_region(struct memblock_type *type,
 
 	/*
 	 * In early alloc during kexec handover, we can only consider
-	 * MEMBLOCK_KHO_SCRATCH regions for the allocations
+	 * MEMBLOCK_KHO_NOPRSRV regions for the allocations
 	 */
-	if ((flags & MEMBLOCK_KHO_SCRATCH) && !memblock_is_kho_scratch(m))
+	if ((flags & MEMBLOCK_KHO_NOPRSRV) && !memblock_is_kho_noprsrv(m))
 		return true;
 
 	return false;
@@ -2498,7 +2498,7 @@ void __init memblock_free_all(void)
 	free_unused_memmap();
 	reset_all_zones_managed_pages();
 
-	memblock_clear_kho_scratch_only();
+	memblock_clear_kho_noprsrv_only();
 	pages = free_low_memory_core_early();
 	totalram_pages_add(pages);
 }
@@ -2597,14 +2597,14 @@ int reserve_mem_release_by_name(const char *name)
 }
 
 #ifdef CONFIG_KEXEC_HANDOVER
-__init void memblock_set_kho_scratch_only(void)
+__init void memblock_set_kho_noprsrv_only(void)
 {
-	kho_scratch_only = true;
+	kho_noprsrv_only = true;
 }
 
-__init void memblock_clear_kho_scratch_only(void)
+__init void memblock_clear_kho_noprsrv_only(void)
 {
-	kho_scratch_only = false;
+	kho_noprsrv_only = false;
 }
 #endif
 
@@ -2860,7 +2860,7 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of scratch region */
+	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
 	start = memblock_phys_alloc(size, align);
 	if (!start) {
 		pr_err("reserve_mem: memblock allocation failed\n");
@@ -2885,7 +2885,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
-	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.55.0.1082.g2b9226bbc0-goog

