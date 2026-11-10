Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313063;
	b=HBmQjO0A2yCa4qduFHBb7bw6ygbiMDRDVyoiGq9YOK9SYq4616vq9ev307THI/pe1U/x
	 xiTyiazFQmkI9pXe381e3V3hLgF7w1xE9QvxMCgH2e+3zQJQ11zuuDMd93bTyrk9YnOEX
	 re8nNxnojr3D2B/ALxyahAmIFO15bz3lupwXy9BtlEp4+lbyPApps78DigM/8koPnDhdy
	 3vxcUYyqzjbCUmtD1POW77z8PvTUPI2DcnedHnxDUNp/TA9/s73D/oro+wSbO5Xol9lGm
	 KgnqlSfnhmJRhi2FxRHg2slSCiONhErpJ4xS+wv62XSZ24+YVRSMIZ/v4MPkJPKgQeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313063;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=FKyHqeXkJfnFo2/e42CmLuZIRnayYURfHn0ko47n0QU=;
	b=ZG5EyEHw4SShsbIsNYzYsnnivcrfKAX2f1EcFUY1zOW6GGmOQsNO9PDB7jbhEkuOZ7ej
	 VtNJ92oJNjjzEU616DUL8WKqcSeDRzRMc0uAogM/E0zZ+Ep4s3T60rDT94ICj/UOeXiMT
	 S1rBrgneiKEP71mhFKLSjb828+t03A5TjwAi0/coHzWt8H8P79Zm18gP14pKT1aEmD/Zb
	 MqowSOlQIFPsi9VXD+Bn114GBEYwnwljXIXTfZie2FS5zveoVh+DNGaaEuNh/8OZMQT0B
	 azfWOA4kN2s+Y0aajZpTILpbrEMyevraj/gn/W+wUiXK7g7qCsDc9g/4z1fDoKmnPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LqGiCAVn;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619EC606A337
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 619EC606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LqGiCAVn
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a0284121c6so14461985e9.3
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313062; x=1794917862; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FKyHqeXkJfnFo2/e42CmLuZIRnayYURfHn0ko47n0QU=;
        b=LqGiCAVnMT4v01Gcy54a9sqhPccraR9pZHNHo6a6Rko7B0Wnpet5sE++UG4GkGIlf3
         7+ZYvNtez14dEsRumfX5w2L4qj9FYxFGrgmpwST4OWmezPuBAL6wPuRy+ZtJXw6ZTJF6
         po7dlwRVWa0GMSsbaCclMSCh3S1UMztOo6wlhdxxBErBtS5HOFEyPWgp2FY7gegzmUTw
         /pWYdw0LPNRn6wqLo6TX9/h6NNulsOEXqjingsEE/+EyxaeUQOs2oSpixhzry64fyAC2
         etQbDsM3k6QMMUbczXIOlvyx4EslLuCB8R0eGV9kzUqPtROQrx5FVfHzxZVsS/j8vhsF
         xpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313062; x=1794917862;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FKyHqeXkJfnFo2/e42CmLuZIRnayYURfHn0ko47n0QU=;
        b=pj9IqCo9kEEgvWwJaJ/y/rXH8vHrvxQQ83K/9S0DNT8fx06iKKIJWUSIIEuvjnTQ4K
         iwoA716YHqYOBF+H1lsM45mWKXnZKcIdhNyq4HKaip6ATc07Nss3DLaRVZqHXHn0zAqx
         tM+sN5r6AJ5AXKL22V7cidRIB6mTm/ii55C87PGun0XeFJMJ3EkVTnrlZD8wOABySaRh
         bmB/22YnwyVkCMipy99EbPCr8TR5Soi1qtqSzSqt29w5mE55io3dmreuXWbCHf4s43QP
         VPU3z238a7lasl28ExCg/s4sU6uev8HsxjDbMNbGyx4pdvMjQfRq7B6BhpxMDU2YbLCz
         zr3Q==
X-Gm-Message-State: APuU4Z92k3fcPfSjp+VtxnlDDvrGHH1dL6GnJtS2oeyYfEIMmwVXdMZ/
	3I90z7W+3viLtB+y2FdfrwN4zPdsgDLpTAge2MGcohzD/S0ADzx0WA33VzTlXKYeMVGLEeECxym
	k/az4+Sx6ZTVjDg0YthHe4WpLBfp0sQRNDGrZcjmeOnP9DqXONkp+lBayqmzx3L31KIPZhikYD3
	CymLCYwoAdB63YaTG4+/iwPL4IssSpUQ==
X-Received: from wrul8.prod.google.com ([2002:a5d:6688:0:b0:48d:edc0:5a37])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:198f:b0:4b4:49d7:bc25
 with SMTP id 5b1f17b1804b1-4ba0234a940mr39574545e9.21.1794313061406; Tue, 10
 Nov 2026 04:17:41 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:34 +0100
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
Message-ID: <20261110121731.2728824-14-ardb+git@google.com>
Subject: [PATCH v2 02/10] efi/riscv: Rename __init_text_end to __inittext_end
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
index 1f4f8496941a..08ada0591f3a 100644
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
@@ -72,7 +72,7 @@ SECTIONS
 	}
 	__exittext_end = .;
 
-	__init_text_end = .;
+	__inittext_end = .;
 	. = ALIGN(SECTION_ALIGN);
 #ifdef CONFIG_EFI
 	. = ALIGN(PECOFF_SECTION_ALIGNMENT);
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
2.56.0.542.g3ef89b7020-goog

