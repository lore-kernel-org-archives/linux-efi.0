Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DDE3A0E80
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279660; cv=none; b=I6mxR92J804lnFMua5RiSRRWPotZ4WTdQ9M6/veTaZiaQcbROV5VoMDqcOfHQd/kZ5TTtUVzt8LXJDhY1AjijFc2dfvkiDrdecfrkg9iESWVPBAfqQ805FHDJvxlpo7B2GVENKcPKxXX3IrvHf9Vo8YEK4jpebcDlhxZIgmckis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279660; c=relaxed/simple;
	bh=ud6229bzqFmsJw1B4jV51SEWrfqqWrMb4pJy+DI1Kls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OD9Oo+ghandhgeCsotWZQwwGHM+KKagEkwqjV3lOP3BK0HpfKydQNQAy2wT03Yp61VjvAj4+G0wmEQyYuvGalaZWQcXzrrs2F7lZLVdenbeJQtxhZqZBO4nX8Q2kKZ3JH0DM7tRrDHPAKF3+toM00kpXOSoUKkrU2cm5fcD5Jqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=pZlDMfKU; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="pZlDMfKU"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b458ca2296so61150275ad.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777279659; x=1777884459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EbS5XqlTtlqCLLkuZnn42EvCeoWF8vUClWjJ8C+Uh3A=;
        b=pZlDMfKUArZtHIgh21BIn96/QH/2PCguT58eMgjBIZnXxRp74G/CwgYJqko8LMvm6X
         e90KH4JhCqoEMHjAOcyTlRg+FAVq+3V8Hf2A2llI1jefuG4CBSlVsllFnv5Y0qw0o9/L
         ogPucZd7pwxOi4n+Nw5IkE4ZsAHvml3yCAtYGkSSbUrDkjeRacE7R7W/Mq6CeEv99n81
         GRNhsG3JpUGCLqyhZMEcTFPw7knYw/v8fVfMj+LtFSYpwUnhbLaSR79oRRKpDMNTHtrc
         MynVgMIsx9YyizFixZF7fXyPgeC30Qe6AubUIBN7P9AIqvc8iFemqQmWTpeeGj4WcEv/
         J5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279659; x=1777884459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbS5XqlTtlqCLLkuZnn42EvCeoWF8vUClWjJ8C+Uh3A=;
        b=nUbVKsYO+ujTYOONuGZifUTh7U0dpan291m60ahR8RQAjWhUusVPdFbqMn5ihsQScX
         zLZXdzuvc5zP8rXmIxJhHIaKL3/aDa5zPt0IM4GBPBcR9jmOvMM2kt2n7p605zax79bI
         iBKMTftf3our4RUFeMwO1AzIbvtaGME4AEZirwhIhBA7PxGu1D6tpEKP/cfaLWmzrq5w
         QqtFlwGmIx+suPZfTv4U5OQH/y/vY15POsQW2X4FNeZVlYFgVDXx7qJ8BqY/BlxYb83L
         AthKRX2uu4MD3DRtf+4QdBXe01NXJk7Vv43XWjfwfZrjR7QMwFWqkGvtratHdwjmj0wN
         wDhA==
X-Forwarded-Encrypted: i=1; AFNElJ+0Q2sRtyQmByGTJKy1mAVUduYqptcpq7pEePccOPnd1m7TPl7iNb+9Lj4mt9nQYtjGgsu0k7SGJfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHBYuVYWNlwbJk6vZtCh5GwYYexUHbMf16f7S7Yxqxec+CfjVN
	rn+sJAzTEn58OXEvWQp6V2QhiRMaBKJJO265fIeHtS/H+CjQbOQxofCHElWi976iQKQ=
X-Gm-Gg: AeBDievb4+t65FAc8Qrh8CdnjdJmJNw3AWDm2RLbo89z4NcqWi6BV5ckzf0JvnIrL6J
	/+tGhur43wLgkao+W0LCUwp2996ei8WOD4byH4GFDUWKAE/qUkjdj88wRoveEzTV3R3g7VWNI1G
	pTDXVM/2MFoJK+wsNTmdOZYlJVSmhcpIHibetog6VpvZGV+AAD4dagO236joqZvljQAYr9y3UCN
	4IILj1o4Iiiokfn9L1CNt+oqPExPyhTbXpdbYzhZBBSSj6NaMba8zged4MzBts9EDQBu+xeuePk
	+4+4ma6O+JiU96XPZL/BaYWJcUAH8tmUSXJXHINpLEXByXeBNqzla9XXlhWBZYcfjosMBgABS6b
	CufGOw02zLXGdA9zk6HG/EXBoApg6GRIL9OPP4lF80J8up5ZoB3YfZLrS6VcUZIEK1X6D/QvvZ7
	4uyA5yAP3uJnAih4A3fUsRzg==
X-Received: by 2002:a17:903:3d47:b0:2b4:5b82:a8e3 with SMTP id d9443c01a7336-2b5f9f51e09mr293896815ad.24.1777279659118;
        Mon, 27 Apr 2026 01:47:39 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm291703215ad.72.2026.04.27.01.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:47:38 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>
Subject: [RESEND PATCH v2 0/2] efi/libstub: Ensure instruction cache coherency after kernel relocation
Date: Mon, 27 Apr 2026 16:47:19 +0800
Message-ID: <20260427084721.40535-1-r@hev.cc>
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
  * Add "()" after function name in the subject.

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

