Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026106;
	b=LihOH2j5+ltDXr4AcabMYKV3kOyngDEdsbMBZF8O16EyXjfAHqQiLOqFuUz25DQBrQ7I
	 iRsXASREWHojkSfXOhFcm4TD8NQxaYK21pIx1M4DoTqLUoYXCimq3Z4GA3CB60ZpLgbXD
	 9zQW23aXCK5W6E+zE44MLaXm+PP8tna9mQAkIf571EkOrvZhFYqRjCagrvwJF49wwiCt4
	 cfpYEfZMgCsMCDxUq5r/zO/kN9G5Td3pTU1fb3Dp8rnmYotubbiCsBsm8tmrISG6TOu3t
	 4NzvFPFiZ99FiSnkMTDHG939sxrqNA9kDL7jWgoV0t1y1GM1EhgQd7oLjK+zZur8bcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026106;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=DiIv3B/kInSJlpauWNEdFhsRn5B5HF5NbCxXGwR/mKY=;
	b=uweXunpL17S6Yzw01shsD8JNpgBp9hjHjuPMCpz+WCxS+T3gfhyuBT2XHzQ9T3du0Gm0
	 3dbb0GV1QHzTbYfMfTN95CuO4owU4BYkeA9/fAymsMQrALRU1z8mcCTdx06k+IBXJ38uZ
	 hgwQYeAG4wuZy98UtFVh7PKakPXsD4gIX1i7TVU+8byFXBkw0LySwwCSCmgXsXSkH0oZY
	 c9/tJ+wHbJkZ5HjOkOe62urD2uiuuM3sKt0nKerKEYTzMn7JitaJqTDCLpGT/IJuNGe0f
	 M1C4Zx839gC6jW0xb1oHUk+r9OGthY0ZZrhTSiT/965o53SK/R1S2bT22AqJ+eQLbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZH7dreKT;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDCD606A33D
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEDCD606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZH7dreKT
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4bb64c99bb8so13587785e9.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026104; x=1795630904; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DiIv3B/kInSJlpauWNEdFhsRn5B5HF5NbCxXGwR/mKY=;
        b=ZH7dreKTZtRpnKlMUCXrinVmzBn1L8cifrqdG5M35KG2qXRP8flGzaWAGGz5y+V4/F
         CP5W9DrH0N4qVbf1Ww4UZQiwJmO0CYJHjI0dpexv2p0LpvKaG7YIn60YpskZg3aiWq2o
         IfMUxKtHgzX+Svbxs/QzhDHxYUyV6pVeYel61I71MB/wIp8keFxuDKzVrzCJ67H1aqau
         qJfY47DZ/v3XnJ0fS1qwSg9g34XpcFq+1GLej3cWIvY1l0bU797eTG0pc70UqCORq+6Q
         oYsIKxzUbWDnCbmZKXRk+GtE5etKEaZXze3cEwBdrqVliNv3o7ictUdmlPnb5ucvN9Yb
         nb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026104; x=1795630904;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DiIv3B/kInSJlpauWNEdFhsRn5B5HF5NbCxXGwR/mKY=;
        b=LJFzw69p9ZkN2kv91WtA0DzzIrneeFSC7FIzuuR8p7AwmLSbm2sIwB/dw7L5KTAtC5
         LPUcmN0OW5wWVlR9Vi/6OETa4bXISG8S9YAi+7fk2BsoHw1Z5FRUooKiNDTffnaFG7p9
         Mm8g+/iqVraCHczEwppaxMe8fCuAmrPT46RtGsmlUisVHv6JnFUn2Orpu3ob6TZTrSj8
         DWSAkxtuC6w/IDcLrnoox8ig3m1Ijbr/7CaxNe8aclzvqLEo/bEvfLmnx+Abios+4k6e
         /jrbCWhFJJkDYnTCxWOB1Hi3wIVEL7IHG7PWgqzLJByWJ5rKtFCudCuTFsMuhp4GqKG2
         MYuw==
X-Gm-Message-State: APuU4Z8uPYoP4HIxou4AfOgSSLeqrhFy7oYDyw/zUpGAY2jEBowXcKNT
	4/LyyzZdqNTvv5Bb2oO0LmAZ1pGF2gBLQlU7AX6RVX38WvJIQp4Fah6lPGVNqx3+iNelmpT3whu
	09LDnUVWGZd/jzD6It6L4mC8vkY1GRfQ8Qv7yfQaVOESKTBt0xUdzauUzSayNpctU3Hhe6ngjF8
	xPsw8UrALXbl5yfOhbP5Te7Oq9caNLtw==
X-Received: from wmte3.prod.google.com ([2002:a05:600c:8b23:b0:4a1:e44e:ffd0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e87:b0:4a5:75d2:c104
 with SMTP id 5b1f17b1804b1-4bb7da2db77mr71528935e9.22.1795026104151; Wed, 18
 Nov 2026 10:21:44 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:07 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=746; i=ardb@kernel.org;
 h=from:subject; bh=jR9RFbU1DFXzsLcPrZ2t6cFJ9as3lkmb0r9/e4KUO7w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm8mi3o96JorGnY3c3uniWlKh0aATKFJUMr3DnsWB6
 e3err6OUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJH6v4wMyw6xcJ6b+EzmOFuT
 1Y2f1xcdyl4ravtF5AjLUUZhfo4b2xgZug9P0Xhuo8DAeP2t7NXOJuVfV/crmV/992mTwjnDW54 WTAA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-22-ardb+git@google.com>
Subject: [PATCH v4 01/19] efi/zboot: arm64: Add missing barrier after cache maintenance
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
2.56.1.708.g77570a6a1d-goog

