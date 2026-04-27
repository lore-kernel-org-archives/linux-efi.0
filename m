Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A364439B958
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279199; cv=none; b=QmONRCxTvhC4WaL1dk3CVbWFtJvwZ6m5S/wZWYNaqej/qGQrTGzE+PWIWP0//XvpMjjZa73pDh+l/axNPg4dIup8bU/VVjoyJRaJc/GfKAFDIEGbJO6pjaO+UVz/osmpw7OSfriAwozIYBmTeZseSH4zi9rtE93bwpvWfIKN4Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279199; c=relaxed/simple;
	bh=vnWQaMXFkKtGP6ZC1Nh1A7b0JU1COH1xk8nY4+B24jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov69heitZA1IlVAXKtqrqL24xIuOWibxSKaoJlTMiXbzI4/bH4PsOTsJrcc74d7HlASO54NmW5wncdYTo22gLGtp8JUeswWHVc0u8DaE7lqfrWLIK5kDoyyi4PcFqv1mDpemur5ACfhWnejWJykcjL4Yt6ofLeYr9RY0iYdbXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=w4xZHwD/; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="w4xZHwD/"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b23fcf90b2so94415885ad.3
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777279197; x=1777883997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HjfJ4whsRboDgauJW5lAp4KFfEFuATjZYAYX/3z86Ss=;
        b=w4xZHwD/pFPxnNzvA4DzwhSq5+WEAKtIJGDx2kuwZw6yo7jqmqekKdu9LnwrtlwtrN
         zKmbPj6xOqORcmibHpu+wBLMBLhYN+gkHqjjngA41yt9yEb2X1fnVMw6mHxRqnw8e9q7
         mkDK3dU/gO7ndweVFP1vuKwKycTR+VCODhCc95ZyrcR+wkBXLjovWpmDjjYhdI2uQ4c9
         F5Qb/JKgwwTObEaqKXlr2WNJfdFJMJukIGiXTVsNrL51vA0kGvloPVjRyuvxouWtirMM
         kPSupdC7e55tg8yh4uZXTHc99Ai4jcQcdBBCiC8t2z6IgYygS6LhJHN61RTqpnXV0moF
         +oNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279197; x=1777883997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HjfJ4whsRboDgauJW5lAp4KFfEFuATjZYAYX/3z86Ss=;
        b=WF/gDgFTEQ2VYBJXGyZKhA82NyK8TzIS+uApSbjV+ODQCk3LfX0HQpcQno6PCC4DTt
         EkSl5DyYig+NhlWzwcHszA6+zpC4yqjQJ8OPJNsIHc9fCbj5R2KFMdlb9EzIjQGABJru
         Mr/suuXvhiOKoxjZ4s4IZkUt95CPydAgzWMGMlG7+Sci3mp/gaDfVfXZ0duosQcecdiJ
         4IdleUSTRivEqeKmpWWtCl6uKArKRKZSVWca4vtG6HgZnA9UT8vt9ZPQX8WkI+pQxhr5
         N9Mj/g0kknUTrx+S/JtyfRqsmu8dRWhBQyFuQTIhUKY6AySNj5uTMpf8CaySD6iC2nKU
         xN0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8CiV+5Aq4UeoFRnU/dnHMbxRkIqC5rVm7DCjXiwVEFWyoiBbFZdiksp/8DpBun0tC5f/ef8TNaGVs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzojg/RakHeaB+6OvR7z4vp9rLnQtiwsrpKl89QTTNf4DahoYSZ
	hXZKTJoWT/KQ42lFd8BCEibSwxtA8PKFvdpNNLTnwK7k3Vy/JOgcbrPlMn/lGQwY2NI=
X-Gm-Gg: AeBDieuTjcma5HLjhV5BevQg9DMY6kdAUizG71M8oe3tLo7H8JpDdOaC3S4U8Bv0o/l
	95hbxGrUlQNw5ayYiEClVY8CGo4lSavXTl1xK1TJqNo/iWyj8CTDGyzmqRepQ6KMhpyuPZ0w4Uf
	INkw47K+b/ghL+741ysftjxHHzlf3mAAnfWHITDyNPgrRkpdeaqmeOpbAkUeKw8w9ErXWRNsCk+
	ZyP8vFAkqv6ZGDP8ImRC53YgN4N2SmSiGW5Z3J2Df0+HhBSkODC0vNSRCQoBaiDUll4Sdg9RaHv
	iq8ZrJ34C0UdYk2SXe92HkzkIYnaZD/sXskUsERFlqh5SwH9lyFfhaBtm7xC8D09VVrrZm2h2mr
	ZzO7wxVjn0OuxeIpQJX+AwPNQ/JdGgiCNrXzWYcAn8bYjIp/gF3TtH3hd+WZ+D7H7J18bOWxblp
	ooCoKisKuK81s=
X-Received: by 2002:a17:903:2406:b0:2b9:4c05:5417 with SMTP id d9443c01a7336-2b94c0561famr79798515ad.32.1777279196945;
        Mon, 27 Apr 2026 01:39:56 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4049bsm276063105ad.77.2026.04.27.01.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:39:56 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v2 2/2] efi/libstub: Synchronize instruction cache after kernel relocation
Date: Mon, 27 Apr 2026 16:39:30 +0800
Message-ID: <20260427083930.36324-3-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427083930.36324-1-r@hev.cc>
References: <20260427083930.36324-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The relocated kernel image is copied to its new location using memcpy().
On architectures with separate instruction and data caches, the copied
instructions may remain stale in the instruction cache, leading to the
execution of outdated contents.

Call efi_cache_sync_image() after the relocation copy to ensure the
instruction cache is synchronized with the updated memory contents before
control is transferred to the relocated kernel.

Signed-off-by: WANG Rui <r@hev.cc>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/firmware/efi/libstub/relocate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/efi/libstub/relocate.c
index d4264bfb6dc1..913b425d089d 100644
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -158,6 +158,7 @@ efi_status_t efi_relocate_kernel(unsigned long *image_addr,
 	 * have been allocated by UEFI, so we can safely use memcpy.
 	 */
 	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
+	efi_cache_sync_image(new_addr, image_size);
 
 	/* Return the new address of the relocated image. */
 	*image_addr = new_addr;
-- 
2.54.0

