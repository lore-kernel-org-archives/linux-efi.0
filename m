Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AAA17C211
	for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 12:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777204972; cv=none; b=in+TB++2c2+1apg6VFn3486k9EUC/dtLs5yRJNzJCF5rYtLEAWrj5dQfSA+DSiHKoGtUqoY5CzxTvgFAaY7sDSJmyCplkKmQbAIkOEB3pp/nakLq1Sf14UI/JgThFdiLzj/EZyJipuPhqv2G6xcP60m/Q6cvQvS0O0Ai3H2DI/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777204972; c=relaxed/simple;
	bh=kRcVXv28tDnvQzXVvyODGNAJffBkNrvU5IYCATY2cz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WcgoqQDmhkTJ6DhjX+7/ReIazdSGo1Vivg8qw0dJOd72f36CBfLoG+ErZqcKNkt1VI87zO+sViVlkruM2XhOuX9APQU9/07J34mgu4UOeQHg8nOwKnVyUbZ/QiEwphBe8bETaD6hEFg7oezj4o/h9wyO+UWXbo+C4Er89eqTu9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=plQjYQCa; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="plQjYQCa"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so8043464a91.2
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 05:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777204971; x=1777809771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ghTQEcleXWHPOaZ8rEPzzwQ8WxO8nfCzXA22IKrt/r4=;
        b=plQjYQCal9QP/HPHUzd8kKSgOxJR2z7EqWHpBR0hkvnIt+3GJtDv6JaSd2zT55t0xm
         xp4TLNvaFeK69KqL99Acyk+Vq0/8dTBSIHh25fPftO5/kT/btGk6SA3j0Jo/ufkCffnX
         9ImyTDAAV15vQ69PJHRoK+TPYy1QDAjAlN6jYz1FvvURO70d6ZIZHOiKlH65a/SQdbpP
         hZ6zghIP0Wn9yJlvfTDIDIlccovMQYYrgll80490riT6rlw6/dtwPOUUm89vIggHnMn+
         hhExnRmGhdbjffGCoWZxCHy8CFWCgJvqTBdfXrsUNGZFdqEB/7ScuKbAUJ8D3ZT3acXc
         /aCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777204971; x=1777809771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghTQEcleXWHPOaZ8rEPzzwQ8WxO8nfCzXA22IKrt/r4=;
        b=FPcPCx3JKHJmq3taheAgoZn3DlpznomBHjFlir79hi49+eD/KqxMVs+ONA+wiWwEee
         +2VzFU13GyBmw6kBpZqGLu16khoK0l5MhGMGIEsgziS+W046yBlKkZmb6HM40BA6zGh8
         9DU9oJ46+hR/Ye0124vBuOTrEUWAQ8BFzVc9/v9rGv2cudtaPSLV7584nHqYSx9C1H1F
         NLFkuJZK9+kAVDFzv20wpc5OkRhHH5TQpj82PvU3JYFdTyHNJiR5cprxBB/28iEQiyJv
         KPdkmWXBF7t3zEuPIO7UZB/zqCT+fKfjD/MU/fuuOp9QEtOU/3VWVEUW+nCwTM7K7me7
         I0lQ==
X-Forwarded-Encrypted: i=1; AFNElJ/BvVD29/2U/5O2Npz6nUXlfMH/sb+WXu5ZSlfUFfDonDwtoFOVBswM95G4N0W8uRGb7/c/rL3uYXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMcrNR8mXj9RpB5V3a6SfGFamv/w9GPD6AMegBYlN4P87/kB13
	ptUUQXa6bSw6ogqB6xkC2VSMOU8y4tCq76K50UA5hYsvXgDgNZv8MEoghf1Xyc8k5LEIGpG6keC
	yFo5K
X-Gm-Gg: AeBDieudxpE3qYYBjGzuAQsTktUP+P/dXLNoZi6uO8cbupeNP7g2p3b9h2DCKHGCX3W
	i+TRHP2CT/9gftOqYg+S7au9uYCyqtPJN3r5VcVr/rmmoQQVS3wZ5ayqOx5IHzSV9OSq70ZgO0F
	5R2skSin3ecnd+9xMh1pEm4X5/TBsK5EHpZIdjrOWebbjurYbMJR2FdOTKFYpvqrum00feS0Eux
	WOMfqV73rW3b4A6aMRGx/kDLU/W8/5JXlKlTZrkZm2SqExSvKAxGFYgiU0OhdOwH6XhZTw8LXWK
	JsRB5VIRP6E+46H9idOwuodCE55mDaNzEKgHiq+4OYrdopX5po5M7S6PY3l/TiRtElIPxPKk3XG
	atzxs8QTwTKWUixNmv3u3eWSLTuRGfyBO0cXtvAQxhTtgAyL9QgwQFOdbjygfDrslWBBGvXRhnl
	ES9E14fC/uiZ3jAt0zpQc=
X-Received: by 2002:a17:90b:1dc2:b0:35f:b306:5d47 with SMTP id 98e67ed59e1d1-361403af9c4mr41043913a91.1.1777204970795;
        Sun, 26 Apr 2026 05:02:50 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3c:3085:4d80:3614:2212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab297c8sm263413965ad.67.2026.04.26.05.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 05:02:50 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [RFC PATCH 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Date: Sun, 26 Apr 2026 20:02:28 +0800
Message-ID: <20260426120231.532644-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

WANG Rui (3):
  LoongArch: Allow rdtime_h and rdtime_l in 64-bit builds
  efi/loongarch: Randomize kernel preferred address for KASLR
  LoongArch: Remove KASLR handling from relocate_kernel()

 arch/loongarch/include/asm/efi.h         |   4 +-
 arch/loongarch/include/asm/loongarch.h   |   6 -
 arch/loongarch/include/asm/setup.h       |   2 +-
 arch/loongarch/kernel/head.S             |  12 --
 arch/loongarch/kernel/relocate.c         | 182 +----------------------
 drivers/firmware/efi/libstub/loongarch.c |  15 ++
 6 files changed, 24 insertions(+), 197 deletions(-)

-- 
2.54.0

