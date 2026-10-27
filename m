Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069819;
	b=nIs1ErY145qYoS3cAJ/Go+U/XvMi0vnXNNm8zLlalmcNcyBjBNYFmaRfu44ZdiHCu4GT
	 9HiSgm+2NOJYerekxg3R2RnstZU9Ix//VXfzJ95SzjGFP7BzCjUP62ARdROGhD6gKcA9U
	 yg+1iMVGwES7iT+gs4GFljFLFlPVzSS8pjynV4fynk6FQlF+9NyM31Rc96LcbaAAtXZaV
	 f6Tf2BsaLZe9/or17ti1UQU69er2qa3yDCINNE1JamdX7aIh4Aa+6S5RxlnutNJ5N0ZDI
	 QyTswX+saxGEbDpfnjl+3Qbx2cRz2eI0OrACDOCJkz/TcedksWJUdROTmCfxm4dtmGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069819;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=8uOyeoIi9QhKAYiQPs1BFfiuxWbIrsz7kuwNrIhzcWE=;
	b=OH7I0LnVCR5kB4/oE7gciA2Z3rcMzCTC0BOak5F1jLFugUOqj/hUaR0/4TT3SKafCqu5
	 Fjw3K2aH9sDqw/xmJ6Ay0VW4wgxTBCyWhg2YjliSgBfm/IROYO0mGIvJ77aAPJpV5bHJO
	 ylkmIuTSC1JTXgg7NpKCPwJpSCZf0bLcAp3CV/xDmBNcYFf32EDUII5oNMLsOP0mMH5jQ
	 nnWTO7NawlyTGuG/R5Nj19T6oyH65RkzAB3L97hT4LTUoN9TbtwzISJ95r7OZvF1XjDy5
	 2J/O8yzCDLuJKYN2HBaTW7WvO/K7lNz+n5vPG2Bt/6vVzkceABP0n2a0INQ+Kffl5zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=r2vB0Mmx;
	arc=none smtp.remote-ip=209.85.161.72
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47360A2629
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F47360A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=r2vB0Mmx
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-704a881f959so4365543eaf.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069817; x=1793674617; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8uOyeoIi9QhKAYiQPs1BFfiuxWbIrsz7kuwNrIhzcWE=;
        b=r2vB0MmxU/Ij++0G9lA64N1gc+nqsa9HjZfkmsUPujgb3r5vPDjkLAaaK9+6qN98so
         7H92t8hB4/3aXX0gV1WUf30T/ql/iRelh77iRQWlwQMW31UnkVCA9xRSUzb9gSz93suH
         cJcJDL810SOUxFXL0Iv2zcPBDU1SnKOGR0WPuTPlHoWzXvVFr0z/LOSliXEHG2KeqLwo
         JkktaDzk/lvt07EoPpFA7S7GkGoz2Bc+8Tuxxowcm4+2L+ubMIc4w/455eNFuJHl9FBq
         BDG3wyAgcyllmmZm2bb5UXRAEO26veuJjwT2yhqwZYnWKE9ZQl0Q+nFbeP8VD6E2ARzt
         x3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069817; x=1793674617;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uOyeoIi9QhKAYiQPs1BFfiuxWbIrsz7kuwNrIhzcWE=;
        b=qchxF5YjLHWo+43HtIs/iF80apUnLmegGjA3IZwCx08UJH/vwtULA0iUP1kv5IUr2k
         aA5QFm4qlSRxzsZOml4IW9hsBV+nIZac3tF3fWh9akvRlWLf9J/egNwzm9/5SuEVEDC4
         RmLY5BtUHr2/UyZzqjn2M/5g+nnl4Z3I1cLSRVKSAtYhBgUBksoGWcibgD+l+wKB1RuW
         A5H69fURszyJEL9TXzKR7AwWDXdGa1zdeOwd/O8crkNqUxBgUhFiL8yfvf/AlRTS/kxY
         d2SbHdBIcI1nhvTLWm6HgTJ1l90BR+hcIOosIxwx+6t07EY89sfe1jol6njws9hSjcZR
         3fuA==
X-Forwarded-Encrypted: i=1; AKwUvByuIw0sxPqssE4kzrcJEmYMyo5LfOe9KLI7M7wGqHhEsSyp2DufRAJcbcHhNb9i8M23ddrkNLE+tMQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYI+/d6WbXXcXznEKC+0lTrhCnU8e48Y07Hp1MkXzFHnFAXriOL1
	GB4X5uvgrNdeEW6ZqUWJQbRvxAd8Kj4wSsCzE48G9BXZTcq05Q78oVzTv64z10Q5AiiKeh5KorY
	/yYOi98LrS0mXcxDbdmWu0Yvi7fd2hzD+vA==
X-Received: from iowl9.prod.google.com ([2002:a05:6602:2dc9:b0:9c7:5a74:531d])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:7094:20b0:6d7:aca3:bba9 with SMTP id 006d021491bc7-70ba0e5ee88mr3818249eaf.38.1793069816905;
 Mon, 26 Oct 2026 19:56:56 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:13 +0000
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
Message-ID: <20261027025616.1632690-11-kevinloughlin@google.com>
Subject: [PATCH 10/13] virtio_balloon: add higher-order page inflation
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

In confidential computing guests requiring page state transitions,
unaccepted memory tracking operates at the EFI unaccepted memory unit
granularity (typically 2MB / order 9 on x86). Inflating the balloon
with 4KB pages would prevent unaccepting the backing 2MB unit.

Inflate balloon pages at unaccepted_memory_order() when
virtballoon_cc_needs_state_transition() is true, while retaining
order-0 allocations for non-CoCo guests and CoCo guests that do not
use unaccepted memory transitions. When a higher-order balloon page
spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 87 ++++++++++++++++++++++++++-------
 include/linux/balloon.h         |  1 +
 mm/balloon.c                    | 67 +++++++++++++++++++------
 3 files changed, 121 insertions(+), 34 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 11f74848fdc4..d162c162b496 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -182,6 +182,13 @@ static void balloon_ack(struct virtqueue *vq)
 	wake_up(&vb->acked);
 }
 
+static inline bool virtballoon_cc_needs_state_transition(void)
+{
+	return IS_ENABLED(CONFIG_UNACCEPTED_MEMORY) &&
+	       cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
+	       has_unaccepted_memory();
+}
+
 static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
@@ -243,24 +250,49 @@ static void set_page_pfns(struct virtio_balloon *vb,
 					  page_to_balloon_pfn(page) + i);
 }
 
+static void queue_page_pfns(struct virtio_balloon *vb, struct virtqueue *vq,
+			    struct page *page, unsigned int order)
+{
+	unsigned int nr_pages = 1 << order;
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		set_page_pfns(vb, vb->pfns + vb->num_pfns, page + i);
+		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
+		if (vb->num_pfns == ARRAY_SIZE(vb->pfns)) {
+			tell_host(vb, vq);
+			vb->num_pfns = 0;
+		}
+	}
+}
+
+static inline unsigned int virtballoon_preferred_order(void)
+{
+	if (virtballoon_cc_needs_state_transition())
+		return unaccepted_memory_order();
+	return 0;
+}
+
 static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 {
-	unsigned int num_allocated_pages;
+	unsigned int order = virtballoon_preferred_order();
+	unsigned int page_pfns = (1 << order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+	unsigned int num_allocated_pages = 0;
 	struct page *page, *next;
 	unsigned int num_pfns;
 	LIST_HEAD(pages);
 
-	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	/* We can only do one array or preferred-order page worth at a time. */
+	num = min(num, max_t(size_t, ARRAY_SIZE(vb->pfns), page_pfns));
 
 	for (num_pfns = 0; num_pfns < num;
-	     num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
-		page = balloon_page_alloc();
+	     num_pfns += page_pfns) {
+		page = balloon_pages_alloc(order);
 
 		if (!page) {
 			dev_info_ratelimited(&vb->vdev->dev,
 					     "Out of puff! Can't get %u pages\n",
-					     VIRTIO_BALLOON_PAGES_PER_PAGE);
+					     page_pfns);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
 			break;
@@ -274,15 +306,17 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 	vb->num_pfns = 0;
 
 	list_for_each_entry_safe(page, next, &pages, lru) {
+		unsigned int page_order = compound_order(page);
+		unsigned int pfns = (1 << page_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+
 		list_del(&page->lru);
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
-		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
-		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
-		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
+		vb->num_pages += pfns;
+		num_allocated_pages += pfns;
+		queue_page_pfns(vb, vb->inflate_vq, page, page_order);
 	}
 
-	num_allocated_pages = vb->num_pfns;
 	/* Did we get any? */
 	if (vb->num_pfns != 0)
 		tell_host(vb, vb->inflate_vq);
@@ -304,28 +338,42 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
 static unsigned int leak_balloon(struct virtio_balloon *vb, size_t num)
 {
-	unsigned int num_freed_pages;
+	unsigned int order = virtballoon_preferred_order();
+	unsigned int page_pfns = (1 << order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+	unsigned int num_freed_pages = 0;
 	struct page *page;
 	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
 	LIST_HEAD(pages);
 
-	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	/* We can only do one array or preferred-order page worth at a time. */
+	num = min(num, max_t(size_t, ARRAY_SIZE(vb->pfns), page_pfns));
 
 	mutex_lock(&vb->balloon_lock);
 	/* We can't release more pages than taken */
 	num = min(num, (size_t)vb->num_pages);
-	for (vb->num_pfns = 0; vb->num_pfns < num;
-	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
+	vb->num_pfns = 0;
+	while (num_freed_pages < num) {
+		unsigned int dequeued_order;
+		unsigned int dequeued_pfns;
+
 		page = balloon_page_dequeue(vb_dev_info);
 		if (!page)
 			break;
-		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
+		dequeued_order = compound_order(page);
+		dequeued_pfns = (1 << dequeued_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+
+		if (num_freed_pages + dequeued_pfns > num &&
+		    num_freed_pages > 0) {
+			balloon_page_enqueue(vb_dev_info, page);
+			break;
+		}
+
+		queue_page_pfns(vb, vb->deflate_vq, page, dequeued_order);
 		list_add(&page->lru, &pages);
-		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
+		vb->num_pages -= dequeued_pfns;
+		num_freed_pages += dequeued_pfns;
 	}
 
-	num_freed_pages = vb->num_pfns;
 	/*
 	 * Note that if
 	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
@@ -474,7 +522,8 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 	 * Aligned up to guest page size to avoid inflating and deflating
 	 * balloon endlessly.
 	 */
-	target = ALIGN(num_pages, VIRTIO_BALLOON_PAGES_PER_PAGE);
+	target = ALIGN((s64)num_pages,
+		       VIRTIO_BALLOON_PAGES_PER_PAGE << virtballoon_preferred_order());
 	return target - vb->num_pages;
 }
 
diff --git a/include/linux/balloon.h b/include/linux/balloon.h
index ca5b15150f42..bc46e36b997f 100644
--- a/include/linux/balloon.h
+++ b/include/linux/balloon.h
@@ -58,6 +58,7 @@ struct balloon_dev_info {
 	bool adjust_managed_page_count;
 };
 
+struct page *balloon_pages_alloc(unsigned int order);
 struct page *balloon_page_alloc(void);
 void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 		struct page *page);
diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..e9941d08d8e9 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -27,9 +27,12 @@ static DEFINE_SPINLOCK(balloon_pages_lock);
 static void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	unsigned int i, nr_pages = 1U << compound_order(page);
+
 	lockdep_assert_held(&balloon_pages_lock);
-	__SetPageOffline(page);
-	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION)) {
+	for (i = 0; i < nr_pages; i++)
+		__SetPageOffline(page + i);
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !PageCompound(page)) {
 		SetPageMovableOps(page);
 		set_page_private(page, (unsigned long)balloon);
 	}
@@ -45,20 +48,31 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
  */
 static void balloon_page_finalize(struct page *page)
 {
+	unsigned int i, nr_pages = 1U << compound_order(page);
+
 	lockdep_assert_held(&balloon_pages_lock);
-	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !PageCompound(page))
 		set_page_private(page, 0);
-	/* PageOffline is sticky until the page is freed to the buddy. */
+	/*
+	 * PageOffline is sticky on the head page until freed to the buddy,
+	 * which resets the head page's page_type in __free_pages_prepare().
+	 * Clear PageOffline on tail pages here as __free_pages_prepare()
+	 * expects tail pages to have a default page_type.
+	 */
+	for (i = 1; i < nr_pages; i++)
+		__ClearPageOffline(page + i);
 }
 
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
+	unsigned int order = compound_order(page);
+
 	balloon_page_insert(b_dev_info, page);
 	if (b_dev_info->adjust_managed_page_count)
-		adjust_managed_page_count(page, -1);
-	__count_vm_event(BALLOON_INFLATE);
-	inc_node_page_state(page, NR_BALLOON_PAGES);
+		adjust_managed_page_count(page, -(1L << order));
+	__count_vm_events(BALLOON_INFLATE, 1UL << order);
+	mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES, 1L << order);
 }
 
 /**
@@ -117,15 +131,18 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 
 	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
+		unsigned int order = compound_order(page);
+
 		if (n_pages == n_req_pages)
 			break;
 		list_del(&page->lru);
 		if (b_dev_info->adjust_managed_page_count)
-			adjust_managed_page_count(page, 1);
+			adjust_managed_page_count(page, 1L << order);
 		balloon_page_finalize(page);
-		__count_vm_event(BALLOON_DEFLATE);
+		__count_vm_events(BALLOON_DEFLATE, 1UL << order);
 		list_add(&page->lru, pages);
-		dec_node_page_state(page, NR_BALLOON_PAGES);
+		mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
+				    -(1L << order));
 		n_pages++;
 	}
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
@@ -135,8 +152,9 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
 
 /**
- * balloon_page_alloc - allocates a new page for insertion into the balloon
- *			page list.
+ * balloon_pages_alloc - allocates a new page of given order for insertion
+ *			 into the balloon page list.
+ * @order: allocation order
  *
  * Driver must call this function to properly allocate a new balloon page.
  * Driver must call balloon_page_enqueue before definitively removing the page
@@ -144,16 +162,35 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
  *
  * Return: struct page for the allocated page or NULL on allocation failure.
  */
-struct page *balloon_page_alloc(void)
+struct page *balloon_pages_alloc(unsigned int order)
 {
 	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 
-	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !order)
 		gfp_flags |= GFP_HIGHUSER_MOVABLE;
 	else
 		gfp_flags |= GFP_HIGHUSER;
 
-	return alloc_page(gfp_flags);
+	if (order > 0)
+		gfp_flags |= __GFP_COMP;
+
+	return alloc_pages(gfp_flags, order);
+}
+EXPORT_SYMBOL_GPL(balloon_pages_alloc);
+
+/**
+ * balloon_page_alloc - allocates a new page for insertion into the balloon
+ *			page list.
+ *
+ * Driver must call this function to properly allocate a new balloon page.
+ * Driver must call balloon_page_enqueue before definitively removing the page
+ * from the guest system.
+ *
+ * Return: struct page for the allocated page or NULL on allocation failure.
+ */
+struct page *balloon_page_alloc(void)
+{
+	return balloon_pages_alloc(0);
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-- 
2.56.0.307.g5fe7bd680c-goog

