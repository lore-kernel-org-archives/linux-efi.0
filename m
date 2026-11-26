Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795733068;
	b=4aD0Fsc+dJmB01sYckynKbcUOPF/6Nappdhp5q9GUUoDmmCiZ2EEiTJkcFzZTgy3yVNd
	 PoA9LC6s2JPCZcRVZlcxiFyCf7vcml4YJpPbu/zlMRtJ4BUaF0vTviaFLauItgxua/b2X
	 hGF1dUNrZ1Q1cyKZXYV7VqIlb35ExcTyp2JO5AyjuwQNOr7Frg5jSnO2VXdoJz7GRJ+z3
	 TVNvT6DGqqHvDzipknvYnx+HSniGQDNiZkXisl2MpGwEpyoWHiHi/9BrmdGCuI7Ddp379
	 +rC1nkc3VDVQ9NgG6giBTGgiITjSgL0ffLvgUyHF+vzAV4NlMxqjVls9sVup2Ol4veA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795733068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=ysdo92WLfsDQB1Dk5sR4V6fHvnDgX8FDuI/IpRC9VDc=;
	b=sKx32A8HX/Y5jKkY9adWrl47plbZBGzByK0ctD0BftY0SWxjw8tyiseDugqXSTDs1ajS
	 QOQczlxoI6akK1fE5ZxNawUHFCUgggKQ7YsIqthovBjYdRPI8F2rx06DleISVAz6qudSO
	 /JY8nNEPsJ/5tEG2MBNLY50ZFuDTA419G5yesrE+2/FgVoYNo0pLlXor6qE+1kWikjW9D
	 OhqaHNK5Ae/8rh/TEGu3tRIbdUsWBHe598nLBEvrmK4UA2VN6vqX8Qu7cAycqb6Tvs/mu
	 adlWrDj0zZK1oErtVr8QO3YlFgh25ecZN4/YWizGECj6FJbqF3TzPryFGuOPIPhvOAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCaWd2oh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57936606A31C;
	Thu, 26 Nov 2026 22:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCaWd2oh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40751F000C1;
	Thu, 26 Nov 2026 22:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795733067;
	bh=ysdo92WLfsDQB1Dk5sR4V6fHvnDgX8FDuI/IpRC9VDc=;
	h=From:To:Cc:Subject:Date;
	b=LCaWd2ohW1rJ1vBK9PLWCuKVbPI1jNlDEDlzsngTVbSL/0CleZ8sO7sgSDy0zv3Y0
	 gxmUIHH50R8tj1GbRL0VqhUG2i5grKbNC93V+Oy6kHxg2DaqspnluVqbYK69ZaBjn1
	 2wOnp3VAHYSJi13ACF+uxQNz/6fP2vyHQtnubYeIkS7rctl/vnqHGTPJZCndamrTbM
	 JtEZ9LRQa/ohLy88qPtLIoqY28mxtQug7dBgeRNnPUX7ZfR27t9gTq03BwmxQBQ6K0
	 UemorxqAhVnOmTvBC5ljAZ6xv7nqN055jax0346B074B8YVEbGFHpDpWqThxP55Y0Q
	 aicwe3Q4HIq5w==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	linux-kbuild@vger.kernel.org
Subject: [PATCH 0/2] efi/zboot: Put ZSTD output size where it belongs
Date: Thu, 26 Nov 2026 23:44:01 +0100
Message-ID: <20261126224400.10147-4-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=ardb@kernel.org; h=from:subject; bh=ibV2GZO0VY+ueBY0IJ4wt/wNVWx7Y7iSY8PTFlIAuYI=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZtjm4GX75KjyX2OT688qq/ZtqY5VmBK2cEci9+Br21bp k2Zfjq9o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzk+geGP/zzOo41/5rolMDn p+//KpyT4/hJyXvziw6UGsqxc973dGD4X7l5WviP6UFtuWnbL2b+s08wOcuwa1qZvEyR+sGuFxF rmQE=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The intent of the EFI zboot format is that non-EFI loaders can access
and decompress the payload using standard libraries and tools. However,
the ZSTD decompressed payload size is not stored in the header where the
standard library would look for it, but appended to the end similar to
how GZIP stores it.

Let's fix this, by capturing and storing the input size explicitly.

This is a prerequisite for upcoming ELF support in EFI zboot, which
concatenates several payloads, and therefore does not support appending
arbitrary data at the end.

Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>
Cc: linux-kbuild@vger.kernel.org

Ard Biesheuvel (2):
  scripts/Makefile.lib: Capture decompressed size in ZSTD22 metadata
  efi/zboot: Use ZSTD frame header for uncompressed payload size

 drivers/firmware/efi/libstub/Makefile.zboot          |  8 +-------
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  5 +++--
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c | 17 ++++++++++++++---
 drivers/firmware/efi/libstub/zboot-header.S          |  2 +-
 drivers/firmware/efi/libstub/zboot.lds               |  1 -
 scripts/Makefile.lib                                 | 10 +++++++---
 6 files changed, 26 insertions(+), 17 deletions(-)

-- 
2.47.3

