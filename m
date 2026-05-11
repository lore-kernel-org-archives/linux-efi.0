Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E233D9043
	for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 10:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496399; cv=none; b=mitOlcyRajI0Uado6hvAjmkKdGcGEnirxF4T8YRAf7mActZRrfWxvsPa+5on/lynT9cPQHHx6yi58wqAoW9TFgHTL6mzuqXWQDBh2uqcYBhAftMnVGcPWp1eSI7Xky/lv/ITB0q1dWWEnsHwLrgCe72xp7J4SsoPgpu/w+Bhero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496399; c=relaxed/simple;
	bh=Y5mUbefp9XBFg6fpQ787wEyH+xfV2Y7Jsw0fmz0xXRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kTlsbOGVR1ya+3cvWcwUnH9tXnhb2i+oj4LtcWLHYNXz63xCK2d9RfaxGn7FdfGoCth1iYAJ0Ib+CfCr7SGs36+wVzNhuATN7+QpGeOScAv9eYZtnKRLxrKT5b/BRxePAVVgem+8UT2jEtIm2UkO4fwhPr8h2AYGCTA1QYMNaXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=M3i02A0g; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="M3i02A0g"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82748257f5fso3048970b3a.1
        for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 03:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1778496396; x=1779101196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HkqpHwr57m2TFfldzHKpZdrF2VStUjZkl//5CCmr3Dc=;
        b=M3i02A0gvfvLhkzU9/PTtWf1vGngR0Vx6YLidbVldeXHSdopgzIjZZZsn+/xij9Tet
         pykihI8whhvNY74oGw0ov3yp+fdiIH1CoAwWrP7KSg4Wxnfh75UFV2TEA0ad1kOV7egu
         9CPSehPXPGQSMCedDB8JEs29fqlNAvCSVq4SRFzUZXRCFwzngTTcLig8WfbOmskKqKVs
         6dQ6AcUPKZQHImq6ZRV5fjlEBsj8b9FAzw4vY27cLM0bRzeFxpW0Jtw+8a3siOzhYVE9
         EM5jnlrSln2dsIELRc97hJ8hf/32C6hGkddbAJd7AjBi8j459+fTxV78UKS7qNdZFCAg
         j9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496396; x=1779101196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkqpHwr57m2TFfldzHKpZdrF2VStUjZkl//5CCmr3Dc=;
        b=IslSfXozjr08Lnf0WSSnbg7RIN6Ys8egCsgZAoTho3RnOPUjNL0yLYPruPWRvF5VfD
         UNDlklKHP0NChiSBglxnnYdRRRV99es+oS6lL3CsGP/iLMpMMT6BMKDR4Nqsh+axKP/Z
         PhSns+AeLdkR+Pod9JZrAPwSilS7N+F5xxNCYu3J+lETxCXvEjIg00VUuVia1KsrvjEg
         O37W0zdp8u15bYVo8bLmztA7fDCfgOYzu5nFha76zaV+iZe0YoEncQV6vZmkNdV1pfG9
         5CMYMih5cHD3Hvm6+HdUsAXDHhXeYaTUYZwLrH0rrIqXkzTxuoiL7Ij4Ghqhj/7DIQCO
         Pstw==
X-Forwarded-Encrypted: i=1; AFNElJ8R8gjq9ND0ZHw33U+T6ZxF6c+32RYli3E45LnUlRyV7j4+tj3mjUJP52QAif0G0WG3Sj7RKq7JWsY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx01rUSv37anBs6ZKlvQ3kFMchVIinhMdy0xQtFgPAM4czRLlR6
	1aEOTvY46K+PiGY6OXmyCAtHQGvgvpXXR7HYLL7imRTHiw/DdSXNLEDw3O97zu1wb9gz9BnMsob
	cHrKZub/daw==
X-Gm-Gg: Acq92OEIuyxmhhVL9Pga0cmQUwkhGPdg8sQmJaT7hYEUqnbgXQnvYn09tJHHG+jMpXF
	O94iAfuY2YvbkKpT1VJTtC1nP9KXh0GC//i6hgZupZ6yDbnHzZ8wF2xx9qf/NosnBLt0hquXTk8
	bl/UIdPdZtgx/N8mA0/GnTe3xKVb68Bdcb5CrGBZhcHvnZjewmfuDwh04rPyaxdavm70dm2y6YT
	97dAzpVrHW8z9aavu0x61Z+Vh6O0xstwJGXHC27PtzvMS3mqSMhSpBr/uCUc3g2ma4AHi5YFYJM
	EGmgtCPVYtmnypQLXIHbBXPDSFPcLu9pTgfMh5/yNfAgPbdIy8C0H/tuLcC5nqAFK1N8/nrNCaC
	q8g8NXyCjIB00dI2Rdz+osabC073LwnQu15JktVvh7hmzFEFb52kxrsf2bH8UovP6jWSZzqFpSh
	JyNzpKbbj8
X-Received: by 2002:a05:6a00:a214:b0:838:1f6b:dcbc with SMTP id d2e1a72fcca58-83bb65f3f6dmr14902315b3a.6.1778496396421;
        Mon, 11 May 2026 03:46:36 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3f:344e:4435:2c77:3920])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c861esm24927599b3a.30.2026.05.11.03.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 03:46:35 -0700 (PDT)
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
Subject: [PATCH v5 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Date: Mon, 11 May 2026 18:45:52 +0800
Message-ID: <20260511104555.196270-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since [v4]:
  * Add a comment above kaslr_disabled() introducing the terms
    "strictly-defined KASLR" and "broadly-defined KASLR", and
    explaining what kaslr_disabled() returns. (Huacai Chen)
  * Set efi_nokaslr when "resume=<devname>" is present, since
    LoongArch hibernation does not support KASLR. (Huacai Chen)
  * Adjust local variable declarations, comment wording, and
    function placement. (Huacai Chen)

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

[v4]: https://lore.kernel.org/loongarch/20260429120300.1786210-1-r@hev.cc
[v3]: https://lore.kernel.org/loongarch/20260429051318.1581350-1-r@hev.cc
[v2]: https://lore.kernel.org/loongarch/20260428040159.1065822-1-r@hev.cc
[v1]: https://lore.kernel.org/loongarch/20260427104721.47724-1-r@hev.cc

WANG Rui (3):
  efi/loongarch: Randomize kernel preferred address for KASLR
  LoongArch: Skip relocation-time KASLR if already applied
  LoongArch: Avoid initrd overlap during kernel relocation

 arch/loongarch/include/asm/efi.h              |  4 +-
 arch/loongarch/kernel/relocate.c              | 50 +++++++++++++++++++
 .../firmware/efi/libstub/efi-stub-helper.c    |  4 ++
 drivers/firmware/efi/libstub/loongarch.c      | 16 ++++++
 4 files changed, 73 insertions(+), 1 deletion(-)

-- 
2.54.0

