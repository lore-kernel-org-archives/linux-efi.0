Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E009F36308D;
	Mon, 23 Mar 2026 07:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252220; cv=none; b=VC9h9geK7TKaOB67BtCPQ1XEsr/KCY+I7RP0FnUkYyQPGMOS9vVk4vqb5roHoVGL722DOqoRhsW7VJGT66vufJEprwUqOrhfHCxU3yF7yy9Ew5I/PLN6RmhpitPuk5YIKEpjWXovQs94nvGNWwDNp3jeuXtR0n5EvIPmMex9HI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252220; c=relaxed/simple;
	bh=+ig/11q3VRUjF4ArUTH3xGDXOKNW07DxpNhjoaJhyZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQE6e3EnCoRIMa/6S22t9AY/6YYpEmLEMBcetQgiDFS3aqTr6diX15C0w4aXSoez39XZ2rGBJY1ZtdouVmm8+agrtUWKH5jwWlGcQWL2Nz1rzIcttcSAid/uF4ZK1Xw8kAdSzVrvB1MeIWc9Q/VQvSnoOiu3n5xDTotLV/q3wzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZ1UA+S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZ1UA+S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE36EC2BC9E;
	Mon, 23 Mar 2026 07:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252219;
	bh=+ig/11q3VRUjF4ArUTH3xGDXOKNW07DxpNhjoaJhyZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZ1UA+S0+bqroRdQ7z9eWrVqAwO2iw+4ovgINTlm3abR6YK36AftCJVaJb1iJfkoo
	 uhqVGJrE9Yb4VkqFX/pnhX1e0V/d6p6AshGhQpkA+JQLZL9YUwzBPJsiWyOz+7akJ8
	 Ciw7bBi65L+YU8wl1or8U8ac4EODsE3Zz4y1GXaEMLmUCFrrK0UqcauK7WvYYOtpaU
	 o2+46DVcuJEsMjFu3pRR4gqkDbBoEVV8rZu4ZWhsLpDVfC6wJmpfrR5WYbGvZfzlnz
	 Vsy42hU8lzIDX/ALRMvYcuUgo/O5Xw9CUlMr0PXgjWQGA9aRWYD5PrDj5dKZthfLfr
	 ARLZ9RxDe9cag==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 8/9] memblock, treewide: make memblock_free() handle late freeing
Date: Mon, 23 Mar 2026 09:48:35 +0200
Message-ID: <20260323074836.3653702-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

It shouldn't be responsibility of memblock users to detect if they free
memory allocated from memblock late and should use memblock_free_late().

Make memblock_free() and memblock_phys_free() take care of late memory
freeing and drop memblock_free_late().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sparc/kernel/mdesc.c               |  4 +-
 arch/x86/kernel/setup.c                 |  2 +-
 arch/x86/platform/efi/memmap.c          |  5 +--
 arch/x86/platform/efi/quirks.c          |  2 +-
 drivers/firmware/efi/apple-properties.c |  2 +-
 drivers/of/kexec.c                      |  2 +-
 include/linux/memblock.h                |  2 -
 kernel/dma/swiotlb.c                    |  6 +--
 lib/bootconfig.c                        |  2 +-
 mm/kfence/core.c                        |  4 +-
 mm/memblock.c                           | 49 ++++++++++---------------
 11 files changed, 31 insertions(+), 49 deletions(-)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 30f171b7b00c..ecd6c8ae49c7 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -183,14 +183,12 @@ static struct mdesc_handle * __init mdesc_memblock_alloc(unsigned int mdesc_size
 static void __init mdesc_memblock_free(struct mdesc_handle *hp)
 {
 	unsigned int alloc_size;
-	unsigned long start;
 
 	BUG_ON(refcount_read(&hp->refcnt) != 0);
 	BUG_ON(!list_empty(&hp->list));
 
 	alloc_size = PAGE_ALIGN(hp->handle_size);
-	start = __pa(hp);
-	memblock_free_late(start, alloc_size);
+	memblock_free(hp, alloc_size);
 }
 
 static struct mdesc_mem_ops memblock_mdesc_ops = {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index eebcc9db1a1b..46882ce79c3a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -426,7 +426,7 @@ int __init ima_free_kexec_buffer(void)
 	if (!ima_kexec_buffer_size)
 		return -ENOENT;
 
-	memblock_free_late(ima_kexec_buffer_phys,
+	memblock_phys_free(ima_kexec_buffer_phys,
 			   ima_kexec_buffer_size);
 
 	ima_kexec_buffer_phys = 0;
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 023697c88910..697a9a26a005 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -34,10 +34,7 @@ static
 void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
 {
 	if (flags & EFI_MEMMAP_MEMBLOCK) {
-		if (slab_is_available())
-			memblock_free_late(phys, size);
-		else
-			memblock_phys_free(phys, size);
+		memblock_phys_free(phys, size);
 	} else if (flags & EFI_MEMMAP_SLAB) {
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 35caa5746115..a560bbcaa006 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -372,7 +372,7 @@ void __init efi_reserve_boot_services(void)
 		 * doesn't make sense as far as the firmware is
 		 * concerned, but it does provide us with a way to tag
 		 * those regions that must not be paired with
-		 * memblock_free_late().
+		 * memblock_phys_free().
 		 */
 		md->attribute |= EFI_MEMORY_RUNTIME;
 	}
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 13ac28754c03..2e525e17fba7 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -226,7 +226,7 @@ static int __init map_properties(void)
 		 */
 		data->len = 0;
 		memunmap(data);
-		memblock_free_late(pa_data + sizeof(*data), data_len);
+		memblock_phys_free(pa_data + sizeof(*data), data_len);
 
 		return ret;
 	}
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index c4cf3552c018..512d9be9d513 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -175,7 +175,7 @@ int __init ima_free_kexec_buffer(void)
 	if (ret)
 		return ret;
 
-	memblock_free_late(addr, size);
+	memblock_phys_free(addr, size);
 	return 0;
 }
 #endif
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..6f6c5b5c4a4b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -172,8 +172,6 @@ void __next_mem_range_rev(u64 *idx, int nid, enum memblock_flags flags,
 			  struct memblock_type *type_b, phys_addr_t *out_start,
 			  phys_addr_t *out_end, int *out_nid);
 
-void memblock_free_late(phys_addr_t base, phys_addr_t size);
-
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 static inline void __next_physmem_range(u64 *idx, struct memblock_type *type,
 					phys_addr_t *out_start,
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index d8e6f1d889d5..e44e039e00d3 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -546,10 +546,10 @@ void __init swiotlb_exit(void)
 		free_pages(tbl_vaddr, get_order(tbl_size));
 		free_pages((unsigned long)mem->slots, get_order(slots_size));
 	} else {
-		memblock_free_late(__pa(mem->areas),
+		memblock_free(mem->areas,
 			array_size(sizeof(*mem->areas), mem->nareas));
-		memblock_free_late(mem->start, tbl_size);
-		memblock_free_late(__pa(mem->slots), slots_size);
+		memblock_phys_free(mem->start, tbl_size);
+		memblock_free(mem->slots, slots_size);
 	}
 
 	memset(mem, 0, sizeof(*mem));
diff --git a/lib/bootconfig.c b/lib/bootconfig.c
index 449369a60846..86a75bf636bc 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -64,7 +64,7 @@ static inline void __init xbc_free_mem(void *addr, size_t size, bool early)
 	if (early)
 		memblock_free(addr, size);
 	else if (addr)
-		memblock_free_late(__pa(addr), size);
+		memblock_free(addr, size);
 }
 
 #else /* !__KERNEL__ */
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 7393957f9a20..5c8268af533e 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -731,10 +731,10 @@ static bool __init kfence_init_pool_early(void)
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
-	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
+	memblock_free((void *)addr, KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 
-	memblock_free_late(__pa(kfence_metadata_init), KFENCE_METADATA_SIZE);
+	memblock_free(kfence_metadata_init, KFENCE_METADATA_SIZE);
 	kfence_metadata_init = NULL;
 
 	return false;
diff --git a/mm/memblock.c b/mm/memblock.c
index 0ad968c2f2e8..dc8811861c11 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -384,26 +384,27 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
  */
 void __init memblock_discard(void)
 {
-	phys_addr_t addr, size;
+	phys_addr_t size;
+	void *addr;
 
 	if (memblock.reserved.regions != memblock_reserved_init_regions) {
-		addr = __pa(memblock.reserved.regions);
+		addr = memblock.reserved.regions;
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
 		if (memblock_reserved_in_slab)
-			kfree(memblock.reserved.regions);
+			kfree(addr);
 		else
-			memblock_free_late(addr, size);
+			memblock_free(addr, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
-		addr = __pa(memblock.memory.regions);
+		addr = memblock.memory.regions;
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
 		if (memblock_memory_in_slab)
-			kfree(memblock.memory.regions);
+			kfree(addr);
 		else
-			memblock_free_late(addr, size);
+			memblock_free(addr, size);
 	}
 
 	memblock_memory = NULL;
@@ -961,7 +962,8 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
  * @size: size of the boot memory block in bytes
  *
  * Free boot memory block previously allocated by memblock_alloc_xx() API.
- * The freeing memory will not be released to the buddy allocator.
+ * If called after the buddy allocator is available, the memory is released to
+ * the buddy allocator.
  */
 void __init_memblock memblock_free(void *ptr, size_t size)
 {
@@ -975,17 +977,24 @@ void __init_memblock memblock_free(void *ptr, size_t size)
  * @size: size of the boot memory block in bytes
  *
  * Free boot memory block previously allocated by memblock_phys_alloc_xx() API.
- * The freeing memory will not be released to the buddy allocator.
+ * If called after the buddy allocator is available, the memory is released to
+ * the buddy allocator.
  */
 int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t end = base + size - 1;
+	int ret;
 
 	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
 		     &base, &end, (void *)_RET_IP_);
 
 	kmemleak_free_part_phys(base, size);
-	return memblock_remove_range(&memblock.reserved, base, size);
+	ret = memblock_remove_range(&memblock.reserved, base, size);
+
+	if (slab_is_available())
+		__free_reserved_area(base, base + size, -1);
+
+	return ret;
 }
 
 int __init_memblock __memblock_reserve(phys_addr_t base, phys_addr_t size,
@@ -1813,26 +1822,6 @@ void *__init __memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
 	return addr;
 }
 
-/**
- * memblock_free_late - free pages directly to buddy allocator
- * @base: phys starting address of the  boot memory block
- * @size: size of the boot memory block in bytes
- *
- * This is only useful when the memblock allocator has already been torn
- * down, but we are still initializing the system.  Pages are released directly
- * to the buddy allocator.
- */
-void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
-{
-	phys_addr_t end = base + size - 1;
-
-	memblock_dbg("%s: [%pa-%pa] %pS\n",
-		     __func__, &base, &end, (void *)_RET_IP_);
-
-	kmemleak_free_part_phys(base, size);
-	__free_reserved_area(base, base + size, -1);
-}
-
 /*
  * Remaining API functions
  */
-- 
2.53.0

