Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839243;
	b=IjRTReCq/nfH+C80eywARSMDp/UwFBW/BitvXp4jKUiYKBTFVxgWpH+kyLTkO+JszmY7
	 RIyL27bCy7vG7yKNLSYIt8FSboDwZ8yAFZigYw53ue0PRajgqhGe7vleLIU3RUTRadsr3
	 6nllm8R70RkBxhxv9s6l4SzTzMrUb94yicYT8ZOljmTrOAk1rB9YLTTQKQ2rn9PYROrgt
	 s9/vrhd2ZAvIDrcY08+dOksE18qE+wAn2HSsKU+UJ+A4ODL/HF0d4qJxuGyOh+MYY0aOe
	 LHNUnHuCG5TbiXLpqO7L2bsUHlqLw4z4c3IZoCFkiSrlBAo8TVOcEZs0Kswo8/4/y2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839243;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=1+y6MXetiY5pCIsFiRqfrAZwgakffoWvR1I9Ffs4CVI=;
	b=HcbqAwprBkMhxO0Iko8Yhf7XYpzTQ5rQfMitXOngnqZIqHys2asXIY0mW4lbCiTISrrJ
	 Zl3W3nlbORKKg8Eci3Viv1ehgIO9THt0qEP5EInnVI37ySVT+ctOav4SqFgaL//HL+TUz
	 3kTBCZ8WQ6YoV7UFHjPQEaIfADsvp6ElF44FmCPF3cDMxQhKCOJoVnrkR+Sig4K1hi3UA
	 VTwU83xTbPsHLMKVQE0/x6adULAQ8Mu8TWZKc1Jxtkh7IaWgO2FA1HHwBcFkjUOWWZzER
	 smMGZb4IIHY0wqNi9RmYYKvZ6G9jhlBDrQmJDxZE/xLobqiUCPIxpxQqHgEOoR0TFfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KMvwyZXC;
	arc=none smtp.remote-ip=209.85.208.72
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE49606A32C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAE49606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KMvwyZXC
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so3555404a12.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839241; x=1795444041; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1+y6MXetiY5pCIsFiRqfrAZwgakffoWvR1I9Ffs4CVI=;
        b=KMvwyZXCCPzrGMvRtRB/4ERnB1E+E3FHGKoUMYlTqI/IEgm+DklkJYIPbL1Yp0/fY1
         ZlWbyiXB/inZMRxUPy8c5CvxXHrTXD3tJnjGgToBbrxbk3cuhgW03CB/8nxvwX/Rmx88
         S8qJX2bz3G3z5mIkqNnh5whaHHkS8OY7sXEb7e2ws15LszykwUVE9+QvXuc/Ec34RWIu
         fDxug3l+d97xnvxut0cYh4+6yje8/TwUAgr7JNBAr+qE6DdUKffRwEiRh+zDIfAJH+kc
         bHsCil1Ip62g5QfPuyyfOIdmN37cfmj8Sd6Ibcx/JgY/sHkfNXBP7Gqwmq2QUuvTwRVn
         oH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839241; x=1795444041;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1+y6MXetiY5pCIsFiRqfrAZwgakffoWvR1I9Ffs4CVI=;
        b=E3CPqn8WPji1pzChPRlkT2u8/FgMjq+Hhdhuj/t5FpUyOt3mkvUlvXoX5gn1mZXqT5
         I5RUUR+I5H/TwFbNXAQc7+Bxsg0tykHJwKAGLQ2io0GGIBNGKU3PMu+lfih6nV2F2y0t
         fqbAUYynmj4ZxE2bIl1d/TnHaVAhlUo2jn+3p49kBJGL0LshJO4T0pI8jS92HSpIFR6L
         QJ5zhrq+366dZzGGtwawKSU1pwBedGegk+/cAE0y/T1UDivYfHXkM/Kyfb6OAk5sAmC9
         yITpEiGIhPamPjTaHipmcPIINY6cDjOwEBQkiQkukSW/aY5Mr82gf+A/Oe1p9jk8P6dx
         3UuQ==
X-Gm-Message-State: APuU4Z+T/c4AxCPvi1kwaCabHreM/82LRIpSkHy/Sn24PkJicsIs3/vr
	Xe+2dMDG2pRqw8r1jyIXo+fKeBSoVjB9jQqWP+0pngHFlmaRAnLaE4NUCj1RNKS2KD+iig6HUSk
	h+FOfDmVG7IEi4mfM+Qkx1XQdwa6f0R9oFuOQqSgfWFcn9eQzPseZu6hbUO6jH/gdOFAqxo1aG3
	01YNso+wQEYVxHYSypZzdOfS7qEtgzOw==
X-Received: from edbbe27.prod.google.com ([2002:a05:6402:1a3b:b0:6b5:70b7:1fdf])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:540e:b0:6b5:6c41:2508
 with SMTP id 4fb4d7f45d1cf-6b7c0c725a1mr8915159a12.36.1794839241097; Mon, 16
 Nov 2026 06:27:21 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:26 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8384; i=ardb@kernel.org;
 h=from:subject; bh=aH5bYyxM3Yx0BvZZdg7Qz3nUcRZACek2m3cbvmQkHNs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30NSyyFjH6jyGlp9T1zK1/wmzFmOS+5zQF29cruQUv
 js3saWjlIVBjItBVkyRRWD233c7T0+UqnWeJQszh5UJZAgDF6cATMT8JiNDg+KdsFju5Kao2ad8
 i7ryWnT382zpjSxek+81MTJYK/Ahwz+ji3LOCx9rbBLecCB+KeuXxXOrHwRvuc32tmDLbu4MXWY WAA==
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-24-ardb+git@google.com>
Subject: [PATCH v3 07/15] efi/libstub: Pass kernel entrypoint down to efi_enter_kernel()
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

ARM is a special case here, as it combines the EFI stub with its legacy
decompressor, and so the generic image_info carrying direct references
to vmlinux symbols cannot be used there. Instead, it provides an empty
struct efi_image_info, which is passed directly to its implementation of
efi_enter_kernel(). So on ARM, populate this efi_image_info with the
base address that the callee expects.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/boot/compressed/head.S           |  2 +-
 drivers/firmware/efi/libstub/arm32-stub.c |  2 +-
 drivers/firmware/efi/libstub/arm64.c      | 16 ++--------------
 drivers/firmware/efi/libstub/efi-stub.c   |  2 +-
 drivers/firmware/efi/libstub/efistub.h    |  9 +++++----
 drivers/firmware/efi/libstub/fdt.c        |  5 +++--
 drivers/firmware/efi/libstub/loongarch.c  |  3 ++-
 drivers/firmware/efi/libstub/riscv.c      | 16 +++-------------
 8 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9f406e9c0ea6..a7f58dfe41bc 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1450,7 +1450,7 @@ __enter_kernel_from_hyp:
 		b	__enter_kernel
 
 ENTRY(efi_enter_kernel)
-		mov	r4, r0			@ preserve image base
+		ldr	r4, [r0]		@ preserve image base
 		mov	r8, r1			@ preserve DT pointer
 
 		adr_l	r0, call_cache_fn
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index f7151a4915ba..b73a0b4fcd10 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -127,7 +127,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	efi_bs_call(free_pages, *reserve_addr + MAX_UNCOMP_KERNEL_SIZE,
 		    (alloc_size - MAX_UNCOMP_KERNEL_SIZE) / EFI_PAGE_SIZE);
 
-	*image_addr = kernel_base + TEXT_OFFSET;
+	*image_addr = efistub_image_info._text_offset = kernel_base + TEXT_OFFSET;
 	*image_size = 0;
 
 	efi_debug("image addr == 0x%lx, reserve_addr == 0x%lx\n",
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
index bb8e360fee7b..b985ababbe66 100644
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
@@ -1205,7 +1206,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 
 efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr);
 
-asmlinkage void __noreturn efi_enter_kernel(unsigned long entrypoint,
+asmlinkage void __noreturn efi_enter_kernel(const struct efi_image_info *image_info,
 					    unsigned long fdt_addr,
 					    unsigned long fdt_size);
 
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
2.56.0.611.g1030f0b940-goog

