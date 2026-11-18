Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026114;
	b=cctg0XJdSNaQG5Op7fOYl34Nf+VvJ6paz7i+xj5l8J6zD/qFn/LtmJUTj+N9nFTXxn34
	 O82mewSAtCNuGiw2rshRdst3y7bmGWZL5Q5mSvXkPxFuM8AzUTqlMse22Y7rID120A5SV
	 l7r+F/PznAKYWEQ0W3ntGFnjSaQv2W/YFiPmXHwKVA5ANFf2XO1/BYbTnjXfOYWFA7dbb
	 C2YjYqJOR/INKdWB3ZuPIPs4g/ncoNN1j8msrEvKU60DNgf0o1IHypBHeA1IpI960TjCL
	 paIcxbEldartYIblNqw0OI9y0c1OfzOHAhw21GuIcg7k27PFZqkT6yNVpolEq2A4IfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=W3qJpbOK0S/KfzF1LTQDOmj6a+FOLurEzqYwJRYI91E=;
	b=rtCDa8fBc4Oft4WHUELZU8o8/8azmsywKx9QHA5Nm2X1zUepZ/5nZzn5XtvZZkTX0t6L
	 7NJOHc0z0WQEI0zn5gmAr92I8aGb9eQDzGbZxPSfGlE9xZcTELpsZbvN2OfLJwRvon6R3
	 TYuNB6d14XK5CV0eM+uUnEL4j5DR7KCHrW08Vd93jAutAMPzbk9Z3n5bY/JKYslMY9p1F
	 9cVVZOm+3MbCY+1w95c7xxugMoL15L24MqYseGjR2QJSUwwp98w6vNZRI/lj7se15de3Q
	 EixDIEIRaE6PyORyMJrMyOrHSLtAtMy9cFLDHUzKB4KMMAvRmsQisVz4KySzE2Wao0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fISJdmvv;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3B606A332
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44C3B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fISJdmvv
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-499ca65ae87so37000f8f.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026113; x=1795630913; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W3qJpbOK0S/KfzF1LTQDOmj6a+FOLurEzqYwJRYI91E=;
        b=fISJdmvvHP+23oMvqScl3H9Wpk7FcIIzpmaYIhwtU+XAs5vkZgga9eYqjP/yejd+u3
         Ct39+fkL4AREBqsF30LQsfx2XUqF2TuKFvI+JAUcBLp5Xw79INp/tYEmi/Oy8vv//8hm
         sFr5MEoG2EbCJW5cHI4VA8V+RWsIBdFRhmSM9wqxUvp/+RQA8RHaw/zIziyIcFraVhhw
         PUJ6c855QTpREXaeQfXO2lQ0WwoQuISbLS27YeXdMBCMkVWuTFKu8BOiQzfblhy9q7Fj
         xwgEbCEaHzk6CnmDs6FypUtmj3iKE38MsjijDl2jMD9LLpaB0MkrJOoKsAJ0Dw/mXwGt
         xK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026113; x=1795630913;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W3qJpbOK0S/KfzF1LTQDOmj6a+FOLurEzqYwJRYI91E=;
        b=tSAjAjFeRatKwhMRJtEVCxxF3kTXP5VCZeoavbPH+l8JdR3gmn40dwkFHBfQNGKQBo
         JBHlSMO5evopWTeiJupwW+8oiP6w4uXxlVEGOJPMbO58I0ZfM/6b9N78cSMgEyVIJpUH
         TJifpdXcC24s8TU8K9zFcsFf9R72n45zI3DNhN1kQLCWIWZft+11BWOm9DGaQndOrpGE
         1DHxDuinluFz+DsFKDtMhZy0STzfB8aX3kVoDjA30vwJenoQMXqsymPU3Mggq1Vq3Xwe
         a9GNiJBDdvMYUdJBPe52U5Z0UkjADCN0/B7v3QfyXV3Q7jbbBvWbnRnvPjWDvBCmulyA
         /Kjw==
X-Gm-Message-State: APuU4Z+nOa6Thgm7V9Eg2gNiFEL5KocnQVtqvjAw/dHj8QpLXjyWYYvo
	0rgGpYgg5YSjR+VUJE2/oxNFb2WsGHl1FhE+YxZXlXkLkjnH4bpHMxE6Re12PBiUMrJomfVhdtm
	GtKQdQK3NJidwFst8rxIfEv9PfJ13jGb7j8pqORRvTwtwxABTBeQxgm4vMsUASgGtgJ7ut7c2ED
	EmHGPhnIDT/b3D145j6hl7rq4CtP8rfQ==
X-Received: from wrul11.prod.google.com ([2002:a5d:668b:0:b0:4a3:5c5b:309f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4310:b0:492:2b36:a149
 with SMTP id ffacd0b85a97d-4a8ee39a399mr578670f8f.25.1795026112167; Wed, 18
 Nov 2026 10:21:52 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:10 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3105; i=ardb@kernel.org;
 h=from:subject; bh=VYcmCaSIFKr4fxWSLhFh8fGld9SRwA19gzbmJfyyOk0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm+mng60ZL704seN5fuy5j+HTcq/zyR2552qw+s+Ct
 aaXv4b86ihlYRDjYpAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQATaQlgZJj396zSquk9MRGb
 dkz+IGJ2SrfWan9054bMgFMBnCkejEcZGfov8D/7+szO6pHCcue/V6d7hTruuuX8qHCKxjflTRo qudwA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-25-ardb+git@google.com>
Subject: [PATCH v4 04/19] efi/riscv: Rename __init_text_end to __inittext_end
 like other archs
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Align RISC-V with arm64, LoongArch and x86, and drop the underscore
between 'init' and 'text' in the section markers. This allows the value
to be captured by generic EFI stub code that can be shared between all
those architectures.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/include/asm/sections.h         | 2 +-
 arch/riscv/kernel/image-vars.h            | 2 +-
 arch/riscv/kernel/vmlinux.lds.S           | 4 ++--
 drivers/firmware/efi/libstub/riscv-stub.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/sections.h b/arch/riscv/include/asm/sections.h
index a393d5035c54..4a882a28f414 100644
--- a/arch/riscv/include/asm/sections.h
+++ b/arch/riscv/include/asm/sections.h
@@ -11,7 +11,7 @@
 extern char _start[];
 extern char _start_kernel[];
 extern char __init_data_begin[], __init_data_end[];
-extern char __init_text_begin[], __init_text_end[];
+extern char __inittext_begin[], __inittext_end[];
 extern char __alt_start[], __alt_end[];
 extern char __exittext_begin[], __exittext_end[];
 
diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index 7b44b94f1283..bf703eba3fa5 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -27,7 +27,7 @@ __efistub__start		= _start;
 __efistub__start_kernel		= _start_kernel;
 __efistub__end			= _end;
 __efistub__edata		= _edata;
-__efistub___init_text_end	= __init_text_end;
+__efistub___inittext_end	= __inittext_end;
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 9849a3e4d102..0ec1b4b55e41 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -46,7 +46,7 @@ SECTIONS
 
 	. = ALIGN(SECTION_ALIGN);
 	__init_begin = .;
-	__init_text_begin = .;
+	__inittext_begin = .;
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) ALIGN(SECTION_ALIGN) { \
 		_sinittext = .;						\
 		INIT_TEXT						\
@@ -72,12 +72,12 @@ SECTIONS
 	}
 	__exittext_end = .;
 
-	__init_text_end = .;
 	. = ALIGN(SECTION_ALIGN);
 #ifdef CONFIG_EFI
 	. = ALIGN(PECOFF_SECTION_ALIGNMENT);
 	__pecoff_text_end = .;
 #endif
+	__inittext_end = .;
 	/* Start of init data section */
 	__init_data_begin = .;
 	INIT_DATA_SECTION(16)
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 725b634c5179..5cbc50a814e1 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -34,7 +34,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	efi_status_t status;
 
 	kernel_size = _edata - _start;
-	kernel_codesize = __init_text_end - _start;
+	kernel_codesize = __inittext_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
 	*reserve_size = kernel_memsize;
-- 
2.56.1.708.g77570a6a1d-goog

