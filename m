Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026136;
	b=v/Eeb5+d917gh3pfdELU9JKc1NhaQqw7qvFcjpzAXvoLzwLxtncbZfGePt+uuoBucZWj
	 7sKTS8+C0/4Z7ZSpkKiyY9S32J5xfEifsskaOcCTVAl7BmMoTT09IAtwfB74OVVXr+lra
	 c6imqg4q3FcJ3HrfjdCJ9O/9WeORwJXzd9js8jzUka60Zrxz8oxCvCeg5WssKz22cRZHa
	 bIfZs9hd9AxrLhHo2C4bMKPY3ScbkyiG+ik2aH14ECOzSUf5qoW4yoVeFXHyank+3FvQp
	 S86Wikn9pOPh4CBizwkFoOghCKFvFeTQJomIqdxRmWUftgvIdo0pz3RTer14FZJhhMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026136;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=rbvVNrqGe63WaCDhQx3Sv7CZ2HUvzt7iMpy1FWtb+xE=;
	b=3LHJi6UXe6WOeZTuLQ5dw+jIUY9jWX6JZkgQ+tM4F4QTPKDrkH6WvtyLXfU4+SLY39eo
	 2jysZS0DPbz0QDW0bj0GuS4nopHOHmd1tlQKvgFaIZExwWVktL0gsjWAV7a0gHoMDfNgn
	 30KWdqvbNEhAydEDHHPOonvubYg8CuzpQTSIYdpd0QKg2xU0l+jMFRiQtduJGr8BfO963
	 63Vfp0ZjRtaEilDjxCb9Cvb9nv5UpG1guzRvH8zFsASuudbipLq2AZKdb0TPVK7fpQ2lM
	 06a8PzWgWqI2xK2+8cI/eoS2fW1Vma6wR5yRlfAVGT5TTzbUI0X5ux2m+2dwoMjm35w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AoIhFk3B;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272A6606A31C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 272A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AoIhFk3B
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4bb68d624baso13067575e9.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026134; x=1795630934; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rbvVNrqGe63WaCDhQx3Sv7CZ2HUvzt7iMpy1FWtb+xE=;
        b=AoIhFk3BO+MFJBWTumVY3fwxkCUxzeuTF2ozxkHnlT9zNImj1HOOQRZqajxOECrl8n
         hKLNPdgDfW4vPp/IrWYTere1lCDXwFa/zQ8nU+Ov51xsaFoQ9rcZpkLwu2mpNzDaWnQy
         +Ell6bFb3w/EaXGUAnZPGOBqQ+Dy3sX5ZUzR6naz0snvkqv5fsp/qmmCiiOhWoK9vsHU
         8M8A0GaetBdLp24UDt6WY7vTfVBgDRyEGy5jcsTooAPzgc70qcfNrc1xvspf784avafb
         sNLkgZ4PtcUVTHdyLNHplhlVFrAY/0+X1iX6PpYCYqdUfnUpcvrKhjgEsgCOe1QxXjme
         8uSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026134; x=1795630934;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rbvVNrqGe63WaCDhQx3Sv7CZ2HUvzt7iMpy1FWtb+xE=;
        b=zufuX23kYlgUgi4ZyqL/CDpWTcasRWn6nHClTI3Lvc/x2tUZ3ar0Mc6m2aqqdo70Ua
         NdJXw+g2O9KpaDMa45XZovJB9Vz52y2dbl8UO5uHXYrdpvPP/00LUjsKzS7cWuBJUwCH
         04iseCpwq7ckQ9PRtdSZIYRBTYddd93DNKzFgUzr99Fz0N0P0XTOSfNULRVhhCA82w3a
         VhTxhDfhSMfMezDtwekfGk9egyfaUh5tn2VdhQoonQDRdT+YBhQm2uBCSiy8JjXawN6w
         xQ4O18UY6meBIce+3PqtpBlvxRzvTrrSP1tRelvMMa1Vjig/Pd5v/gX6vQFvrWUR9tCy
         /+wQ==
X-Gm-Message-State: APuU4Z/8PlVml4zlgwKZQawNbG0/IkwW9O6EWOzhnzXpY65KMMnxzqIw
	kjlIjazPXnA037SRQBDluWY+PozvjdjT9LRaR2WZ7c7Q1TTeQBCB9dKRcKi5QW7Nk1HiqN4xw1I
	+3Uk44KZBG+c54Fr0iB0WaA/RLfrsRnOxa7b/uRIergoeLd5Yrvl0vG6AYh8694/wU+a4prjgG4
	n9jb+KhFqgthWxZO8EyLDekc1RIHLZCg==
X-Received: from wmcq6.prod.google.com ([2002:a05:600c:c106:b0:4a1:b721:2a42])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a55:b0:4b1:2026:6b41
 with SMTP id 5b1f17b1804b1-4bb7da2bd37mr65014595e9.30.1795026134131; Wed, 18
 Nov 2026 10:22:14 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:22 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3432; i=ardb@kernel.org;
 h=from:subject; bh=JdUM/iQUeD0oJbWCV6TTeOpr5VeNWaZWfcnI9fEnIyM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvmxVzhTeaiPgdOv59tuORKzfu67fZ8M+NyVqZmvl2/
 pKvPjJqHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiNlwM/1Mt+iTFuloPxcy6
 5OZ/+M3kr+/VedYcu87aXuZXUfdcxISR4S3DKTM1X/aMueVnPD/f6Joxs3mJt/nLR5sn3pZ2avr JzgIA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-37-ardb+git@google.com>
Subject: [PATCH v4 16/19] efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Refactor efi_cache_sync_image() so that it is not in charge of calling
efi_remap_image(), which is really the wrong way around.

Instead, call efi_remap_image() from the primary zboot procedure, where
it is more straight-forward to obtain the code size from the loaded
image.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm64.c                 |  2 --
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  2 --
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c |  2 --
 drivers/firmware/efi/libstub/zboot.c                 | 14 +++++++++++++-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index e892302f4189..f8bb890b9631 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -113,8 +113,6 @@ void efi_cache_sync_image(unsigned long image_base,
 	asm("ic ialluis");
 	dsb(ish);
 	isb();
-
-	efi_remap_image(image_base, alloc_size, code_size);
 }
 
 void __noreturn efi_enter_kernel(const struct efi_image_info *image_info,
diff --git a/drivers/firmware/efi/libstub/zboot-decompress-gzip.c b/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
index e97a7e9d3c98..79cf8c48b033 100644
--- a/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
+++ b/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
@@ -62,7 +62,5 @@ efi_status_t efi_zboot_decompress(u8 *out, unsigned long outlen)
 		return EFI_LOAD_ERROR;
 	}
 
-	efi_cache_sync_image((unsigned long)out, outlen);
-
 	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/zboot-decompress-zstd.c b/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
index bde9d94dd2e3..dd7f11238154 100644
--- a/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
+++ b/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
@@ -43,7 +43,5 @@ efi_status_t efi_zboot_decompress(u8 *out, unsigned long outlen)
 		return EFI_LOAD_ERROR;
 	}
 
-	efi_cache_sync_image((unsigned long)out, outlen);
-
 	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4cff756902ad..9c7de225b39e 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -40,6 +40,17 @@ const struct efi_image_info *zboot_get_image_info(unsigned long image_base)
 	return (void *)image_base + efistub_image_info_offset;
 }
 
+static efi_status_t efi_zboot_remap_image(const struct efi_image_info *image_info,
+					  unsigned long image_base,
+					  unsigned long image_size)
+{
+	unsigned long code_size = efistub_kernel_codesize(image_info);
+
+	efi_cache_sync_image(image_base, code_size);
+
+	return efi_remap_image(image_base, image_size, code_size);
+}
+
 asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
@@ -107,7 +118,8 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 		goto error;
 
 	auto image_info = zboot_get_image_info(image_base);
-	status = efi_stub_common(handle, image, image_info, cmdline_ptr);
+	status = efi_zboot_remap_image(image_info, image_base, alloc_size) ?:
+		 efi_stub_common(handle, image, image_info, cmdline_ptr);
 
 error:
 	efi_free(alloc_size, image_base);
-- 
2.56.1.708.g77570a6a1d-goog

