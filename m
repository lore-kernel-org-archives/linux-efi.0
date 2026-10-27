Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069805;
	b=A6xwUTjdngBlkdFJGRPN1TdDPuuzKi74IopudwJkJA/xH7ggLZ4bIw5Q+2NpEAEx1Kjg
	 VQwE6A9tHm/APZm6ahnJGjekffpASf5IIzOoPHxslVXYp6onlfcHgOE4sDgYxBcI5otfa
	 kFN6TFX+x3AXWpKpNqcmlV2DkpO75/6JItm0FundiBLCuhcP/2fCUaIPU2mt6Fma/Gf6x
	 ATixcjWJfAr7C3DLUPHl75kZUmhPfKhjhKG0QN6c8wEkUvRUEyRHXvXcY40sbm4uXvFrx
	 d8r0YXMXPzkF++TltpSsA25Fi5AHFRSNRTuW3f18puWV0s7M9gQbM69cDLfJuxRtFjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=0uzqgwftXz/DV+yjf2QpwILGgyMTBZAoH8uvJ/r3lMk=;
	b=AWFOYe3VkxFD7YJ0xBAaESObHxywLakjc7gu4ADgfrhfg4k1uvR/SZySA8ywbcX/e0WO
	 lY35W0nfy5/6zLSMe+hJb5SOYX6Eqoz25o2N9vuAeemEv5gwGMqJBTD1PzfCvj4bGghhO
	 9HRmu0zrRqyycIS/7emf+Xl/4V+wLUViFlLNmtaX8Q47kJOaftzEGxG3Oz6ckWHBDfeJC
	 ASv26is3eJHVBez5vPypaF1VW1T6arsnbCyw51BrSnakrlfEy96gyLZY4nNJ0AgS875+8
	 pR0YqxPmTnpaVNqlSsSrSjy93AhtsBlarEZ0FJvcQys4YvAqBOJDoFE8ziZtedeWmlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=jHa9QGYh;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1D5606A31F
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D1D5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=jHa9QGYh
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c734afb8deso5325375b6e.1
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069803; x=1793674603; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0uzqgwftXz/DV+yjf2QpwILGgyMTBZAoH8uvJ/r3lMk=;
        b=jHa9QGYh9X3IBMWXkVkIZOr+NsAFmipaU5nggTwDXLj19FELj902baUVTGkipnWe3Z
         E4YZQ8TxciuXuQz58f+GelwdXWhuaE1csqWkcUYit0yhtY3cs13AAznyIIJwRng05sIA
         dDLIKjP1s3OIxvq1+pkTXmok3LQQ3CsC2+i+riY33euyquXpE5vQOAcNeLQqZAvA4NrE
         dxZ5zftFUUltE6+LpVpQckECMQvhny7+11Us+5m4MzTr90U15pxueHcoQunGP9fGIR9C
         PfhgiYxrTvcpf6LtkGUVz8yVM4+dxa3yBWz5k6iPbmkgkYQW0oetuRTN1CWQtvxBh1Ep
         8YLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069803; x=1793674603;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0uzqgwftXz/DV+yjf2QpwILGgyMTBZAoH8uvJ/r3lMk=;
        b=avtBDOkLHC+cJDqxnlL6lDty2yFO8vuJnlymGv7dDLHJqcGYnc9tXmt7zssvBRd5i9
         s6qaw6QzC54P6s/v+u1OXmpK8PnoOaq01Hg2+iBmIMXJxlitnZpnxC2g5g9UL9Uj3ik4
         2lMEmLGm9dHqWGZYaWglcdrdHc8/VzUNlbI/EvHMSBqRxuntRBdZMCZpXnCSFzw8zdSe
         Dr71U2LMcwhDXUXZZP4KIkYMRTQiBZhSgSDhN9y2z91YB0Hw4wyAAweWSRytPWdibWzs
         04YP4HnU/99Uruls+JuecpibW+2DgaZImXaOQZVqBdAYIe41sUnr7KA2hFIC9d0xgAae
         5WcA==
X-Forwarded-Encrypted: i=1; AKwUvBxPlqKoNCgeRqYHUqfB2gkNsRcdpvWSZ2dIHq8XR/PNWngT/hNTucpc/04uGjqcpG5euZnzHxNMLnM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIDpGvXf/p8nTQpdo5QxBsLwG2MT0WrPjkOXdMDfBWfgpwY+/oE
	jSMVlpFmslksqcRhBI7WD97tzSG+hxpY7BuPJnTB2MJ0aJGylKyvsuD8UpI9U/5DKxtD6PEmR6e
	af/d4m2JGNMpcCclSj4h3ZciwGxBDWrJ5WQ==
X-Received: from ioxz3.prod.google.com ([2002:a05:6602:17c3:b0:9c7:733a:80ab])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:448b:b0:4ea:14ab:142d with SMTP id 5614622812f47-55c002fc7b3mr5525425b6e.40.1793069802970;
 Mon, 26 Oct 2026 19:56:42 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:05 +0000
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
Message-ID: <20261027025616.1632690-3-kevinloughlin@google.com>
Subject: [PATCH 02/13] virtio_balloon: add reporting_vq DMA map ops
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

In confidential computing guests where VIRTIO_F_ACCESS_PLATFORM is
negotiated, the standard DMA mapping layer rejects mapping unencrypted
or swiotlb-bounced scatterlists when reporting large free page blocks
through reporting_vq. However, the host VMM only inspects the guest
physical address and length of reported free page ranges in the
virtqueue descriptor table and never reads or writes the reported guest
memory payload.

When guest memory encryption is active (CC_ATTR_GUEST_MEM_ENCRYPT),
attach custom per-virtqueue mapping operations (balloon_reporting_map_ops)
to reporting_vq that translate scatterlist entries directly to guest
physical addresses without allocating swiotlb bounce buffers or
decrypting guest memory.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 56 ++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index ab3e3d887e00..11f74848fdc4 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -580,6 +581,55 @@ static void update_balloon_size_func(struct work_struct *work)
 		finish_wakeup_event(vb);
 }
 
+static dma_addr_t balloon_reporting_map_page(union virtio_map map,
+					     struct page *page,
+					     unsigned long offset, size_t size,
+					     enum dma_data_direction dir,
+					     unsigned long attrs)
+{
+	/*
+	 * Free page reporting transfers physical address and size metadata
+	 * via vring descriptors; the device/host never accesses or transfers
+	 * data on the page itself. Return the true physical address without
+	 * DMA mapping / bounce buffering.
+	 */
+	return (dma_addr_t)page_to_phys(page) + offset;
+}
+
+static void balloon_reporting_unmap_page(union virtio_map map,
+					 dma_addr_t map_handle, size_t size,
+					 enum dma_data_direction dir,
+					 unsigned long attrs)
+{
+}
+
+static void balloon_reporting_sync_single(union virtio_map map,
+					  dma_addr_t map_handle, size_t size,
+					  enum dma_data_direction dir)
+{
+}
+
+static bool balloon_reporting_need_sync(union virtio_map map,
+					dma_addr_t map_handle)
+{
+	return false;
+}
+
+static int balloon_reporting_mapping_error(union virtio_map map,
+					   dma_addr_t map_handle)
+{
+	return 0;
+}
+
+static const struct virtio_map_ops balloon_reporting_map_ops = {
+	.map_page		= balloon_reporting_map_page,
+	.unmap_page		= balloon_reporting_unmap_page,
+	.sync_single_for_cpu	= balloon_reporting_sync_single,
+	.sync_single_for_device	= balloon_reporting_sync_single,
+	.need_sync		= balloon_reporting_need_sync,
+	.mapping_error		= balloon_reporting_mapping_error,
+};
+
 static int init_vqs(struct virtio_balloon *vb)
 {
 	struct virtqueue_info vqs_info[VIRTIO_BALLOON_VQ_MAX] = {};
@@ -641,8 +691,12 @@ static int init_vqs(struct virtio_balloon *vb)
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
 		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
+		if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+			virtqueue_set_map_ops(vb->reporting_vq,
+					      &balloon_reporting_map_ops);
+	}
 
 	return 0;
 }
-- 
2.56.0.307.g5fe7bd680c-goog

