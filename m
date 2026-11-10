Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313062;
	b=qS0klopF7YQzjnAjElKvAtAo268oGiiSfHBwD9AWQnz9UzykUkqBKyHqm+PYsVILxpo3
	 nFr32gBQBNmlyC+b0CM5lzpn4qUAuxIibbQ28sfl3oJ9FIafHjIQ7yZJGYbt7sU8EiH1D
	 LQY8Zm0aApJc1OJvz444ucv6J85mnqbFf55O1xYeaagkNQ7OokD2wyaTIZeTNbbOOBs28
	 x3nCCc8zDoJwF4R5cjvxNhvffa69swJQFpr4jTO/EMKCUQL26SrzVTNgnSlIlAWRnX5qT
	 aS1Qjr1Clv2/nCwl1nbAfj7Mfs2ZccXVG00ljnc08XLEAtX17NoEEMlD9f4QDWS0JGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=PjRDWUymC+7EL3JaTKRije1yqTzPKOHWaJhKCJD3MI0=;
	b=DMDvHNg/lYsudRKYcYsf7fRnPkhGJC8UNWeYUqpIluySAd0VSGqy1DYab9PGBzGV0OFS
	 AAzJ4WM7QHNzXvBDdI4FbjjmSYCabZOLTP/w6WB0dajoJkeHQYY6dJ0X/MxmDj2CdhRZj
	 72hGJr1TOgVdAckDFQN12/AqmzSvKq2wbPbNWmiYoQ6VuZEK1OI+HNkOp19WMszjGpa2y
	 PuuhcVtOp6fLlQELxkNedrWQ3HNyHy4txQx2N85WpsfFGZ/pxqdsJUp+uiVhGikTOhDtU
	 oo1Ph9OV4Ke83fIlRwkTkyg8cUiM+AW6H3aiBncT1bYl36EBMq3/OilWu14quJ81G2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VfPDp6es;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E3E606A334
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08E3E606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VfPDp6es
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1fdde384cso12420105e9.3
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313060; x=1794917860; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PjRDWUymC+7EL3JaTKRije1yqTzPKOHWaJhKCJD3MI0=;
        b=VfPDp6esFbTdostXxuwMiec3e+Z8+8kQ6nssx9aJVdMDef9+XEmhv2R/Kn3swT1R+/
         GIHpTG/Zi5S13Kd1XMGTYtV6xgOYZiT8R/fIL6uVR+ILe8wSBA0Jtip5Qep4fA0QSigI
         K0PmNjv/eJe6bDSB/X1eKAkD1lc5xfDzJiiwSHjiy9S2IYIeB7ZJ5oM0tRhUoCpWar5T
         H5ed7LJSnCu5RDjaNyKxZkNggbdlECs7f87ik8RWvIZKJGs1De+pC7C3rG8dsYYQxpbE
         qS+Z+9iHvm33hxtA77l58grbPVc5AI20i8eOtHZ+Bq0BJWv1MfyUB91apTfOW3mX+7uA
         XPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313060; x=1794917860;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PjRDWUymC+7EL3JaTKRije1yqTzPKOHWaJhKCJD3MI0=;
        b=YeAQ70VnaRxMqZjA+fjRvtRnC5YRQJ7dyNPAH/Vaf/YasF/+eL2Jpiv3lOB+kE+Bxy
         uC5s0GFDxdfqOc7qDkaEWE4fHx6ihJ48OcmRMQ5Sk2nEPdQuGNhHefZ81dANiqXb4kv8
         L51hKG0zMdAz6AIKRKH+2p+mBIDC2+aeHeGmJlQnsWYPMKyfAamLveePz52rbhzJcvLG
         D64yyl4F61OEheGdhse2Zgr+rYNcDb4EJhsC+m3AecmITzvHkfhlFGlb/xhW9Gaawf0x
         QEcMFGv7kbPYfboJaVRlmY7aVscJmbE9MOgTKqLuqZvBH5OrStISMRZ2Dzpk+/QXDNL4
         Kw4Q==
X-Gm-Message-State: APuU4Z8WZEqbLe8JJYIkiOV3/mYfUJIX2piNuFcw4D1CYCWPHmCYCPuJ
	gJW0AXV682MLNFUoLLfuMvrw9uPY2HuYWJszlDyzjsbAfl5eRIfclAoNXuKwxuhLkjJjZ+9iVXZ
	yMbWAMUnoRMGPtET+LEHZFxjEDG7V7kEpSTZNgGsPA49Uz6cOfl1PDQUQzohhUi5EDbVWwnBBu4
	WbSiaT2wFzAj4ykTxjFNIlHAzimzMayg==
X-Received: from wmbc22.prod.google.com ([2002:a7b:c016:0:b0:4a1:8bbb:59bd])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19c9:b0:4a7:c366:d791
 with SMTP id 5b1f17b1804b1-4ba02308537mr40596315e9.1.1794313060140; Tue, 10
 Nov 2026 04:17:40 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:33 +0100
In-Reply-To: <20261110121731.2728824-12-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261110121731.2728824-12-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261110121731.2728824-13-ardb+git@google.com>
Subject: [PATCH v2 01/10] efi/zboot: arm64: Add missing barrier after cache maintenance
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Prevent the I-cache from fetching stale data by issuing a barrier after
the data cache maintenance completes but before performing the I-cache
maintenance.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index e57cd3de0a00..62fc8e53c8a0 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -107,6 +107,8 @@ void efi_cache_sync_image(unsigned long image_base,
 			base += lsize;
 			size -= lsize;
 		} while (size >= lsize);
+
+		dsb(ish);
 	}
 
 	asm("ic ialluis");
-- 
2.56.0.542.g3ef89b7020-goog

