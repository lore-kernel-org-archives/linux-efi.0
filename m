Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069822;
	b=GbOFSD67CUz41qsyX/GmwY7YmIAKeRECSHytVDiVXimVFf1vdU7CBRloj7+vzbFj6y3M
	 Agg+87KaBOsh330/gBlDLOHY5NjvZzE94N2vsYoh27/OvVMS5CemnVNtKRZXd/Xlhekw3
	 udM8nxXX1DbE59jmGBpjG5/TG6AwU4uv6yupYPL+IULrHmf5hdQH5wHp5syTccphB9F2n
	 DqTtG8EUK9xybz+qsc67r8Wwa5W6TJT7aMDcAWz8mcD6uev4HnoIBetB8BOYSOqy/1+ib
	 lGDgBer8bOTBffhyR+B4hbmQJLgTCzYlChKjVHgXOep43D0INa0wLa83pbqsg32ElCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069822;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=CMgB+FzrQPZBtoyno0UE3jQCmYhoPeFOpiZUNmu3S6w=;
	b=kifpCDGKHT3bU5JcZxvHxP8cGsYo6IjibdijO+4CHg6eVM+63WpCaC1GZRxtaTDIvGhN
	 z4LjTL/3wO1iXFnzmwiXFaWw1QD6AGUyuHfFyhJcSxv78kykdXxo6j4EbsrLv1XaSrJxy
	 gUb7psfgdWwOmIiFxmK7W1P2fGQjZhdLsZ2hDcmwhcDp0SCIJI23ezhG/fpY13a7HmF+L
	 kMWH+FqZzvlw97ODw7SIqRKbx2H7k+kD/Jteg7URMHSFjkBvL2Uf/k9L4s6HLaIcW7xzf
	 TCFY4ajojEyMup2aQ9tqdoq4YKyJ3qS0GkCUUr8nhk41im//THdPYMo1SiLSlY1ZH4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kuK+jZ60;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E5660A381F
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50E5660A381F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kuK+jZ60
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a7de733fa9so5161527b6e.3
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069820; x=1793674620; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CMgB+FzrQPZBtoyno0UE3jQCmYhoPeFOpiZUNmu3S6w=;
        b=kuK+jZ60O5kkR8qvTjPWlwfNFqA0hINqgr5KdWNji68KBSi/DjquQq+Xsa/324lZLE
         gAIJJ9i0nUCAr9FpY+unKcy4PmPIgR+cM+r4PafxmkLdxSae8KVPOwJ+cHd1StiJWj8d
         Lb4Hc2QOAJg3SzDdK3zFWDErko1sJLAduFCV/AF9yBOVxVUjkmCBymlGDYcjMAL/ilvU
         q75nIVK6x5wLDVSSdrhKTQGHtljrfWRYn94YYG4TjmbGPyqA+fPP/KzGH0DRlXXZgSni
         EAZiWR4u7B9y1x6iP7Mh6sru1gz+xk6sNfKL11WvZ56arHRxhteISaO3EprO5OokELfW
         I3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069820; x=1793674620;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CMgB+FzrQPZBtoyno0UE3jQCmYhoPeFOpiZUNmu3S6w=;
        b=jFkDz0eFZHdtRcQiI0JE6cMB1bzDBFoklDYl1SF950x6u9h029EhqBUm/spyfWm7k8
         3EqbAXLpM3meSMCwMeZWqSDZPwFSrr6FLveT/fSyCwR4Dbx7oAeNE9vcx28b9hoRlmcf
         wZ2pOgXsC7vfN4u6rWWyzr6IrkLPKZOnxabkHLDQO7nqJLhUedAZc8iyh0FpN2Ge4xAA
         1zuneUMFuEYRN2pdmeX0A/FJyh1cbEUAdwHkvfpgCbqJfHAP99v9JHuUOhbA96/iF1C4
         wjoY/AkHqsSNk1xk6WBpAGnuzIvTUiQt/4sqCiBmA0bQYanoZiXUGtWAgjGidkq5fXzV
         XZKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXOb7OFOhDJ+j5PeTCizj/iDxJAlxUJqTgn1S4nTcmL7Tun1r2djj3D+yz0h+XBulmTzH8CQ1odBI=@vger.kernel.org
X-Gm-Message-State: AFq9FYL7zGq+zJ+XfMCMBP08wJkXVO5YWyUYH02dN1nPCYPyA+6DERyq
	IXWJtPQgcxbRqV/ZgeyyxoM/H+7Vw6qhABKPuny4Q4TN+dqWa9tn9CGiriEDMpoDkjd/podUOsA
	UbY+x+ZL/kTqqfOhlqavRzX3XLbyPR+I6hQ==
X-Received: from iovf14.prod.google.com ([2002:a05:6602:38e:b0:9c8:5014:752e])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:50a3:b0:549:e9e3:9490 with SMTP id 5614622812f47-55c0023237emr5583862b6e.23.1793069820114;
 Mon, 26 Oct 2026 19:57:00 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:15 +0000
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
Message-ID: <20261027025616.1632690-13-kevinloughlin@google.com>
Subject: [PATCH 12/13] virtio_balloon: unaccept inflated balloon pages
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

When pages are allocated for balloon inflation in confidential
computing guests requiring page state transitions, mark the allocated
pages as unaccepted via mark_memory_unaccepted() before notifying the
host VMM. When those pages are later deflated and released via
put_page(), the page allocator routes them to zone->unaccepted_pages
for lazy re-acceptance on demand.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e10bd792ef7c..217431e75751 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -329,6 +329,15 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 		unsigned int pfns = (1 << page_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
 
 		list_del(&page->lru);
+		if (virtballoon_cc_needs_state_transition()) {
+			unsigned long page_size = (1UL << page_order) * PAGE_SIZE;
+			phys_addr_t paddr = page_to_phys(page);
+
+			if (mark_memory_unaccepted(paddr, page_size)) {
+				put_page(page);
+				continue;
+			}
+		}
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
 		vb->num_pages += pfns;
-- 
2.56.0.307.g5fe7bd680c-goog

