Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069823;
	b=BbJgND22tEVEeNlf9YR42Mz0aIdr7ZAHXX9vuqelfLidJE1H3m5+0S+dsO8kaIW7F+Xr
	 UHqvsVJPSx/RoV32PEuChI+13xZbMDw/ILjPfiuyZmDaFkZbQ4vtvzXizctPnqlIItdOt
	 IDLVpECIzKjp7mE1NZfdeuiEPfSgkEldcolh3gQUNhDH8Xtx92Axi/kDdDSXYNj2DsP3Z
	 xqtDw8OAv5PJyvGSaxw8CAjcbJrPUh5Rtve1HmYR7yk0LemjgFsJXu7McL8P1oo5jTlty
	 GdphiT9TmFI+GFbwrUBNVnLpP8Y3PGOFPB2YZEB1u+j4flA6+kn7AHG+M7oc/aE+FnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069823;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=0dhD+kOKqUQOH4NXaqpvq7snu+OHZ+U62/aV76eABXw=;
	b=a2oZXGQ9Bg2mR5snw8G/FePBtRaAQM6OkRKDmumZAQZ1eW8a6nQ/DcQJSIzzA+TAvuW7
	 An/q1fF5kdA/qJiUNyMECobPdbq7rDsYCumxaBOcA/b0RcxWEF3sJK1422y8r7cDN4AII
	 mGebMGtxRNOtqJAz1Clq/TyMM/Z5nr5iN5M82D39ZB5NH8O/rkGbCkIIaHoyAu2DGzVs7
	 9lDBhGrr7sHGVdBr3RcJ1iWmKe0aZZhBof4bX+p+xQoUciprw/pquQw2m5fwPXEss2vFy
	 d6fxIiYIFpqVfKEcGVIWAvpSBTafhiuXxl9IjeHJkxtplbeNFNXF0CrNxnNrOkakwBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QfCQutLR;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DC060A3834
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:57:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24DC060A3834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QfCQutLR
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-54d6281f6dbso4145254b6e.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069822; x=1793674622; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0dhD+kOKqUQOH4NXaqpvq7snu+OHZ+U62/aV76eABXw=;
        b=QfCQutLRkxyQpHquEma0pWnTbXmhRvvI7CyxjB/pz34eXXHwYUDs1JKtjQW9SvB9xB
         b3+SxllXAlSfzL5YYRwltunB8yMfrAz/XzPXktGbT2UQtSP4W9W08Kup66nqCp5OwZGv
         u9xZeyLv3b8vAKPTLC0tdYBugX74ZVezQV2CDdPAL6q33wzXLIFbv9N2Tk0L8jJZDoVP
         Ei32C2l9cCJMvkUxyHZbldWyMEzlj4cpieumH9lFVnXoZ1YMut7WLsg99VYzmoZphMth
         vnzm9EpXe80AqEdFyTpAmid1dIK8PzjugxcAHAcW8U+269ScfCcM+6+SvMMDz595eKh5
         RKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069822; x=1793674622;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0dhD+kOKqUQOH4NXaqpvq7snu+OHZ+U62/aV76eABXw=;
        b=NVjgB0yVX2OX0vx+xEiVoZIFCw3sJxYm6r3DzzPgYS4BPEjb90mT15/D7QX4hZxm2k
         JLvHjXZpE7Jgux/dUBlb9GRJhPvBeLsYYukPcmrkAXqKMvgMUfafHq8MQnpDTJl1LqQT
         D9cZBf3tl/eCnz10oua3bpf+vEXEqmHIWvT7tYMmiKF8nSsGIceTVUeL8IKTuQEk5h4G
         mzltYPyYI2FSOAIlKNcYcLb0+xX3FR7LIhJEAc2QW43T5DOMGqjwuy8i2b3THEz84dqJ
         pWRFKejVmDo6T46bWtrhQp1YlZ1NDPCEDa7FJ4nUjyRyftYulnbq1Fu550u+8pQOYgDg
         5nGQ==
X-Forwarded-Encrypted: i=1; AKwUvBy+gCFqI4Jfo3+OMzs1PPOGJ/dNqi8nXpwXnHupFxboB9jQeRH8wkgk0oCFd55Ip0lNmTyTD05GGbI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKcL2GU6/BxRRg5JFi3WuBMRqCFp2ppr/ZqK7XEdG0TP8wo93/I
	QC7kBmWEXQ0npKVbbRlrsTdfzK6FVpk/Fxe1GNpD5V8Urx9aiHG9apqy2CzFhP/E6vnLq/qsVKO
	M2lXPiyRdgi+oPy65f8Kp5w2nu3gn1i65/Q==
X-Received: from jacnq31-n1.prod.google.com ([2002:a05:6638:e21f:10b0:61c:8e68:e95d])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c1c4:b0:4c7:7ce5:a32a with SMTP id 5614622812f47-55bfff7e470mr5562520b6e.4.1793069821819;
 Mon, 26 Oct 2026 19:57:01 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:16 +0000
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
Message-ID: <20261027025616.1632690-14-kevinloughlin@google.com>
Subject: [PATCH 13/13] virtio_balloon: enforce ACCESS_PLATFORM in CoCo
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

In confidential computing environments (CC_ATTR_GUEST_MEM_ENCRYPT),
virtio devices require VIRTIO_F_ACCESS_PLATFORM to negotiate restricted
memory access and DMA bounce buffering for virtqueue rings and
metadata buffers.

Currently, virtballoon_validate() unconditionally clears
VIRTIO_F_ACCESS_PLATFORM, causing virtio_features_ok() to reject probing
the balloon device (-ENODEV) when restricted memory access is active.

Preserve VIRTIO_F_ACCESS_PLATFORM in virtballoon_validate() when
CC_ATTR_GUEST_MEM_ENCRYPT is active, clear VIRTIO_BALLOON_F_FREE_PAGE_HINT
in CoCo since free_page_vq maps MAX_PAGE_ORDER blocks through standard DMA
ops without unaccepting them. Reject probing (-ENODEV) on CoCo
platforms where balloon page state transitions are unsupported.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 36 ++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 217431e75751..ae011636c07f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1311,6 +1311,14 @@ static int virtballoon_restore(struct virtio_device *vdev)
 }
 #endif
 
+static bool virtballoon_cc_supported(void)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return has_unaccepted_memory();
+
+	return cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT);
+}
+
 static int virtballoon_validate(struct virtio_device *vdev)
 {
 	/*
@@ -1318,7 +1326,17 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	 * initialized. If we cannot do that then we should disable
 	 * page reporting as it could potentially change the contents
 	 * of our free pages.
+	 *
+	 * In encrypted guests without unaccepted memory (e.g. SEV-ES), the
+	 * hypervisor cannot populate discarded pages with guest-encrypted
+	 * poison/zero values and the guest does not re-initialize reported
+	 * pages on return. Clear VIRTIO_BALLOON_F_PAGE_POISON so reporting
+	 * is disabled when init_on_free or page_poison is active.
 	 */
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
+	    !has_unaccepted_memory())
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
+
 	if (!want_init_on_free() && !page_poisoning_enabled_static())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
@@ -1329,7 +1347,23 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	 * virtqueue_add during page reporting.
 	 */
 	__virtio_clear_bit(vdev, VIRTIO_RING_F_INDIRECT_DESC);
-	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
+
+	/*
+	 * The balloon bypasses the DMA API for page addresses and cannot
+	 * support a physical or virtual IOMMU on non-CoCo guests. In CoCo
+	 * guests, VIRTIO_F_ACCESS_PLATFORM is required for bounce-buffering
+	 * virtqueue rings and metadata. Disable free page hinting in CoCo
+	 * guests as free_page_vq maps MAX_PAGE_ORDER blocks through standard
+	 * DMA ops, and reject probing on CoCo platforms where balloon page
+	 * state transitions are not supported.
+	 */
+	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
+	} else {
+		if (!virtballoon_cc_supported())
+			return -ENODEV;
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
+	}
 	return 0;
 }
 
-- 
2.56.0.307.g5fe7bd680c-goog

