Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026111;
	b=PWetW53gxHGrwQGV8hqNkTSAoGD9eRvoEHh+jpjXKyjfajNUO2MyRzvlzc6F0n5lxXYy
	 Ba8b5OQk6HBFJZDxVKCPV5/s45i9F7ga1fcoGSFuLq8TlIvJ09X7IlKZO8MnyvSKMoH+k
	 DBua3ai3YgKQkFP3lMF2Dc9loToxgREr7U3X3y+f2wYdwqH3UK9QY4hANztrnmEfvNSN8
	 BrKZCUJxCCEUv1LCfjuobmgIFS+HQrj76hRmT1JVHLEPsqR9mPKIWxZTrilVxhxZqR3lH
	 Ftyyb1xTae5ZwCsfpUsHuUow14iWJPXAM09xNbekQRZwBsuKwzpRjMVQnoAC8805UdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=8uARk++meO5zgQMDlHPkaRg5Ipl+Zw0cx2xa6wUMMvU=;
	b=iQ2avkv7Ns1LfNy/oYbEzh9qSOZ0l+cVEZEDxUAW0J6itvAGBE8EVCLVB/M7JkI2ZFNQ
	 4qmVJL4MerV3lj5715B2+zconu0XnIrGxKf2rrMWE3VzsPsqYvCC6KHno9Y0k/9WTeDCk
	 Og0Cwt9/l7wy1H7B5KjuFxbvf53BqoUGdAnq74Axx52yDCg+4vvySr3FvPK/f0hSLzGMA
	 rFiNB7iXyzKhzYIJUM+E7p5V1iOTkKUCE9uZJxhy3wkM821yDtrioG7bMUuCOJasKTzYY
	 Va0vsAJMffzaNh4sPoBnTyasNqulBGWqR5BBAF+JcynFjTrkegTWuHE+TLxwW0ZpKkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IDPIymfr;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6389606A32A
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6389606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IDPIymfr
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-492b5408dedso883919f8f.3
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026109; x=1795630909; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8uARk++meO5zgQMDlHPkaRg5Ipl+Zw0cx2xa6wUMMvU=;
        b=IDPIymfrN+uOvgQfIVygubOhBYmoyZLfOk+ZKUwNEER+uMwukrcG4arivrAr3J4LFC
         5AcV7ENT+i4mh41wANZNchGKkPd3ZE3DTp+PuDz0BxhYmPi3ysItfNnLHhgEghzR8a1b
         jzYe0Kx/DcVOaKVfdEEB0XBVjc5zIx8j7a6n3nID6VZXdD8lY3UivXCSnDaR+vcu0FR3
         UCp3QMHEvR4Pm7RODNlPVq9q9luekNLk60KLPmPeUQcPYkLKYWkqT1+X7KkkCBilk2Xs
         b3VKuBcF619UzWj+0SB2xdHpF4dnx4dIa/FSLWc5c2SdenJZogKE4xSPB/UL1UV+Knrt
         AmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026109; x=1795630909;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uARk++meO5zgQMDlHPkaRg5Ipl+Zw0cx2xa6wUMMvU=;
        b=VctverE22TQ/X9r63+ShU6NxRMEGEEHV32HDLvI7AgeFZIw0A+wOVUsmTvfFqMcZzU
         fOioztuQi03Z/tEUdn5v4hhyQSYw1NUwsp+3Cm/Z4t5z0eiptZHGwMn2F6ogtkS0L/4F
         dsCzwdGUManaE1QLD7nKz3batMpXYFg8mjLOk6ezc1kteUjYiIeHRDTzKJQnuxCG/Yw0
         v9hR1e4Y6Ve/oBjHHxqOtZ2ck0572EiRxGptLXI9SuDxlLCoNPVdarTgtFeb2nOUxtRN
         FEsFvc5z2kwDbJmlwJx41/aGdkbuS6EoEp+ChJ+f8GjGEmJ05gpoGnqvOIrDkggy2GhF
         dGYw==
X-Gm-Message-State: APuU4Z9JJj8YB6afPkCWg4j0kv5pX/6M6R5Z4UZAIsCMqEzcRr7TN6Ow
	8yPEgde9JLXs9fmFdHhVqKqJ7axtqkUCJL25K8sWjKJOAO17x1JkhDwtb2paBkSYcDgKTUBzCPl
	axBgO3uZZc+pbs79ht0V4Mjx4mPcndVTvSF8d/iBCSUjQs/YSim9LRgd+tnQ8QF9udMp3/xhN1v
	XjP+ih9jPJZW9SfetHk8EdZpomBYVV7Q==
X-Received: from wruh8.prod.google.com ([2002:a5d:6888:0:b0:4a7:4422:f19c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:468b:b0:4bb:6cef:d14b
 with SMTP id 5b1f17b1804b1-4bb7d5d64c3mr73846785e9.2.1795026108878; Wed, 18
 Nov 2026 10:21:48 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:08 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1519; i=ardb@kernel.org;
 h=from:subject; bh=vKdz9BGSZVExEz+d9rJxUgExCcdNux9c9+LOmmgmNfY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvmymTmUW7PTesiP30fqlynVQUw7ELZQZ1eu0r/0sfD
 THmbeTsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABO5sILhr3jAfmfn0L3nqq/N
 4sjPd9leY7N46grXDmOWVeV76+sV5jEy7Mrxff+YpWTaT9GJLTl/ck9uODnZ+qH+kt6Sk/v3H0i IZQIA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-23-ardb+git@google.com>
Subject: [PATCH v4 02/19] riscv: Use _stext not _text to denote the start of
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
2.56.1.708.g77570a6a1d-goog

