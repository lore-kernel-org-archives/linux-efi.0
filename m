Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D50836604B
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777261526; cv=none; b=tk5+zh2QhlAYYxxTGY3QsZ05OBwHofkLtroysiWypFYXFJxprakoa2IqX0LSijzoJfVnZNZOOKL1vEgNUxpIy/UauZWL02MDqzi6zZ3RG6eEfc/yYur0BXaWBCD5Rt7cmhqa1u3OauugxjjLhxsz0zBAi1PkOxCOepGf2W0LaC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777261526; c=relaxed/simple;
	bh=SJjBIHnJyopRMGSXdQG1IrX1S846AD36k5xbBYwIWG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwpsOWWBv+T3m0LxuxXz+ugJonyUUwwqUdsYpoaKs75WvNR4DhOuPhR0B5xK5bVtBINbaufK28wpndMZHNmdwkOEFOiE/I16zMJP6azywaejPum7fQTseVn0u0S92XzcIgysieBNXLbRCJrzWSq/c2YpPc8vpkz355o0hnPRoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=lcy/FRhG; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="lcy/FRhG"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35fb166b0c6so5122898a91.0
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 20:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777261524; x=1777866324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R07shkiVuWsLnnERZIMp6yUrzas7HOh6Y70yJzuQ6hA=;
        b=lcy/FRhGY+fTrp1ZU2Xpb6KxPezIcJmAjIEikb7YpMQRbPk8/TqI6uxrHVZ+5CmA0K
         osXqsy0r9vpXwlOZECW0HpWEAhBJwnD/NMpSuIYg+mb+jWxLT7n78603hotZNlfCrjV3
         AZPE1C/NX048i8aVXOd7FEGtjnrvX5vq3zQH653uDFEC3ESgp5WJeSVNWKMx5H+cufP4
         iv8uKMzXNKRfISKxTBC8D7RqNRXsTmdXz0W/FcrBtY0nvOleA/0JW/EsvtoYt0kTU/5l
         wNki6oZt3R8MiiDdtOdQrBVK/qgdnDoFJ4GPXP8jknsa5pBZhQEhYAqYGFtTXYe9N36q
         H6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777261524; x=1777866324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R07shkiVuWsLnnERZIMp6yUrzas7HOh6Y70yJzuQ6hA=;
        b=Z3hXQbEr4bIuZZh6qFLLeG6wTSs22S3Zg/0/G6qoz8/815SmkE5u3oYNwdwWAeOgJL
         doYvamJo45LEtH6R5nPN2hX770Tj3rnAUTHsDtVnMYZIF5X7Z04EXMi3Kj1iSIuBzhXX
         0tiCYw+KcZ8s5TO8p4oAkUzBlKbWuR0zHnbg10YB0Cp7a2F7L4K4xWCbZ/B7sOK8gT3C
         v0bdZJyzAYsKLRYHG2vdk0eg5eXP8opMdgaA3mruMWTJ9MF2jQMOItdzhRtJ+7jUSydF
         hkj/Rn5MGcdXEw+vF9cfujpthXSm2d4ZyKpKeRA4psdZvxmwhAn9dUg5ZgsSiv8gDHcA
         9FFA==
X-Forwarded-Encrypted: i=1; AFNElJ88HJNuVnGRweHafa6c/uKu84sx6r+hbh2SbPHlG8kxIpnlHJBGy9Uke/ACoC/J0pJj4BktfDaqF0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRQLJ6ABFFp7gfhE09X5HV9AR73Ek6KimJso9oU5mjFC8WHJ9T
	Wva+Z0y1aR1ryo0po+g6VthA3GtH1xKy4z+srTwByJmVSbH3F1jK7R3oC1nTATU1luM=
X-Gm-Gg: AeBDievnEDreFHC+L/qLyjIM1RkA/vUQn5UXsO1NoDfKzT4MB6B4/2FUBcGdh4kADck
	+b15KtHn9yAJwzefa+fhqt0zdihq43kT5Y2H1VN/2NW1BXRyXndw/dYqfDFeBEW9eSpAK12oekQ
	JgQAWsXDVF2A1bajOMSxAZ5luCNL9sEtBL2d7h7UJvuEW3yDUbvzDNDV0hdVQmdHpJjDLeMv2PO
	IfAlz5D7NZFnMQ2MeFXsfwTuAcXlBAtyRI4wpsuxtj4dw0GU3bWhhGWFHPiQKFJErxkW+wzH/qB
	cnk2r9rlCguyT2ipBN//K0Z8gRldCJYX33bSa45marpKgvoryoxfLP3zGESvr9KWWQNN2R+KXCZ
	0y/ID/gXVbLWi/5lOUBy3XDeOD9/iiMTtadvSs0lP/Ahk7Qt9NA7kHfv/edP5Cvdu6BVArRbAhK
	8E1ZnKn1y6GK6a+7j57DY=
X-Received: by 2002:a17:90b:17c5:b0:35a:10b6:1208 with SMTP id 98e67ed59e1d1-361402fd6bcmr38690575a91.14.1777261524404;
        Sun, 26 Apr 2026 20:45:24 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3c:3085:4d80:3614:2212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa3073asm279061375ad.27.2026.04.26.20.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 20:45:24 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>
Subject: [PATCH 1/2] efi/loongarch: Implement efi_cache_sync_image
Date: Mon, 27 Apr 2026 11:44:50 +0800
Message-ID: <20260427034451.717817-2-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427034451.717817-1-r@hev.cc>
References: <20260427034451.717817-1-r@hev.cc>
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
---
 drivers/firmware/efi/libstub/loongarch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 9825f5218137..26495747f69f 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -82,3 +82,8 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	real_kernel_entry(true, (unsigned long)cmdline_ptr,
 			  (unsigned long)efi_system_table);
 }
+
+void efi_cache_sync_image(unsigned long image_base, unsigned long alloc_size)
+{
+	asm volatile ("ibar 0" ::: "memory");
+}
-- 
2.54.0

