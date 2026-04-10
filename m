Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DBB3CCFBB
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 15:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836009; cv=none; b=DNQHM5rpSMSkuNDzA7ybwlQN0QYX/ewmFoIKYvyR9clTFTv0FFi1GcRermwCxHihftPNoyKHGQumG5Sw9mz+uyskVlddb+3jQg5onm4eEjNzLrsWvciQNTU5GiLfuRwU6HW8n3zqe5c1MaNB15hY7Q6UTR1OJFbjQNR+TAw1i9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836009; c=relaxed/simple;
	bh=tKdN/ntNmjDfRnPFM5w/R3s2TrEcyHLsivf+NXbBjmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mvK/2bFC4ZUSK6qdOtNyPrjAPbwGw3KK8r90/ZiDDRK9y1mlSVSNLx0ALR7KuUway9+er9LiTqB0gP0bfUpXfyVNs+asv2AJme6f2D7z2f6CzUCVmkZTVinTxEck4+UwgTycKOkeiGBuuZTxRbqeFb1MUVnjgaDRfCzGCLu/cso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DiQeFM+T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DiQeFM+T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775836007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GaiSHE3hb4TSGjELzTDu6prFgI/KaCw7rqgh99exW9M=;
	b=DiQeFM+Ts4QV+bJGDtwO2Qmrb9s7US/yFqXD8OumUIw2jNRGVs6bUZcn0NfuQ4VLffhHvY
	aXo73xytB/ACAQ6hrqBqGfyDB3pavRpzGzgxCA0pnbCdodf0/NcgOJKFNHe/O29aUNxA4q
	zF44N/BK5/HZjBi+IuQpnlnjn54zbHQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-75-eOQbHzu9N_ar_9LA2852Lw-1; Fri,
 10 Apr 2026 11:46:44 -0400
X-MC-Unique: eOQbHzu9N_ar_9LA2852Lw-1
X-Mimecast-MFC-AGG-ID: eOQbHzu9N_ar_9LA2852Lw_1775836003
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E013B1956056;
	Fri, 10 Apr 2026 15:46:42 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.33.165])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD5D3195608E;
	Fri, 10 Apr 2026 15:46:39 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	linux-efi@vger.kernel.org
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efi/capsule-loader: fix incorrect sizeof in phys array reallocation
Date: Fri, 10 Apr 2026 17:46:37 +0200
Message-ID: <20260410154637.42301-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Thomas Huth <thuth@redhat.com>

The krealloc() call for cap_info->phys in __efi_capsule_setup_info() uses
sizeof(phys_addr_t *) instead of sizeof(phys_addr_t), which might be
causing an undersized allocation.

The allocation is also inconsistent with the initial array allocation in
efi_capsule_open() that allocates one entry with sizeof(phys_addr_t),
and the efi_capsule_write() function that stores phys_addr_t values (not
pointers) via page_to_phys().

On 64-bit systems where sizeof(phys_addr_t) == sizeof(phys_addr_t *), this
goes unnoticed. On 32-bit systems with PAE where phys_addr_t is 64-bit but
pointers are 32-bit, this allocates half the required space, which might
lead to a heap buffer overflow when storing physical addresses.

This is similar to the bug fixed in commit fccfa646ef36 ("efi/capsule-loader:
fix incorrect allocation size") which fixed the same issue at the initial
allocation site.

Fixes: f24c4d478013 ("efi/capsule-loader: Reinstate virtual capsule mapping")
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/firmware/efi/capsule-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 2c628a1270919..8e8f81f0a5a0a 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -67,7 +67,7 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 	cap_info->pages = temp_page;
 
 	temp_page = krealloc(cap_info->phys,
-			     pages_needed * sizeof(phys_addr_t *),
+			     pages_needed * sizeof(phys_addr_t),
 			     GFP_KERNEL | __GFP_ZERO);
 	if (!temp_page)
 		return -ENOMEM;
-- 
2.53.0

