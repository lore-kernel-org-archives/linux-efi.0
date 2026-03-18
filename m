Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F63B4E8C;
	Wed, 18 Mar 2026 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831566; cv=none; b=AWii3TdVYNOwax33cUmur7JBC9T7driU9Pl7Es8yxdJCTAtS5VXKR89zK26RqASjJ2DN8gPKqYN37exin0ofhbubxvtRkkYFutX+LtE+jyuNzv7uZ/SGZ78uGReoL7v3yEyq5QO2XgIsT72EB7JPvSthZvZATyRNenFU2yBloHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831566; c=relaxed/simple;
	bh=EMwQwmstIDHc8FNs0QO2SlPHAkcDkrQ193OPS3fBl+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9TxEoIpNEm3vh0taIRYaFXoQn0DZ09v5crywfVIu1ZXm7zvzZZJE1LL7UJHsGVi7ytbwb5ynvWAVrc6H/pSVQjJ+5/HTL/5E3r3WZB+7KtFwtRqFIHw3V0BoaPd5rU36oWi7ZlqEg7vSM4y50NwzYSYw6XHEvLxOk+3vFXp8cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiqHuDff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiqHuDff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39407C2BCB9;
	Wed, 18 Mar 2026 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831565;
	bh=EMwQwmstIDHc8FNs0QO2SlPHAkcDkrQ193OPS3fBl+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiqHuDff+jDdjfstb/ZYgq2TD5ZpMwcm65UNdvRfRBe8PAN3icqQumgjGf0jjMwOP
	 j4nc/ZDV4yAotyjkmHE/A3sTeQSiHgk4XGbx+8PnfOEVuotW+6DjC+n8FzEn0N07ex
	 xwVTZRvNHJmzO1cKw+KDDsxpa6ivmiuE4M/gWBYWIPYVlHgBT4kKgBSZEAuXMBjlX5
	 77Iul3JgDJt2CbM/2QFqakDPRN1MY9jKIxjxmHZ2w5mk+/6blf8d902eLpySGRS5tT
	 qwiMpZ1OvhQHOtEQggRNLvjuWaF43Qy6zBz0ESnJrIw7OmrwuwmUImSs2W6tHshrk1
	 mMgjbGI9FPdTg==
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
Subject: [PATCH 4/8] memblock: make free_reserved_area() more robust
Date: Wed, 18 Mar 2026 12:58:23 +0200
Message-ID: <20260318105827.1358927-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There are two potential problems in free_reserved_area():
* it may free a page with not-existent buddy page
* it may be passed a virtual address from an alias mapping that won't
  be properly translated by virt_to_page(), for example a symbol on arm64

While first issue is quite theoretical and the second one does not manifest
itself because all the callers do the right thing, it is easy to make
free_reserved_area() robust enough to avoid these potential issues.

Replace the loop by virtual address with a loop by pfn that uses
for_each_valid_pfn() and use __pa() or __pa_symbol() depending on the
virtual mapping alias to correctly determine the loop boundaries.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 8f3010dddc58..27d4c9889b59 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -895,21 +895,32 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 
 unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
 {
-	void *pos;
-	unsigned long pages = 0;
+	phys_addr_t start_pa, end_pa;
+	unsigned long pages = 0, pfn;
 
-	start = (void *)PAGE_ALIGN((unsigned long)start);
-	end = (void *)((unsigned long)end & PAGE_MASK);
-	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
-		struct page *page = virt_to_page(pos);
+	/*
+	 * end is the first address past the region and it may be beyond what
+	 * __pa() or __pa_symbol() can handle.
+	 * Use the address included in the range for the cnversion and add back
+	 * 1 afterwards.
+	 */
+	if (__is_kernel((unsigned long)start)) {
+		start_pa = __pa_symbol(start);
+		end_pa = __pa_symbol(end - 1) + 1;
+	} else {
+		start_pa = __pa(start);
+		end_pa = __pa(end - 1) + 1;
+	}
+
+	for_each_valid_pfn(pfn, PFN_UP(start_pa), PFN_DOWN(end_pa)) {
+		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
 
 		/*
-		 * 'direct_map_addr' might be different from 'pos'
-		 * because some architectures' virt_to_page()
-		 * work with aliases.  Getting the direct map
-		 * address ensures that we get a _writeable_
-		 * alias for the memset().
+		 * 'direct_map_addr' might be different from the kernel virtual
+		 * address because some architectures use aliases.
+		 * Going via physical address, pfn_to_page() and page_address()
+		 * ensures that we get a _writeable_ alias for the memset().
 		 */
 		direct_map_addr = page_address(page);
 		/*
@@ -921,6 +932,7 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 			memset(direct_map_addr, poison, PAGE_SIZE);
 
 		free_reserved_page(page);
+		pages++;
 	}
 
 	if (pages && s)
-- 
2.51.0

