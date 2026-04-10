Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314663A9D82
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808032; cv=none; b=n+5S0kNbU/s0LDKGN3i9L2zQs2HcNJxe4zCjpJ3oTCYMbr/qd78AhasrE5r6X7sJi6h3zfXHJTtZ+iRn2Wx5zV9vBm4yY1Z6w0CxXNSIj7Bi1xLNI5yTeu6xhHg3Fpsmit6g+HMY06919OWkye23cJBTxE45VU0sfR8fDfUfirc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808032; c=relaxed/simple;
	bh=pr8QEBbnszis14zfZ5a8IpBKOMihG9vcklfRoGOhBUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fmno5+R+KOyvcSSX8uthfnhHtJYtXHFBqgD5/hd2x6yh30t72NeIh/DGJu9ZyaOAiU7+8gsj7CxNl6JsUGFatffsF6SAxVyvzCuq94pvtxFQLPo/NnPm1+fFkHWaNoqblAIwHIHIhF9LhMt7qc/mTq5EzPs5wshmDrtdt/B/wus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tU3MLSQx; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tU3MLSQx"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so14199025e9.3
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808030; x=1776412830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AuKgU5F4yjz7fCBhFZrw06bTjm0O5cNfeictVRtboxE=;
        b=tU3MLSQx2BahU9Jauq+YuneFJ6zjiKMChmCmWFy/bDpB0bLa4//NtcrcBpfbhp4rC8
         ia+FskZYUP1yr2edYLL/Yh+3TXdk9XjrlCCODki73nRVmnLDzaygqRf3fDBYQYYjShdW
         stOrsHLEpbgAMoxL7FR6sSZkT/UKQH0E0D02sN1ENveSBhS60rSq9mdtl3KLUAnIYtLd
         hAZp3rfmAyhpkHnBihuqpQVcY2+/vakKnhVDIuz6jdntWUXVDmOJA5bsUBrrdm1AxhjA
         3w6QAJzbYg8I7dCuo2aKFZ6enmHTd4K11BFdNEL9c+QsBCtUqBHET/EgpNhux6//W8n4
         AnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808030; x=1776412830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AuKgU5F4yjz7fCBhFZrw06bTjm0O5cNfeictVRtboxE=;
        b=WzefPPJ7YbW2qwX79pWQkRZNzigUWXX4p/Hi36PRUQFFQJoVVHcvu9gb4ZTEIKSGXi
         3CvLVclV4tmoxxuJPWOTf4glZkx+fci/LxLhGP4EK+8gInkQnN/LnZdC3N4Cr2aKcScB
         vs6zZZn+dtpKRh8F6MsLdZKwVUX7ZYxrB3DAHR14dF1eQnvKltfwfxW12nWHNyqK/wUI
         7MzLO0ttCfNFWT3k1gQAMN+lsQmusd4wc+smSQAYj9dNGSMMbOkd7BeNbIRhQHJyDJMA
         CbJ0B7Rrp6M0YTzboapHWfi9KyBU6LhsgIfydyL5tt2J8ny15SptYHt5+PYFvDkVZNeU
         RyKA==
X-Gm-Message-State: AOJu0YzbpK63a4qVYd7PLdCMaKAlpeqlIqsqpZ2lVH4woTvl1cHXcKVr
	1w9vOTqEJnJSCgQGoY8y0WACx5Naanlxlj+zp9JB8wSqFcturp8bAyiqqnvn5Ay9QYz70xj5/W8
	Kjxbcs/PnkIHGmWc8/wsNM+GaErB5nbG58JB1N28KxEGxc9eZ6uVM+2W0kxSs3zZipokS7aHYZl
	ppF3IBq2mBwXbap7020x3sLin0o5fYWw==
X-Received: from wrse9.prod.google.com ([2002:adf:fc49:0:b0:43b:7a63:37ca])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a010:b0:488:aa3d:faca
 with SMTP id 5b1f17b1804b1-488d68af250mr25530245e9.18.1775808029523; Fri, 10
 Apr 2026 01:00:29 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:52 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=915; i=ardb@kernel.org;
 h=from:subject; bh=4dG7M9eLw58W6NeWNgCBMOIErdjPUYMAR1EfYEEwfHo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPG2l/dG4oWhR5gEZB+wN/sM3NL47vYYGdHA5PYrnUyB
 X/tYh92lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIksEGZkWJAb4zZZtzrZ8+Ci
 efPyzsXvfHPJa198549nMqnT7yrL/mdkuCd4ab3Hd6/9y23mrHTznu+xuHbm3nWhizbviS2rMVw jzg0A
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-11-ardb+git@google.com>
Subject: [PATCH 2/7] x86/efi: Drop redundant EFI_PARAVIRT check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_memblock_x86_reserve_range() exits early if EFI_PARAVIRT is set, so
there is no point in checking it a second time further down.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d84c6020dda1..b60f8454a1ec 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -211,11 +211,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	data.desc_size		= e->efi_memdesc_size;
 	data.desc_version	= e->efi_memdesc_version;
 
-	if (!efi_enabled(EFI_PARAVIRT)) {
-		rv = efi_memmap_init_early(&data);
-		if (rv)
-			return rv;
-	}
+	rv = efi_memmap_init_early(&data);
+	if (rv)
+		return rv;
 
 	if (add_efi_memmap || do_efi_soft_reserve())
 		do_add_efi_memmap();
-- 
2.53.0.1213.gd9a14994de-goog

