Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B2539B497
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279193; cv=none; b=s+Vr/nhT6sf0NGNLusi3Z9rb5h6RVDkI/uw/Pb+YsCgFJlq6mECRYvv790K5UB7aRilXumQzRHbz00SDHxip2gEnplqOTxwKVzwY7HnoPb6uhRR76fnxzxBiKDsISxqgw4M0ayRFYnDwwkc/IS4EqFfPXLguDCPaWCiuM9C1rws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279193; c=relaxed/simple;
	bh=8VkYf4oej+1NJIsr42kCIdqMEirKvkfOijKLfIgkJYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i2lEzal4jmvGaawhE1/lLKrBVzC2b2xmvVkxD4i9FkwWEh7t8/zeSfJ9TGLQObSl8DgLrJGdLR4PuwvNlarqy8+abtXttPRjH0mZpZ39jGE0VTzG3nMBfdqU0/O9oomRvpbHqeGD7Szu67U0Qy2oeLIHgDq6F92TgQGrP1LHJPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=TA2HuvVD; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="TA2HuvVD"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so6504141a91.2
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777279191; x=1777883991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l2khddAE4U1nIPfkSKNCb9MwtuVNtnWHE+Vf+vbXZFk=;
        b=TA2HuvVDRrTqqVVTJKkfhGfaQUO+D1SHd/IimW7YT84WR38XiSx6aH2ER+y4fbesna
         QZ2Oqng59H57izRZqNdkHun/y9DioBHLWERzt1Ksp/MqNQvPNddopqItQmTBuxhSn0ZD
         wzSS9tqQYyqo5lgkmj7vUkz5gRlS0IuxvOZoSTsn3rbNy3aM9fqHW9cQaC+xgqdA2sGJ
         Pgu8NHV9zS61mlJuuJ0eVgFRyXsECD8gC4Zz2Ln+j4mAtmTN0wlLybgNpFzVPtbgMKeH
         aFbyqRR9BzHNMWQfd4mfJZhclvkaefhGyUTTyunQT/cl2uGPtN+H+wsR7sVBFvqb6bJR
         ZJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279191; x=1777883991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2khddAE4U1nIPfkSKNCb9MwtuVNtnWHE+Vf+vbXZFk=;
        b=a34GpprEvHMWgEeCVbeQcj/h6GPYJ7k4Sjok30fnSGj32qk2cQd+6Weegw8uwA3CLS
         /F0EyGjpwXs2aVAMnKVSb4vzdZxvwESd81ISUaPOytuQAH2VrxdxPkxAPq1FC011uS9j
         6VzUj6Hf2W0UNb0O1IBAJLa2tJBtpj2rk8sqOuW4Mi3JH3IKVMar/U6TyM3HlppWtvQJ
         vRPjl6nRgc7tdTG4+kMmJWV7WQIagpPFxbCs8BoqJXstc/GmV1h/3giy1vXJays5J9xQ
         PdIZaEeBJe3+bB6iV/uOuwmzngQIMVJoYxqvYdWP3hB8zGaE0/uOioiQY0L2LV6MKaCh
         xRvg==
X-Forwarded-Encrypted: i=1; AFNElJ9qAq6bMaEAqFKL2RntcU6dXIQi4eRyfR0pXL0uccRd6V5Qp175QEcLNCvfJ+pFmotaY2tsKxzDThU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN8jx/wUOLFdPgdiLxVrrS60yVVvZ9TVgNo63FXT+QW++zPWoV
	aJX3EXl17mJLtxCpQAexVjGjH7n9HHYYuCD+ynD2rwT/YVuzTDhWkkB5xmBT3Hyj4PuuwTRT2eX
	IX9/N
X-Gm-Gg: AeBDieuuvN/5LIILRnLOdTrMU/wCsaXj35zigXXh0sE385Li/8Vw+sUc+BDmne4Ow6z
	bEN7pTM1/9bsVGkhCxeJoNbgnsbztX2WhomVGlNkN7MP51u2z7PfYVj8tjktvW8OeEzfKYP+dE6
	L1RijGml7b6esrorN6HP+dn7sOgOOdyZiSgQBasu+CvfDw5Orj5zajqL4SbG7W/sH5OKJKbQYWT
	SSYVLnss/mkEmsWpYGxmzWMqAU3OVFOijLOoqP1PEKRvgkMIS7WBtMsrlJZ9YsVFX2JsSvCBK4T
	EYwa/i8FYKF6q5JXqnzqIl5mKbCGVYp6akfkERFMZTY2Y8N+/uwoUqMSBqmOFktOA5i+IyyObnb
	b4Nj4EXHTjpq5TWfkFWe9AJESyPaVzZwRl5gH7/lfLasjTMaphlkupAOhEr90SyT2b7nRuRRrUD
	3iQeR8uaeg0gc=
X-Received: by 2002:a17:90b:350f:b0:359:8e5e:43de with SMTP id 98e67ed59e1d1-3614049358emr44701147a91.22.1777279191383;
        Mon, 27 Apr 2026 01:39:51 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4049bsm276063105ad.77.2026.04.27.01.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:39:51 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>
Subject: [PATCH v2 0/2] efi/libstub: Ensure instruction cache coherency after kernel relocation
Date: Mon, 27 Apr 2026 16:39:28 +0800
Message-ID: <20260427083930.36324-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since [v1]:
  * Move efi_cache_sync_image() after check_platform_features(), matching arm64.

The EFI stub relocates the kernel image by copying it to a new memory
location using memcpy(). On architectures where the instruction and data
caches are not automatically coherent, the copied instructions may not be
visible to the instruction fetch unit without explicit cache maintenance.

This series adds the missing call to efi_cache_sync_image() in the generic
relocation path, and provides a LoongArch implementation using the ibar
instruction to ensure instruction fetches observe the updated contents.

[v1]: https://lore.kernel.org/loongarch/20260427034451.717817-1-r@hev.cc

WANG Rui (2):
  efi/loongarch: Implement efi_cache_sync_image
  efi/libstub: Synchronize instruction cache after kernel relocation

 drivers/firmware/efi/libstub/loongarch.c | 5 +++++
 drivers/firmware/efi/libstub/relocate.c  | 1 +
 2 files changed, 6 insertions(+)

-- 
2.54.0

