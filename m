Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026124;
	b=iT+zWYN309RheuCyp+BbrCKAJDnuu3DILf6tZpySw0gAc0mAgMpDQGkwyFYNtT+tqwR7
	 fesxgdXaQEloMjn1Q14iNlbb0Sm2wsooW43rlfIqpil+TNQQ5IG2/ch6VP9emSzvYslIc
	 11QhGm47+otsgHUavMcQZLelar5xd0m/KIvlfqd4cS/6h8KSKffeEbLAFT2OcBuI1PV7h
	 7aKrCKR2lO74d7vWnI6iGV8SJ1rirXw5eM0nEre13rR1QT2EyZ00OWg4P22P+HWr24CUW
	 y4ckZnCkIRHS346/Uf8gjIV+uIKdjkfQYK4ADUy5H4ZB6jm4VmhS1JKbbgjPvG4CY9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=SihVeKYKUcYtwtVeDbgNDziHJwcySsXbAtpJvKrk9Z8=;
	b=mX1JPojoLuKDp8h2tSjMMY+BaPAE76LDwJ+XBjwKYeaG5kjlRJEibZh72p25pP2l1Vak
	 Z9bkJjygef9F1xU+AfDx7vRQaFULXKvjPM31Ov9Y6d/b6cssTuikir53a1WKvUYVbjZl8
	 +uGUQz9lnaiWkVOTVFB4VKTEMRT/5W4cE/a2hCD7I7Ou1J1xQLY8Hvawc82p9tUgtHGAd
	 UxbcnSxuhslBYweXQWWg+WsDw3TSUeM2Jv9/syig/yxHc8lDKRG+U9jXWkbpxr73TnEWO
	 Xq8r+S6yENW18jOp2lrY2I8o6RM5ci/VU0jfrTI2dG+2y9sKVnZoFf7zy+5MscVeL9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DkHUb2mq;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D83606A31C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20D83606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DkHUb2mq
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a0284121c6so8948965e9.3
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026122; x=1795630922; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SihVeKYKUcYtwtVeDbgNDziHJwcySsXbAtpJvKrk9Z8=;
        b=DkHUb2mqUCXpznWfez9ZUEtyylmGEfpCs80BPlx6H+RRPQuTRzutTs8nJLmPcKOmUp
         c9RJFrgeQcqPXUOoJ7esIosYVSM5yFms191eMlRBLDmjQbVfgxcomEc2mBGhbkZCU0Fq
         KafeZJofUeJZb2KORywwuEQ4kli3H8iwAESkvzTzl4HRj02ULgdONq0D2l3cP8AYijLJ
         JMgTz/pnsrbq6MqtbFwuGqFrb3wcOeNDsllEyK49++W0Sqq/opUpD6IEOOk3W99BO0Md
         rPvxPWdSXpnNavA5onOHoJoSLeVastzFXioxg548CmLNfRp7ZRvAQqTKigo7oZjQcv58
         tVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026122; x=1795630922;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SihVeKYKUcYtwtVeDbgNDziHJwcySsXbAtpJvKrk9Z8=;
        b=Del898a3nbrslmVpzPhwcoVDfi86J3PxC/3Ls1/vcs09DsWiCE2b63rXZ50EDweqwu
         bHZRdQ/3aEsUrjE2FySlQ++D+KP435/e/l2YTcsDbIqihSgL1KsXEUN89xsslWyXKI3O
         cSSxZ3LTUd1bcyBg6uNo68xb3DLIXsU0ZOJCK6eB8p73ZDUjiBh3mASnqCVaYus56U3s
         tD0/RyftDFNHX4QeYthtTFd5tRSjgt57b3ouK9iDatAEYvLRMdjkVEqf07Nlc9IwfU5e
         v/ffTxImaaW+NaI665tpPMuCxrxt+1gKhTS5POKMd5LEeSC2G36xGHiOnusTmKQtTuab
         ia/g==
X-Gm-Message-State: APuU4Z9ko6xElG+dIUtZBWU59ZymyEWc2VipDpB5b0ZYVIbzDuof2eo6
	HFJmb/FSOzgXErH9w8JQUgjwblfBx7S4u4WGc4FzstJJhN/RuHljrePMJFkoo8Sb3ghktyIV8PJ
	7pCk+R/7IAZHiVHqp6OrsA6aTaMkB84WuZXCf0JNUoaiin8VPgzANivQzhsavRI3ckuONo/JbiJ
	CapxQGBP4hhSCJy/3ujWsbNlD5fIYJ5w==
X-Received: from wmbiv20.prod.google.com ([2002:a05:600c:5494:b0:4a5:9877:cd58])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:82c5:b0:4bb:693e:4c8e
 with SMTP id 5b1f17b1804b1-4bb7da270bamr81627805e9.21.1795026122038; Wed, 18
 Nov 2026 10:22:02 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:15 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10740; i=ardb@kernel.org;
 h=from:subject; bh=td1YOzQllFOmKxcYaPTJfDzgNk5vXqWQSMoBqMUdfHI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm3lKLDOcmw5vsfpY4HN61YsfO1ZVFP5R2Ddt+tdT7
 0SNuR5KdJSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJWLxkZGifybL/yIZlD6Zx
 nTg6x2bmMqvGORzSqncMzldJ7ggKO1DJyDBrr83xtSx3Uw+8jGyU8XtwRdSwzi7yYO37Wdv3bLe +9pILAA==
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-30-ardb+git@google.com>
Subject: [PATCH v4 09/19] efi/libstub: Pass kernel entrypoint down to efi_enter_kernel()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Update the EFI stub code shared by arm64 and RISC-V so that the kernel
entry point is taken from struct efi_image_info rather than from opaque
arithmetic performed on linker symbols.

Notably, this results in EFI zboot to enter via the actual kernel
entrypoint rather than byte 0x0 of the loaded image on these
architectures. Beyond that, it is mostly a cleanup that will allow
special linker exports for global symbols to be dropped in subsequent
patches.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/boot/compressed/head.S           |  3 ++-
 arch/arm64/include/asm/efi.h              |  2 --
 arch/riscv/include/asm/efi.h              |  2 --
 drivers/firmware/efi/libstub/arm64-stub.c | 15 ---------------
 drivers/firmware/efi/libstub/arm64.c      | 16 ++--------------
 drivers/firmware/efi/libstub/efi-stub.c   |  2 +-
 drivers/firmware/efi/libstub/efistub.h    | 13 +++++++------
 drivers/firmware/efi/libstub/fdt.c        |  5 +++--
 drivers/firmware/efi/libstub/loongarch.c  |  3 ++-
 drivers/firmware/efi/libstub/riscv-stub.c | 13 -------------
 drivers/firmware/efi/libstub/riscv.c      | 16 +++-------------
 11 files changed, 20 insertions(+), 70 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9f406e9c0ea6..6e4d8ce0efbb 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1450,7 +1450,8 @@ __enter_kernel_from_hyp:
 		b	__enter_kernel
 
 ENTRY(efi_enter_kernel)
-		mov	r4, r0			@ preserve image base
+		ldr	r4, [r0]		@ preserve image base
+		add	r4, r4, r0
 		mov	r8, r1			@ preserve DT pointer
 
 		adr_l	r0, call_cache_fn
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e8a9783235cb..d5775f38efea 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -103,8 +103,6 @@ static inline unsigned long efi_get_kimg_min_align(void)
 #define EFI_ALLOC_ALIGN		SZ_64K
 #define EFI_ALLOC_LIMIT		((1UL << 48) - 1)
 
-extern unsigned long primary_entry_offset(void);
-
 /*
  * On ARM systems, virtually remapped UEFI runtime services are set up in two
  * distinct stages:
diff --git a/arch/riscv/include/asm/efi.h b/arch/riscv/include/asm/efi.h
index 46a355913b27..ded51c656126 100644
--- a/arch/riscv/include/asm/efi.h
+++ b/arch/riscv/include/asm/efi.h
@@ -43,8 +43,6 @@ static inline unsigned long efi_get_kimg_min_align(void)
 void arch_efi_call_virt_setup(void);
 void arch_efi_call_virt_teardown(void);
 
-unsigned long stext_offset(void);
-
 void efi_icache_sync(unsigned long start, unsigned long end);
 
 #endif /* _ASM_EFI_H */
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index b57cccd75ab5..6140def24c69 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -10,7 +10,6 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 #include <asm/memory.h>
-#include <asm/sections.h>
 
 #include "efistub.h"
 
@@ -35,20 +34,6 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 					 efi_kaslr_get_phys_seed(image_handle));
 }
 
-asmlinkage void primary_entry(void);
-
-unsigned long primary_entry_offset(void)
-{
-	/*
-	 * When built as part of the kernel, the EFI stub cannot branch to the
-	 * kernel proper via the image header, as the PE/COFF header is
-	 * strictly not part of the in-memory presentation of the image, only
-	 * of the file representation. So instead, we need to jump to the
-	 * actual entrypoint in the .text region of the image.
-	 */
-	return (char *)primary_entry - _text;
-}
-
 void efi_icache_sync(unsigned long start, unsigned long end)
 {
 	caches_clean_inval_pou(start, end);
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index d35c6dd76601..e892302f4189 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -117,24 +117,12 @@ void efi_cache_sync_image(unsigned long image_base,
 	efi_remap_image(image_base, alloc_size, code_size);
 }
 
-unsigned long __weak primary_entry_offset(void)
-{
-	/*
-	 * By default, we can invoke the kernel via the branch instruction in
-	 * the image header, so offset #0. This will be overridden by the EFI
-	 * stub build that is linked into the core kernel, as in that case, the
-	 * image header may not have been loaded into memory, or may be mapped
-	 * with non-executable permissions.
-	 */
-       return 0;
-}
-
-void __noreturn efi_enter_kernel(unsigned long entrypoint,
+void __noreturn efi_enter_kernel(const struct efi_image_info *image_info,
 				 unsigned long fdt_addr,
 				 unsigned long fdt_size)
 {
 	void (* __noreturn enter_kernel)(u64, u64, u64, u64);
 
-	enter_kernel = (void *)entrypoint + primary_entry_offset();
+	enter_kernel = efistub_kernel_entry(image_info);
 	enter_kernel(fdt_addr, 0, 0, 0);
 }
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index bf9a9f53a95c..55bf7ed50c81 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -191,7 +191,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 
 	install_memreserve_table();
 
-	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
+	status = efi_boot_kernel(handle, image, image_info, cmdline_ptr);
 
 	free_primary_display(dpy);
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index edc768a54473..e45d16095247 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1054,9 +1054,6 @@ typedef efi_status_t (*efi_exit_boot_map_processing)(
 efi_status_t efi_exit_boot_services(void *handle, void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
-efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
-			     unsigned long kernel_addr, char *cmdline_ptr);
-
 void *get_fdt(unsigned long *fdt_size);
 
 efi_status_t efi_alloc_virtmap(efi_memory_desc_t **virtmap,
@@ -1189,6 +1186,10 @@ void *efistub_kernel_entry(const struct efi_image_info *image_info)
 	return offset_to_ptr(&image_info->entry_offset);
 }
 
+efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
+			     const struct efi_image_info *image_info,
+			     char *cmdline_ptr);
+
 static inline
 void *efistub_sysfb_display_info(const struct efi_image_info *image_info)
 {
@@ -1205,9 +1206,9 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 
 efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr);
 
-asmlinkage void __noreturn efi_enter_kernel(unsigned long entrypoint,
-					    unsigned long fdt_addr,
-					    unsigned long fdt_size);
+void __noreturn efi_enter_kernel(const struct efi_image_info *image_info,
+				 unsigned long fdt_addr,
+				 unsigned long fdt_size);
 
 void efi_handle_post_ebs_state(void);
 
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index f01450b49975..09e9e5bc831e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -344,7 +344,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 }
 
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
-			     unsigned long kernel_addr, char *cmdline_ptr)
+			     const struct efi_image_info *image_info,
+			     char *cmdline_ptr)
 {
 	unsigned long fdt_addr;
 	efi_status_t status;
@@ -359,7 +360,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	if (IS_ENABLED(CONFIG_ARM))
 		efi_handle_post_ebs_state();
 
-	efi_enter_kernel(kernel_addr, fdt_addr, fdt_totalsize((void *)fdt_addr));
+	efi_enter_kernel(image_info, fdt_addr, fdt_totalsize((void *)fdt_addr));
 	/* not reached */
 }
 
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 2b0c87dc9908..7f21e79384d3 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -66,8 +66,9 @@ unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
 }
 
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
-			     unsigned long kernel_addr, char *cmdline_ptr)
+			     const struct efi_image_info *image_info, char *cmdline_ptr)
 {
+	unsigned long kernel_addr = efistub_kernel_base(image_info);
 	kernel_entry_t real_kernel_entry;
 	struct exit_boot_struct priv;
 	unsigned long desc_size;
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index e4f9723d5055..840fdd63dccf 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -6,23 +6,10 @@
 #include <linux/efi.h>
 
 #include <asm/efi.h>
-#include <asm/sections.h>
 #include <linux/unaligned.h>
 
 #include "efistub.h"
 
-unsigned long stext_offset(void)
-{
-	/*
-	 * When built as part of the kernel, the EFI stub cannot branch to the
-	 * kernel proper via the image header, as the PE/COFF header is
-	 * strictly not part of the in-memory presentation of the image, only
-	 * of the file representation. So instead, we need to jump to the
-	 * actual entrypoint in the .text region of the image.
-	 */
-	return _start_kernel - _start;
-}
-
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
 				 unsigned long *reserve_addr,
diff --git a/drivers/firmware/efi/libstub/riscv.c b/drivers/firmware/efi/libstub/riscv.c
index 49db47c05bfe..7be2774dea90 100644
--- a/drivers/firmware/efi/libstub/riscv.c
+++ b/drivers/firmware/efi/libstub/riscv.c
@@ -72,20 +72,10 @@ efi_status_t check_platform_features(void)
 	return EFI_SUCCESS;
 }
 
-unsigned long __weak stext_offset(void)
+void __noreturn efi_enter_kernel(const struct efi_image_info *image_info,
+				 unsigned long fdt, unsigned long fdt_size)
 {
-	/*
-	 * This fallback definition is used by the EFI zboot stub, which loads
-	 * the entire image so it can branch via the image header at offset #0.
-	 */
-	return 0;
-}
-
-void __noreturn efi_enter_kernel(unsigned long entrypoint, unsigned long fdt,
-				 unsigned long fdt_size)
-{
-	unsigned long kernel_entry = entrypoint + stext_offset();
-	jump_kernel_func jump_kernel = (jump_kernel_func)kernel_entry;
+	jump_kernel_func jump_kernel = efistub_kernel_entry(image_info);
 
 	/*
 	 * Jump to real kernel here with following constraints.
-- 
2.56.1.708.g77570a6a1d-goog

