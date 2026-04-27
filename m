Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516AF1D5174
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777261524; cv=none; b=B66KXkESKoHHFgXAhIjDR1b1QqWZlGBSqUT5nhUfR6gu0lCtVww6gNV5VTNpfNPOY9OeR5BFqpZClCKX5+Q/Y/ZCcz5eXmX9pptpIQheD+pE5HBnRqJ1vIgjMJ+x/kLYBx2Of6rQ0NgWr8clq80AFG4o39b49NU8aF1SbKG3yng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777261524; c=relaxed/simple;
	bh=Z8T81jPhfrem9chwe22i+fePhVQlA7ofKkkJOecRdnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ltQt+7tVHyLqs6TX3eFxpqS0AlkTmccRbbR1zDPx0omSWyhtw9Em3540mrx1R1uuFijKzCDjoeNZ1WsCK0L0lEVtZ0LNj2JZyPkSitC1bfYIsdz6KG7Ys0yOdAbQzb4J5e6vknAhQlR44kqo8xOkwlzCjJkAVjjSvPPDwqI3MiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=kKss+8qu; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="kKss+8qu"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c798fc1a28cso2911662a12.3
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 20:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777261522; x=1777866322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=olS8oKBz9uJQUERWBS12mc4yNCSnT/djHgFK88Ulfns=;
        b=kKss+8quHYcKAHcGBMJQCKTso3SIFdGXbPwh2CSHMn5g2P7l2RgpKKrKjzo/Apo+F9
         TAnjhn3psaYis7MIh/ymXu+UFt2XAYnMBi1NxcUwxV6VziGAYUPnRSvaNKDEVOzX7bP/
         fAm7KkVYS7ypdgS+KGxb31Dz4RODjJSIInD3VcLjY8bkZApQ85ZCtu6KCDA/ELwigBLS
         idbhKSJYw5iJqPcwJTnyY5aa0YdOqTZzoKlkJYzLmSt0zTPNwiL1FIWiwKmvKSRBduYu
         1l6JfM3uu+fEIb7o6yxWdacf4vgcfUJUkU249LOP8oabb7lougfUeTjlwwHSfNI1P60d
         pr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777261522; x=1777866322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olS8oKBz9uJQUERWBS12mc4yNCSnT/djHgFK88Ulfns=;
        b=TlqRT8G79niCxjHVkUUJrR5JH6Z0ElT9FIQUbPfmc4ESjf2nMS0gxnoWkEr914Qa+V
         7adYChlgHNhP8aF3ULs2YoIYLQisk+ZPx9c2JfzOwvEarc7oWMf67ixruV/pwWmt+W6x
         +lGhK9t6RhSu1hOvbTteBloWakQFoeLyvNa4VS6XQ/b0IRgkMRGSFNe2iyFyOqnG89wm
         Tp2NVZqSuB4oKn3tovssPKQfi1MEBUifVYFZWi1sd/S6dM2t00byiBA5YJ7Bnuu+AMtG
         BCsyx0xwJaWPTN92cKE8GTZf1RUOcBicCIkK1Un/dQaDIVdK8WDIO3U50i8K8XJ0ZN1b
         6wdQ==
X-Forwarded-Encrypted: i=1; AFNElJ85P+Nu0G8LskwoClvevEOtLjcuBgPd6eRwlCvZNbMP9L0LsbdgOk9gL18q6hU9VHjNKFOcvcpnjA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPsQMJegTBn7GynY8xBwr4LDqD1vhaK5Cr/K3oisovW052iPZt
	HNfH+oDmWf/AlYOmhfaPCaa/gkR9a4P3HbtyYij6Gca9ODysl6Xfx5PwGJMTtYzeQoD0vKedh5M
	CVqmC
X-Gm-Gg: AeBDietrnRlf0QOERBSHygtEkcXkZZGbqhuie4p/Lskr1lA3H2DPxEM3kMfCttzpIO3
	H1Tfsjbg45rYj6FHMxumy6NqlT3xFCcH8wfStWeGPzuZlevXXWklQgt4tz0tCi51POktH+FKod6
	3lerTGLPYi7t7iwSuEY8QtWR5x6NMRQQcFE10MPi/vJ8dl2xvO8Iye7KeyfYFGvyPSxIrgfZNnJ
	+c6pzwKan2Xxd+2R5uD/5SYWZa6/IPVG21SvROyDaMFhpgzpX6hbUGBHiNeNRos97snlOaA0GIs
	O1y7+5Mooha3GI/Gwmi3dYwztM8NXsc7jSPQvXYuhz5+Y7Z7CZsDbGGHGsc7bwy9pCJ7KfYIk/F
	RduT78U/NTrlG3hawfx5T6NdsZ33Zrqp7SBJRHyfe21hDyXACeU2rbGfUZr1bUBwNnf/o1P+xKt
	u+xZTIUxObBPEBKTVtH6E=
X-Received: by 2002:a17:903:124a:b0:2b2:5515:661c with SMTP id d9443c01a7336-2b5f9f61603mr431091235ad.31.1777261521666;
        Sun, 26 Apr 2026 20:45:21 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3c:3085:4d80:3614:2212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa3073asm279061375ad.27.2026.04.26.20.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 20:45:21 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>
Subject: [PATCH 0/2] efi/libstub: Ensure instruction cache coherency after kernel relocation
Date: Mon, 27 Apr 2026 11:44:49 +0800
Message-ID: <20260427034451.717817-1-r@hev.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EFI stub relocates the kernel image by copying it to a new memory
location using memcpy(). On architectures where the instruction and data
caches are not automatically coherent, the copied instructions may not be
visible to the instruction fetch unit without explicit cache maintenance.

This series adds the missing call to efi_cache_sync_image() in the generic
relocation path, and provides a LoongArch implementation using the ibar
instruction to ensure instruction fetches observe the updated contents.

WANG Rui (2):
  efi/loongarch: Implement efi_cache_sync_image
  efi/libstub: Synchronize instruction cache after kernel relocation

 drivers/firmware/efi/libstub/loongarch.c | 5 +++++
 drivers/firmware/efi/libstub/relocate.c  | 1 +
 2 files changed, 6 insertions(+)

-- 
2.54.0

