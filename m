Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35336CDEB;
	Wed, 18 Mar 2026 20:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867158; cv=none; b=m/5t9bhECYXyR57iZg9hcGnOM+mHrXwKEmSbzOFcXfHBbRMASxOlkh10nswASmUYveoH1yTHXb1t8S/CRW1qAszBnIVzcUiAs8ba4kJZ5W2z4yPRYWgWvJDulydd7dfcQXK8NWdqotrdUCUAdf+/2IsYz7knJLlz09UlhhiTPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867158; c=relaxed/simple;
	bh=kbGM3c4xh2xtlPKItuu8b0plWdnAptUOEmkS13CYnz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khU+CvzlJ6E3i8P/yZqbQ78bHcQSp04efTuoG5gRRpqgKcpxagUxlPHjwfcJfqLGN9j/Nwo1IjJmDSrFWgchtAzkFvs2XSilLw2+C2+Ac6yn9DtJ6h8vS2fJJVsMaUNgOfAdIa/aUYzNUXOF6y41NAcw1QksAQKmKnaiCHHkjmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7zvu5MI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7zvu5MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF7BC19421;
	Wed, 18 Mar 2026 20:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773867157;
	bh=kbGM3c4xh2xtlPKItuu8b0plWdnAptUOEmkS13CYnz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7zvu5MIc5CYIGmjWx+P+mS8/hs2GooJWHfXhDPqFeWyum4sz6NQ2neYQyXlUtlCv
	 SOoz9lLS4EQYDGViVf0oRa8oUQ4wZWHCy5DjVMkrRZlzhDZfSxX8btIRC6pKKcZtqq
	 HqFvYKZdPu6NZcu/RPV8yxBpMtnFC8Ki3vcf/rOBJrcG5AcAzdMR2gnTomxyf7IP8H
	 zHZMPsz/wlq4Amx6dQtpM7EHwIuIilXwCtH35+nfGyIdYuPry8qYRVdyy1g3sS3ITk
	 esmcmpAq0Qm7xqoPTPtpTIaBIFFTr4xbzEGttviQsDf6G2SgDxhQSQi5C5yhB9KCwG
	 yOFQuYZFuGWzw==
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
Subject: [PATCH 9/8] memblock tests: add stubs required for free_reserved_area()
Date: Wed, 18 Mar 2026 22:52:21 +0200
Message-ID: <20260318205221.1402161-1-rppt@kernel.org>
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

After moving free_reserved_area() function to mm/memblock.c memblock
tests lack stubs for several functions and macros this function calls.

Add them.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/include/linux/mm.h          |  1 +
 tools/testing/memblock/internal.h | 28 +++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 028f3faf46e7..4407d8396108 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -17,6 +17,7 @@
 
 #define __va(x) ((void *)((unsigned long)(x)))
 #define __pa(x) ((unsigned long)(x))
+#define __pa_symbol(x) ((unsigned long)(x))
 
 #define pfn_to_page(pfn) ((void *)((pfn) * PAGE_SIZE))
 
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index 009b97bbdd22..7ff61172ab24 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -11,9 +11,16 @@ static int memblock_debug = 1;
 
 #define pr_warn_ratelimited(fmt, ...)    printf(fmt, ##__VA_ARGS__)
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 bool mirrored_kernelcore = false;
 
 struct page {};
+static inline void *page_address(struct page *page)
+{
+	BUG();
+	return page;
+}
 
 void memblock_free_pages(unsigned long pfn, unsigned int order)
 {
@@ -23,10 +30,25 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
-static inline unsigned long free_reserved_area(void *start, void *end,
-					       int poison, const char *s)
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
+void free_reserved_page(struct page *page);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
+	for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
+
+static inline void *kasan_reset_tag(const void *addr)
+{
+	return (void *)addr;
+}
+
+static inline bool __is_kernel(unsigned long addr)
 {
-	return 0;
+	return false;
 }
 
 #endif
-- 
2.51.0

