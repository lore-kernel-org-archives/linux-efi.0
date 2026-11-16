Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839248;
	b=ui6xn9fjobNJJyPHyxBKtZMrakHgk1UfMaELfsX5VyZkNobPsE3wf58L1Mo+hn1sCWNf
	 8kmoUrFu0zMJj4C5aaBXyIJpvFlejCd+W0/WbwB7GVjOKmsjVH7wqMx2Q/tY0GNEE2SYp
	 3g2O3uqCs4rNrzpeRv7+HJ4Cikda8iLDI7WtYm/RxnsqBik5uzh38HaXDnq/iZXk5Wbsl
	 NXHCAnbXGR8toZkt5dtgQjoV8ArD2/0x7I0jxQZnQ1FZn3xpmSTbcoIVl2gdKcWPGH85+
	 tHINPZmtR/dfPH4cmeJc1PkWDrd6VW9BwP9MU5aMWXx0Wd/lDYIksTklXxfOVvQPH+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839248;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=o11hgmvCCkoqVQmKB/Ee34WO8eez+JgS5dBD2M+SoXI=;
	b=J/maOODCMuv3IIM7YOgdTGXiLQIAnNdoxGpOwNZ0f66HsAS05+506peLKgi/24Y+wLkb
	 omsExyt2gddeDIbNVXD/kOJCpIBoAE9qfqCuOxrNgtyegGLOxHCl/9HamoPbef6rg1SzW
	 VGptxFYUshvRceSnubb+99W/6GAaHiBJLisWYv0qE7taXrAsBZpeP7nZ80/dj6BneNok2
	 6HtUiK0iU2GyM/ytx9APsUSeLlNIFj3CjyJJnh+2f7P5dd3yVtwXJZNyqjf+X3z7O9+No
	 JQsB+7SOl8Dbtfo4a+m0NyfU+5AeWmIrQEeyQUQA/20kvup/m5pPPOTI6ZdkkS+t6EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oevEe7NJ;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F55606A339
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9F55606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oevEe7NJ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-490a0e72578so2119475f8f.0
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839246; x=1795444046; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o11hgmvCCkoqVQmKB/Ee34WO8eez+JgS5dBD2M+SoXI=;
        b=oevEe7NJ5yr8CPsqVgKL6V4Ha+u3lioeKrh8esqDqCsPr/QRhD6nRiygv0Pdo47iba
         Cs4Qs9pD46mbHwFjYp6f0Tu61JaZAPE1TWKeeX15X56vvAFmjqtgtAN42r+TRmAAxOjr
         zAfF7oKzhMJctzo5LrRFMx59/ot3WS0U1onX2lOu/UjLaSeIYWoeaWICr9UoX9cFT981
         W5meAarz2sEx1Ej4bxzFYcm051kqVCfX7UTWAMJN0ZVO3SQ3eExZHJ0lf/pVOzgJcGe+
         UXh8YmeVRQfrGPnk5qQdk5n2CNClCcwggSJ4FA7hI7si/kmj+8FA22mg+5eFsG2wJHKs
         RT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839246; x=1795444046;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o11hgmvCCkoqVQmKB/Ee34WO8eez+JgS5dBD2M+SoXI=;
        b=gKSFAJNQSPLTnxbZYsbtCxol7h1Xlpt6LL6oUChtPma2pyvuatfuTipBIDgbjTSvLW
         fH0m4Pb9VKXCAarGnIKpWTquk5eKahNtAXVwReWMP5OooFU0M0csiC33ZWoPwm1yKvsM
         GEdvFZqVIFKV+c6P/1SMOhNQv3Zksl1RUrHa8Gc2kVA3tZPp4Zh3aNwgsMPUSAbeLikL
         VqYs0TElUeZwlLe6ndZhmQSOusFEu57J+gXj9tdjibVS0Fi1EKgScroOcTGkZD+YLbR7
         dVYe8sndMQkBAGAfSXuGuYe3trdmjAryo52mbflTbdwxrK4VTU/IUMJyrlGIhGT70X0S
         Lv5A==
X-Gm-Message-State: APuU4Z9FCPZS4mgMx2fBDAPHYLLECMcVJDALR33Nq0UyGA/gBQCgDOkc
	bDECo5bCBzsjNSuMZYZhOFLJ/TMU95FiXPDEbZ74jf0ZEuneZD5VmlmtZUAqHvU5iMpKDEehfGR
	63CcRSpcFsZjwGEXqMdtAiGf2ROAczzaOva1YXWeS8sp7oVRTRlzcEaRi/mzkMw7wbOjRk4wnL9
	0C+5UyUNTLJEkEPaxUPi+0AZTJqUWpEA==
X-Received: from wron1.prod.google.com ([2002:adf:f081:0:b0:48a:f42f:f171])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64e4:0:b0:487:6f2:1a4c
 with SMTP id ffacd0b85a97d-49c7381b46cmr25352969f8f.25.1794839244204; Mon, 16
 Nov 2026 06:27:24 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:29 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3411; i=ardb@kernel.org;
 h=from:subject; bh=0nt34/MyeHyViz+7a3rT70EnJHsQtwP3I7KaD72gSz8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30MwW9bOfZvZ9yNX/vfrllKK/Sb621ld3cr94vuZPV
 XKIj2JiRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiIaRojw6VFJQo7Lx1UX/bw
 Z4Lt9mypXpbEfDaVbsdzMx+zxa+ad4iR4fPSijBDhm9f1SV53q4o+TLnofCRLzvWVE9J4bisvO3 uXU4A
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-27-ardb+git@google.com>
Subject: [PATCH v3 10/15] efi/libstub: riscv: Use struct efi_image_info to
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
 arch/riscv/kernel/image-vars.h            |  8 -------
 drivers/firmware/efi/libstub/riscv-stub.c | 25 +++++---------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index bf703eba3fa5..c18b24792a29 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -23,14 +23,6 @@
  * linked at. The routines below are all implemented in assembler in a
  * position independent manner
  */
-__efistub__start		= _start;
-__efistub__start_kernel		= _start_kernel;
-__efistub__end			= _end;
-__efistub__edata		= _edata;
-__efistub___inittext_end	= __inittext_end;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
-__efistub_sysfb_primary_display	= sysfb_primary_display;
-#endif
 
 /*
  * These double-word integer shifts are used by the library code, and
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 0ddbe7cc8628..58581ccb4cc0 100644
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
@@ -31,13 +18,13 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
 {
-	unsigned long kernel_size, kernel_codesize, kernel_memsize;
+	unsigned long kernel_base	= efistub_kernel_base(*image_info);
+	unsigned long kernel_size	= efistub_kernel_size(*image_info);
+	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
+	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
 	efi_status_t status;
 
-	kernel_size = _edata - _start;
-	kernel_codesize = __inittext_end - _start;
-	kernel_memsize = kernel_size + (_end - _edata);
-	*image_addr = (unsigned long)_start;
+	*image_addr = kernel_base;
 	*reserve_size = kernel_memsize;
 
 	status = efi_kaslr_relocate_kernel(image_addr,
@@ -47,7 +34,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
 
-	*(unsigned long *)image_info += *image_addr - (unsigned long)_start;
+	*(unsigned long *)image_info += *image_addr - kernel_base;
 	return status;
 }
 
-- 
2.56.0.611.g1030f0b940-goog

