Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026138;
	b=S5mCSHVBF0nTBmujS7b/bITc61K2Us6YwymNuNlgNHw64eA3n7i7dAxHhta34V5qLizy
	 ByI/7gGZNjuMYRuO5JeZcYJWspHtzAHxUE0Ch0ikmbGY3yclpdG+sHNk0rDcen6wSM56s
	 vny+Z7DjIPjP8j12VUoIn8S0Dj4JH2I+mk6yJNPwgw9cIbWz79P7wIuuF9N7ntoZLBCdU
	 1WYXnvtCsSDQidn6XBm6f5T/TgDGj+EpMHLTPo8l4xx+JN+jjaNp2l/nKQ/bu2ndZhiac
	 pOTL5oH+d83sFxyNQC46kbUJfiSk3i/b/i0BJ4ckMv11Q0XjOs7AOLD+1c6bjuAOWNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026138;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=8sF7COacRN1vGXnrZrNazsi2/3EiiL8z1PsIPlc+wKk=;
	b=gfF9Jqdjk3S0Xwf5DrAtlGPxLhPkb2beRmybF3ImQStUzhy1nSgsKbaiMVOAYVIDM7qx
	 DWuOqz0nYhzvdvBCMohAOFVka1Xd1rPcEdv9s+jGaH8xxSnpaaxC1jEpKd3h1t4jDGQlb
	 IhMqwcdvsHA83hNOHDbEn7/gKtXDI0UZiCISASLnfpQLpJ73c8s0QDwdm5ZCxfqrsW2yq
	 D+y2Cbz7pX6RwNJpWoSJ+eOS9G1D3kAcmx8Fzjnl3tXhSKsKNMcWyhELfZ77wl8SS7SzT
	 n4zWXHhSmxjXcgmDvcgdBoSGgkQU4Q9lzA9WiG23DBUtWtQC+1vbuZywQp4W4v1pN3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kCTgs1dQ;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D15606A32F
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2D15606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kCTgs1dQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso10966435e9.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026136; x=1795630936; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8sF7COacRN1vGXnrZrNazsi2/3EiiL8z1PsIPlc+wKk=;
        b=kCTgs1dQ25gfYTHGpydN8jlg1QTAiwAOVRdm2NLfBq1ulG9Vav9fnuZS7uXMHatE0y
         TKEa885fHVpcbO1BSyi42P3BzOdCuTrvV3y+yAt5pXlo67F9n1OkYvwP0ZiLl0dGUFJ2
         /yzfeXRPujOau5bm0b3DYWpD8mxnUr+V086tEBl5C3PU/WC5mB0a2NCExr2b0LEVUeaw
         L+D0fVkNjP7P2GPd+JYtAslbIbG7OUzL5QL4SYzSpCI+noWqULgqLxo/NI2jlT+LIIoW
         3hAtiZZZj4orNGBG64x1Q+wPeCuTU6POmB/Uj+JWXr1LH2up4ddvOZ0hTfzsRMekZF8c
         EKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026136; x=1795630936;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8sF7COacRN1vGXnrZrNazsi2/3EiiL8z1PsIPlc+wKk=;
        b=Rdrn5T3UqoolCiFDVV2pqJQue62fHoU0jsEy743JOfgKVQMgzF83X9abMS1HTP+AS1
         pMtfCk/bxvBYLREqcmjUYV+AHVFjU4bvIZj/y7dbO2jsKIbH1J4c2tZZ9MwzcE2mutZu
         m+O6bTUu9jcp2D2AfrGN4vnHVyvcbTc3gAWErb+Qup3PDdLUz29C7du1GanpAPBwHxsL
         kFtXQQiKWTRNFhLsrPd0GoK8clZJ/3nG32Ro+CFH9PHE2NdLv0uNGKZtJEUQlWX7BSqS
         BHW/HXHTKrxpMFF2L4QBPQ+MI16OYjlhi923bUeduSUke5XuOJDg+d73Oua07Zq8Lu+w
         nE4A==
X-Gm-Message-State: APuU4Z8x2obGFXUs35Cl//BpvfP0ZzSFANhog9DCuxBnrtqVbNKETKoW
	4RWig+0OsxDixu6ExZQQac+mxsRqgW/vlssMia/BZPGYEZdgqsHA1sqjAINrdDe5Qw99+mRUNh1
	GxR3zrZUEOk4d5gLvn5SQyv+F3CFPZBT/qKQjgkUMBKfLLkMogWJJo1VMbfmyEnBIi86XRHkXOY
	36Sxt5zA2XN2ibUVUXv78baQ+Nrwts1Q==
X-Received: from wmxt15-n1.prod.google.com ([2002:a05:600d:864f:10b0:4bb:609a:3944])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3555:b0:4a2:150f:1601
 with SMTP id 5b1f17b1804b1-4bb7da2be68mr70517655e9.12.1795026136002; Wed, 18
 Nov 2026 10:22:16 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:23 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2989; i=ardb@kernel.org;
 h=from:subject; bh=mMy4EOR4GKL669ZECvINo54lmzHNhYmaQBvXpm8/VGc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm1UmrxnyoqPFFE209K4fZTWeG7MtSqmC6ROf9YfZl
 Xe15KQ6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwETm9jAyzGPUu7r22ayNLf+V
 bb67davLvrqTphuU2Hpe0f73hFcrQxn+iosLFkU+ZtZgvOfNbiglFLlGbcbVis8FQhy1+U/E05d wAQA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-38-ardb+git@google.com>
Subject: [PATCH v4 17/19] efi/libstub: arm64: Drop zboot code_size hack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that the code size can be obtained via the generic image_info
struct, there is no longer a need to inject it explicitly during the
build.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/boot/Makefile               | 3 ---
 arch/arm64/kernel/image-vars.h         | 4 ----
 drivers/firmware/efi/libstub/arm64.c   | 4 +---
 drivers/firmware/efi/libstub/zboot.lds | 4 ----
 4 files changed, 1 insertion(+), 14 deletions(-)

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
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 329d5e214b36..ca634cedcf63 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -140,10 +140,6 @@ KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
 
 #endif /* CONFIG_KVM */
 
-#ifdef CONFIG_EFI_ZBOOT
-_kernel_codesize = ABSOLUTE(__inittext_end - _text);
-#endif
-
 /*
  * LLD will occasionally error out with a '__init_end does not converge' error
  * if INIT_IDMAP_DIR_SIZE is defined in terms of _end, as this results in a
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index f8bb890b9631..8a051412814d 100644
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
index e1365907f805..e0f0bf005854 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -2,8 +2,6 @@
 
 ENTRY(__efistub_efi_zboot_header);
 
-PROVIDE(zboot_code_size = ABSOLUTE(0));
-
 SECTIONS
 {
 	.head : ALIGN(4096) {
@@ -22,8 +20,6 @@ SECTIONS
 		*(.rodata* .init.rodata* .srodata*)
 
 		. = ALIGN(4);
-		__efistub_code_size = .;
-		LONG(zboot_code_size);
 		__efistub_efistub_image_info_offset = .;
 		LONG(efistub_image_info_offset);
 
-- 
2.56.1.708.g77570a6a1d-goog

