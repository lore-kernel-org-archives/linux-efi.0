Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069815;
	b=eYn30rnkzXBjaOcK9Mj+QYqAa3uXvCTVOsKG4Yds+TUuoehqfMpbJb1Xvop5gqOvoDOs
	 OLdKFTghIiPyY/87oDIQ0rvTinfEaDqOCNte//GkNRAqxJABcJ0Z/GbIdmxIJOKFwQRdl
	 E4ZtzfKJyxgExGSz4j8UxKM/lq61A0BZ/oQ49BMLS9lkxCynMfy3R5EBbZNA2LEL50fEb
	 BSEo3YSe3bxq7ni8OLIdA4AOCLx0z8vn+2tQx+qdWueQPFUNBtIOd217FZFdBkRaw5mhn
	 S36lrNL7GpG0KAjDODQqhw/hYEpXzStH79KgL/x4euL69T1yX0OzDEPJp48LNGN286A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=LCdG6rFn11zBCazpVzMCvIt14BjXcoxSwJ2DZpHTKik=;
	b=Ndp+uYXGrqyUN+G3ARhaz68faWiMjejoMMtDSvCZ8DUJeLupiptUh29cYbDG/kzqd0+H
	 wSPmtgQNFEoyibfKzcjnNYz7/1QzkXTmwNNyOBU41mwBioEitGdD+5as/MLc2PxsPsJnh
	 0JRqMhVukjU8Ut9Hj6sBC5BW28Yz9q+VJJ5CCN3Xod66hQ5v0NRudHATYOeY0xDWuhYTz
	 kzxh56XjQhA1xCHDBUYOWrAK4LCBwnSXgiLyuHZaek6gxnhwFTw7VD77NCkRvjOQlXCRi
	 q7fIBbW7/T9RbKqPJI3og7ck2nQNPKnlH8IU/8WYbfIiUhtQQybD/4SIpXTlb58GYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=n4SHizbm;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC481606A322
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC481606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=n4SHizbm
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b26d8d2498so5304322b6e.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069814; x=1793674614; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCdG6rFn11zBCazpVzMCvIt14BjXcoxSwJ2DZpHTKik=;
        b=n4SHizbmrVKHw5giNfmoZ4gzXbtHzneH5WzkSgh2t8TWpy/3bc8abaUFhq1mRLUagv
         4grlXHWSR1O+DGsfkRGyBTS4SBlsI30DWaaXWqpVZ+J4IgHaDYxxN8uW88yWFN7psIXi
         0MIUCKZy/3okX+88aoawpGiZW1wmqeZNTO9D8jxy7BgFp21dU/YAq/J3aYzr0DU6/VOA
         9qd7ayF3K9AzavUz46dQVAYcx47Zf0AfDDBrjWZ4mrvfoVZFsrxHrYTm61cW6ZMXD2tm
         NFQ0Eb8Jft4olwKq8My+g0V5dWZ7FdDBH8rlAK2OXDi0fEEhvEO5Hw9Ciyuet/DIeA4m
         GPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069814; x=1793674614;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LCdG6rFn11zBCazpVzMCvIt14BjXcoxSwJ2DZpHTKik=;
        b=yfMZE/zRyRkRGRwvO+JQXgYeziJuDErNO1X39xhTbdYOk67vlsFOOEv9ddti87dSER
         TQ6LnOPjTCEJXVIiZcimqzjf0pdomQ2kmW2jwI41rJFGr27zwIiVIEKugrFsAfMslJh1
         l2c40eVEu5bG1ckj5wNYgyyONxf0Jo2IpY5H0ueuD/5hqTaAXMYlcAJA2zqeR/4Iactr
         08CmZdf6IeLXbs8LIMzc56yUe35NowYTb8bu+5fvuAfwopBEMs7D5iln5G+L62X5Ypxn
         tWgLyn4N6GaRgIT/4+0hyTqVqZLD0d9gGpzK4sPXANfuwxEvwOZI2cg6qpEpcM2wHi6e
         0INg==
X-Forwarded-Encrypted: i=1; AKwUvBzOJjIwCcvRQ77QZL4fFIRXGo35xPmneRocynhpcMkPtru/PWVI0WFmFFBSk7UHO6vFWh1WES8snr0=@vger.kernel.org
X-Gm-Message-State: AFq9FYKzyHhtJf7m7h0V1wdV5QCyrZl8JfPM+RtDoMu7ODOWqIFRGVQP
	8OBUjgkkp69t4Ch8HxG0s6Y2EHb+Q/l4WjNFqtbIdbCrn4M2rzu9TUqr0BtXMVscv9ezoXb6oL1
	4dUIrcfsoS2p14n6MYL6Tqwu+1BDyJNIsew==
X-Received: from iohd14-n1.prod.google.com ([2002:a05:6602:86ce:10b0:9c4:b80b:7605])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1b2b:b0:4f4:73a9:f853 with SMTP id 5614622812f47-55bfff91bbdmr5294339b6e.1.1793069813464;
 Mon, 26 Oct 2026 19:56:53 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:11 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-9-kevinloughlin@google.com>
Subject: [PATCH 08/13] mm/page_alloc: route unaccepted isolated pages
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"

When free page reporting unaccepts isolated pages on confidential
computing guests, __putback_isolated_page() must not return those
unaccepted pages directly to zone->free_area; doing so would violate the
allocator invariant that all pages on zone->free_area are accepted.

Update __putback_isolated_page(), __free_pages_ok(),
__free_frozen_pages(), and free_unref_folios() to route dynamically
unaccepted pages to zone->unaccepted_pages via __free_unaccepted_locked()
(falling back to immediate acceptance for isolated or CMA pageblocks).

In addition:
- Extract free_pages_prepare_init() so post-acceptance poisoning,
  zeroing, KASAN tagging, arch_free_page(), and debug_pagealloc
  unmapping run after accept_memory() without touching unaccepted pages
  in __free_pages_prepare() or re-running metadata teardown in
  __accept_page().
- Pass FPI_SKIP_REPORT_NOTIFY when __accept_page() frees a freshly
  accepted block into the buddy allocator so it is not immediately
  re-queued for free page reporting before allocation.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 mm/page_alloc.c | 120 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 35 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 46ae8c6f3814..c10b77304633 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1298,12 +1298,53 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+static inline bool should_free_unaccepted(struct page *page,
+					  unsigned int order,
+					  fpi_t fpi_flags)
+{
+	return !(fpi_flags & FPI_NOLOCK) &&
+	       page_contains_unaccepted(page, order);
+}
+
+static void free_pages_prepare_init(struct page *page, unsigned int order)
+{
+	bool skip_kasan_poison = should_skip_kasan_poison(page);
+	bool init = want_init_on_free();
+
+	kernel_poison_pages(page, 1 << order);
+
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * KASAN poisoning and memory initialization code must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
+	 * With hardware tag-based KASAN, memory tags must be set before the
+	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 */
+	if (!skip_kasan_poison) {
+		kasan_poison_pages(page, order, init);
+
+		/* Memory is already initialized if KASAN did it internally. */
+		if (kasan_has_integrated_init())
+			init = false;
+	}
+	if (init)
+		clear_highpages_kasan_tagged(page, 1 << order);
+
+	/*
+	 * arch_free_page() can make the page's contents inaccessible.  s390
+	 * does this.  So nothing which can access the page's contents should
+	 * happen after this.
+	 */
+	arch_free_page(page, order);
+
+	debug_pagealloc_unmap_pages(page, 1 << order);
+}
+
 static __always_inline bool __free_pages_prepare(struct page *page,
 		unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(page);
-	bool init = want_init_on_free();
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
@@ -1411,34 +1452,10 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 					   PAGE_SIZE << order);
 	}
 
-	kernel_poison_pages(page, 1 << order);
-
-	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * KASAN poisoning and memory initialization code must be
-	 * kept together to avoid discrepancies in behavior.
-	 *
-	 * With hardware tag-based KASAN, memory tags must be set before the
-	 * page becomes unavailable via debug_pagealloc or arch_free_page.
-	 */
-	if (!skip_kasan_poison) {
-		kasan_poison_pages(page, order, init);
-
-		/* Memory is already initialized if KASAN did it internally. */
-		if (kasan_has_integrated_init())
-			init = false;
-	}
-	if (init)
-		clear_highpages_kasan_tagged(page, 1 << order);
-
-	/*
-	 * arch_free_page() can make the page's contents inaccessible.  s390
-	 * does this.  So nothing which can access the page's contents should
-	 * happen after this.
-	 */
-	arch_free_page(page, order);
+	if (should_free_unaccepted(page, order, fpi_flags))
+		return true;
 
-	debug_pagealloc_unmap_pages(page, 1 << order);
+	free_pages_prepare_init(page, order);
 
 	return true;
 }
@@ -1572,14 +1589,31 @@ static void free_one_page(struct zone *zone, struct page *page,
 	__count_vm_events(PGFREE, 1 << order);
 }
 
+static bool handle_unaccepted_free(struct page *page, unsigned int order,
+				   fpi_t fpi_flags)
+{
+	if (!should_free_unaccepted(page, order, fpi_flags))
+		return false;
+
+	if (__free_unaccepted(page, order))
+		return true;
+
+	accept_memory(page_to_phys(page), PAGE_SIZE << order);
+	free_pages_prepare_init(page, order);
+	return false;
+}
+
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (handle_unaccepted_free(page, order, fpi_flags))
+			return;
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -2955,7 +2989,8 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
-	if (!pcp_allowed_order(order)) {
+	if (!pcp_allowed_order(order) ||
+	    should_free_unaccepted(page, order, fpi_flags)) {
 		__free_pages_ok(page, order, fpi_flags);
 		return;
 	}
@@ -3024,9 +3059,13 @@ void free_unref_folios(struct folio_batch *folios)
 			continue;
 		/*
 		 * Free orders not handled on the PCP directly to the
-		 * allocator.
+		 * allocator, as well as any pages containing unaccepted memory.
 		 */
-		if (!pcp_allowed_order(order)) {
+		if (!pcp_allowed_order(order) ||
+		    should_free_unaccepted(&folio->page, order, FPI_NONE)) {
+			if (handle_unaccepted_free(&folio->page, order,
+						   FPI_NONE))
+				continue;
 			free_one_page(folio_zone(folio), &folio->page,
 				      pfn, order, FPI_NONE);
 			continue;
@@ -3187,6 +3226,16 @@ void __putback_isolated_page(struct page *page, unsigned int order, int mt)
 	/* zone lock should be held when this function is called */
 	lockdep_assert_held(&zone->lock);
 
+	if (page_contains_unaccepted(page, order)) {
+		if (__free_unaccepted_locked(page, zone, order))
+			return;
+		accept_memory(page_to_phys(page), PAGE_SIZE << order);
+		free_pages_prepare_init(page, order);
+		split_large_buddy(zone, page, page_to_pfn(page), order,
+				  FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
+		return;
+	}
+
 	/* Return isolated page to tail of freelist. */
 	__free_one_page(page, page_to_pfn(page), zone, order, mt,
 			FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
@@ -7933,8 +7982,9 @@ static void __accept_page(struct zone *zone, unsigned long *flags,
 	spin_unlock_irqrestore(&zone->lock, *flags);
 
 	accept_memory(page_to_phys(page), PAGE_SIZE << order);
-
-	__free_pages_ok(page, order, FPI_TO_TAIL);
+	free_pages_prepare_init(page, order);
+	free_one_page(zone, page, page_to_pfn(page), order,
+		      FPI_TO_TAIL | FPI_SKIP_REPORT_NOTIFY);
 }
 
 void accept_page(struct page *page)
-- 
2.56.0.307.g5fe7bd680c-goog

