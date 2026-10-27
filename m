Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069818;
	b=Y8fCzt2cyNXpRQOZmwDyo95rrep4IZ1zvjBQ+c82qaVMfLqmBqcPAU4URbOVBK+SDbBm
	 QlkxvMIPYGOognlRphTPUIRbrmUaFjTdv/id0LrGSB1Lya9tSTgpDyU+lBJ7avlUT9DmB
	 I3OPhTOZbt8dDYRZk8BmyLjF502KHi35c0vqqpcUyRlKwnq5dvmJapbQ/d94NHfTTwkrH
	 0bsNMQrfzju3rpEH/K+72+pFEYfUga/9iRVrlAEjukFOnCvrq8E0VkdKvZikG+eHkyaCP
	 1pGLv3L1O+js4Pt4g3KS/khCnjT+mRsWBBs0wpFRyPpwsJ3x0q83cCc5eTLvVrD7BwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069818;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JIN7ZwAAf8V6R765/OvGx6wup+UwImZjXSx/G9RFR6U=;
	b=gY//tFXsGm9CeVCyMGT+aQKyG0MwWYcIyA/vyLcJvAesAA90d/MJvkweyGnaucml5JYB
	 cnGx9sUGF7tX2165yA4xkBU6TAT91Ll5B75st2x+SLWCOLFUXoq87HgAqTIUArfZm58Ef
	 t52yWr/RyYjyDeVYthg5y5+rKbbrHd7/1rl8bq8ibquqPnkPaounigN1yS1QKhU3bTvlP
	 ADECp8pxXMs5YkPRTjgp/XI706XrbSPxYs81gcVZadp2Kr4OZaPmNtMQmQTOq4T4OfJ+x
	 ZnNExHkIiI9vMPA+6wUHcMOVMP6ivV/1CPDbdCsZnKesWcFJHX6fO6yYTdjyH1V/ykQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=NedSquQH;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F6360A262D
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21F6360A262D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=NedSquQH
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-851f720d7afso1828087a34.3
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069812; x=1793674612; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JIN7ZwAAf8V6R765/OvGx6wup+UwImZjXSx/G9RFR6U=;
        b=NedSquQHdQxeThU0lR6Xpy1FUoVE2CtdTmo8tnCqNqgaYvsHbP35ObYbzZnArrvZqx
         eqcKNhdzpHIGoqykW7BVaWsVOlkm9vDG2KfRpoCxvQfSAME79h0d7zviFVsJBRoGuLWz
         MWLpNTnw6hLBPe2vde5p8plsQmEXmB2ytm3LCXoZFUmXvcQ0qBfANR9TOBdHJohx6hVU
         ahh0cKgfoMxaymVKkwTjqrktrw8T6z1LcTrXR4ZEbL0pfqp6YQ4WampZauCwG5gWhc+7
         DsfhPb7DT050UCam7dJX9HcydaRDUHWtvWH5LBEooZ8hxMIuxwmVPnTPd1onmMSuWcv1
         Kp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069812; x=1793674612;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JIN7ZwAAf8V6R765/OvGx6wup+UwImZjXSx/G9RFR6U=;
        b=qiChO5yi2JmR24AI4UP5nM9sB3LBh8P5sDo/SX+8KE56UZSOWfORo/0RQpU2WFP7LP
         GLeoM7MBf8/7mgDV1HRacq6eJLpwYy2UcJ5dKMkDFDv0iR/KpeXVZunNkP2i+zMltRKV
         ps08B3Q8z+VGjuCqqKaIcz73isJG8x01toHJE95t+H9QWHcKHGd/XVWphIi0W5vNWejV
         4Vhn/XbLM38wSrXaI/HMVLn6fC73TVH2gWl+NzJm5dBR+qft+VkFet92e3og2UvoQnpG
         T4+SA7DcpHX+lCP1dVlGl7DUzfgvH5iXDvj2YTpOBSRy1jShjWN2gLHjgq8vA/XF2iJQ
         PzTA==
X-Forwarded-Encrypted: i=1; AKwUvBxW8Z/z5/GvGh4fZoBXCnIqShB1RidE2KCc2PfFYU+XFy8QV4SZUY87MO1H4pk7/w1bbxPuahP+v/w=@vger.kernel.org
X-Gm-Message-State: AFq9FYKiH8/3RO/Oxh+EK6USnRS+a85cBdXSDJn7wXpXibdIJeuiYMye
	+bSS0cMew7tjJhPqpcHcHcXHSoYEyhEZMlZ/w6hgjIUIVAv1eOGHLmQY2LqRa1CECpgYdDQl6y4
	UuBZlwPgrn+j8Gv5vscNrTLiNQPZ+GtUiCA==
X-Received: from ioaa4.prod.google.com ([2002:a05:6602:2084:b0:9c7:6772:c251])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1391:b0:6dd:25a3:94dd with SMTP id 006d021491bc7-70ba0e5707fmr4813315eaf.41.1793069811694;
 Mon, 26 Oct 2026 19:56:51 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:10 +0000
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
Message-ID: <20261027025616.1632690-8-kevinloughlin@google.com>
Subject: [PATCH 07/13] mm/page_alloc: allow lower-order unaccepted_pages
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

Currently, zone->unaccepted_pages assumes all unaccepted blocks are
MAX_PAGE_ORDER. However, dynamic memory unacceptance operates at
unaccepted_memory_order() granularity (typically 2 MiB / PMD_ORDER on
x86).

Introduce has_unaccepted_memory() to report whether lazy unaccepted
memory and dynamic unacceptance are active (returning false when booted
with accept_memory=eager), and generalize zone->unaccepted_pages from
MAX_PAGE_ORDER to orders >= unaccepted_memory_order() stored in
page_private(page):
- Update __free_unaccepted_locked() to verify that pageblocks are
  mergeable (moving blocks >= pageblock_order to MIGRATE_MOVABLE) and
  record the block order in page_private(page).
- Update __accept_page(), try_to_accept_memory_one(), and
  cond_accept_memory() to accept blocks of order page_private(page),
  and ensure cond_accept_memory() accepts at least (1 << order) pages
  when high-order watermark or rmqueue checks fail.
- Update prep_move_freepages_block(), set_migratetype_isolate(),
  isolate_single_pageblock(), and skip_buddy_pages() to handle
  variable-order PageUnaccepted blocks.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 Documentation/mm/physical_memory.rst     |   3 +-
 drivers/firmware/efi/unaccepted_memory.c |   2 +-
 include/linux/mm.h                       |   6 ++
 include/linux/mmzone.h                   |   2 +-
 mm/page_alloc.c                          | 127 ++++++++++++++++++-----
 mm/page_isolation.c                      |  44 +++++++-
 mm/page_owner.c                          |   7 +-
 7 files changed, 155 insertions(+), 36 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 2e67e8b23a99..e9fb554932d5 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -526,7 +526,8 @@ General
   ``zone_init_free_lists()``.
 
 ``unaccepted_pages``
-  The list of pages to be accepted. All pages on the list are ``MAX_PAGE_ORDER``.
+  The list of pages to be accepted. All pages on the list are at least
+  ``unaccepted_memory_order()`` and record their order in ``page_private()``.
   Defined only when ``CONFIG_UNACCEPTED_MEMORY`` is enabled.
 
 ``flags``
diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 128bc1b113cd..769faf430690 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -246,7 +246,7 @@ int mark_memory_unaccepted(phys_addr_t start, unsigned long size)
 	unsigned long flags;
 	u64 unit_size;
 
-	if (!arch_has_unaccept_memory())
+	if (!has_unaccepted_memory())
 		return -EOPNOTSUPP;
 
 	unaccepted = efi_get_unaccepted_table();
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27bb40651c85..619c71565dd6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5362,6 +5362,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+bool has_unaccepted_memory(void);
 unsigned int unaccepted_memory_order(void);
 int mark_memory_unaccepted(phys_addr_t start, unsigned long size);
 
@@ -5377,6 +5378,11 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline bool has_unaccepted_memory(void)
+{
+	return false;
+}
+
 static inline unsigned int unaccepted_memory_order(void)
 {
 	return 0;
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d44b04589f48..ae4657dbb5a8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1112,7 +1112,7 @@ struct zone {
 	struct free_area	free_area[NR_PAGE_ORDERS];
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
-	/* Pages to be accepted. All pages on the list are MAX_PAGE_ORDER */
+	/* Pages to be accepted. All pages are >= unaccepted_memory_order() */
 	struct list_head	unaccepted_pages;
 
 	/* To be called once the last page in the zone is accepted */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3322f9e75616..46ae8c6f3814 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -300,8 +300,10 @@ static unsigned long alloc_stall_warn_jiffies = INITIAL_JIFFIES;
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
-			       int alloc_flags);
-static bool __free_unaccepted(struct page *page);
+			       int alloc_flags, bool force);
+static bool __free_unaccepted(struct page *page, unsigned int order);
+static bool __free_unaccepted_locked(struct page *page, struct zone *zone,
+				     unsigned int order);
 
 int page_group_by_mobility_disabled __read_mostly;
 
@@ -1614,8 +1616,10 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
-	if (page_contains_unaccepted(page, order)) {
-		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
+	if (range_contains_unaccepted_memory(page_to_phys(page),
+					     PAGE_SIZE << order)) {
+		if (order >= unaccepted_memory_order() &&
+		    __free_unaccepted(page, order))
 			return;
 
 		accept_memory(page_to_phys(page), PAGE_SIZE << order);
@@ -2003,6 +2007,13 @@ static bool prep_move_freepages_block(struct zone *zone, struct page *page,
 				pfn += nr;
 				continue;
 			}
+			if (PageUnaccepted(page)) {
+				int nr = 1 << page_private(page);
+
+				*num_free += nr;
+				pfn += nr;
+				continue;
+			}
 			/*
 			 * We assume that pages that could be isolated for
 			 * migration are movable. But we don't actually try
@@ -3872,7 +3883,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			continue;
 		}
 
-		cond_accept_memory(zone, order, alloc_flags);
+		cond_accept_memory(zone, order, alloc_flags, false);
 
 		/*
 		 * Detect whether the number of free pages is below high
@@ -3897,7 +3908,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			if (cond_accept_memory(zone, order, alloc_flags))
+			if (cond_accept_memory(zone, order, alloc_flags, true))
 				goto try_this_zone;
 
 			/*
@@ -3934,7 +3945,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 			return page;
 		} else {
-			if (cond_accept_memory(zone, order, alloc_flags))
+			if (cond_accept_memory(zone, order, alloc_flags, true))
 				goto try_this_zone;
 
 			/* Try again if zone has deferred pages */
@@ -5216,7 +5227,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0, alloc_flags);
+		cond_accept_memory(zone, 0, alloc_flags, false);
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
@@ -5225,7 +5236,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0, alloc_flags))
+		if (cond_accept_memory(zone, 0, alloc_flags, true))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -7867,6 +7878,7 @@ bool has_managed_zone(enum zone_type zone)
 }
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
+#include <asm/unaccepted_memory.h>
 
 static bool lazy_accept = true;
 
@@ -7884,25 +7896,45 @@ static int __init accept_memory_parse(char *p)
 }
 early_param("accept_memory", accept_memory_parse);
 
+bool has_unaccepted_memory(void)
+{
+	return lazy_accept && efi_get_unaccepted_table() &&
+	       arch_has_unaccept_memory() &&
+	       unaccepted_memory_order() <= MAX_PAGE_ORDER;
+}
+EXPORT_SYMBOL_GPL(has_unaccepted_memory);
+
 static bool page_contains_unaccepted(struct page *page, unsigned int order)
 {
 	phys_addr_t start = page_to_phys(page);
 
+	/*
+	 * Unaccepted memory is tracked and freed in blocks of at least
+	 * unaccepted_memory_order(). Skipping lower-order frees avoids
+	 * acquiring unaccepted_memory_lock on normal page frees.
+	 */
+	if (!has_unaccepted_memory() || order < unaccepted_memory_order())
+		return false;
+
 	return range_contains_unaccepted_memory(start, PAGE_SIZE << order);
 }
 
 static void __accept_page(struct zone *zone, unsigned long *flags,
 			  struct page *page)
 {
+	unsigned int order = page_private(page);
+	unsigned int nr_pages = 1 << order;
+
 	list_del(&page->lru);
-	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
-	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
+	account_freepages(zone, -nr_pages, MIGRATE_MOVABLE);
+	__mod_zone_page_state(zone, NR_UNACCEPTED, -nr_pages);
 	__ClearPageUnaccepted(page);
+	set_page_private(page, 0);
 	spin_unlock_irqrestore(&zone->lock, *flags);
 
-	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
+	accept_memory(page_to_phys(page), PAGE_SIZE << order);
 
-	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
+	__free_pages_ok(page, order, FPI_TO_TAIL);
 }
 
 void accept_page(struct page *page)
@@ -7920,27 +7952,29 @@ void accept_page(struct page *page)
 	__accept_page(zone, &flags, page);
 }
 
-static bool try_to_accept_memory_one(struct zone *zone)
+static unsigned int try_to_accept_memory_one(struct zone *zone)
 {
 	unsigned long flags;
 	struct page *page;
+	unsigned int nr_pages;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	page = list_first_entry_or_null(&zone->unaccepted_pages,
 					struct page, lru);
 	if (!page) {
 		spin_unlock_irqrestore(&zone->lock, flags);
-		return false;
+		return 0;
 	}
 
+	nr_pages = 1 << page_private(page);
 	/* Unlocks zone->lock */
 	__accept_page(zone, &flags, page);
 
-	return true;
+	return nr_pages;
 }
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
-			       int alloc_flags)
+			       int alloc_flags, bool force)
 {
 	long to_accept, wmark;
 	bool ret = false;
@@ -7957,7 +7991,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 	/*
 	 * Watermarks have not been initialized yet.
 	 *
-	 * Accepting one MAX_PAGE_ORDER page to ensure progress.
+	 * Accepting one block to ensure progress.
 	 */
 	if (!wmark)
 		return try_to_accept_memory_one(zone);
@@ -7968,32 +8002,62 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));
 
+	if (force && to_accept < (1L << order))
+		to_accept = 1L << order;
+
 	while (to_accept > 0) {
-		if (!try_to_accept_memory_one(zone))
+		unsigned int accepted = try_to_accept_memory_one(zone);
+
+		if (!accepted)
 			break;
 		ret = true;
-		to_accept -= MAX_ORDER_NR_PAGES;
+		to_accept -= accepted;
 	}
 
 	return ret;
 }
 
-static bool __free_unaccepted(struct page *page)
+static bool __free_unaccepted_locked(struct page *page, struct zone *zone,
+				     unsigned int order)
+{
+	unsigned int nr_pages = 1 << order;
+	unsigned int step = max_t(unsigned int, 1, pageblock_nr_pages);
+	unsigned int i;
+
+	lockdep_assert_held(&zone->lock);
+
+	for (i = 0; i < nr_pages; i += step) {
+		int mt = get_pageblock_migratetype(page + i);
+
+		if (!migratetype_is_mergeable(mt))
+			return false;
+	}
+
+	if (order >= pageblock_order)
+		change_pageblock_range(page, order, MIGRATE_MOVABLE);
+
+	set_page_private(page, order);
+	list_add_tail(&page->lru, &zone->unaccepted_pages);
+	account_freepages(zone, nr_pages, MIGRATE_MOVABLE);
+	__mod_zone_page_state(zone, NR_UNACCEPTED, nr_pages);
+	__SetPageUnaccepted(page);
+	return true;
+}
+
+static bool __free_unaccepted(struct page *page, unsigned int order)
 {
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
+	bool ret;
 
 	if (!lazy_accept)
 		return false;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	list_add_tail(&page->lru, &zone->unaccepted_pages);
-	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
-	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
-	__SetPageUnaccepted(page);
+	ret = __free_unaccepted_locked(page, zone, order);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return true;
+	return ret;
 }
 
 #else
@@ -8004,12 +8068,19 @@ static bool page_contains_unaccepted(struct page *page, unsigned int order)
 }
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
-			       int alloc_flags)
+			       int alloc_flags, bool force)
 {
 	return false;
 }
 
-static bool __free_unaccepted(struct page *page)
+static bool __free_unaccepted_locked(struct page *page, struct zone *zone,
+				     unsigned int order)
+{
+	BUILD_BUG();
+	return false;
+}
+
+static bool __free_unaccepted(struct page *page, unsigned int order)
 {
 	BUILD_BUG();
 	return false;
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5aaad037384e..c85ce158a646 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -165,6 +165,36 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
 	return NULL;
 }
 
+static struct page *find_unaccepted_page_in_pageblock(struct zone *zone,
+						      struct page *page)
+{
+#ifdef CONFIG_UNACCEPTED_MEMORY
+	unsigned long pb_start = pageblock_start_pfn(page_to_pfn(page));
+	unsigned long pb_end = pageblock_end_pfn(page_to_pfn(page));
+	unsigned long start_pfn, pfn, step;
+
+	lockdep_assert_held(&zone->lock);
+
+	if (list_empty(&zone->unaccepted_pages) ||
+	    unaccepted_memory_order() > MAX_PAGE_ORDER)
+		return NULL;
+
+	start_pfn = ALIGN_DOWN(pb_start, MAX_ORDER_NR_PAGES);
+	step = 1UL << unaccepted_memory_order();
+
+	for (pfn = start_pfn; pfn < pb_end; pfn += step) {
+		struct page *cand = pfn_to_online_page(pfn);
+
+		if (!cand || page_zone(cand) != zone || !PageUnaccepted(cand))
+			continue;
+
+		if (pfn + (1UL << page_private(cand)) > pb_start)
+			return cand;
+	}
+#endif
+	return NULL;
+}
+
 /*
  * This function set pageblock migratetype to isolate if no unmovable page is
  * present in [start_pfn, end_pfn). The pageblock must intersect with
@@ -175,10 +205,14 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
+	struct page *unaccepted = NULL;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
-	if (PageUnaccepted(page))
-		accept_page(page);
+retry:
+	if (unaccepted) {
+		accept_page(unaccepted);
+		unaccepted = NULL;
+	}
 
 	scoped_guard(spinlock_irqsave, &zone->lock) {
 		/*
@@ -189,6 +223,10 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 		if (is_migrate_isolate_page(page))
 			return -EBUSY;
 
+		unaccepted = find_unaccepted_page_in_pageblock(zone, page);
+		if (unaccepted)
+			goto retry;
+
 		/*
 		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
 		 * itself. We just check MOVABLE pages.
@@ -383,7 +421,7 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		pfn = page_to_pfn(page);
 
 		if (PageUnaccepted(page)) {
-			pfn += MAX_ORDER_NR_PAGES;
+			accept_page(page);
 			continue;
 		}
 
diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d765..e3f3a019b0bc 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -459,10 +459,13 @@ static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
 {
 	unsigned long order;
 
-	if (!PageBuddy(page))
+	if (PageBuddy(page))
+		order = buddy_order_unsafe(page);
+	else if (PageUnaccepted(page))
+		order = READ_ONCE(page->private);
+	else
 		return false;
 
-	order = buddy_order_unsafe(page);
 	if (order <= MAX_PAGE_ORDER) {
 		unsigned long new_pfn = *pfn + (1UL << order);
 		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
-- 
2.56.0.307.g5fe7bd680c-goog

