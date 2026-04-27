Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6D21C862F
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 10:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286861; cv=none; b=e06KtJwwG8pTp5hZs3tQzai1uFB+1ynkrzDPS+xRPzoTqdciPqDxgYid25gbqyJB8miKRDS+4Ho/HdqZ6OTGSP6ODQDSmG1EMT2aZj5zB4VokvgX1sPd9HWHaYD9zcWHywq5QYPQP+JTHpGN1Lf+AvBCoQ4r0t98NGS5jmv3EzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286861; c=relaxed/simple;
	bh=kcLRKUt6VV+0E3c3aZ/Ze6zUJANaEPNPvyoBX7yqlW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pdjq9O4LBNQRGLhUs8vd2MU+TEgIABN4zTIcEP3t1gW/dgBUx++3aaZ/IgO9EaNtbG310xEJ/qu7T6J7i3epoRTqxsY2E3AB9f89hgd/BsRYDvEu+R0L7jGYTqW5bHycz/o2ZKC7fJrAP5zh8S5O5ZfiO2z+K0lPRBryLjJgHHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=stCYQSV9; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="stCYQSV9"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so4704219a91.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777286858; x=1777891658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qBaDcbNtNJIr+4BqFmEontn2SIWukKG96vRmR4j4yIo=;
        b=stCYQSV9hkPxQhI+Myt4TEvFWF3v49NkFTjBnBn1L8k3TqQ1i2uWAc2H8b3p29hC00
         YAYbSqG39Bl2xDICdcRH8QeOcxRQZodHfiB+ZQMAyhuzM/IFHPs5HUMhahKG6WYZ4QfS
         EssjP2qgwdGmg2VHJ9DW6do6J8uMbLDlnFSGaeveeDn6rMRIQZq1yafuORhkceOqAfto
         0zrfTbYxbNuZnho3sXxjRL0+C19F4snygWKmwLlvMdVN1YR23sXHTJG9dexaHf0F004y
         eDrv5sRZOfgZ153IerG1o3WXLHct4t5jJW4PjdGDqu6ph8Tu2VJgoPGRQCZPu9PkXTge
         3byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777286858; x=1777891658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBaDcbNtNJIr+4BqFmEontn2SIWukKG96vRmR4j4yIo=;
        b=hPY6PQCES1rAJ2y8RT6pw4t2N8/acSe/C7O+IWz2iqCubD+tcieaB1ItBMNiLcTv5j
         2+iS9PiOZSrgBJTC21K824cAo+8jq0sT1mBYGg8+C2O9h/OZh8pkk76JMLms6nBYr6NX
         JzAYLtzOcmNitwXqXBdZGxsCdCK7JDFnvi8Jg8uNzt1xSWF5fwHt921naM90ADVnj1P9
         EE+7qLEfCeICetob24oz7vpcvT/vQUKkdlyZ6QDRJ+ntWo+gI3qgX//NHBX0dIKbTXh+
         xwHl9gF6YUaOj9a8JBn0QEh8TBmJ0LyO/7JuFMinv+1qFuQgzn5OHftDDrZnfk8R3MLn
         Z9Bg==
X-Forwarded-Encrypted: i=1; AFNElJ+YDK5vhdVMjhAmn/lqDQNn1im3WFBsr068ceug+Md2dOjzgOgW4m7qWCMUlmhQG67o3iwttmNe6q8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQxIiCXtAt0LbzCCf2vvn4neo6omVZ6xa9xb4wIL+oDKDUiCGW
	3jsLXNRei/d058lmVufgvtaco0DQ6HLLo9JsPHCYLNgiOPRpuEAYduFICF1xYKxT2os=
X-Gm-Gg: AeBDievLkrPzEhPkqHPVlYVbJ5AL2C7+qCLLYspE98FoKJsUrtTnBztyjZJfDYKhzu6
	bNQ5RNN6dHdM3mkKhM6Ax8DCqk6hdeLhWT81XfWvq6ICoFA8Hj+omFgpEEe93s/sUbi5B9QFjlt
	ER+pGsTIQGrJHj5R2fDmSJRmU17M3IrpiPeKt5Eiuog6Y0AP649OXKolw5VIF9nqoxftrH2kQ7t
	uMbvO8Hg336cb4nW6E86Ktbe2iVv2gEMVqFdNqwLdeLJfaAm9j4lp1zIQ+eLFHwh8xziKEPxTzA
	Eksqt8hY/O0HQD80okrdnHUwvwNcX/o51REPz1cNWFNBUScYdWIjiRqB6mcU85Csh4+B35J4lRW
	kTypT0uG39ATPMYsds4TL3kc9XX19G/RM1ACYN6dqPSBpSpilq/GYVosJW7TImgukkX29q3PUha
	5gJnW9gWKlKSA=
X-Received: by 2002:a17:90b:1846:b0:35f:c796:ca5f with SMTP id 98e67ed59e1d1-3614047a264mr45414490a91.19.1777286858194;
        Mon, 27 Apr 2026 03:47:38 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362dde4ccbfsm16227029a91.1.2026.04.27.03.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 03:47:37 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Date: Mon, 27 Apr 2026 18:47:18 +0800
Message-ID: <20260427104721.47724-1-r@hev.cc>
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
  LoongArch: Allow rdtime_h() and rdtime_l() in 64-bit builds
  efi/loongarch: Randomize kernel preferred address for KASLR
  LoongArch: Skip relocation-time KASLR if it has already been applied

 arch/loongarch/Kconfig                   |  2 +-
 arch/loongarch/include/asm/efi.h         |  4 +++-
 arch/loongarch/include/asm/loongarch.h   |  6 ------
 arch/loongarch/kernel/relocate.c         |  4 ++++
 drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
 5 files changed, 24 insertions(+), 8 deletions(-)

-- 
2.54.0

