Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069817;
	b=RvG+VStoKVNJoNNTDDyJO/aRYru434bvP4ZLc0Bk9lhlvcB6fIbBrhnhWHhDYHp4lgbI
	 W5XCGPdk6Zth4QF3eu3FF5tw6S1pm0aXCnToF6j24JBFaT9GQAlIaX4aXP1Fk5+0ZXSPq
	 RiwverlEBwskUlIeoEAJ/kL0wV0RsvvkLErTzPQFxDzEaXyGC6Um0twIoGpztIrhAyjwv
	 qbF/RwYIia3WcsyBO7viwcoZa3+vA7X6tqBjXYHkxgjELT3ijOIiVLJe7TI2bJ8mytw/4
	 V1S3WBdHXbZ+MmiBEke8oBFXdWFr5I5bB2kvEMLB+UK9iHT5cg+bJ/E4S/GkCq4KqIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=eHj0mfeE/EOyly5xUtGq8rmazujhmFPCCIldDauievA=;
	b=P9osH4KwSLOjEjBsnm2/SEH6Ijm3Y9XIu61gpSar/7h4WfdBiVRX2LCjn5+uFoqSf58H
	 CxlPJ0NIJ4Jx1AWXn7IcuyExoqE3b+Nxpt2L6pxbg37Ppc/lzuaAnIRSwhbfiILMJOPtD
	 mkY2EqdLHRORjJNlsfnF+jw5CFQG+OZGsZj68Pg+IV2R2mZ20GP6R+EI+3CH/iUquQKiV
	 Bvk4iz/DE/mOD0TFpe/4M1qfVpUjMDTl0RhU5d5bZjJpDiXkYp2t2zlsf4AwNHH6+ZjK6
	 Rgu+HugivxU+vi1vqSXDnRtdgUkJUtEMU1LEcTwAwQOQV1UEDlGKKAeOejJgU8AKvaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="g/K+x0bZ";
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4EB606A329
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C4EB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=g/K+x0bZ
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-846863cd436so4166051a34.0
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069815; x=1793674615; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eHj0mfeE/EOyly5xUtGq8rmazujhmFPCCIldDauievA=;
        b=g/K+x0bZM683O0Tv6fRM79dQ4+7paH4oxE3s85zNeGMjEBlmQIt/VEFc9tICujAq6j
         QoMGGdQFcgSDYOlSH0KJ3cg2Wi9VMvATRN+TOhmn7NP15fBcjXeo5elFwUZmFeFn8BWB
         L3thRldvTwsyFvTTdEMCNRcl7JMRavr4Pjrm2/GKfeUBrB6cGl5KjJsG8DhmazHJCaBk
         e7V6mRgIz7Hao8xaSrDDeECKKdLMxczGAs0ERBSBMW2shL8fu5XSQUn72BSPQWB5tjto
         nEKxMAsFRbB80nJouCmaHHXRemR2UgcY4loi7cuIRugmxXEWJN2AhbHR2GHPVf2kSCAO
         allA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069815; x=1793674615;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eHj0mfeE/EOyly5xUtGq8rmazujhmFPCCIldDauievA=;
        b=vFQomQRHGkyvl9ZfwmHk7mhe9efVd6S57Q6F3PzH+gY9/hLPvjqK1Tga08busZZmie
         LbWPIKchkT/HiqAVeObeH7NYUt4qJVZu1gzpHSxAbC+ft9q0T3OOdjqNA0UXsutT+3x2
         aF8Mp7WAe1zUdSeDzaCszfbp9pMDgrwJwob0W3cdRa2iAZgs1lmFatREK0zrty6/aF0r
         8qvZNf4bm67eAPVEIkXXjST44Ghi0xozp0gC99rjFqKK/BEDEIckO7guCTFO/QsZzr/w
         HL8JVIoAPL1nF0o+9Zrsk6ru0qE+M/4CY/e3yo6P4Q/Ylu0QHgBXryIAtQb+ANX8hSK4
         0w/A==
X-Forwarded-Encrypted: i=1; AKwUvBxARRZ/uEcIxOWtNnyxWhL6LD97XG3TqRoGBWHnCgOkPI5fOjog4fHGQ23B5U/Q6OKDY5HJIx1Edag=@vger.kernel.org
X-Gm-Message-State: AFq9FYIx14PKVVvZSE22BV/b9pg9XuDPxvmO2kMAw/4wzaCMgjQQa6tv
	lkEh/4/d9TfKrNbuabpgRqOOrTSGlgHCq9GKntHoYqJJPkkmPZPX2KRj+i8H0RXHue1UkORP5JH
	rhn0J17ox3HsgXMe8Cvo/ZpX/Zw4xjEJxoA==
X-Received: from ioda11-n2.prod.google.com ([2002:a05:6602:204b:20b0:9c4:dfbe:8634])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:603:b0:70d:8086:e452 with SMTP id 006d021491bc7-70d8086eebemr3032864eaf.25.1793069815271;
 Mon, 26 Oct 2026 19:56:55 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:12 +0000
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
Message-ID: <20261027025616.1632690-10-kevinloughlin@google.com>
Subject: [PATCH 09/13] mm/page_reporting: account for unaccepted memory
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

When lazy unaccepted memory is active, pages on zone->unaccepted_pages
are counted in NR_FREE_PAGES (MIGRATE_MOVABLE) as well as NR_UNACCEPTED.
Without accounting for NR_UNACCEPTED in free page reporting watermarks,
page_reporting_process_zone() and __isolate_free_page() treat
unaccepted pages as already-accepted free buddy pages and can over-drain
accepted free lists.

Account for zone_page_state(zone, NR_UNACCEPTED) in
__isolate_free_page(), page_reporting_cycle(), and
page_reporting_process_zone() (using promo_wmark_pages(zone) for free
page reporting watermarks and skipping non-mergeable migratetypes when
has_unaccepted_memory() is active), and enforce
unaccepted_memory_order() as the minimum page_reporting_order.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 mm/page_alloc.c     |  3 +++
 mm/page_reporting.c | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c10b77304633..541b2eaf34a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3183,6 +3183,9 @@ int __isolate_free_page(struct page *page, unsigned int order)
 		 * exists.
 		 */
 		watermark = zone->_watermark[WMARK_MIN] + (1UL << order);
+#ifdef CONFIG_UNACCEPTED_MEMORY
+		watermark += zone_page_state(zone, NR_UNACCEPTED);
+#endif
 		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
 			return 0;
 	}
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index de587be17801..adacdb015b55 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -17,11 +17,14 @@ unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
+	unsigned int min_order = has_unaccepted_memory() ?
+				 unaccepted_memory_order() : 0;
+
 	/*
 	 * If param is set beyond this limit, order is set to default
 	 * pageblock_order value
 	 */
-	return  param_set_uint_minmax(val, kp, 0, MAX_PAGE_ORDER);
+	return param_set_uint_minmax(val, kp, min_order, MAX_PAGE_ORDER);
 }
 
 static const struct kernel_param_ops page_reporting_param_ops = {
@@ -206,6 +209,21 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 
 		/* Attempt to pull page from list and place in scatterlist */
 		if (*offset) {
+#ifdef CONFIG_UNACCEPTED_MEMORY
+			if (has_unaccepted_memory() ||
+			    !list_empty(&zone->unaccepted_pages)) {
+				unsigned long watermark;
+
+				watermark = promo_wmark_pages(zone) +
+					    zone_page_state(zone, NR_UNACCEPTED) +
+					    (1UL << order);
+				if (!zone_watermark_ok(zone, 0, watermark, 0,
+						       ALLOC_CMA)) {
+					next = page;
+					break;
+				}
+			}
+#endif
 			if (!__isolate_free_page(page, order)) {
 				next = page;
 				break;
@@ -275,6 +293,12 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 	/* Generate minimum watermark to be able to guarantee progress */
 	watermark = low_wmark_pages(zone) +
 		    (prdev->capacity << page_reporting_order);
+#ifdef CONFIG_UNACCEPTED_MEMORY
+	if (has_unaccepted_memory() || !list_empty(&zone->unaccepted_pages))
+		watermark = promo_wmark_pages(zone) +
+			    zone_page_state(zone, NR_UNACCEPTED) +
+			    (prdev->capacity << page_reporting_order);
+#endif
 
 	/*
 	 * Cancel request if insufficient free memory or if we failed
@@ -289,6 +313,11 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			/* We do not pull pages from the isolate free list */
 			if (is_migrate_isolate(mt))
 				continue;
+#ifdef CONFIG_UNACCEPTED_MEMORY
+			if (has_unaccepted_memory() &&
+			    !migratetype_is_mergeable(mt))
+				continue;
+#endif
 
 			err = page_reporting_cycle(prdev, zone, order, mt,
 						   sgl, &offset);
@@ -384,6 +413,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 		else
 			page_reporting_order = pageblock_order;
 	}
+	if (has_unaccepted_memory() &&
+	    page_reporting_order < unaccepted_memory_order())
+		page_reporting_order = unaccepted_memory_order();
 
 	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
 		prdev->capacity = PAGE_REPORTING_CAPACITY;
-- 
2.56.0.307.g5fe7bd680c-goog

