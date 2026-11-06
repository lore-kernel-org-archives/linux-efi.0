Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974798;
	b=nwnAq+mMriq4idBmEwFDcHzkBxiTjmBtmGapWd/MSF5GjI8Buo21bznVOMVwYP8Cng3t
	 Uj2B8GRi3AfWPT2FRlSHONaZ+l1CUI2/sI7n1EIzrdg9ONbKbQ2U/98cCDAH6CqVAsPBO
	 4s8KDH6W8LjoIsbmfZ7zXCx2ov58Y87ofe+pDBa7Xi2/5lEXOzHmNJd1znHVmk9n7fFwX
	 EM8+vGeOmWJmhYzoqxpHaAgxvHDc75/tqG00Evee4xh+m+6feSP4izxIyisospXepfi2v
	 KWy/fHBdmSqGUx+nGvLmIVEMD8Jr+kXPVHcJrKqiy8TnUpyLeQgmyBY4LEJMiRZ8oRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974798;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Q87JkWe4IOxAaj+S1cTCBpK2mbAExz1BAJFg9wuG6Mc=;
	b=yn5Gt+IRonBlMDy+VMZAsE7AA5bxD0WXKOWussYc8MToxkk64KroanvdsBlFvH9dnGsJ
	 /07AwkROWqIXIaNpiSMwrg6RYDoCLwlU86zaYN8NngfnhnUT0B1pyPNPw06hmyNEvSukQ
	 IPiGJdopPqF2kxwfsE88GWRkWKKTh0cTyllvoQ8Cx3yXbDM+m99pvnPxbiTHWC+4Akm1T
	 jkuldpwvqjtiMgLIEyplYcg3XKRoIbgX3WlZcD0Ned1qZOdMIzVQo659i/ml95H5lRtOu
	 hFg4RvJtyXPtLlmtDNE6UQFNvtsp/Xt9esaDqNSkIJqQwW2JOjfcWorQxCmt9bSBvOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Znu86eqF;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B29606A330
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:19:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B29606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Znu86eqF
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c49b95262a5so54404166b.3
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793974796; x=1794579596; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q87JkWe4IOxAaj+S1cTCBpK2mbAExz1BAJFg9wuG6Mc=;
        b=Znu86eqFCd9FyEdQbuDEnFYavZ8IfUej/NwuYZBEfxAfYiG8FgPl5IPsx/WCh6krVp
         wbHyKJbL2aWOo7NjkQNcPL7NtpWtxPKrO5wCX3v3doLmkmNWrLUld2x7btNjVvq9htZc
         TdTFhN40uj326utK6/gpvRmLatFS02sxJr1sr+b9wmE0FokpUfKOxxGmW7I+7q2V+UII
         ezBYv6hZtLgNT69rDDgpi+lSlOHHoCStjiT2iFZVm+OQBqHKBVFKb3e4/47wEjXSVQH4
         IE6tlOQgJgqzfM6G3X3QvIxGM2deGClYXO0IRkjPI8ebN8C2uh+uksXV8pDcvzwJCgYW
         HVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974796; x=1794579596;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q87JkWe4IOxAaj+S1cTCBpK2mbAExz1BAJFg9wuG6Mc=;
        b=js68m6EJHbRRweAV263iym1wdEczCgi+nZzhM+uvUDYMI+xAGTlFVXAAshUQmIvfWg
         /TbQDHglhpwQBIMkZq3oRBUbqJhZYJdzsGAmPxpDCn/EHInMnEQX40LleaOpO0Wbxrjw
         rYxzYN9RbNENqoxaJBSgfl2a980idj67vRrE/FtRWdYUVaxGSZNIRQgRd59dXshcQ9fh
         hqm0CQdDE+N7lAI/JOd7in5jUC7CU6Ab75pqdaTXMJPwG9I41XFS1YYqHJUnLXvIbF/U
         X6yrA7Abu/qtyYIZETKLuKBFrKW9weGy4ZaXXlNtYtnTLtOJ+V5978mJARdrsmzL2jpO
         bxQg==
X-Gm-Message-State: APuU4Z9KMHd6qmAEUIFbz8+LPmcuHhBIN0qPGXWgtMFGF/jjp77bYqgo
	5ccV/shqLUp179QL5c74HTmguu0GZcLhTQVb4VNXCTL7hIg56BhBF2pC5DWBAoEs2+6OL0gjw8X
	uCp8CZmOnyVsYpvqZFL27oADeT2iKvXhQPwUkMDKY3/2GaJ2fhseZt9Y9kwaau7Jf7m4n8gUYbw
	BrU8ImDgRE6lcBDD8Ef1X/Pld3fYggJA==
X-Received: from ejda5.prod.google.com ([2002:a17:906:2745:b0:c3f:8199:7182])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:99c1:b0:c49:df71:14f5
 with SMTP id a640c23a62f3a-c4d34c5fe59mr235201566b.31.1793974795660; Fri, 06
 Nov 2026 06:19:55 -0800 (PST)
Date: Fri,  6 Nov 2026 15:19:42 +0100
In-Reply-To: <20261106141936.2744481-7-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261106141936.2744481-7-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106141936.2744481-12-ardb+git@google.com>
Subject: [PATCH 5/5] efi/arm64: Drop build and linker script hacks to obtain
 image code size
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of taking vmlinux symbol values at build time and poking them
into the zboot linker script, wire up struct efi_image_info so this
information can be obtained from the code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/boot/Makefile                  |  3 ---
 arch/arm64/include/asm/efi.h              | 11 ++++++++---
 arch/arm64/kernel/image-vars.h            |  4 ----
 drivers/firmware/efi/libstub/arm64-stub.c |  2 ++
 drivers/firmware/efi/libstub/arm64.c      |  4 +---
 drivers/firmware/efi/libstub/zboot.lds    |  7 -------
 6 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/Makefile b/arch/arm64/boot/Makefile
index d42d07667822..509b59518818 100644
--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -51,7 +51,4 @@ EFI_ZBOOT_BFD_TARGET	:= elf64-littleaarch64
 EFI_ZBOOT_MACH_TYPE	:= ARM64
 EFI_ZBOOT_FORWARD_CFI	:= $(CONFIG_ARM64_BTI_KERNEL)
 
-EFI_ZBOOT_OBJCOPY_FLAGS	= --add-symbol zboot_code_size=0x$$( \
-				$(NM) vmlinux|grep _kernel_codesize|cut -d' ' -f1)
-
 include $(srctree)/drivers/firmware/efi/libstub/Makefile.zboot
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index b0c9120b9741..3194e133a4d5 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -151,10 +151,15 @@ efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f);
 
 void efi_icache_sync(unsigned long start, unsigned long end);
 
-// temporary resolution for efistub_get_code_size()
-#define efistub_get_code_size(image_info) ({ extern u32 code_size; code_size; })
-
 struct efi_image_info {
+	s32 _text_offset;
+	s32 __inittext_end_offset;
 };
 
+static inline u32 efistub_get_code_size(const struct efi_image_info *info)
+{
+	return info->__inittext_end_offset - info->_text_offset;
+}
+#define efistub_get_code_size efistub_get_code_size
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 19d602e45523..b02234f080b0 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -150,10 +150,6 @@ KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
 
 #endif /* CONFIG_KVM */
 
-#ifdef CONFIG_EFI_ZBOOT
-_kernel_codesize = ABSOLUTE(__inittext_end - _text);
-#endif
-
 /*
  * LLD will occasionally error out with a '__init_end does not converge' error
  * if INIT_IDMAP_DIR_SIZE is defined in terms of _end, as this results in a
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 8daed681f97d..754cb2843967 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -68,6 +68,8 @@ asm("	.section \".rodata\", \"a\", %progbits;			" \
     "	.align	3;						" \
     "	.globl	efi_image_info;					" \
     "efi_image_info:						" \
+    "	.long	_text - efi_image_info;				" \
+    "	.long	__inittext_end - efi_image_info;		" \
     "	.previous						");
 
 
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index 190cf180bb23..da6fa2f6c821 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -88,8 +88,6 @@ efi_status_t check_platform_features(void)
 #define DCTYPE	"cvau"
 #endif
 
-u32 __weak code_size;
-
 void efi_cache_sync_image(unsigned long image_base,
 			  unsigned long alloc_size)
 {
@@ -100,7 +98,7 @@ void efi_cache_sync_image(unsigned long image_base,
 	/* only perform the cache maintenance if needed for I/D coherency */
 	if (!(ctr & BIT(CTR_EL0_IDC_SHIFT))) {
 		unsigned long base = image_base;
-		unsigned long size = code_size;
+		unsigned long size = alloc_size;
 
 		do {
 			asm("dc " DCTYPE ", %0" :: "r"(base));
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index 367907eb7d86..61714a151766 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -2,8 +2,6 @@
 
 ENTRY(__efistub_efi_zboot_header);
 
-PROVIDE(zboot_code_size = ABSOLUTE(0));
-
 SECTIONS
 {
 	.head : ALIGN(4096) {
@@ -20,11 +18,6 @@ SECTIONS
 		__efistub_payload_size = . - 4;
 		__efistub__gzdata_end = .;
 		*(.rodata* .init.rodata* .srodata*)
-
-		. = ALIGN(4);
-		__efistub_code_size = .;
-		LONG(zboot_code_size);
-
 		_etext = ALIGN(4096);
 		. = _etext;
 	}
-- 
2.56.0.455.g6c5a503b38-goog

