Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069802;
	b=pFEYvAiJr2qANTjR7J8MQl5yQw5FxGS0Q35YsoLufLaJOQHzxVUqtLJJXVBuEYKYlgTg
	 daUJR2aPs97AvL+LXVwyIPL+GMlGm0x7zlVUFwljxMSYeCj1b713bpKzKPV+P0M9tSG6A
	 wszTq+Qz59HlRdVaraqbvSWUFjqPwbopl2ZFKVXR3dSEXOYCv/LBBw7txPkfMjNXS7/c0
	 9oztYo8vG4ALEO61O19cwaF+BkjPytycC2vI6uJCGRR9SUolLti7p+bBzEhExGK8toOAI
	 PKnQLIXvgHc6R8IKDQDBZYUMAzQfiAIcG20KaaUXDYksLkH5qlW9rXUJGQKUsLSIyag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069802;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=GOMxiaMp4kiAv1sy1QvOMscX3P97g6hNx07NHuZ9MZc=;
	b=HelY6LpX2dMijSbHxvqft+kJOABs7xl6PYZ4w4M3BxtBzxo/90rNCm/AeIvRezeEm8aV
	 brpLjLkTiG4jsMH/b7l+Mv8U7/UJTGT68CqdwpTyCX5DpHESpE4WlruD5so7hb1sZ+ypE
	 NTmHA6wNHOm4q2DbktAIralhg7akrZO8+eqFE+SeWWpizzdYMoDznkdXi9m++lVlprs3v
	 5sFbiD2qm6kP4sd+fLElJzmClA7lc55Z/OCBUX/fS0NNOIfk+Ipt+dWcG2WHN306zNR+b
	 PDSOIqDB9c3B6fVP8BH4TgP99ygtx9X7JftXEsYZddRCTxKiCWDCAEx4k3I4MDUIl8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=AAry79Vj;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A94606A31B
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23A94606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=AAry79Vj
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-5384e381fbbso3608996b6e.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069801; x=1793674601; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GOMxiaMp4kiAv1sy1QvOMscX3P97g6hNx07NHuZ9MZc=;
        b=AAry79VjZ4pZ2rQbZ0VLmG1my5o4V/Cl3z7uD8i8+UEZi00dNWDWKlx3/krTQlY1Ua
         plx8zD9ovnp5LHTl5Fd9GQl0XOBLCMkZTVnMobkHFEn2jKV7R4yMGwvSlhhUoDpj0u1l
         c5+tiiXr+qUU0mTub3oOjmmbmGlT4IprCZxXJQQIMOxQU6W7luUPFGPkymIPBgMluIyU
         iGd3Vc3P+UAL8M2XGWBnfmgjYwns4A3fOCjcVc9rQyHHqX2HOOi9amT6YIKsOGpO6ulP
         RXIxJZVQ5d1Q02UljAbJkFQ/iG62F5iT4S5PTHFj+v8abHsBE4T7x4qp61k376UzdJ6A
         ILUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069801; x=1793674601;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GOMxiaMp4kiAv1sy1QvOMscX3P97g6hNx07NHuZ9MZc=;
        b=YKG0UtjcTwMXVFulfEeu43teSRwO/67fE8fE9HenK3Zleqp6dswQkLomPbLpaUBJJw
         Ve3S3q58AXRTV9qJJ8nCHwaO/kS1tNThG4SrrU1zGvAZOoYTUSxRKFwYlFIWmoLbNchb
         pyUD0y+czrjzt3Z8kHUuTEgLrlUE6kBlZBxsBZny/Hp2pj6xDL2c3u8AAzR+8jwTJmEk
         9OUBRxAuRf+Jyt9108okBZyU17j8LXB4CaBYlKH/jZFD1jIm0en9320qDtC6jpKgaRAT
         cL/R2doFFE+GnKLtkVa8sNXBfTvNAy7wPAcpfo3BFE5PqRQ5bBd7qaOIdcWlsCKQEU7H
         61QA==
X-Forwarded-Encrypted: i=1; AKwUvBxd7fzTS2CStO8qQWZtjp0CarPoW4NZ2benV+lxh8E4dDGi+AvSygMgOwzWQtibQcTcebYypkEO97k=@vger.kernel.org
X-Gm-Message-State: AFq9FYL45qLLmxC9EXjQJAm23Jvfzc6iwbxXSaBdWiQaIUMvUBVGmTKM
	oqQMniUSBR8i8VOZUwQYScuqz3uU3mnGyhFKMY2P7qMLGKN+eWKQtbuwgskeOdPyu6+xjoGdOXT
	OnLraoLYuB2v7Kw7yZpnPHaG0iEmd3uLWxw==
X-Received: from jabhk1.prod.google.com ([2002:a05:6638:8081:b0:61a:c6d0:40f4])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:148c:b0:4f6:2ccb:c2a with SMTP id 5614622812f47-55c0039eb90mr5670563b6e.68.1793069800756;
 Mon, 26 Oct 2026 19:56:40 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:04 +0000
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
Message-ID: <20261027025616.1632690-2-kevinloughlin@google.com>
Subject: [PATCH 01/13] virtio_ring: support per-virtqueue DMA mapping ops
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

Allow individual virtqueues to override the device-wide DMA mapping
operations via virtqueue_set_map_ops(). When custom per-virtqueue
mapping operations are configured, vring_map_one_sg(), vring_unmap_one(),
vring_mapping_error(), and the DMA sync helpers dispatch through
vq->map_ops instead of the parent virtio_device DMA API path.

Replace vring_map_single() with vring_map_indirect() and
vring_unmap_indirect() using the device-level mapping path (vdev->map
or dma_map_page_attrs()) so that indirect descriptor tables continue to
be DMA-mapped for host VMM access even when a virtqueue overrides buffer
mapping via vq->map_ops.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_ring.c | 136 ++++++++++++++++++++++++-----------
 include/linux/virtio.h       |   4 ++
 2 files changed, 98 insertions(+), 42 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index db678f5a80e0..9c6a1e9f0a0b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -261,6 +261,7 @@ struct vring_virtqueue {
 	bool we_own_ring;
 
 	union virtio_map map;
+	const struct virtio_map_ops *map_ops;
 
 #ifdef DEBUG
 	/* They're supposed to lock for us. */
@@ -477,16 +478,32 @@ static struct device *vring_dma_dev(const struct vring_virtqueue *vq)
 	return vq->map.dma_dev;
 }
 
+static inline const struct virtio_map_ops *vring_get_map_ops(const struct vring_virtqueue *vq)
+{
+	if (vq->map_ops)
+		return vq->map_ops;
+	return vq->vq.vdev->map;
+}
+
+void virtqueue_set_map_ops(struct virtqueue *_vq,
+			   const struct virtio_map_ops *map_ops)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	vq->map_ops = map_ops;
+}
+EXPORT_SYMBOL_GPL(virtqueue_set_map_ops);
+
 static int vring_mapping_error(const struct vring_virtqueue *vq,
 			       dma_addr_t addr)
 {
-	struct virtio_device *vdev = vq->vq.vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return 0;
 
-	if (vdev->map)
-		return vdev->map->mapping_error(vq->map, addr);
+	if (map_ops)
+		return map_ops->mapping_error(vq->map, addr);
 	else
 		return dma_mapping_error(vring_dma_dev(vq), addr);
 }
@@ -530,15 +547,45 @@ static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist
 	return 0;
 }
 
-static dma_addr_t vring_map_single(const struct vring_virtqueue *vq,
-				   void *cpu_addr, size_t size,
-				   enum dma_data_direction direction)
+static int vring_map_indirect(const struct vring_virtqueue *vq, void *cpu_addr,
+			      size_t size, dma_addr_t *addr)
 {
-	if (!vq->use_map_api)
-		return (dma_addr_t)virt_to_phys(cpu_addr);
+	struct virtio_device *vdev = vq->vq.vdev;
+
+	if (!vq->use_map_api) {
+		kmsan_handle_dma(virt_to_phys(cpu_addr), size, DMA_TO_DEVICE);
+		*addr = (dma_addr_t)virt_to_phys(cpu_addr);
+		return 0;
+	}
+
+	if (vdev->map) {
+		*addr = vdev->map->map_page(vq->map, virt_to_page(cpu_addr),
+					    offset_in_page(cpu_addr), size,
+					    DMA_TO_DEVICE, 0);
+		if (vdev->map->mapping_error(vq->map, *addr))
+			return -ENOMEM;
+		return 0;
+	}
+
+	*addr = dma_map_page_attrs(vring_dma_dev(vq), virt_to_page(cpu_addr),
+				   offset_in_page(cpu_addr), size,
+				   DMA_TO_DEVICE, 0);
+	if (dma_mapping_error(vring_dma_dev(vq), *addr))
+		return -ENOMEM;
 
-	return virtqueue_map_single_attrs(&vq->vq, cpu_addr,
-					  size, direction, 0);
+	return 0;
+}
+
+static void vring_unmap_indirect(const struct vring_virtqueue *vq,
+				 dma_addr_t addr, size_t size)
+{
+	struct virtio_device *vdev = vq->vq.vdev;
+
+	if (vdev->map)
+		vdev->map->unmap_page(vq->map, addr, size, DMA_TO_DEVICE, 0);
+	else
+		dma_unmap_page_attrs(vring_dma_dev(vq), addr, size,
+				     DMA_TO_DEVICE, 0);
 }
 
 static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
@@ -576,6 +623,8 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 	if (flags & VRING_DESC_F_INDIRECT) {
 		if (!vq->use_map_api)
 			goto out;
+		vring_unmap_indirect(vq, extra->addr, extra->len);
+		goto out;
 	} else if (!vring_need_unmap_buffer(vq, extra))
 		goto out;
 
@@ -761,10 +810,11 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
 
 	if (indirect) {
 		/* Now that the indirect table is filled in, map it. */
-		dma_addr_t addr = vring_map_single(
-			vq, desc, total_sg * sizeof(struct vring_desc),
-			DMA_TO_DEVICE);
-		if (vring_mapping_error(vq, addr))
+		dma_addr_t addr;
+
+		if (vring_map_indirect(vq, desc,
+				       total_sg * sizeof(struct vring_desc),
+				       &addr))
 			goto unmap_release;
 
 		virtqueue_add_desc_split(vq, vq->split.vring.desc,
@@ -1370,6 +1420,7 @@ static struct virtqueue *__vring_new_virtqueue_split(unsigned int index,
 #endif
 	vq->map = map;
 	vq->use_map_api = vring_use_map_api(vdev);
+	vq->map_ops = NULL;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -1488,6 +1539,8 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
 	if (flags & VRING_DESC_F_INDIRECT) {
 		if (!vq->use_map_api)
 			return;
+		vring_unmap_indirect(vq, extra->addr, extra->len);
+		return;
 	} else if (!vring_need_unmap_buffer(vq, extra))
 		return;
 
@@ -1585,10 +1638,9 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	}
 
 	/* Now that the indirect table is filled in, map it. */
-	addr = vring_map_single(vq, desc,
-			total_sg * sizeof(struct vring_packed_desc),
-			DMA_TO_DEVICE);
-	if (vring_mapping_error(vq, addr))
+	if (vring_map_indirect(vq, desc,
+			       total_sg * sizeof(struct vring_packed_desc),
+			       &addr))
 		goto unmap_release;
 
 	vq->packed.vring.desc[head].addr = cpu_to_le64(addr);
@@ -2620,6 +2672,7 @@ static struct virtqueue *__vring_new_virtqueue_packed(unsigned int index,
 #endif
 	vq->map = map;
 	vq->use_map_api = vring_use_map_api(vdev);
+	vq->map_ops = NULL;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -3064,7 +3117,7 @@ struct device *virtqueue_dma_dev(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	if (vq->use_map_api && !_vq->vdev->map)
+	if (vq->use_map_api && !vring_get_map_ops(vq))
 		return vq->map.dma_dev;
 	else
 		return NULL;
@@ -3809,18 +3862,17 @@ EXPORT_SYMBOL_GPL(virtqueue_map_free_coherent);
  */
 dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
 				    struct page *page,
-				    unsigned long offset,
-				    size_t size,
+				    unsigned long offset, size_t size,
 				    enum dma_data_direction dir,
 				    unsigned long attrs)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
-	if (vdev->map)
-		return vdev->map->map_page(vq->map,
-					   page, offset, size,
-					   dir, attrs);
+	if (map_ops)
+		return map_ops->map_page(vq->map,
+					 page, offset, size,
+					 dir, attrs);
 
 	return dma_map_page_attrs(vring_dma_dev(vq),
 				  page, offset, size,
@@ -3842,11 +3894,11 @@ void virtqueue_unmap_page_attrs(const struct virtqueue *_vq,
 				unsigned long attrs)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
-	if (vdev->map)
-		vdev->map->unmap_page(vq->map,
-				      map_handle, size, dir, attrs);
+	if (map_ops)
+		map_ops->unmap_page(vq->map,
+				    map_handle, size, dir, attrs);
 	else
 		dma_unmap_page_attrs(vring_dma_dev(vq), map_handle,
 				     size, dir, attrs);
@@ -3941,13 +3993,13 @@ EXPORT_SYMBOL_GPL(virtqueue_map_mapping_error);
 bool virtqueue_map_need_sync(const struct virtqueue *_vq, dma_addr_t addr)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return false;
 
-	if (vdev->map)
-		return vdev->map->need_sync(vq->map, addr);
+	if (map_ops)
+		return map_ops->need_sync(vq->map, addr);
 	else
 		return dma_need_sync(vring_dma_dev(vq), addr);
 }
@@ -3971,14 +4023,14 @@ void virtqueue_map_sync_single_range_for_cpu(const struct virtqueue *_vq,
 					     enum dma_data_direction dir)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return;
 
-	if (vdev->map)
-		vdev->map->sync_single_for_cpu(vq->map,
-					       addr + offset, size, dir);
+	if (map_ops)
+		map_ops->sync_single_for_cpu(vq->map,
+					     addr + offset, size, dir);
 	else
 		dma_sync_single_range_for_cpu(vring_dma_dev(vq),
 					      addr, offset, size, dir);
@@ -4002,15 +4054,15 @@ void virtqueue_map_sync_single_range_for_device(const struct virtqueue *_vq,
 						enum dma_data_direction dir)
 {
 	const struct vring_virtqueue *vq = to_vvq(_vq);
-	struct virtio_device *vdev = _vq->vdev;
+	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
 
 	if (!vq->use_map_api)
 		return;
 
-	if (vdev->map)
-		vdev->map->sync_single_for_device(vq->map,
-						  addr + offset,
-						  size, dir);
+	if (map_ops)
+		map_ops->sync_single_for_device(vq->map,
+						addr + offset,
+						size, dir);
 	else
 		dma_sync_single_range_for_device(vring_dma_dev(vq), addr,
 						 offset, size, dir);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index f923e42cfd01..20fe333d6778 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -44,6 +44,7 @@ struct virtqueue {
 };
 
 struct vduse_vq_group;
+struct virtio_map_ops;
 
 union virtio_map {
 	/* Device that performs DMA */
@@ -294,6 +295,9 @@ void virtqueue_map_free_coherent(struct virtio_device *vdev,
 				 size_t size, void *vaddr,
 				 dma_addr_t dma_handle);
 
+void virtqueue_set_map_ops(struct virtqueue *_vq,
+			   const struct virtio_map_ops *map_ops);
+
 dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
 				    struct page *page,
 				    unsigned long offset,
-- 
2.56.0.307.g5fe7bd680c-goog

