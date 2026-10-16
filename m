Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF7F47DF97;
	Fri, 16 Oct 2026 12:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152999; cv=none; b=DTP347KMWOn2busA24e8GOfW/T3RqAZrFy9kHZcckbRX2BRz/f+ZxZdt7ZF1QS296SQRQKG93mpdlNL+Nz0/WdN02cB9buHkwOhwDjvfZvYru2xAwpppGCGureDZyjA0SF36/OfzjbDU94I4ekl54/1QdlMOGAyWsXu3SYPniRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152999; c=relaxed/simple;
	bh=1Gz6lnJ9jCEh+Kk8x+u/AGj+TPZOj2wnVXg46SHamPY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y24lRnqJ2aNXQYhCYR790vay7dF4TTJ6Ya2Ycw7eVtaadGVuULM+EMCl4Q0hG9TR2xlgHAJIOUNxKK5DEB31b/8nb6m14twMft4ahCA6PXG/na/NCHUbsnwyZG6YifObjAriTTzaJQCQG0xxyn9fYFRd3rngkaNl4k790f22UWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=E0HohYgw; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="E0HohYgw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=j5WlAhqdTw51jsZEU9Iyw0h5ziY3yj6B04AcJcwRWsQ=; b=E0HohYgw5ujnAplsuyMYLRHFDE
	60AWIkqF2yvNNrQugsfhZt2HYxEg7gWKMI+M+rF8WAQCr6+7E/3Oj9yEcqWFIh5dYsI1pE6LbPPuz
	O1DGBOErtRRx3QXC8ZRYMDwGnFT8+KbNrXAQaIV61lA+QNMt9kkDlbW97WT+Fidh2KDDsJsOYFg6h
	iaCEJP2maS5YZfYX44WTpsQH0m9h9WQmBV9WMhPDsog+orgplCrLWlIcMffYasO5qAN+UcsOAvNvI
	j5xPPK34LJs/6sCupscoWlHcJIASSKC9xDjlLXgvZs82DqsPkWgZqW0bXL+EFhyyimEjLykVJWgqt
	ZMjCUmhA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrM-005xTU-0o;
	Fri, 16 Oct 2026 12:16:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:44 -0700
Subject: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=7042; i=leitao@debian.org;
 h=from:subject:message-id; bh=1Gz6lnJ9jCEh+Kk8x+u/AGj+TPZOj2wnVXg46SHamPY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV08vEVvFeWRabaDAQScb6RPo6JT8sn2h7BQ
 RIiwfePyl+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bR6VD/9O6KCng9ZkpKqc8pPLBw+L56WCgwopttow90n2D7auR9dm6jAeNh7rxGnx24E5T06au2y
 Y+qR5Xz4DpxdAGZJzl29FGHCSzBXR+mX0I+mQBr8TRdfYhgkV1RrKPl69IMwBm8ZuS6wbi4Zc3V
 Xv5mQ+mdcKXNa1/wy/mYLJrtWaOFTvQKn52rvYxJQt2NhakISGJ6w2pa8bwiTlxvI5VfxeATvtR
 SDVfIX+YQJRJPdeKTaLpeuIveioDr3D2Uv29PeZe5VasnfPNNlQ1Jig1rYC+TZ0fjY2BT7bTEwW
 6BlzDcymHLE05Rw9G5389PUXC1znR0f3P4opZ2+oFVLI6h4G+yM5OsixP6t50Pl0Q/5K+FOaviH
 BqA2ogubvD9F3dgY0pO/jqd+tA+beX8bsihH5IUUpU69HaxI2hFLuedZeo5lmIxClJEq9csgtxB
 DoCa4JedObIu8JDqlZjB7Z5nVud/0lkgbz8Le7g4vvp5G2Lt72r+K+6ZGdN+igOLetWc3Go1fdV
 IB+umGeEkFI/bM51eEe49AbUSuTcJyeW45rKDlmnK/6s6ixq3wdmqddmHXHzp++YVpl9V413A68
 v/8MDLKIyGxESyybAfrSr3v8eUhu1qjiy6CNBbHiN8KoQLiM6t6jNQHXz1hx3mpDdNC30MdaqtZ
 MYqQMCTDkgdarNg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

memblock allocates from and frees to buddy whatever is not reserved, and
knows nothing about frames an earlier kernel found hardware-poisoned.
Such a frame can back the memmap, a page table or a percpu area before
any hwpoison code runs, and otherwise reaches the buddy allocator like
any other free frame.

Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.
memblock neither allocates from a flagged range nor frees it to buddy.
memmap_init_reserved_pages() initializes its struct pages like any other
reserved range, including above first_deferred_pfn, but flags the RAM
frames PG_hwpoison instead of PG_reserved. That is the state of a frame
poisoned by this kernel. Holes in the range stay reserved.

PG_reserved is left clear on purpose. page_is_unmovable() treats a
reserved page as unmovable but skips a counted PG_hwpoison one, so a
memory block holding an inherited frame can still be offlined.

memblock_reserve_hwpoison() is the entry point. It is best effort. Until
the reserved array can be resized it keeps spare slots for the
reservations that must not fail. It flags only what no earlier
reservation covers, a kexec segment for one: that was placed around the
bad frames, and memblock_add_range() would warn about the overlap. A page
shared with such a reservation stays with it, so no page is flagged
twice.

It returns 0 only when every free part of the range is reserved. If any
part cannot be reserved it returns an error, even when another part was.

Name the flag in the debugfs flag table. MEMBLOCK_RSRV_HUGETLB gets a
name too: it has none, and would be left as a NULL slot below the new
flag, which memblock_debug_show() passes on to seq_puts().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/memblock.h | 10 ++++++
 mm/memblock.c            | 80 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index aa845f488327f2..86755be249666d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_RSRV_HWPOISON: reserved memory region holding frames an earlier
+ * kernel found to be hardware-poisoned.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_RSRV_HWPOISON	= 0x100, /* poisoned by an earlier kernel */
 };
 
 /**
@@ -142,6 +145,8 @@ static __always_inline int memblock_reserve_kern(phys_addr_t base, phys_addr_t s
 	return __memblock_reserve(base, size, NUMA_NO_NODE, MEMBLOCK_RSRV_KERN);
 }
 
+int memblock_reserve_hwpoison(phys_addr_t base, phys_addr_t size);
+
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
 #endif
@@ -295,6 +300,11 @@ static inline bool memblock_is_reserved_noinit(struct memblock_region *m)
 	return m->flags & MEMBLOCK_RSRV_NOINIT;
 }
 
+static inline bool memblock_is_reserved_hwpoison(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_RSRV_HWPOISON;
+}
+
 static inline bool memblock_is_driver_managed(struct memblock_region *m)
 {
 	return m->flags & MEMBLOCK_DRIVER_MANAGED;
diff --git a/mm/memblock.c b/mm/memblock.c
index 31961ed628b0ad..d20d99972a4db0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -36,6 +36,9 @@
 # define INIT_MEMBLOCK_RESERVED_REGIONS		INIT_MEMBLOCK_REGIONS
 #endif
 
+/* Reserved slots memblock_reserve_hwpoison() leaves free until a resize. */
+#define MEMBLOCK_HWPOISON_SPARE			32
+
 #ifndef INIT_MEMBLOCK_MEMORY_REGIONS
 #define INIT_MEMBLOCK_MEMORY_REGIONS		INIT_MEMBLOCK_REGIONS
 #endif
@@ -1015,6 +1018,55 @@ int __init_memblock __memblock_reserve(phys_addr_t base, phys_addr_t size,
 	return memblock_add_range(&memblock.reserved, base, size, nid, flags);
 }
 
+int __init memblock_reserve_hwpoison(phys_addr_t base, phys_addr_t size)
+{
+	phys_addr_t end = base + size;
+	bool reserved = false;
+	int err = 0;
+
+	while (base < end) {
+		phys_addr_t next = end;
+		struct memblock_region *r;
+		bool covered = false;
+
+		for_each_reserved_mem_region(r) {
+			if (r->base + r->size <= base)
+				continue;
+			if (r->base >= end)
+				break;
+			if (PAGE_ALIGN_DOWN(r->base) <= base) {
+				base = min(end, PAGE_ALIGN(r->base + r->size));
+				covered = true;
+			} else {
+				next = PAGE_ALIGN_DOWN(r->base);
+			}
+			break;
+		}
+		if (covered)
+			continue;
+
+		if (!memblock_can_resize &&
+		    memblock.reserved.cnt + MEMBLOCK_HWPOISON_SPARE >=
+		    memblock.reserved.max) {
+			err = -ENOSPC;
+			break;
+		}
+
+		err = __memblock_reserve(base, next - base, NUMA_NO_NODE,
+					 MEMBLOCK_RSRV_HWPOISON);
+		if (err)
+			break;
+
+		reserved = true;
+		base = next;
+	}
+
+	if (err)
+		return err;
+
+	return reserved ? 0 : -EBUSY;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
 {
@@ -2394,6 +2446,27 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
 	}
 }
 
+/*
+ * Frames an earlier kernel found poisoned end up as a frame poisoned by this
+ * kernel would: PG_hwpoison, not PG_reserved. Holes in the range stay reserved.
+ */
+static void __init memmap_init_hwpoison_range(phys_addr_t start,
+					      phys_addr_t end, int nid)
+{
+	unsigned long pfn;
+
+	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
+		struct page *page = pfn_to_page(pfn);
+
+		init_deferred_page(pfn, nid);
+
+		if (memblock_is_map_memory(PFN_PHYS(pfn)))
+			hwpoison_boot_page(page);
+		else
+			__SetPageReserved(page);
+	}
+}
+
 static void __init memmap_init_reserved_pages(void)
 {
 	struct memblock_region *region;
@@ -2438,7 +2511,10 @@ static void __init memmap_init_reserved_pages(void)
 			if (!numa_valid_node(nid))
 				nid = early_pfn_to_nid(PFN_DOWN(start));
 
-			memmap_init_reserved_range(start, end, nid);
+			if (memblock_is_reserved_hwpoison(region))
+				memmap_init_hwpoison_range(start, end, nid);
+			else
+				memmap_init_reserved_range(start, end, nid);
 		}
 	}
 }
@@ -2874,6 +2950,8 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_RSRV_HWPOISON)] = "RSV_HWPOISON",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)

-- 
2.53.0-Meta

