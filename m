Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313067;
	b=GQ7+Gcp+fhNEaGUWkE/7vtE3QgDY0tNCbZkRxlFhsmwzvbLGemiKdof259GWafsv4XB9
	 lKCjGnmeD5OGwRHPuV1aWGOOZSy/VfygjIvK1qT2zCZfqo3hvdE9G00VRUyXjyOj100Ha
	 scBoTPKvxEq8kdXfgELAh0h+ChUyGiZBXynUe1ZQaLKj+J45HdNTwBdH1evK6y5D9Ehhe
	 F5rW3wwFvqZMSYl8Xd/aPBmSdXhuNrAj6Z1gcpDQgF7T10a1u42FyHcK5U+2WnQKkadYN
	 gsNkRuLSZZD82YFaVhxU00YJF/b7T7+pZJcVlIOdCzRFQd0+4ay/qKVHHG6IAc/sUKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313067;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=s3QC/0gK2OClsDHJrI+qx7+T7UXE2mSOvFr6ntlSSRU=;
	b=4TJyrwENBNYe1/ctFJ7tqQVF18qm0BJMsNJlYPiX76D3Wei+HDQ6Y8eser8Bt7/e3SNg
	 QytfTKQQ9ZXfmMChVaYhXUveIPuKGv6m0dlp4K/SkYAT+BEReYVLH1Edmqz3qo1zWVhm/
	 vriL88BVGglatcpK+INbc9Pgi0EQQ+2oNPQF73QX96V3OKEEy/kcH5r3Su2Dsr8zEczcB
	 aqdAWzeiwwoQ05tiNiCTrPiBUsk9UyauCrbjrCVPq1m6oCZwEn0Jacq8Nbyoa7YpQ6mIN
	 TL9RzyJf72IMZzytj8pxk5sFAnoEfOZb2UUwYfv4zqmNhVUOwJjru0gHgT687HESRyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gy1ARSa4;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB26606A321
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BB26606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gy1ARSa4
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-492425d771bso1328555f8f.2
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313065; x=1794917865; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s3QC/0gK2OClsDHJrI+qx7+T7UXE2mSOvFr6ntlSSRU=;
        b=gy1ARSa4204mLb1PRJgUG8Mr35HFpTSbHQHB4a2+kuDT0FAXLegXoboiG+7SKzQ4kN
         Xr+kJf0TajgIuk9Mi8SfS0Z/vVaC0jvII3EQBDbrDPo6nTjyDCgnlc6059yA+vof80zN
         FaLqmsh0OXax416FQAiT49YyhKJNxph3VpNnh+qXDJH9hZRYCeqzDICVkF7QJXBPLFR/
         QLijOrXbe3kZUFb7bU02SnqPomARLtLNQpXbLc/QvfjxHGwkGYtG7yZhAe2RQInnhzuo
         fPMJGeYRvpeVPC9jmJAyxbj/YUPC1nLUMcHeSFYaVNT6/DZzkx8mbhxq1vGnf7ZzfL3y
         P1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313065; x=1794917865;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s3QC/0gK2OClsDHJrI+qx7+T7UXE2mSOvFr6ntlSSRU=;
        b=T4UywP5JL6s+Evhx10q5RoVOCYPXW/5q44BHAW6UxOjIBs0nzAE96XKCBPFXymsgj7
         LIrD01YklRoGjvgRAjXxErgc1CfHK3gKEspDSWAPd6br1x/t5b5RQ73HRk/F3MYBerDH
         qkhHR+Ez9MvPvV2KQlQyp7llC4HnsqpwJm/AFmNVvs2GfgL3Le3W1959B9u033KArfGl
         uKwdIFoWG5yOSD/7Vx5OIgXLbXMKjSuuuqmgt13GeAF3Z2Ixyt9CTzWan1MQUe6MJVnN
         +P5rKl4aK5/N6O3ZO6NKsaKIfejRSCuuxbTWwUR05IXck3qsBk89TbSEnTW3bmJByX8u
         p1bA==
X-Gm-Message-State: APuU4Z+/13590gybnM/ToyW2xQeIz6GDYzdGl/gjZermYY/dxZBL0ODC
	DlgIlOjVhcBfntzjAATeQ30FCoeJ6LAp0WgKYUpXts+IBJ2xBEAsMiCEEwli2ZXWcMQONx9qYtk
	HLwQFmm/YadNzaI57biESY0LguKxEmDyBJt8zbtji6yhw5q7o3irsHHkUKwhS++sSEbYhNCVbKw
	mSsQ8fM33OahXVIHXselTOXyqzzyVMtQ==
X-Received: from wrod4.prod.google.com ([2002:adf:ef84:0:b0:48d:f014:9e3c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:268a:b0:48e:c84:5be6
 with SMTP id ffacd0b85a97d-4982ecf61e2mr4261257f8f.14.1794313064491; Tue, 10
 Nov 2026 04:17:44 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:37 +0100
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
Message-ID: <20261110121731.2728824-17-ardb+git@google.com>
Subject: [PATCH v2 05/10] efi/libstub: arm64: Use struct efi_image_info to
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
 arch/arm64/kernel/image-vars.h            |  6 ------
 drivers/firmware/efi/libstub/arm64-stub.c | 20 ++++++++++----------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 19d602e45523..9ab71d103f64 100644
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
@@ -33,10 +31,6 @@ PROVIDE(__efistub_primary_entry		= primary_entry);
  */
 PROVIDE(__efistub_caches_clean_inval_pou = __pi_caches_clean_inval_pou);
 
-PROVIDE(__efistub__text			= _text);
-PROVIDE(__efistub__end			= _end);
-PROVIDE(__efistub___inittext_end       	= __inittext_end);
-PROVIDE(__efistub__edata		= _edata);
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 PROVIDE(__efistub_sysfb_primary_display	= sysfb_primary_display);
 #endif
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2c3869356147..8184b345af69 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -10,7 +10,6 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 #include <asm/memory.h>
-#include <asm/sections.h>
 
 #include "efistub.h"
 
@@ -21,22 +20,23 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle)
 {
-	unsigned long kernel_size, kernel_codesize, kernel_memsize;
+	auto image_info			= efistub_get_image_info();
+	unsigned long kernel_base	= efistub_kernel_base(image_info);
+	unsigned long kernel_size	= efistub_kernel_size(image_info);
+	unsigned long kernel_codesize	= efistub_kernel_codesize(image_info);
+	unsigned long kernel_memsize	= efistub_kernel_memsize(image_info);
 
-	if (image->image_base != _text) {
+	if (image->image_base != (void *)kernel_base) {
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
-		image->image_base = _text;
+		image->image_base = (void *)kernel_base;
 	}
 
-	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
+	if (!IS_ALIGNED(kernel_base, SEGMENT_ALIGN))
 		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
 			SEGMENT_ALIGN >> 10);
 
-	kernel_size = _edata - _text;
-	kernel_codesize = __inittext_end - _text;
-	kernel_memsize = kernel_size + (_end - _edata);
 	*reserve_size = kernel_memsize;
-	*image_addr = (unsigned long)_text;
+	*image_addr = kernel_base;
 
 	return efi_kaslr_relocate_kernel(image_addr, reserve_addr, reserve_size,
 					 kernel_size, kernel_codesize, kernel_memsize,
@@ -54,7 +54,7 @@ unsigned long primary_entry_offset(void)
 	 * of the file representation. So instead, we need to jump to the
 	 * actual entrypoint in the .text region of the image.
 	 */
-	return (char *)primary_entry - _text;
+	return efistub_kernel_entry_offset(efistub_get_image_info());
 }
 
 void efi_icache_sync(unsigned long start, unsigned long end)
-- 
2.56.0.542.g3ef89b7020-goog

