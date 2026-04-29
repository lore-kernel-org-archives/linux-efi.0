Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126FB3F2109
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 12:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464219; cv=none; b=Vok+/T2BDArzCMXxcogKrhpiujxbk6pAknDhwuCa42G6TrQj/RHargV+gKNI1NOQYCD2qtKHFoA5s7buWVnB0e9A6ULrwfCFJYyPIbVAJ4CS6YHrECadul5PwqAUQ/VAPIC58+VUOpYx7nrbd5ERsMXsjZEK4gWiScCCOjpYyw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464219; c=relaxed/simple;
	bh=stpTmU7S/OiOZ1k50FUfkHZaoNqcsoeBAFBDz9JYs/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GENoxxp0giWI3hCMyTRY/MsXKgyuxOYoTKRaAVj5fAJKvgPO4q1Wg0E53I1qv6avC2R8Mj0lGh22FWL6YF1W05DOhUs5GXInGR1Bfh1OVmJSFD6glZ+lueJdfDh9YJ0QB8WNP+ivMUKr0/ep4Sqf4EWvnxD6MzV33x3my9xLhRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=r8NiZUlH; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="r8NiZUlH"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82f8b60e485so5187931b3a.0
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777464217; x=1778069017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zitPtmtf9h1hodlmn4/XOblxDn0DauzTlzLSukkp4sk=;
        b=r8NiZUlHiOnp7Pfq8RuTv/yfigb676KZdIfqHosAy+5+YONfsPrldEjQ7Cp4QagMQw
         +qJv6DISrgDKifbXc7FqqEyB4ZeCbwzUXfqMR8KIE1ZXgRhQHn0GTyhyjKsRbGbLKYts
         IFomM76OHdOR8MTHtgqeYTUlUKOZyKAbvro8C+LY9qUsKBxi99C61Yq6DbfJDmhDGdGq
         UK0lXkfQ23PNiM0q5h5eHUfUmf8KDGZAEnoIBze/+eYUDxdTZ0hbSlbuKF6NYasXgCek
         N7HY35Oln/ohLRf9qybTLeiSrN2cp7V5zDjIOyuUfO0tSllmAUzS6/oLfOGF90L4HwKZ
         b26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777464217; x=1778069017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zitPtmtf9h1hodlmn4/XOblxDn0DauzTlzLSukkp4sk=;
        b=Jy46eGiCZ211cv2EyKWSlSkx6g0ecSmaK1ODTzLFmjp0NTDgE/HSs7bEuy8AYe/+jf
         ZMkbyklPXJlNpa7zMPcQqSuhWCMpirdew/gSjftwbAm2lDmlGico9Knwxb7cHPiyb0Uq
         7yJu94wNxTn5au3kmzNaXunXspyQGkuXvaeI3SP7JeORxWDw7pNSwQc+Z/hZziXgC72E
         njecMoqMpYJew7D11MAswbWKqHl1WRdSUEai6X/NfO5QB9ppHmkGxNSzDp/ThjwN1MIl
         7xCOL3vQHAHILxxeNFwmccDI/mHws9bRZH366GtGGDZJvgQVVXcwLDRG6uVFd7Nab0PH
         snDA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZYh7zotvMQUya7l0RaZU9GeTIdBpbQHH8HfP459VZ1wuEjYuSTcEJaiVdXqNy8YMkcqfLQA6YwMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoSkyBBrbeBIkiq7Vt50b/9wUipwbmjLyelZp17pI4NeTMQ/Fl
	b4qX8KIJQJzuJTxIS2sOZVG1PijFZQwInbgD2/9JdHOd1KxsTnLgILSttAZK3CKsrHA=
X-Gm-Gg: AeBDieuLp09mGP1LBlvqb45Jt64aCPAOepn+I3bUeEOlM6PR7lC+gcUUHE6mD0s9Lim
	bZsfY604Gpk33xHqwfo4a5LpZb2dr4V2pEcAK/GBlz5sZKdniPBkDq5j3lmtkKo5YdnNxQnGDNW
	7itbB/Rs4oy2DXSiPw00A9S+E52VlC/rb05hy/bLwao1nYzeQX0g14Ua9dEL5zF3QwUXGwj7vzy
	aEoe++FaGJcxT+Lf2XUJbZFvWm4InmaJ8g/rEdmrz2pkg1TEbKBr3BP2qTJ5JMbecER7RVflp/S
	rKi+H5ZQjauRw6yDqfjw3BN88sjyXEvz4G4oAH4OFVP7zWp+EIJ4avKV677C8le2xYfPY8ZOmgX
	m6Ez0OKWYus2FUA4P++RWoMhW76kFddQDU4ktceICTP96+547dwM1f2sFnVH5K35stC+4mSj2tx
	69Br53KIudPyDt8l276A==
X-Received: by 2002:aa7:9067:0:b0:82c:21af:a7bf with SMTP id d2e1a72fcca58-834ddad8bc3mr7310658b3a.13.1777464217056;
        Wed, 29 Apr 2026 05:03:37 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5efaaasm2016493b3a.27.2026.04.29.05.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:03:36 -0700 (PDT)
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
Subject: [PATCH v4 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Date: Wed, 29 Apr 2026 20:02:57 +0800
Message-ID: <20260429120300.1786210-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since [v3]:
  * Minor cleanups based on review comments.

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

[v3]: https://lore.kernel.org/loongarch/20260429051318.1581350-1-r@hev.cc
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

