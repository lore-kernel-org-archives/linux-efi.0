Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839235;
	b=cgJaHLkpq0Vep+0uF6Z+xpEmlZgqSr0N8wjpr0OeUgmigQax61Q9OfHG8SL/xRu33iJx
	 UWz5gfbsw9CpxlT5Dxrmrt1Uva7w6qRAeoPP7005L0ewpZ6pAfU68z7Jy/j+lnY4jSOh9
	 o6UWryLbxGMkyu0tXGwtZ9+5U2C3OqUX1FShWkkjRUr3z0doHApj7NhxWHkqUrJX9YwDB
	 ZnHQnOXkb0jBXWGFSrU132hpCim5Unsk7lO22K3jb0FlhjaJNkXk6mqmPDB26dISK53az
	 Nt+d0sbTY+4ABnPute3zeny0GqBrC6eebbZ6qNcfELa3pW05qrwg7NGO4GkSkIZoDeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839235;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=90r0f+b5kRu0Uic25PAyXOgLnJJKMJ4pyDwq3qDyCYw=;
	b=OUiSMN/RyF0m/i1178tskPejvvQrOziNkuoFmbYeXhQd8MNtz0cipyra6rl83gffyDXg
	 M5iUuKK80Baw4Gm0lGuZw+2eQtY3CjPebcwFtC5QiJmE6FcZjHGR4AhUQilgIgRcv+7pG
	 BM9ROdrpzx/PLaxQLTK8zxktYXThjwhf3WZjOdThlss3UHRAZyQ2gr4sSsE/KQvrMrwkl
	 RqE4WjzLXXKfwtbNQx3CxFo/5Y5eaNYmnvmE77w3Rt0mlGfNK0UK+0fZLtWd7xMMjj7i+
	 DLGjff8UUOot+v8UEUsDwbyhyUoSR3+i1pJnLYxe8wWnihTF2j3OBYI3M9ZHalN9qKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=llsSItMG;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55BD606A32C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D55BD606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=llsSItMG
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c504b52eed3so373503366b.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839233; x=1795444033; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=90r0f+b5kRu0Uic25PAyXOgLnJJKMJ4pyDwq3qDyCYw=;
        b=llsSItMGsdt24weZq6w0Sp7YnsZovRXMtc6m7pTGlF/6APJ7UeBotmOykgf26PJpbE
         58CaIrszm74ryKHHFDKTQHa1oEdSaQ0F1zS5cOJi23YGNJMvynyG5Lth4/nSvXYRasMH
         FdHlhzOivne5drFFaK5EgDgqGnbdX10XtljxuZQdJ/9Ps6tYztamA+H6EV0BVMiY/J79
         D3NCdzU3YdQB70WuHoF2ly0gTfVbeKXUUJXumNtw9HiohzCnzr6BS+zG8t5WN0jjmLEy
         qmpP+jsr3w4yamOlsXxBS8IDeOkFUfRXSREyl/1kUEWjPbjO6/BC1/L0OcZu3RgGske8
         N1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839233; x=1795444033;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=90r0f+b5kRu0Uic25PAyXOgLnJJKMJ4pyDwq3qDyCYw=;
        b=vKeoZefg4OxtzrFEvKNll1UJ5UmtLWjfEw92ZINfyeHSVJCvumtxS7bB0N5OaZJUX7
         K6W55IoTB0kbejbexSFFk0WwxTUedLT//TCxn+r/k+T9T+0wVK8Gvn52jRKI3pYfW9hU
         5e+7eMQX4CJNVOsSq9d1JD0eHG34TL0tqtQi7NGFwEmSAusq+fUIWOwbRMcidB8BQbfv
         Y0RDTGSvCsIgCHfqYQEPgBiDKNjTaSr4FxHXmMbfGt4I5+64sQZUUFh3L/93RO/qeI9U
         rCxQQQUN/3CRtxAFXzPeNk/n0K/DRyTwbPeFacZMfdDwwGfYRucEK90Hr9lgn4ymwRCG
         rEqA==
X-Gm-Message-State: APuU4Z+pAUpnxA9/uejMeXhc1otYD7K/g9lf4llFSB/WAOTcMLcBNiBi
	T66SyVGHkjERgyaBUGqAMo2bmdAVXAnS/8TE4hphQo3svCRitQUxV0s+YwHVhtWardQApn3QN2P
	XDbe5Rk1bTY5fbaVN+VfESzo/3saUNWoZ84wZQj3iSaPkO0rGxqHGLrYNt11WwiNN9xhAhYYg9G
	AXQCxe2GAgTb99/z/8Cfx1vbL8SL3fRQ==
X-Received: from ejbm16.prod.google.com ([2002:a17:906:2590:b0:c31:b9d1:9418])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3f93:b0:c50:4a71:cb5
 with SMTP id a640c23a62f3a-c5096325a62mr886143966b.15.1794839232899; Mon, 16
 Nov 2026 06:27:12 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:20 +0100
In-Reply-To: <20261116142618.1687025-17-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261116142618.1687025-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=746; i=ardb@kernel.org;
 h=from:subject; bh=iJCrUIisab7JCQVRK3E8zIw6kz1I277eBbn3gnc4d2w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu3UG90+Yzl1rc013y9ZXnQWS/H/X/bfbaiq8UBCq2FN
 gdPX+bsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPh2cPwh6dmke6e8uL/z2ad
 mSb4JvW/NQNDXmW2/c78Vb+e+jD+jmP4X6y5KONutmDPSvfWR4F7GjZoFLxQSRbMnznVJfniZ95 cXgA=
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-18-ardb+git@google.com>
Subject: [PATCH v3 01/15] efi/zboot: arm64: Add missing barrier after cache maintenance
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
 drivers/firmware/efi/libstub/arm64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index e57cd3de0a00..d35c6dd76601 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -109,6 +109,7 @@ void efi_cache_sync_image(unsigned long image_base,
 		} while (size >= lsize);
 	}
 
+	dsb(ish);
 	asm("ic ialluis");
 	dsb(ish);
 	isb();
-- 
2.56.0.611.g1030f0b940-goog

