Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC1E3603D9;
	Mon, 23 Mar 2026 07:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252197; cv=none; b=LI8+oCP81mL92dE3QKO/GZyKY9Biws+h9MoDxyodIRB1lv92taPNh4IM7PrvJMKvEePP73OmF1uTK9Jl1rEnx/6T/d/0MfbzPhfeBJ821+zBTh22Vh8MXxMBoGdmNwNnTLop+XXhSzjbuQr2JtR88GpnDLp7vmoSpIGIZm1W/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252197; c=relaxed/simple;
	bh=CusCegPCNb++eRZgEnFYAhQJhnAtG3gjmvQHWQKqyPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QS68z+wLHqtx4CbRT4DPwnbG0Pmk4dEJHpULohmsv2hT5V6yMggG5SVqUgVfinYwRWs8ORWzc7/x9iaNsWo7nk6HwHv3zf8G2vcOK5fOuH4PtyrykYE2VFFjl6HvaoRw3Xi8HbTYcu6Tq/7/ZEO9I3CW4VhtEu6bmZWRexCZWL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6fPKlxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6fPKlxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B693C2BC9E;
	Mon, 23 Mar 2026 07:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252197;
	bh=CusCegPCNb++eRZgEnFYAhQJhnAtG3gjmvQHWQKqyPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6fPKlxHQgWSYzAKTM8G/WWrhZHeaeNsETUGqkQueGTMK64wv6WfUMzzorQkeopo7
	 hBHZE+Gqs69UQLXKRy/u5tAt1wOavloqFcv52lzntc3bYHhMnIBwNhwWERo67xoRWs
	 e+V1fc4IuFsAILvV17/Umo0CswXHiww2G9w5Xmd5bUZ/65HujbklLiPL0z9Ta4QPPB
	 jXAaAUCkB5sI+cmP91/5BYP+gLzDhZrZBjNKcAP9UvluKbCVPCd5xFSjRu5OWYWMU0
	 Gk6PiNYwrqh+5Y8Mj243Ec5aEbQi2bt8Ki9ITja32vtDHNFNfgb/1VhVG4vtHkAh/C
	 1xTA2fQLh15Mg==
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
Subject: [PATCH v2 6/9] memblock: extract page freeing from free_reserved_area() into a helper
Date: Mon, 23 Mar 2026 09:48:33 +0200
Message-ID: <20260323074836.3653702-7-rppt@kernel.org>
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

There are two functions that release pages to the buddy allocator late in
the boot: free_reserved_area() and memblock_free_late().

Currently they are using different underlying functionality,
free_reserved_area() runs each page being freed via free_reserved_page()
and memblock_free_late() uses memblock_free_pages() -> __free_pages_core(),
but in the end they both boil down to a loop that frees a range page by
page.

Extract the loop frees pages from free_reserved_area() into a helper and
use that helper in memblock_free_late().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 55 +++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index eb086724802a..ccdf3d225626 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -893,26 +893,12 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 	return memblock_remove_range(&memblock.memory, base, size);
 }
 
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
+static unsigned long __free_reserved_area(phys_addr_t start, phys_addr_t end,
+					  int poison)
 {
-	phys_addr_t start_pa, end_pa;
 	unsigned long pages = 0, pfn;
 
-	/*
-	 * end is the first address past the region and it may be beyond what
-	 * __pa() or __pa_symbol() can handle.
-	 * Use the address included in the range for the conversion and add
-	 * back 1 afterwards.
-	 */
-	if (__is_kernel((unsigned long)start)) {
-		start_pa = __pa_symbol(start);
-		end_pa = __pa_symbol(end - 1) + 1;
-	} else {
-		start_pa = __pa(start);
-		end_pa = __pa(end - 1) + 1;
-	}
-
-	for_each_valid_pfn(pfn, PFN_UP(start_pa), PFN_DOWN(end_pa)) {
+	for_each_valid_pfn(pfn, PFN_UP(start), PFN_DOWN(end)) {
 		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
 
@@ -934,7 +920,29 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 		free_reserved_page(page);
 		pages++;
 	}
+	return pages;
+}
+
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
+{
+	phys_addr_t start_pa, end_pa;
+	unsigned long pages;
+
+	/*
+	 * end is the first address past the region and it may be beyond what
+	 * __pa() or __pa_symbol() can handle.
+	 * Use the address included in the range for the conversion and add back
+	 * 1 afterwards.
+	 */
+	if (__is_kernel((unsigned long)start)) {
+		start_pa = __pa_symbol(start);
+		end_pa = __pa_symbol(end - 1) + 1;
+	} else {
+		start_pa = __pa(start);
+		end_pa = __pa(end - 1) + 1;
+	}
 
+	pages = __free_reserved_area(start_pa, end_pa, poison);
 	if (pages && s)
 		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
 
@@ -1810,20 +1818,15 @@ void *__init __memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
  */
 void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
-	phys_addr_t cursor, end;
+	phys_addr_t end = base + size - 1;
 
-	end = base + size - 1;
 	memblock_dbg("%s: [%pa-%pa] %pS\n",
 		     __func__, &base, &end, (void *)_RET_IP_);
-	kmemleak_free_part_phys(base, size);
-	cursor = PFN_UP(base);
-	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(cursor, 0);
-		totalram_pages_inc();
-	}
+	kmemleak_free_part_phys(base, size);
+	__free_reserved_area(base, base + size, -1);
 }
+
 /*
  * Remaining API functions
  */
-- 
2.53.0

