Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069819;
	b=OQYWAimbuakcmzuersiAzGJ7P3cVKJr+iMIU1mQ9bGfbuKSKY6gHcSBokxFS+LeF98S5
	 TDunPpcLmFO7+MDoadP5+BdsnoEGHlhJQI6ekcU1VcLnV/n4tZsPvsElVHf1mBzYtzIc+
	 f8Cs3ao9JsvkUs1bnwL3upvDbu05lg5A7XhXbSZx2Qu/GsXFxze7NAooMIdCAnSu5mTGF
	 +ISp3mtBtggF8SixawnMURKEqSmHp/Uh69x0hmgF+F8IWO0QAWiyI4C6BddxF4pkFK5gi
	 Q3tDAzm6QfapvtSxl7YNtpiTC6UhKgEAn5/gnDUc3xLuE9Ux4cW3befSBpDbtCsB4vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069819;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=j+w6uCJntt3i4Wr5zbmAS2QfetxR0x7f970do0XgFlo=;
	b=uv/b+Oc6lqGRc0NdjcOWUUgpoLxj1FhXcTx5a7ghTMEY/MsU/VTXM4syb5qxHzbQThmU
	 3oVjwzB1AHXD2JOu5x+PSsZBBmbR0nikGhh2V96SpYok/HLgXMBAg70r+BdMA9NC8R0FS
	 dhcWcYGRfZ9r7jmoy0w3M5Urflb2WPiVHJRCFW932zQ2ijO+edqhRNf+ZQ7yoXddg/mGr
	 ZaZ/CL8GGBpa5KIc4e+2B5SmIGdHVGNvx9IdTT49KYw0hP81FGbhnsS5yvlKCa1YNtaJq
	 SNM8BcKz5p2zb4gfAijViRtPdeHT0Bl/Yij4kR08UI/hL39TR8mlRYEDitwZx2PqL6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uNMzfIBd;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC160A3802
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91FC160A3802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uNMzfIBd
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-82169fb66c3so10091204a34.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069819; x=1793674619; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j+w6uCJntt3i4Wr5zbmAS2QfetxR0x7f970do0XgFlo=;
        b=uNMzfIBdZgy1KN8bFNHYHiLLIV46Yma9kQMtlPcXXX7T7zwVL/i/+ib96FOmt5+WL3
         n1BuyeykqhM2dDAsutuCqTP+qaiftM6tMCYKdeJxOT/dhgZwRud9ipglpmeLiyTc2X1K
         trU8END+WQoLb46jffScMCnl6ZaLswuyFEfQ0qimov7DpefFYqEY4EM3GQ9FGU+z13w2
         5WY6rE8qRK944Oq/DAzAyWIAnyog/b7XYFMymQ3u0W56oB/57ya5y9/wV0rmw651EsJU
         VRu7dz10YDkmjpEPcQtLIH7lbGZBUZ2HxvVB2BMakZ1BxsJMI14d2hx6PFe3ifCr5r38
         SYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069819; x=1793674619;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j+w6uCJntt3i4Wr5zbmAS2QfetxR0x7f970do0XgFlo=;
        b=UhlB1Cjg8WFMjIDSGJLivwVuso2GKni2EO/eY+Z4H9MQGzOc4iJ4ox3YYmaCHPOZzb
         oPuxxrqIid4yX+nMc19Ksz9ppkzCBWzHoyCVn3GqIRo/bknSuxWoK4qKS67ku+P/ISjD
         EuT/GgAB16H7rLtTTaqqa91gn704xNrYJPbe/OupSZO8yIqOFeit33jP1TqUqRAp0HTN
         DKTG/TwFukLqlp98CAZQN6Mh8btTR0o+OGXHgSUIy2l1eAIAcnRMKa/otjZEjqNvSdwg
         A+S3EvQXizKmwdPSo2NLuy0Nv6c0n9jKftYgPyRR/ls15uFfGB3CfwSSh4046oI4IbO+
         nlzA==
X-Forwarded-Encrypted: i=1; AKwUvBxcHICTLkla1SS2sm0+mFGAsxPlTTtFMEmWMCrke+pGSElxXaMWjpOOgQqmFMIgtXkjhdU1L/e0qAk=@vger.kernel.org
X-Gm-Message-State: AFq9FYJyQ0ztYY3yUyWyv7RzhFXTkbwsLGii/aAz+b6pZSfVU/B+dIzL
	q1t/jC0vPYp6CwTqxHNI4xtuHxRnvwwWrZ1iuf0bAq1Les3syvg2exs/T1kgzEB9GEgfiM0zRlX
	iUdvhMDl6LhDg14dxacemKhK3cwk1k9ACzw==
X-Received: from ioo6-n2.prod.google.com ([2002:a05:6602:8646:20b0:9c7:5a22:a4be])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1b2b:b0:4f4:73a9:f853 with SMTP id 5614622812f47-55bfff91bbdmr5294378b6e.1.1793069818445;
 Mon, 26 Oct 2026 19:56:58 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:14 +0000
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
Message-ID: <20261027025616.1632690-12-kevinloughlin@google.com>
Subject: [PATCH 11/13] virtio_balloon: unaccept free reporting ranges
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

In confidential computing guests with dynamic unaccepted memory
transitions, configure the free page reporting order to
unaccepted_memory_order(). Invoke mark_memory_unaccepted() on each
scatterlist range in virtballoon_free_page_report() before adding the
scatterlist to reporting_vq and kicking the host.

Unaccepting the pages prior to virtqueue_add_inbuf() and virtqueue_kick()
guarantees that the guest finishes PVALIDATE(validate=false) before the
host VMM can observe the reporting request in the virtqueue ring and
punch a hole in guest_memfd, eliminating any race where the guest
re-allocates and re-accepts a page before a deferred host hole-punch
executes.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d162c162b496..e10bd792ef7c 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -213,7 +213,26 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtio_balloon *vb =
 		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
 	struct virtqueue *vq = vb->reporting_vq;
-	unsigned int unused, err;
+	unsigned int unused;
+	int err;
+
+	if (virtballoon_cc_needs_state_transition()) {
+		unsigned long unit_size = PAGE_SIZE << unaccepted_memory_order();
+		struct scatterlist *sgl;
+		unsigned int i;
+
+		for_each_sg(sg, sgl, nents, i) {
+			if (WARN_ON_ONCE(!IS_ALIGNED(sg_phys(sgl), unit_size) ||
+					 !IS_ALIGNED(sgl->length, unit_size)))
+				return -EINVAL;
+		}
+		for_each_sg(sg, sgl, nents, i) {
+			err = mark_memory_unaccepted(sg_phys(sgl), sgl->length);
+			if (err)
+				return err;
+			cond_resched();
+		}
+	}
 
 	/* We should always be able to add these buffers to an empty queue. */
 	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT);
@@ -1142,8 +1161,11 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		 * host's base page size. However, it needs more work to report
 		 * that value. The hard-coded order would be fine currently.
 		 */
+		if (virtballoon_cc_needs_state_transition())
+			vb->pr_dev_info.order = unaccepted_memory_order();
 #if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
-		vb->pr_dev_info.order = 5;
+		else
+			vb->pr_dev_info.order = 5;
 #endif
 
 		vb->pr_dev_info.capacity = capacity;
-- 
2.56.0.307.g5fe7bd680c-goog

