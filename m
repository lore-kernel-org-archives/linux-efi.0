Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793094176;
	b=SNS20Vn4m2RIr9PmmV807JxaCl5psrb60nOrPzXqqUgCI3tE6SC4KvbhBfImcjiiX7bH
	 tKeJDXiY9xjC57DdfI8Zsid5dKLlrY0L2N7tknC+1yiOD7lFwwKOXvThyd9d2/Yn0a4ZH
	 yrWU630hAhnCvmhmqA9GRljVNy9BhdBsnQBBJ99Hw2KMcG6/ZWiNPn4CItat8Ax0rzRDq
	 rX8lEY8WT92tcSAFxHfGXkB9Xj+dbly2CwvV1o0/jk1YwbBjO1it6ewuVwt+0eWL2cV39
	 yBGgEXZBdegiHPQ3AF/AokNwZdwtfHB2bLl/wWAv0yICpdmrfBVtjrn/gyI240ZDO0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793094176;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
	b=0mnJTC/23AkGWAOeeA63OvqTk+w75MKMdNsfh79e3z38rnN1/0L5GlHlP4gkyFxfcKIQ
	 khCcwQ5Vuj4KK6tzQZ2oAWeCp76TMr2zAwg7NtTStdg5Abns7hswHBNUfkO5w+oyNNjbH
	 rJ5aLwYdh11Dz0Ixeiikm5FwrPyx0V4WbW4ZDq1yjsMq4eFfe5QwfghHtXXJ2FJi5xmbd
	 d2Joe46154a9DySUU9oxqzJ0B+xpXjc9kWIyzUnJusdptYnLaaU76bryx3+1s/pGtyMMk
	 pZMTJ5cXqjcoXIVPpnpNSfqG07TU5RXoWxUZJw37dhOe1JBzIaKnyfnUVWRpKV7GYTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DVrTuZc6;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=mLjdfrUM;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94582606A31B
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 09:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94582606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DVrTuZc6;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=mLjdfrUM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793094174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
	b=DVrTuZc6aN+ZiCxZU6SP/cuYh2ldVZ2ZoQK7fsNDVA8kpEqzbnXduZLsAwsGUrkjHK9esw
	+0eJwOt6Q9QMCH5fCxhiKJgLUhyP0PRVEsDUd1hHSbxauoOdWgaNIX0vv+LZnF/lsLiUbL
	q8xct7s/8KmPhoYVwd1LtoXV/6FBb9o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-mnViCRtfO6KSwsU9z3vaNA-1; Tue, 27 Oct 2026 05:42:53 -0400
X-MC-Unique: mnViCRtfO6KSwsU9z3vaNA-1
X-Mimecast-MFC-AGG-ID: mnViCRtfO6KSwsU9z3vaNA_1793094172
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e0389d6f9so1979576f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793094172; x=1793698972; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
        b=mLjdfrUMVrdt8eeBhAA1isBPKPa7qPZdkpKfVn8ly75MSmKAeTZtIEDbyre6Fr3flJ
         0Jg9zerRhdFHYDnayvhAHrFhZBJJpx9X1t6QNVHJtQ0cdNibee0GQcYlaW8TZVZYq1pf
         OBFLO/I1CSD8GsyL/q/+cFKbwdoBlLtetP3EhWtGa2FwhJpkmtbx8KK8w5SMkxPa35vn
         GjA5exOJQ/fNaW0aO+06+1HZuCo3pAJ+54tmq8c7h3+NdHfmQ7LDcVdwCSOsSUhMvk9h
         sQ2svYQe04520lvlzSJ/To45DQu5FlwhIWxGmyalRVaFl4gck3UUwqJ9mGz7PL0SrQ19
         sg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793094172; x=1793698972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
        b=jkYE2L7kAcEgX3xU4L4J91rDASbVs19fWfzq2KufiG/0mltw5ZUHYbruNX2YZtmtMz
         Yq306h4V6hmXaqQzEfTGwhbXEAAJUy1zMUxFbVD2XqyhlKULexXbWXzWYXPvwa1fZ/c8
         +pBtC3XumZ/Hs4yXes62WhFTj9Cq2CNtZN0UaTwYke1IZtLe+KrIpr6jnyAo5uPfFmSE
         PVbcAMYowhLVkWHfUxG3pIZw3KmHiI8MZEZgdikhGIht11m9LEjTokabltAnEtcvtP7G
         ahiXsYHHYu1QivVuURZ96keczSnLcZAh1reyULFnSkwmoiCbcLsFIiFUkvQxr3Cb82vE
         vZig==
X-Forwarded-Encrypted: i=1; AKwUvBx0mx5vcbRVG9cjffbRmkITThryW81jWEm+LTkhx0vpCdYzRHDfdgapjqKPiI9UfR/d1GnhPE1hgXU=@vger.kernel.org
X-Gm-Message-State: AFq9FYIl0xEOgZV/UDrmDmiivywXYe/cKcZkV7iwHR/Z8gFrnvm274j4
	d+9A9Y0ZFLqi7C3w6iPjK2/I0dHZSy81UkbQt0K0wkLlUMGmDsGywTHOy2enFEEKdtGNbljGFW7
	SsutkOAfKKAlFePJGFyZ4nMHmcuV63BTdIRxKCAeVDVBGKewb0rmTEZmBHwCINQ==
X-Gm-Gg: AYBFou3rdQQAA3DR+AHnIvcQEFlKFp8E9usVDBEOY9p+eOsbXYDeEWufUkqyvoK+NhE
	/5ufby5VIo/JL7VF0nsUdHvQ6SSXVsHl2pBOekTukoaI9ZvzvyG2FL684KNZVKrvOVn4VfE85L0
	R0d97eQFxHorqucZ9vLVfLaB7ls5QAqlWbc+3AH/7LBlGTQJJZg3OVvfUckpiXUI38gpAI3OpND
	jKYxkUoLwavTZZW13y6uzEDFzlBb7k8CLpjFwLoxz1UmKDRtGYEreZAjgj7oY5Rmi75hm212R3j
	qo57p6clN9ihRlihdPZrWt5ltDK7JAlUHcXoXJ0Kkq4ZLIAB9J4an9QSfVUrCkFg9uI=
X-Received: by 2002:a05:6000:2289:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-48e3eb9fe3emr17684530f8f.47.1793094171607;
        Tue, 27 Oct 2026 02:42:51 -0700 (PDT)
X-Received: by 2002:a05:6000:2289:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-48e3eb9fe3emr17684427f8f.47.1793094170889;
        Tue, 27 Oct 2026 02:42:50 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm25694707f8f.45.2026.10.27.02.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:42:49 -0700 (PDT)
Date: Tue, 27 Oct 2026 05:42:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 01/13] virtio_ring: support per-virtqueue DMA mapping ops
Message-ID: <20261027053843-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-2-kevinloughlin@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027025616.1632690-2-kevinloughlin@google.com>

On Tue, Oct 27, 2026 at 02:56:04AM +0000, Kevin Loughlin wrote:
> Allow individual virtqueues to override the device-wide DMA mapping
> operations via virtqueue_set_map_ops(). When custom per-virtqueue
> mapping operations are configured, vring_map_one_sg(), vring_unmap_one(),
> vring_mapping_error(), and the DMA sync helpers dispatch through
> vq->map_ops instead of the parent virtio_device DMA API path.
> 
> Replace vring_map_single() with vring_map_indirect() and
> vring_unmap_indirect() using the device-level mapping path (vdev->map
> or dma_map_page_attrs()) so that indirect descriptor tables continue to
> be DMA-mapped for host VMM access even when a virtqueue overrides buffer
> mapping via vq->map_ops.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>

Please, don't. The automatic mappings inside virtio core are there
to keep simple things, simple.

Everyone doing something funky with mappings should use the premapped API.


> ---
>  drivers/virtio/virtio_ring.c | 136 ++++++++++++++++++++++++-----------
>  include/linux/virtio.h       |   4 ++
>  2 files changed, 98 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index db678f5a80e0..9c6a1e9f0a0b 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -261,6 +261,7 @@ struct vring_virtqueue {
>  	bool we_own_ring;
>  
>  	union virtio_map map;
> +	const struct virtio_map_ops *map_ops;
>  
>  #ifdef DEBUG
>  	/* They're supposed to lock for us. */
> @@ -477,16 +478,32 @@ static struct device *vring_dma_dev(const struct vring_virtqueue *vq)
>  	return vq->map.dma_dev;
>  }
>  
> +static inline const struct virtio_map_ops *vring_get_map_ops(const struct vring_virtqueue *vq)
> +{
> +	if (vq->map_ops)
> +		return vq->map_ops;
> +	return vq->vq.vdev->map;
> +}
> +
> +void virtqueue_set_map_ops(struct virtqueue *_vq,
> +			   const struct virtio_map_ops *map_ops)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	vq->map_ops = map_ops;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_set_map_ops);
> +
>  static int vring_mapping_error(const struct vring_virtqueue *vq,
>  			       dma_addr_t addr)
>  {
> -	struct virtio_device *vdev = vq->vq.vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return 0;
>  
> -	if (vdev->map)
> -		return vdev->map->mapping_error(vq->map, addr);
> +	if (map_ops)
> +		return map_ops->mapping_error(vq->map, addr);
>  	else
>  		return dma_mapping_error(vring_dma_dev(vq), addr);
>  }
> @@ -530,15 +547,45 @@ static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist
>  	return 0;
>  }
>  
> -static dma_addr_t vring_map_single(const struct vring_virtqueue *vq,
> -				   void *cpu_addr, size_t size,
> -				   enum dma_data_direction direction)
> +static int vring_map_indirect(const struct vring_virtqueue *vq, void *cpu_addr,
> +			      size_t size, dma_addr_t *addr)
>  {
> -	if (!vq->use_map_api)
> -		return (dma_addr_t)virt_to_phys(cpu_addr);
> +	struct virtio_device *vdev = vq->vq.vdev;
> +
> +	if (!vq->use_map_api) {
> +		kmsan_handle_dma(virt_to_phys(cpu_addr), size, DMA_TO_DEVICE);
> +		*addr = (dma_addr_t)virt_to_phys(cpu_addr);
> +		return 0;
> +	}
> +
> +	if (vdev->map) {
> +		*addr = vdev->map->map_page(vq->map, virt_to_page(cpu_addr),
> +					    offset_in_page(cpu_addr), size,
> +					    DMA_TO_DEVICE, 0);
> +		if (vdev->map->mapping_error(vq->map, *addr))
> +			return -ENOMEM;
> +		return 0;
> +	}
> +
> +	*addr = dma_map_page_attrs(vring_dma_dev(vq), virt_to_page(cpu_addr),
> +				   offset_in_page(cpu_addr), size,
> +				   DMA_TO_DEVICE, 0);
> +	if (dma_mapping_error(vring_dma_dev(vq), *addr))
> +		return -ENOMEM;
>  
> -	return virtqueue_map_single_attrs(&vq->vq, cpu_addr,
> -					  size, direction, 0);
> +	return 0;
> +}
> +
> +static void vring_unmap_indirect(const struct vring_virtqueue *vq,
> +				 dma_addr_t addr, size_t size)
> +{
> +	struct virtio_device *vdev = vq->vq.vdev;
> +
> +	if (vdev->map)
> +		vdev->map->unmap_page(vq->map, addr, size, DMA_TO_DEVICE, 0);
> +	else
> +		dma_unmap_page_attrs(vring_dma_dev(vq), addr, size,
> +				     DMA_TO_DEVICE, 0);
>  }
>  
>  static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
> @@ -576,6 +623,8 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	if (flags & VRING_DESC_F_INDIRECT) {
>  		if (!vq->use_map_api)
>  			goto out;
> +		vring_unmap_indirect(vq, extra->addr, extra->len);
> +		goto out;
>  	} else if (!vring_need_unmap_buffer(vq, extra))
>  		goto out;
>  
> @@ -761,10 +810,11 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
>  
>  	if (indirect) {
>  		/* Now that the indirect table is filled in, map it. */
> -		dma_addr_t addr = vring_map_single(
> -			vq, desc, total_sg * sizeof(struct vring_desc),
> -			DMA_TO_DEVICE);
> -		if (vring_mapping_error(vq, addr))
> +		dma_addr_t addr;
> +
> +		if (vring_map_indirect(vq, desc,
> +				       total_sg * sizeof(struct vring_desc),
> +				       &addr))
>  			goto unmap_release;
>  
>  		virtqueue_add_desc_split(vq, vq->split.vring.desc,
> @@ -1370,6 +1420,7 @@ static struct virtqueue *__vring_new_virtqueue_split(unsigned int index,
>  #endif
>  	vq->map = map;
>  	vq->use_map_api = vring_use_map_api(vdev);
> +	vq->map_ops = NULL;
>  
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
> @@ -1488,6 +1539,8 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
>  	if (flags & VRING_DESC_F_INDIRECT) {
>  		if (!vq->use_map_api)
>  			return;
> +		vring_unmap_indirect(vq, extra->addr, extra->len);
> +		return;
>  	} else if (!vring_need_unmap_buffer(vq, extra))
>  		return;
>  
> @@ -1585,10 +1638,9 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
>  	}
>  
>  	/* Now that the indirect table is filled in, map it. */
> -	addr = vring_map_single(vq, desc,
> -			total_sg * sizeof(struct vring_packed_desc),
> -			DMA_TO_DEVICE);
> -	if (vring_mapping_error(vq, addr))
> +	if (vring_map_indirect(vq, desc,
> +			       total_sg * sizeof(struct vring_packed_desc),
> +			       &addr))
>  		goto unmap_release;
>  
>  	vq->packed.vring.desc[head].addr = cpu_to_le64(addr);
> @@ -2620,6 +2672,7 @@ static struct virtqueue *__vring_new_virtqueue_packed(unsigned int index,
>  #endif
>  	vq->map = map;
>  	vq->use_map_api = vring_use_map_api(vdev);
> +	vq->map_ops = NULL;
>  
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
> @@ -3064,7 +3117,7 @@ struct device *virtqueue_dma_dev(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
> -	if (vq->use_map_api && !_vq->vdev->map)
> +	if (vq->use_map_api && !vring_get_map_ops(vq))
>  		return vq->map.dma_dev;
>  	else
>  		return NULL;
> @@ -3809,18 +3862,17 @@ EXPORT_SYMBOL_GPL(virtqueue_map_free_coherent);
>   */
>  dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
>  				    struct page *page,
> -				    unsigned long offset,
> -				    size_t size,
> +				    unsigned long offset, size_t size,
>  				    enum dma_data_direction dir,
>  				    unsigned long attrs)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
> -	if (vdev->map)
> -		return vdev->map->map_page(vq->map,
> -					   page, offset, size,
> -					   dir, attrs);
> +	if (map_ops)
> +		return map_ops->map_page(vq->map,
> +					 page, offset, size,
> +					 dir, attrs);
>  
>  	return dma_map_page_attrs(vring_dma_dev(vq),
>  				  page, offset, size,
> @@ -3842,11 +3894,11 @@ void virtqueue_unmap_page_attrs(const struct virtqueue *_vq,
>  				unsigned long attrs)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
> -	if (vdev->map)
> -		vdev->map->unmap_page(vq->map,
> -				      map_handle, size, dir, attrs);
> +	if (map_ops)
> +		map_ops->unmap_page(vq->map,
> +				    map_handle, size, dir, attrs);
>  	else
>  		dma_unmap_page_attrs(vring_dma_dev(vq), map_handle,
>  				     size, dir, attrs);
> @@ -3941,13 +3993,13 @@ EXPORT_SYMBOL_GPL(virtqueue_map_mapping_error);
>  bool virtqueue_map_need_sync(const struct virtqueue *_vq, dma_addr_t addr)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return false;
>  
> -	if (vdev->map)
> -		return vdev->map->need_sync(vq->map, addr);
> +	if (map_ops)
> +		return map_ops->need_sync(vq->map, addr);
>  	else
>  		return dma_need_sync(vring_dma_dev(vq), addr);
>  }
> @@ -3971,14 +4023,14 @@ void virtqueue_map_sync_single_range_for_cpu(const struct virtqueue *_vq,
>  					     enum dma_data_direction dir)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return;
>  
> -	if (vdev->map)
> -		vdev->map->sync_single_for_cpu(vq->map,
> -					       addr + offset, size, dir);
> +	if (map_ops)
> +		map_ops->sync_single_for_cpu(vq->map,
> +					     addr + offset, size, dir);
>  	else
>  		dma_sync_single_range_for_cpu(vring_dma_dev(vq),
>  					      addr, offset, size, dir);
> @@ -4002,15 +4054,15 @@ void virtqueue_map_sync_single_range_for_device(const struct virtqueue *_vq,
>  						enum dma_data_direction dir)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return;
>  
> -	if (vdev->map)
> -		vdev->map->sync_single_for_device(vq->map,
> -						  addr + offset,
> -						  size, dir);
> +	if (map_ops)
> +		map_ops->sync_single_for_device(vq->map,
> +						addr + offset,
> +						size, dir);
>  	else
>  		dma_sync_single_range_for_device(vring_dma_dev(vq), addr,
>  						 offset, size, dir);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index f923e42cfd01..20fe333d6778 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -44,6 +44,7 @@ struct virtqueue {
>  };
>  
>  struct vduse_vq_group;
> +struct virtio_map_ops;
>  
>  union virtio_map {
>  	/* Device that performs DMA */
> @@ -294,6 +295,9 @@ void virtqueue_map_free_coherent(struct virtio_device *vdev,
>  				 size_t size, void *vaddr,
>  				 dma_addr_t dma_handle);
>  
> +void virtqueue_set_map_ops(struct virtqueue *_vq,
> +			   const struct virtio_map_ops *map_ops);
> +
>  dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
>  				    struct page *page,
>  				    unsigned long offset,
> -- 
> 2.56.0.307.g5fe7bd680c-goog

