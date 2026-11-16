Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839250;
	b=RbRBYNcbdg8WUkUnFGDYFF7xvRGcNtbn4ETLFlgeYd2fz+EqVA/TWqWIbF6hB3LmCLwb
	 MfN9QKhakXXR60FrfHmWrNKpiFECLc/Xk+ZfOoxwyRSndlEkyFBHr8LHBbgONaQpM86oK
	 1Ge+TCOGTlt0JgU4+Lny2S1Z1ghHHyLKmN6Bj8cyhjyCZ82A85fK2OzGqVML61SWGQli6
	 T/SJUb+HXJIubHPqxYVpzqB6FFVg345OCm21HC2HeabWngh5SZCrGbEdebnsfDEe9xszq
	 /UYVLyhNaZHd7eKPKtpDUJvAgJC7PARaPfHDSqD6VAyMx/NTE+PJBHCBphl1cP2QDRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839250;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=K7Sgz3ld+ZNxi0hBngHAfrUu3ksDDoe/zQYxMmRp/T4=;
	b=pl2mgMPnhF25XljRyK3ENdIWbhtx19NhC9De4zBl2kLx4VIIL/iWxjQ8MomNVb4vVn4f
	 +L61tYI9UgqSqz+I5qDVB1FE4aHAa168CB/kgNNFk360qROcukKVwGd1lgIuvTZs0W+N9
	 r7lP7KEVL27/6vpZSofatVpG443/dWqK00//046LxW8jdiv2sqQnToRspx7eExaSo+4bW
	 vPbqq2mcNiQiGtUQCRf98IKRRPwjhZ3BqxIxOPgTR0dGHO+8JTAJjMheLb3dNCVJw1Ii2
	 RYeOZVYK2RoZUW8LFK1jY/3v0LRA5ZfUvAr2ZxnyiMlrrdKWkz9QZtiKR6wowHDrJQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hFs+c+ug;
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E9A606A32F
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59E9A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hFs+c+ug
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4901562b819so3237524f8f.3
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839249; x=1795444049; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K7Sgz3ld+ZNxi0hBngHAfrUu3ksDDoe/zQYxMmRp/T4=;
        b=hFs+c+ugtqCjd9KBTKVrrqUwz4IXFZebxuu6rh0tk49uhKE0LO1YfqnMy68XKG1Myc
         CJgNQKNAlMdNNIvO5iB2jf79TdS++Wu2dPcKFsZNsKPYAixpJb3+XEDn9XrvVwR0rUoC
         oUynAEefaoN9kN7AESeUSCax5RZmJ01cSCck2KXgXNnKIGqnQAOGQGo3BD6Jt1Ehlj7H
         s35rATf62r1TieS0T1o6NTHoGI+sCVy+ObYMWwVcbMNSm7w1mY9x1ymyqmyU7l/+1E2W
         1XohL4oGoAtpULjUEx37Bxnjy9s1MpifNTg5K+dJquphSKkGb8dlM0rcBrCol5TSCB/h
         zhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839249; x=1795444049;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K7Sgz3ld+ZNxi0hBngHAfrUu3ksDDoe/zQYxMmRp/T4=;
        b=W/sT8liuVP8kMQAPWxyON5VjMVR78W/BQGWVtj4zuSiqTtSqzFk8BOBD2yHNqhUBUh
         VhW8StFxISCrXojyDT4wql2pEVsbprvJ4vPKkMf36UR/B6ORDNpwtJrnOuEUh3DAwcnh
         2DDjMsWr45KxQb5W3ANSdblQo3GqaG/nwywGKIfZZuLo9TQlspl3nqYZvmScNTcjOvKO
         RyuStZYG27CF/NJylUqrJe6vS7u1YSidyVTQ8boWX96vlw81dGrhaXHablzmh9HRtFta
         4/RxTO+mszdkMibOm0FhetLlpAmScCoWfnfVAuUIMMHKGSaisR5k9yE/+c1bsqZTCcPy
         Wltw==
X-Gm-Message-State: APuU4Z9yJIkIH4K6dsBvixUmCCuMVGILoyegneXng3452H8V+hT8/6q4
	JrI38e0oz3scDOUSS56Di0WgAeo7ZQuWYXzW7XiqDnV5Q1PB+1ozezH49tug4JpTGSQ0024Oa3J
	b51HqUwOxIUCP46vU3t0gVpl5AwQHsXJMCZtivP2cZhc913qSpjLZricHrtHlIV3R2GrWBzmeW3
	wcX23BXhEXEzHnVWafnNmHcCmybXgujg==
X-Received: from wrve6.prod.google.com ([2002:a5d:5306:0:b0:49e:f4c:b427])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1863:b0:48d:ee35:b3fe
 with SMTP id ffacd0b85a97d-49c6d45308fmr26905295f8f.8.1794839248438; Mon, 16
 Nov 2026 06:27:28 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:32 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2989; i=ardb@kernel.org;
 h=from:subject; bh=4MxOZY/YO/IfVCPcb3Gx/rGT/ia9EZpFm+NWrw0PtxI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30NxgLubf0xQ07M/eeqe3zGcCp+jmF29ORL2NFuXwt
 i/67svfUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbybR4jw/nQ2UEqc643yObG
 rA9QLvcJyRBNPt8bxfdWLcddfyXPZUaGNfL7Zygavslr9X+589e/CNN5vJ9VM3sTb22bPiPb6k0 RNwA=
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-30-ardb+git@google.com>
Subject: [PATCH v3 13/15] efi/libstub: arm64: Drop zboot code_size hack
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
2.56.0.611.g1030f0b940-goog

