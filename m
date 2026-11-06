Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974792;
	b=poqX6tDmzbCwez4QSurnnBDjhA3Ogpm+d64VGDLYpa5WGiiNgeysdU7jtrVqYfT4bmgJ
	 imvdeuErmmXx7q0YUXBO6AyLxUVRgFs9zt3fmiIoM8w95Dh4OKIgiao9QJZHlavt1e6Tc
	 Nvv1xA+Qa9j+Z3LdHercae8rMFaWAl6gCOMOzK0p6pYVYbJQo/Mvr8XQHUOgZA6VzpQTj
	 nx/wHJ71m1VEabsID8085sqwj4aRELo/AI9o8nmZDGXD+7jPpvVCOrBcigecfl2EScdM+
	 AlsJ2l7x1jt7lug6KyRnLD8h4huNE9fshe1Pni63tg7hfNt3QnACcqkN+CsA1qISkpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974792;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=TwsPFdRh0C49DOdl+xuWiS4YPqcCQKDREkOH0Q0gTC4=;
	b=Wtc6YReTgvTtH/qDaOw08Hhs0q6qcL37HE1aPiiRC7IF5f/cTa709axZTU2GO6ZSg0aJ
	 6soUvghkTljojuAwus+aPtirNkOaDEVNT+ovViTXCK4YYmV4pCeNXH8PcsPZHAhkj7hNs
	 xzzS9vlhGTuugu/a6wJ0W3K5JY15AI91cWb1COtY7c9EoEQneXBxHn83wdp95/n2ZRIIo
	 WPeKPMdeGQbbiqlzn/M4aWZZRIyCGoWJwsrTCXYcEob8x0i7NDNbppk4Pprp+ELnUkgc0
	 K1UyZYQlaCHaqBDNH2fEjV22iR43RO+S3AUmAEwKJ2iAtzwNUjUVyYxpLplv4KCAdMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZCHkKsjq;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A25606A32F
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:19:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4A25606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZCHkKsjq
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a214a5f8a1so8178915e9.0
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793974790; x=1794579590; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TwsPFdRh0C49DOdl+xuWiS4YPqcCQKDREkOH0Q0gTC4=;
        b=ZCHkKsjqMGVGm5r3xZbIrIR61i7gOY10ycs7jzaTZSiG1uGNhXmsFPnDc/SLKYlFKI
         xSmdlOEM2EoviZm1jtJLfzPvHrslELZqJKX+8imeTcpLuroSIuc7hQpAExtzFILywxde
         5ZtgCkECYbiuduulv/s+Q2JaDsID5olgBM36qCXKi5JgoB6nHFv07eC1Gp3PwMm7Wmlv
         cXBGn+2QTWgfgzXffQG+C33eWMUo2R+lYrrq5uKhy1F8gi14xjR9euiMTLquDcREEXbN
         vS368QvMd0XQph90S8Rufs/BxX2gRIpukkY/4l58cF2AYi5YNoiNn0dOZhI8yjpFgZPV
         1uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974790; x=1794579590;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TwsPFdRh0C49DOdl+xuWiS4YPqcCQKDREkOH0Q0gTC4=;
        b=lHfNOb9PjBcB6dINOWPQ5PxWgsqx+zy+NqfgMxSJeL8+4CvRS5cqW0D969PX2WkY+h
         m4nxl65GKeh8K2Ejd3SlCO1OG5/KQ/b3ZPIHaJho9o/ow/+Svl6xLlzI8ZuyJ13NcaMX
         5aEHuqzod34AgZuQha9nDetqwman/j73A4nzpjU55YqzyN5+KV5S2Pj7dno06b5HuHLC
         7DxmsyH006JFXVx5PHnuGAx0Yt8nguQnloDdcYioMscAvqpl3vC2YMRt8sWT1CInGxmL
         lgm3RgNJeT9diCFPlR31pQHLORHUzZzVDXsyrIrPuKfaQs+f3VJ1X98uII/EItYnSpLQ
         P9dQ==
X-Gm-Message-State: APuU4Z+yJ5vtH0t1jfEVXyOrz6+v4EkdDqtPOQBP1+g71iblMSsZa/xI
	DYJ5EJsJei5uAQbRU/qXzZBptcZqTrhpkVmrRNTvtHJFLm1a1KKLTmi5YYncPASxR6c63xog25w
	2TIt34skfnXkVcd72lEnQokwa4TY84k1wHkcbbwyTyt/y+x2uSgJ8CD0i8nRyKHONan1Ze/wEIa
	NAnj43gY3pnt3aaK3KRehhQ/qFXoSfbQ==
X-Received: from wmok21.prod.google.com ([2002:a05:600c:4795:b0:4a1:d943:b7d5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d0b:b0:4a1:742e:3
 with SMTP id 5b1f17b1804b1-4b6e0170a5cmr45487535e9.27.1793974789972; Fri, 06
 Nov 2026 06:19:49 -0800 (PST)
Date: Fri,  6 Nov 2026 15:19:37 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106141936.2744481-7-ardb+git@google.com>
Subject: [PATCH 0/5] efi: Expose loaded image properties via info struct
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Clean up the arm64 build script and linker hacks that zboot uses to
obtain properties of the loaded image (which it cannot access directly
via a relative reference like the ordinary EFI stub).

Instead, define a struct efi_image_info (whose contents are arch
specific), and expose its offset in the loaded image via the arm64 image
header, so that zboot can access it after decompressing the image.

Cc: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/all/0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com/

Ard Biesheuvel (5):
  efi/libstub: Make efi_remap_image() return efi_status_t
  efi/libstub: Pass a struct efi_image_info to efi_stub_common()
  efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
  efi/arm64: Expose struct efi_image_info via the image header
  efi/arm64: Drop build and linker script hacks to obtain image code
    size

 Documentation/arch/arm64/booting.rst           |  3 +-
 arch/arm64/boot/Makefile                       |  3 --
 arch/arm64/include/asm/efi.h                   | 11 ++++++
 arch/arm64/include/asm/image.h                 |  4 ++-
 arch/arm64/kernel/efi-header.S                 |  6 ++++
 arch/arm64/kernel/head.S                       |  3 +-
 arch/arm64/kernel/image-vars.h                 |  4 ---
 drivers/firmware/efi/libstub/arm64-stub.c      | 16 +++++++++
 drivers/firmware/efi/libstub/arm64.c           | 13 ++++---
 drivers/firmware/efi/libstub/efi-stub-entry.c  |  8 ++++-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 13 ++++---
 drivers/firmware/efi/libstub/efi-stub.c        |  3 +-
 drivers/firmware/efi/libstub/efistub.h         | 16 +++++++--
 drivers/firmware/efi/libstub/zboot.c           | 36 ++++++++++++++++++--
 drivers/firmware/efi/libstub/zboot.lds         |  7 ----
 15 files changed, 112 insertions(+), 34 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.455.g6c5a503b38-goog

