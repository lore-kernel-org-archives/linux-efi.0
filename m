Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839236;
	b=Zxvz4GIO2x9cW9iyE23aWsyLgmuLKNrCmgF2Wj6WjjGzux3TT3JRM1gYwQlugp6wOkNm
	 132wCyWw8/7HFjdE+fE7DHdq6rF9YxhwqeNa8EixNEUCyiz4CLBSUd3KJwLvYoMtxubok
	 i50QHinPI4KR2B13pHNXrYj6O32KMzpcdEIH4rgv5uOIpTPK+3NYyc1Hlbv+8zDtg6F5s
	 seYAvfuzr/a3kNyT+gbLzoav+R00nsSZ+g6Jou2lakfbj8iGVdAKXsHs0F53MzF44lJyU
	 /DHYf2bOtcA7mFnQZ6bxgBYddeYDSpe5TV1wkvWn5Xd+lUeCEahOvsPphPNLmONlQow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=Ys9OiBJUlo0yeYgXBzy5BjlTE2/m4y7kU18rGSki1UU=;
	b=ddLXl+zCBTHtUhXukXXGF2/miyxYl2hRKyqQ3B+yxVNXmstzldiFKjZyS8VCN2gYMNRt
	 oXx4Lq2DwYff2pIz3UK/iF+neT8D+0KicdLE7wVWWq0UE5p2QlTtasGpzbuXxMrW18Kai
	 eCWfcJF/N/9mp+gg5+D4J1rXHKy/Hykbpu3/4lbHl1NGm6D4WMc+ep1oO7/m//4Fj5c3X
	 u1h4vP1NwiyyuGnQoiIZ7qlPsupBOQ+cy7HuHesZxTy77a3WIBqvOUntfyaIP6+7W05PQ
	 2gyzHf7bXruVdOMEv5giHLF59CHt78mvb6tzi/vtFse1hqmD5Grz0rXEmpgXsKcmndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WSVSLqjG;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EEC606A33B
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81EEC606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WSVSLqjG
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48df02b91f9so823849f8f.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839235; x=1795444035; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ys9OiBJUlo0yeYgXBzy5BjlTE2/m4y7kU18rGSki1UU=;
        b=WSVSLqjGC61PdcFgTu+Vr/yEpovVpvvwxs7N0K0f+vp74ev8aCjCltuij/cCsqwg+h
         EaqY9eXiJiOE2sY4J3oUQLaNuWRarVXDJXL7NX9tQpjpXIACyV5oELc71lbNREnfuq9e
         TWoREuUfGuxJ7j8Iu4uj0adqe6I/wzF5z1fWlP6g+cSQRl/hnNw87c/aYlDwAcF+t8Hs
         xCO8GyfSVA63EiaLaUzp1PsqXBMXB0TUD+PLWH+t9TP6JqTR+vlHyDspndx/FI4krW+q
         onYqtrLdyPxK1TefTGy0oEriMHBqMs4prdZfoZxrkh9twkA+f+ve4lSCb1mHkLFmehVZ
         5Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839235; x=1795444035;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ys9OiBJUlo0yeYgXBzy5BjlTE2/m4y7kU18rGSki1UU=;
        b=ypasAKKufIJU0mezfqAU6jnD8tiXJuDx74mwpOS+NAiMTu6cR4sB135ELvA2K3EYgG
         WCb6132XR5NAkJNaW1WWNZd6xhNVp/di/w32wk0jrAO6dLn56Qf9qtCt0w3lkbMdInOs
         kOVXSRn2k3MGranL+hCqp5OOrHPpx90icJDgyqfCqP+zTcU+OOWyTnCaF72JM/UBrjPy
         SXo1rzjMu23mZfgwXM4WBu+/LGqSpht6bV+KuzUBfN56zbOuP0UUZL6T51ENYcUAgaGN
         lCbNGqd9ACzDDyrY5b53pQYTHsgHQVmKe3i61zUoxy8riHijH7kv7C4XQCif2oTsv2A3
         Co9A==
X-Gm-Message-State: APuU4Z8i4fk2c9eKoL9WDVtJNTvlF5sg5vh6BlINQsceXf14CnN4zzij
	L2RsKT+KWuFnGDB+Ng0pqifXzd/7zt22y0qLxDjeABTjuxKv/6VN0fXaL+r3N8TdNWmPnYYGoku
	luTN6jLDWQIvdsWaFDs2ju/LDinqJ1b1LJA9DkkkAwIvuvA/+/zIbDY1icdwKNwvfNCiIcgBFi/
	ktG5ExeUjxPwPXh1SutYTmDwmjLhL7Dw==
X-Received: from wrbdt8.prod.google.com ([2002:a05:6000:d08:b0:48c:4566:c9eb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6a0d:b0:4b9:f90b:1c4d
 with SMTP id 5b1f17b1804b1-4bb4e2d5f2bmr239377595e9.5.1794839234339; Mon, 16
 Nov 2026 06:27:14 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:21 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1472; i=ardb@kernel.org;
 h=from:subject; bh=mmsq8s70dc7bNFJDZXgqjzymvtzE/nNvMalQITqcOTw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu3UJ9vcdyFG2nWGW/zz3w2eSlTsfeBxTOhJUZZb6ctf
 Vhnf+hjRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiI4SSG/z7r9Rf6bZwfUfP4
 kLHJCjYONxfmqZofN0xSXf/nxdmg0BqGv/IeFg0uLJvZl19WUD+yJqV1hbSMkWSL2P5b2xdw7/x oygwA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-19-ardb+git@google.com>
Subject: [PATCH v3 02/15] riscv: Use _stext not _text to denote the start of
 kernel code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On RISC-V, _text and _stext currently refer to the same location, i.e.,
the start of the .text output section, which follows the image header
(.head.text) emitted by HEAD_TEXT_SECTION. _start is the symbol that
refers to the actual start of the image.

On other architectures such as arm64, _text refers to the start of the
image, and _stext to the start of the kernel code, and generic code
(such as the EFI stub) may start relying on this distinction.

So switch the only user of _text in arch/riscv, i.e., the "Kernel code"
resource that is exposed via /proc/iomem (and from which the "Kernel
image" resource inherits its start address), over to _stext. This is a
no-op given that both symbols currently resolve to the same address, but
it permits _text to be moved to the start of the image, making it an
alias of _start.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index d79f99b86033..e6112d424fde 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -91,7 +91,7 @@ static int __init add_kernel_resources(void)
 	 * child nodes.
 	 */
 
-	code_res.start = __pa_symbol(_text);
+	code_res.start = __pa_symbol(_stext);
 	code_res.end = __pa_symbol(_etext) - 1;
 	code_res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-- 
2.56.0.611.g1030f0b940-goog

