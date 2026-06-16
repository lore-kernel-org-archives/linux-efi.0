Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46C234FF79
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634612; cv=none; b=NROMB1geW1bKSIUQMY/tVRRZZt0TwnJKW0HZTasF3ecylTeh6SEu3vBRz83+VyPqzYiLhjv4sya3z22R8snG+jZyV03O4iXT/0zt1BjAKGiPF6xxOnFDqMi6CcH/FBs4SpoXAZZAPs9nLDhFIC6QtKxzE2Fxqi3xKVuNs+i5mNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634612; c=relaxed/simple;
	bh=U2bfHtoJeOkasncTz6MQSAvgazv6WmGLk781Lw+Ys/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QsEnFaDT2xCU7iqhBvj2QhTJEKQzFa/JG7Pj9xF4KnQmYW3aEiGBJNazMraE6eialKdirrsFO6p2Enkr72PE23tR2Nvy8IOqobLC/t8oUy+K7KTtOLSR04Gr1adOnNJxYama3Z2oy4Wn8JKAeLtwfP4XFMOJYJfGmF1zp9Qtkow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HuerNG2a; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HuerNG2a"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36bb3551f6eso3892051a91.1
        for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 11:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781634610; x=1782239410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Dv06OEZvF8tRVAKSy2Zj2XParkcF+9FcOKnYnV3pt4w=;
        b=HuerNG2a9yoXsyaM0HVW7teZpRnwceBOEr0gIuh6ZZaE2G30auaFWhu2GV39UMNCAn
         SSQwlxfwWlYju09FoeDT5oRKz7pAv5w7r0Zf/DNHmh9VLB6mQK2Ne4wWRgg6Mb3WThh7
         wQKwXG/PngJlGaJXQoOA76iUiZeHm8BPPkj1S7g1EBkU3zs5oPon4v+Vt23ilSY64F7Y
         I5HOU4IRhdH6XcHsKRr7GCR8sp39Qe0F0AVnCf3szITP524hYvd8iAYU/enLhhvJygCL
         j5jRZPplDJ5QwEValn3fPQClflYdkdogvRzrBV4N8e6IeML+4jGzjYGkTVukP4hFWeAt
         VyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781634610; x=1782239410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dv06OEZvF8tRVAKSy2Zj2XParkcF+9FcOKnYnV3pt4w=;
        b=evXZlmoTD3G1kws6vzhWaeh5UJACfbPI/WUp4bHXM96XY2vegrQyqX8uE//oFDV4Jq
         WRGCdFWS4Lc+QHgyrqxISqn3nqGa+ZJAtJZBt0bjhJ41B37YXKUep/emsQyUAqNktlUJ
         9irm2t0N9tl0h2zmZD9KBnOKJn4aNZI+AZnTGfcKEao0u2hKJfHbEvRdYFgw0a6r9CB1
         XjmpzNG36xWioAyJkqMAwJpk6KMT3eucmO96TMqlMxVL/fE/Jy2GbPy9wDWaZFPpwD+k
         f/BHQxo97aaJlpAIhPt2UQUjhqPuX1CZCvZOv4NDe4JDQ9/T+mm53bjiO4K3A7oI5drg
         8DOg==
X-Forwarded-Encrypted: i=1; AFNElJ8BLXbbW9c+axavr/vw1MdZr/8bfcn1mvFemBKoFCZ7SsP1mnjmMi66vAGSp+BnrnlqF4yQV+XM7kY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO5OxYf1sMbQBzYzdLU7YDvxoXuuBQC04BGyglCZlsJ6Va1Fip
	FZZb5bZpolcJkVBDfIahBSYeJX16gZdgHm2R/Iz9CcilGfGXdx08E7+t
X-Gm-Gg: Acq92OH/xKTJ7lLXwHuF++l8YiiUDtafzoBVCD5Rd6Fd2XldmUdU0tGBoypht3gNoel
	INYjCababDAX491nfH1Bq1s1obU5k1mo/t3U3lM8pLx6bUrU8JV/t6/lYzSDepM/LHQfOwHh1z/
	bIQw3SOMhOuoJpF0V6y9Y18iYnbRaq/ANP81GcGW2Ul6X/UAD7dDg584343FX8I01eF+XVJ8cy8
	eAc3XxOpGB07BRTbHpOLkGO9yo5N/uUkMkYqZkDstVT+Daphq7X5ZBKytI5l0YtDpgvm8JLqbM6
	twiaTdejlmZb6ErrM7oJAp+O9tozVkWK3k2oyzZBBL7qEJIHVJ8EG5B3kkMD+iOaeuazARKaS8/
	38ZxAJr6j2zdeR+qWljwKgItAd4LLfH6tGHopxxsgmNUKvY/20QDo+iJ5MbBfqDizv2n+zWGwaC
	xi6I2hRu5w9NEq8qaohw==
X-Received: by 2002:a17:90b:1fc4:b0:36b:75:6387 with SMTP id 98e67ed59e1d1-37c9343455bmr629532a91.8.1781634610240;
        Tue, 16 Jun 2026 11:30:10 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c43345e3ffsm141092685ad.71.2026.06.16.11.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 11:30:09 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	x86@kernel.org
Subject: [PATCH 0/5] treewide: remove unreachable memblock_reserve() return value checks in early boot
Date: Wed, 17 Jun 2026 03:29:51 +0900
Message-ID: <20260616182959.2429774-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memblock_reserve() can only return an error after memblock_allow_resize()
has been called. Before that it either succeeds or panics, never returning
an error.

Before memblock_allow_resize() is called, the return value checks of
memblock_reserve() are unreachable and can be removed.

All the call sites are in different trees, so I split the change into one
patch per arch/subsystem. The patches are independent and can be applied
separately.

Sang-Heon Jeon (5):
  x86/setup: remove unreachable memblock_reserve() return value check
  sh: remove unreachable memblock_reserve() return value check
  powerpc/fadump: remove unreachable memblock_reserve() return value
    checks
  xtensa: remove unreachable memblock_reserve() return value checks
  Revert "tpm: do not ignore memblock_reserve return value"

 arch/powerpc/kernel/fadump.c   | 14 +++-----------
 arch/sh/kernel/machine_kexec.c |  7 +------
 arch/x86/kernel/setup.c        |  7 ++-----
 arch/xtensa/kernel/setup.c     | 13 +++++++------
 drivers/firmware/efi/tpm.c     |  7 +------
 5 files changed, 14 insertions(+), 34 deletions(-)

-- 
2.43.0

