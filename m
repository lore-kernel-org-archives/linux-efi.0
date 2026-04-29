Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D2433A716
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439640; cv=none; b=Snco4/RrGpIRIKic9OEZnYsxr1hudO/wSppdgD32q3lXEuhjbU5gwRwbChvBtlyKhW8APvYPcR5Fbrlc5pnxg3I8IoTsy+KaaX4T7/FuxZADm6A8/zNuyrz6SvQRF9V/KvBzFoMZt8eH17MNLUzjX4aSdnhmbGe/TXCMNfi419Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439640; c=relaxed/simple;
	bh=fLx7XKHTHH6UDvhEAPenncyVd6XtMyelO2DdvXwhRGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NWuDr4xOB9BFfJlX2H/z9jK5n0CttmvDyJHCaQe5G7niEBCVL9Zt8+ZIf/oSDXbmuMib/fjpLtiKGbniyKLH0ZSCsbkS3EznaMPom6GbzgJ9XinPkVFx2E0cbczjqdJnYSIRAOJ9zkq4mujW4nZiUlCwl3anNtEOZxeU/P2DIpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=fioWP+r6; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="fioWP+r6"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so5769222a91.0
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 22:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777439639; x=1778044439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bM1p8teMQ8tc32DGf5XZZMDcKwPJm9rYVZ05iIFpvhU=;
        b=fioWP+r6gaWKHVW/jjMdZ/aEi5L8jQF+p1+WY/YDf8L7Z5o+xIWGPVgDgrT95WxgNw
         7ClK9jnFJKFcYMOCAKM7BqbVnm//hfjHqjb3oQdvsyhzmjO/ewtrYJkG+ipFjMQABwat
         spf2sJgOyftjFzML4S0o/E22d6scICnm/TeIJp3YO0SKA4NtlmHQ6RIgKLnr5sHhNLMs
         1m8YZ28CdY0lq7k0jk8aKqCSu7YVEsJh59QmFJqLyLUgPC6Fu2WKEfNzNaAeuVL2gfBc
         yZaCiqiYsS8rSIgJGmz6S4IJCfN13SWqBP8v1ZucikGJH8iW3/FTsUqKCcWMB1JXmyW5
         Td/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777439639; x=1778044439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bM1p8teMQ8tc32DGf5XZZMDcKwPJm9rYVZ05iIFpvhU=;
        b=Ed9LtXgNu/6Zy73xWXRtXs5SSvyChB4Uq90Z2tGDY0Po6krnpFDH58i5GBv6xqaeEQ
         FRFoeSnOJGzD//DWuwBUQDd6w0F4s11sjhsg06V7Kvh3+93QPRO2E1eAtlt04I8CgfSX
         DYXI9PsJ7K6/yVE18idjsOYYkRygUHCRcvqhMuJge72ZSjDpOPSfbIUYLpNv9TaMqHEm
         nNASEl5maxpPtqADn8NX0F9eN85iU5wZNNmLarOZqV1SGPQgb8i4j7znTIg0bqxMnM5Z
         XRQsKPCN8AZbDBkAVZJUc0Fb5d7vZWmYGb2AI5TLfDPhPU1MmBGVBZtyK+A71y8NmY0W
         jVWg==
X-Forwarded-Encrypted: i=1; AFNElJ+/yOGgQeBi5UmHdCd4u/fTHXj8I83HTWG6jVmHzwoGFIwKhP1/Fm7t8hXEwGcggPztb6e9I69Jxqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdOqxl+5GJHRiS5uHN4WolQRt6LRCSVVMcoW51urf2a9hHF8OY
	SBU36WlEqNNX7L4ALEkCXJOiZDf3MYJuOsQMqDDnwKdwpjDkHMreVkF/Otumd4HJAAgsJ/4UPyN
	gOFtXkY0=
X-Gm-Gg: AeBDievIpfJlhkRLWpC79a8oyAL8u3ecGMvuLTOERQ020hJ9hA4yvBD8SwBw4c0fp90
	SpAO8NC67xN2A6z5ztpnn3NDv0jabW2pgTYLKoq/nFslgAc9hB5FOtj5TjSTU6RlHVPUX9oZz4e
	rqhIISwcwaTwXH60I83pwkXVbYlp9mZlWU5aM7Jwpk5OOOCUbg7f8NmCmqTL5vx9vBVW5NsVsU8
	aHteMIP6t9OoUwtF3P6vhmU31126p0/fHjTj6tsLEicZzGweGRy9or2VQ/ahcY818c+6q0J1bH9
	zFCOFC+y+AZkfB92DnlP/LjrbOmQBUA8iQadnY92/EgRWz5eTknBOJp16QUvIVEMbEZyEKyY7BB
	JjrOjKSme0OsezniuwYA34HptkjBPrDk5+WQz+1cJaVCKetJcYEtge54vQRmFGYVeZU+7Knd63V
	E1Hi7Wy4FRzeTcG7Hb6g==
X-Received: by 2002:a17:903:1b66:b0:2ae:8253:1452 with SMTP id d9443c01a7336-2b98734184amr21843565ad.11.1777439638849;
        Tue, 28 Apr 2026 22:13:58 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988787360sm8846935ad.20.2026.04.28.22.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 22:13:58 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Lisa Robinson <lisa@bytefly.space>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v3 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Date: Wed, 29 Apr 2026 13:13:15 +0800
Message-ID: <20260429051318.1581350-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since [v2]:
  * Add a new patch to prevent initrd overlap during relocation.
  * Revert changes to the CONFIG_RANDOMIZE_BASE_MAX_OFFSET range.

Changes since [v1]:
  * Drop the patch "LoongArch: Allow rdtime_h() and rdtime_l() in 64-bit builds".
  * Use random_get_entropy() instead of rdtime_l().

This series addresses a potential overlap issue between the kernel
image and the initrd when KASLR is enabled.

In the normal boot flow, the bootloader is responsible for loading
both vmlinux and the initrd, and it can guarantee that the two do
not overlap in memory. However, this assumption only holds as long
as neither image changes its location afterwards.

The in-kernel KASLR implementation breaks that assumption. When the
initrd is placed close to the kernel image, randomizing the kernel
location at runtime may move it into the initrd region, leading to
memory corruption early during boot.

To fix this, this series moves the KASLR logic out of the kernel
proper and into the EFI stub. With this change, the final placement
of both the kernel image and the initrd is determined by the EFI
memory allocator. This ensures that the two allocations are
coordinated and cannot overlap.

Functionally, the kernel still supports KASLR as before, but the
randomization now happens before the kernel is entered, rather than
during early kernel relocation.

[v2]: https://lore.kernel.org/loongarch/20260428040159.1065822-1-r@hev.cc
[v1]: https://lore.kernel.org/loongarch/20260427104721.47724-1-r@hev.cc

WANG Rui (3):
  efi/loongarch: Randomize kernel preferred address for KASLR
  LoongArch: Skip relocation-time KASLR if it has already been applied
  LoongArch: Avoid initrd overlap during kernel relocation

 arch/loongarch/include/asm/efi.h         |  4 +-
 arch/loongarch/kernel/relocate.c         | 49 ++++++++++++++++++++++++
 drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)

-- 
2.54.0

