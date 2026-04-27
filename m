Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603E363090
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777261528; cv=none; b=CPwaHGua6st9a54kceMrHxvsQyqBjrgRNlgt8B79SCRpg5vtpKAEj6Ps0BGWWq4gKkcDZWh72Mymm+mfWLlDLPzd+aBGGJv7vTppq3VszWUH4DrH1jsCoDcbIK6If9vzyj0R8RTKe9/ZjD9VW3o7KNWH+J4W/VrbgQRSWGkcn0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777261528; c=relaxed/simple;
	bh=GQxbjViAq937qxPVb6aK5SarlLun1y1QS/zeWJMo7J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3YIefn/kw1P9E0LemCnJ6WefiD8wMRIxCcU9xKWpran1PkzxKLm0x66DnEDoeunvAxMLEvhuy/zM/RLmfnLDT1EGeBzeKxAb1U5vLplLTsQ+uVvdDf3+QMlq8FpJDMN09N+8GN1yywaWEiBiA/UcFehOjhQBJ4jZkVVXH3+3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=GPX4GEVF; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="GPX4GEVF"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35fc258aaa4so5954869a91.2
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 20:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777261527; x=1777866327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yj2Ks0SGF50ciVTp9OSJTi2f/jET1S92yU/1nIOqmmo=;
        b=GPX4GEVFiL9r8/4T/ByYSi38ykhm3O6A4s1Rkwd7NwFXLnvUj3XU/yIegVGgGE13tq
         Sb/j/OItZ/3kLF1u1qqgpp32+DiVeO/8geJx98rs8QWzNP47JLp1lbXR2N4ynokwPzWi
         0OzYovd+WH5QxL3QBxvB2ub4NbEaSU5QMXIw3Y9PQD6+er7o0BCZms7yefe+/XxBtyuI
         m2gva+aHlVoMquWt0NR1l/8nOzk+dWLXRlNTjHE0tU+IvsLAa18C5viDqToNvW1SOqr+
         XJRA+eYF+A0yN8tn6UsO2IhgvHTK4YnxLMEkOqKRBGUCLkOobbgD5WNqt/jq6aEXKQ8Q
         nO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777261527; x=1777866327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yj2Ks0SGF50ciVTp9OSJTi2f/jET1S92yU/1nIOqmmo=;
        b=pRSwGLefajo6ygGIARFZsjpL8Es+mfHrpsYwyWl8JGDf+s3Fhx0B/Ye5mfB0W6gZsn
         Zvr/LbSPB9oiyWdoKPnL9dSt1QQ32PHsUXvHw05Xdu+gX5R7w/gB5pDySgN8n2DmPxWh
         JQEYYLQy0MnTjsl8C1AQ9Yqz9AwaXGxN63VRVANb1cF36pgyiT/v3B+UZtXcIZxnEza9
         BGFgN4RvgBMHarhhWMQpHZxBxf09p0ufbq9AvXYXPvBqz5RCkkndO8DuxODEsnYG27mc
         E6QxBLGe8nZA8IQn6tmhG3XDFINB8Uv1Q9AuGuoMitaWkKBjXvBSy9Hx+cfenLv362nW
         lN4A==
X-Forwarded-Encrypted: i=1; AFNElJ+zSr8AhTy1tNTnPMkOCD+iwjANogN1uyhppK0gMRfzdLsoyddNxqeIfJl2VUX74DfdITEW38kmR+E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7kWMt49QFCZa2/R+Ku/dXh9ooJVMiMMiJY2FRz376J+SnJR4Y
	8TNBDpbQN5R2zc0/kxzNPGQoNk2Ya+NJ49cxG2tqh2+1saPJ2uTnRmdbtkNsHhYBhhY=
X-Gm-Gg: AeBDiesqNc1lj/4s+vTOrePQJ9UHyIGfzgN+g5MxInsJuoDlZhL3CawCBCp2cQGnv+j
	JXXe+3VlZmK+D8S962BwTFlxDe0Sukh4j5md9tjasSWTUMrdzCEh3pT00Pw9Gvqhu7jJHMQSS88
	hHbiTrkjou4oFAdqgSNv0m6nurnSH+HW9hz4ZX0CIf+JAVGZkKB53AkJqYqhI9Xzc49HupVyqg4
	BO7RUhyQZgYtfm9GD19SSHs+09zYnjwX71hATpzWHE8tElZpXAhzHolmWoAgJ/5UA0czZXAbexW
	uVQIpMvMJe31fzY97qrxG8CqQiCU97X3wWxqwDX9ZX1HVooZ7oUkypQnWSYuhdJUV/ca5dwk6Ph
	K6jNqlBo0CeM6P+Li3fpwubX8BV6VdvRmftHh0Iz5Vn9W/yNKl8EXtJNOtQgYz+TDjDEcLXmyhL
	d5zegwdbM+X27JVuDsWDk=
X-Received: by 2002:a17:90a:74f:b0:361:4720:af84 with SMTP id 98e67ed59e1d1-3614720b0e4mr27755933a91.20.1777261527135;
        Sun, 26 Apr 2026 20:45:27 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3c:3085:4d80:3614:2212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa3073asm279061375ad.27.2026.04.26.20.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 20:45:26 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>
Subject: [PATCH 2/2] efi/libstub: Synchronize instruction cache after kernel relocation
Date: Mon, 27 Apr 2026 11:44:51 +0800
Message-ID: <20260427034451.717817-3-r@hev.cc>
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

The relocated kernel image is copied to its new location using memcpy().
On architectures with separate instruction and data caches, the copied
instructions may remain stale in the instruction cache, leading to the
execution of outdated contents.

Call efi_cache_sync_image() after the relocation copy to ensure the
instruction cache is synchronized with the updated memory contents before
control is transferred to the relocated kernel.

Signed-off-by: WANG Rui <r@hev.cc>
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

