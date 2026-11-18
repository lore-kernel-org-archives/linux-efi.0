Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026131;
	b=gSCn3F+NsT1yx7Hys37Yc1Uj1HpcJNHQWWNfF8HvmsrCFrbKYgrqmgVgBAyrktCR4Qgv
	 JJCXzLLfcDgosoqcl7u+gqVPhsDgtCcnJiwR1M3HVxMscJkY5I6FYzNUf4ZBcvbES07SO
	 +6976EOUUJs1YEGK5OXecgaRLmhMVajqef0lj2sG6Lv6cOsKR5oqffw/z0uUH+X+8hAj8
	 hw+iHL9q/L4Ib/zT4w74F1It2eg6RQgzAmJa34mLV7rn5Q61lDmi1PGKRwX/ZLqePAOyV
	 HK6m4itTZ3/aAKhr3Liph4i0E+H2zk1rzvemyvtBSxVxNQYQAVFsgAuypp3N6nEezZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=/w24HJ5snxMHL69L/+mJ+Lj7pv3WZPo9wKgPL92/NjM=;
	b=oBH7DaSSQ7kd7GP+nj/kLQ5LJbR4i2TWbvKw7U0ShxL1QeMKweMiuXJQxzdYVo8SnOqZ
	 BiuwQR6QVlueUj6pN4XIUqAzYQpBIB2HXUyz0Fvtl3OousmKQOvuSfi0JktH3STBWjLdw
	 erXoTThSiPXsGd6AXDjuip2Vyih9f1cfi4MtAru3kJbpV8EcoOuIaZjKQ2lKlJP/1fD/9
	 QPbNMcoxx5orj1YsQOztKUIlsfjLmkjPbCsMtwPmxoYfWHs5dYjN5Npl4/t6kEB8/2/wk
	 bWOSK5KvpgmRbkFkcEBL1ezGkd3PZOqkxsfGCpw6aDwFd9ZYWfjEdeel3PkF4ZK0EFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m2y0eQ7b;
	arc=none smtp.remote-ip=209.85.208.198
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572EE606A32A
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 572EE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m2y0eQ7b
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3adfb3ca48bso7057701fa.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026128; x=1795630928; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/w24HJ5snxMHL69L/+mJ+Lj7pv3WZPo9wKgPL92/NjM=;
        b=m2y0eQ7bX0mEqt69O2PDyvpd+qH0vwTqyJk8vUwtRuMBor07EwffZ2+WwgCO2+P3oU
         kEzpqlE06jQxbmtJRs8VLGlplTvOFs4qEw0+njsnBy85AYJoQzvM0W6BB0+PoPtGMA4c
         5XNsLKGRyXFADUwB0kq1UIVVmKBLl4eZ5voqnalrREBkoZp70ZrpaIFF8Vt65Ie+RNI6
         lnvZt+v49zu1uXn5USKw4CJfhvRZ1jBqQFXJnN0/nrv9mBcSPvlLmEAOG3qLD99BsN4R
         tRr1sKJYaANZOXze/TK/G9W1j2+186Re/qxoAJmOUizRfSHnTYU2Jxnt1JwK82Mjjr+Y
         AWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026128; x=1795630928;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/w24HJ5snxMHL69L/+mJ+Lj7pv3WZPo9wKgPL92/NjM=;
        b=wPGGiR95rev4/CrQQj2TSv3dmzD0YF5fe63cyfKZ3tc7yjzVI4+rIAt8O8z+7w2/g+
         1NOntZgsU7yPboVc2IH2UysDuoPOxa9qC0Yz+yOT4Yjhv7W1JlKLsrmvS9z1L9Yd6GUC
         pWBwzBThlrkm4CrjS1rByn0Bd2dFh4hKjEaxY8HO6hpIivb9hwhp3zXe0SUD7AC8tgqv
         QXQqoTjO/HWC9UO3FRZS5One+zC8R+lS9oI3X6TUoCCSJVhpMbzJ1CaFVoEiHnC4ufEP
         1cPYNe+WdUBdb815ORbNyfIXQRz3mUa0QxlPfLlYhJjIoPZ6bGiFu5cpW4jL/y6IwaQd
         VTTw==
X-Gm-Message-State: APuU4Z/Pj10h4CwEmd9TaWWUOJUnJcmgOVZG7ECS3ZhIf+24p7T+llMm
	qbakNKbbdqijuSqrILwjN6FgsaWHTngxpHGyBtocDaFADmfA8dghpjKBsTwqM16n7FHRIghlMls
	SwV5ozjztglRHqnX+IEYXtZqChCNUR6maU1A5Ait2JA0UwDhAnVtfRptvv6RjTiYhQDmYEamSeN
	MQdZkY7ZPfKaMuGpZ9TEpfqaFdY/FsPw==
X-Received: from ljke10.prod.google.com ([2002:a2e:9e0a:0:b0:3ad:cb6c:2eac])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:128e:b0:5c1:57c0:50a
 with SMTP id 2adb3069b0e04-5c1a9a70da2mr1102294e87.6.1795026128043; Wed, 18
 Nov 2026 10:22:08 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:18 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2668; i=ardb@kernel.org;
 h=from:subject; bh=wNLIXVywodXJ9QBXpbGE8MqPkM5GL227KxQF5YBIKeY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm8UspUdmNPI807zatFKuZGFOu/OMG3lnPcRsJ5rUJ
 X++mbG6o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk219GhssVs7fNSPr4JkY6
 9cIMJd616y69vOvOc1Xs3umnGyxWl+QxMhz7evb0mumaBSbvtE8JXJ+SF/3miIWf0/QjVh27X/6 +xM8GAA==
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-33-ardb+git@google.com>
Subject: [PATCH v4 12/19] efi/libstub: arm64: Use struct efi_image_info to
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/image-vars.h            | 10 ----------
 drivers/firmware/efi/libstub/arm64-stub.c |  8 +++++---
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 19d602e45523..329d5e214b36 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -20,8 +20,6 @@
 	PROVIDE(pisym = sym);		\
 	ASSERT((sym - KIMAGE_VADDR) < (__bss_start - KIMAGE_VADDR), #msg)
 
-PROVIDE(__efistub_primary_entry		= primary_entry);
-
 /*
  * The EFI stub has its own symbol namespace prefixed by __efistub_, to
  * isolate it from the kernel proper. The following symbols are legally
@@ -32,14 +30,6 @@ PROVIDE(__efistub_primary_entry		= primary_entry);
  * position independent manner
  */
 PROVIDE(__efistub_caches_clean_inval_pou = __pi_caches_clean_inval_pou);
-
-PROVIDE(__efistub__text			= _text);
-PROVIDE(__efistub__end			= _end);
-PROVIDE(__efistub___inittext_end       	= __inittext_end);
-PROVIDE(__efistub__edata		= _edata);
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
-PROVIDE(__efistub_sysfb_primary_display	= sysfb_primary_display);
-#endif
 PROVIDE(__efistub__ctype		= _ctype);
 
 PROVIDE(__pi___memcpy			= __pi_memcpy);
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index af38cf73cf01..351fcb4493e1 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -19,12 +19,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
 {
-	if (image->image_base != _text) {
+	unsigned long kernel_base = efistub_kernel_base(*image_info);
+
+	if (image->image_base != (void *)kernel_base) {
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
-		image->image_base = _text;
+		image->image_base = (void *)kernel_base;
 	}
 
-	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
+	if (!IS_ALIGNED(kernel_base, SEGMENT_ALIGN))
 		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
 			SEGMENT_ALIGN >> 10);
 
-- 
2.56.1.708.g77570a6a1d-goog

