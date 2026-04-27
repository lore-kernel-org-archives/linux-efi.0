Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE6639BFF4
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279196; cv=none; b=RGMEpeQo9tyrMN/IiIFXti9N4TXckJfAD4u+CMI7Tnd31YFpXJMtM8s3PclG9L/EkRhUhanIUebn+9Bv9RA3LvH7ena21v15IzL9cHwq1VLa8ZJzYfjafj22REmpGLC0Npx4i3EhcdjoT5cOsm39uUoq42MRvvcDL2XW8Reftwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279196; c=relaxed/simple;
	bh=UFnN0s+RsvkTALfr/a8OQyrxAQCThTQXJhV/kjv+G6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMZ+fBVjQhG3hIgoePxRgJmzuGild5Xn7CGzjNt0+5ducpRaGySVCnkIDiWpOa6pOi/kRdpSvZMeczXl0Hi54ydqx6qLfYpIilYI9SJeWBRXYfO3faM3C9jIfFl6H8Zm2lTCZGW6OwCJuHhMfnBh2wUyxI2xVX/Ya9k5XOkbIXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=Ba/MBmRq; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="Ba/MBmRq"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad9f316d68so43616255ad.2
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777279194; x=1777883994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKHydH/fhv4hYoRFTuRlPVbogNTqYgaWcyoMFBpB6F8=;
        b=Ba/MBmRq/leiVFj0LKsCsplbyRjd/iqCmsszhOm9wtzgUT19ev1MCzF4y3en2pxBFb
         HbiDv9UU/Bp6Oi+O3WxsXIt4UqHquYzEhk1SfJJW88JLKiAYEQuIQ+ELetoP63dOQkzS
         J1fSWoN4cjllinPzMR1tUijL9d66lNeuF8on1J2p4C24ftgDkfxogBBqtu+1esmaGHbx
         6BILtnC12K5oZluDxSmq4hwRqUGEKtNi+MK/1X3DdV6Uve7nB60Iu6EPyhd6HUfjtxfJ
         gL5bpI9xn6uqH9CT06oCENdDHAox4TloN/qY406ysS76V8cByi4SummUDa78YV+DvGPg
         IVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279194; x=1777883994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oKHydH/fhv4hYoRFTuRlPVbogNTqYgaWcyoMFBpB6F8=;
        b=pw5Gh+J5w7Etb5Y3lOL9wx4vQgLBmro1Tte7OuM9U8+P514VCzcA4UQ4MkU39s0gSe
         ox1X6/entPvOyPsMq5BD3H+z67ByUyIDwyaxi/Ljo891mH4M2m3lXzgEaA1jl2Lb/69J
         DkgiXoUPb8yrQ/sb6tDRTZUzvqvy3TJP0eoyOZSqTaHDvSEBfJ0u7Od13rpo7+eQKRrh
         5n2CAhceGTD2xf7dxNi6HpO5AXPV8tSan5+lHiE4vk3/qR7lQQPDPwZBCr1AR6BKLgi0
         qCJzd7Fu78l9B4Y+ZktgQqGZbn9D3HjJcLOI4MPQTaRyas5IZUo8SfeHCkrBPvpuzjWL
         6TMA==
X-Forwarded-Encrypted: i=1; AFNElJ+RPreHWSeEgIEK3FNLtyQcAFbxuwRQZsqq4y+K5heBL3yxiO+c4EkU24yd1FPM6/ajw7FFJYX4lAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZYG0K2hn2WRO1FJPzmWCVR5CDMu/3HLtocacGhUvhWTwGGoBV
	zhevu8pOUt+3XjhYiRbcxbXf58TqWzDJdc6rp+QDPgCbQ2QCDZbGn0FhqG7kJOvIKvk=
X-Gm-Gg: AeBDietqde9yzhbWaetiBlxfizdAilYEhs18AwyIJswL2y1MxKsODxshX2rs3zUnpal
	XaFItPXI44AO+iBWtLGCtxyERdprTjsOboHPmryZeUAuLbQXeh7i1LPOczhZYbof6tGIOFdGr+J
	7HAGyHy/wlVZBhhGnzSST/1yWEDG3NryqYsKljVJZImu8ydNplJ3vLxJ7gZCybEoES/OmZVNiZO
	nBlRf0pAeBQG2HDRsv7t3CwkygOQy1xPk/s3E+Z05ZX0gNoOosMfazyetgfnxKESAPlIbF3kKci
	+s0NblZL5w/Z7aF48mJRLHVbavUQqpufw3u0PJ2uBZC2naBDm7dzdVvnASvskiqYKIEjkwmg6LN
	1TVhe+p9828sFITX+hhbHkFxEgiacvyOOvRpy5vkwiT1prI2HIcWVT1V6siNKb/dzNnOr8UHvr0
	aDXo6hJnEKI8Y=
X-Received: by 2002:a17:903:28f:b0:2b4:5309:2c14 with SMTP id d9443c01a7336-2b5f9f3ad64mr471009225ad.31.1777279194102;
        Mon, 27 Apr 2026 01:39:54 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4049bsm276063105ad.77.2026.04.27.01.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:39:53 -0700 (PDT)
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
Subject: [PATCH v2 1/2] efi/loongarch: Implement efi_cache_sync_image
Date: Mon, 27 Apr 2026 16:39:29 +0800
Message-ID: <20260427083930.36324-2-r@hev.cc>
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

Provide a LoongArch implementation of efi_cache_sync_image() to ensure
instruction cache coherency after the kernel image is relocated.

Signed-off-by: WANG Rui <r@hev.cc>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/firmware/efi/libstub/loongarch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 9825f5218137..f7938d5c196a 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -18,6 +18,11 @@ efi_status_t check_platform_features(void)
 	return EFI_SUCCESS;
 }
 
+void efi_cache_sync_image(unsigned long image_base, unsigned long alloc_size)
+{
+	asm volatile ("ibar 0" ::: "memory");
+}
+
 struct exit_boot_struct {
 	efi_memory_desc_t	*runtime_map;
 	int			runtime_entry_count;
-- 
2.54.0

