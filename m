Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313068;
	b=otFKsJfaMuYoVTeAhL5756NLVlbaI134Q85ke3kfCUE3mq8LxuR5qO7P53lrbaOxm0la
	 uq7CPhQCcswCTIegzb7VAcTKVcckDH48z7lAPBVRGfqqmE4X61cCB82hH2MS2SFukxuTT
	 AODrV2Mcp7D3/DCN4hW6vHpnT8fITWtlvZx8CfeZ7XiOtXpeS6NncMw0ZznA8WUEs4xvV
	 k6Fld4iHMkgrfkm2uW5RlmBxQjECLj4jLzsvDq42PM4HipC0yHjzqEMAxW7LSzp2VTC6b
	 ilo36UzVR0d4onRJ3YEVejDLfuA90OaUb01nmc1twPc2WDRSJ+kqeP6h4Q5lNjgGi3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=vWyWnC7FTB1F4LSiq4vWzvhtzfzrYrtPmxSukIMBSxY=;
	b=KUSKtD3ajXffaaNFrg3VliH5AxG2E6BXoEgAoYWv2QdA/nv4sBuI52XIeP9wZgGJl5D8
	 MmEfvmZVg7R3zzgf5tvX/3YJa56i6v79PNZ83U1os7L9ryRiN+HuvgyvLBl82d1F+nNoh
	 Z2fmMHHbxQp125GQP5TAk7+/i/JuBDOjujNgeZrZuy4NKG/Uya7FZUh3uYmjYSj0cMsRX
	 xvnbVLCHvpMVjRDpVTkQuu4pv8h8S7OVGNaXHYaeGww1EQhVvqQ00TGFWWFLPLKHfwnMa
	 ggKriTMnMCl4MVWcXTW18VBqmz/zTtf9eXjoFfIGNfR53wn4j+lKp4F28BR6Pmn5vCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="X/cLw/OZ";
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADD0606A32A
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ADD0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X/cLw/OZ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4afef353dd2so21117655e9.1
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313066; x=1794917866; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vWyWnC7FTB1F4LSiq4vWzvhtzfzrYrtPmxSukIMBSxY=;
        b=X/cLw/OZlYigHmPMVGeMYycx8w2WE0JIbe+srVJzJkexPui4yv1HMUTjzfXoRrZ5fD
         WghvZtgMklSH7aPcm6dhGUjXqZyMjsWgHWFVqp33Bi6/qTncjA5ZGIjYPfnrJUO86onC
         DauK1oH6z49MLKZoH8/wwtt5XbtRbCxrpo7Wxr6gm36fz+OiCvHrt4IXQ+bB25rk1dEX
         cbnhSk6eREXpvx2l1zn0mneJk7Olrnc/fxlwwpuJJwSuPvkzXGrSQpf5pym3LfYjacux
         umK/hAaIRnhpDGnV529THybKZzZKzomMaqP6kM4mGeqJuYOllRecpds92H5eW15+AVzA
         aikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313066; x=1794917866;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vWyWnC7FTB1F4LSiq4vWzvhtzfzrYrtPmxSukIMBSxY=;
        b=ncRWU6R8Wjgk7ixI7PiEut5k6kOOZ4OzY12q23fYM8jMEWzwqU2+pql5MpKX6c8J8I
         CIFan0pF6XaynVqQk3yebaWEzYIrNbCJj80nAJeeFuUjBwB6roGbg8MUJ+tH20fzWh3g
         vMxuVkPXGDJf4P7+swn7newMZnuB1dKDDo5uwRgvBmm8yPLQPdH8z/A4seAm9qD8HFfN
         TCReqrbu02oG0AHapOCVKQfoMwpMq7p1CP/tvbWmT/ermIJXZ1lGmsqpunUt1Eys6WCz
         PDIv6lutIuvUctCyMXElGfPdE/JauGUGNNl3Y+VtInj+Sqi4wsd3FqSJUXlCK/6ksbV/
         8Euw==
X-Gm-Message-State: APuU4Z+2IRZWfE+RhNgMK9fituecrkZDqU6cbrUt5Z/a/HwxhQ7uzSfP
	HJWn7XfTfSoetUIGrP7sxExvWNgcZjdGmjOgIsHJ8FKW3uBTIrUYD8gZZ8aOC6xMeOcTkiwofzr
	oFaYBTeM5hB7u+RWSDORy6KD+VD9yjxmJY+We4pyPLiizT7fKMbEtKANrrM/VLla4BohWu/gVPH
	uheWnA/iA9yVpszijbafYmh7K/Z7/lxA==
X-Received: from wmbh27.prod.google.com ([2002:a05:600c:a11b:b0:4a1:f1e1:c6d6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6290:b0:4a6:7d6:821f
 with SMTP id 5b1f17b1804b1-4ba02350573mr44083795e9.29.1794313065550; Tue, 10
 Nov 2026 04:17:45 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:38 +0100
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
Message-ID: <20261110121731.2728824-18-ardb+git@google.com>
Subject: [PATCH v2 06/10] efi/libstub: loongarch: Use struct efi_image_info to
 access image properties
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of exposing individual symbols to the EFI stub explicitly via
the linker script, use the generic struct efi_image_info, which accesses
the original symbols via PC-relative references from the stub itself.

This improves code reuse across architectures, and makes it easier to
add new references in a generic manner.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/loongarch/kernel/image-vars.h            | 1 -
 drivers/firmware/efi/libstub/loongarch-stub.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e557ebd46c2b..d8676cea754a 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -8,7 +8,6 @@
 #ifdef CONFIG_EFI_STUB
 
 __efistub_strcmp		= strcmp;
-__efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index c87ac7025107..ab7e73e38334 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -118,7 +118,5 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 unsigned long kernel_entry_address(unsigned long kernel_addr,
 		efi_loaded_image_t *image)
 {
-	unsigned long base = (unsigned long)image->image_base;
-
-	return (unsigned long)&kernel_entry - base + kernel_addr;
+	return kernel_addr + efistub_kernel_entry_offset(efistub_get_image_info());
 }
-- 
2.56.0.542.g3ef89b7020-goog

