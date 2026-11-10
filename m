Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313072;
	b=WwE8UmwhiEvhmFTUL8ptIQ2q49g+ZAa8sPdmexXAQDyP23elMvo/fSHOiVke8c+17vur
	 moe6TvfYzKlhonOhIfUHHNUUhVwtkFZaXL2UZfeX8rTowLe+MDGiW4oEit9kqnJ9FA9t7
	 soxwypeMPOM0bcig8FiD59HJKNVySbvpY3GVzomdHhQOSzr2N4Y58+DTXsfM2cPn2j2Bz
	 2enHXt+OdJjjWG9b0EVgRFMJT7tk5k0E5Fn0Wm5yBRzz98BE9MYbJkHWDPBFeQ6MQM2v4
	 IPPbvvEWK4jQGImJ8DORUlEqs8ct1c7Ej04apl5/P2M560ldhFm4jbnei3M2yiX6GmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313072;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=/NOGXHiMglGNlkAHWoIUlx58rvJ+/z9H2Q0oQTuWMl4=;
	b=yEmYmfnGZ5f3VLkBXWhby8jTJ6b7rParU5gm+Y8EYJbtay2ScB8R8+v367Zq9D+50e+i
	 A9yrVmFZcJcT8ASNzR7Rraz5BTvzZPKVaTkFZ00mHi7lYHxM1Gc82G8t2jPqUOHd/yeWo
	 /R5HhuZB0O46ldjXeQFkcXh0I3orS9SHDLc6dRwAT/pZASgTTcR8Xa9LmTuYUpFbUOKGi
	 84rT1VsUEGj+6DIJS6brpILhPWZbuMo6ro/mVh5GrKbcatc3wuN5N0EA2d0b5Zm8oxpZ6
	 E7TO/+DCZ2DyRSjGGtmuWj1CSgukrTZ8W27aPwerwRPUq6SuZGXTY+l5iapnIZEkCJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KHujnKC4;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1865606A331
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1865606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KHujnKC4
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4ba01393800so6482745e9.1
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313070; x=1794917870; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/NOGXHiMglGNlkAHWoIUlx58rvJ+/z9H2Q0oQTuWMl4=;
        b=KHujnKC4JkVBwCqhdoE1kgf4zLIoGbvUHXD2UjMJQ7oYM/y1qDI54CRRgRETMVCF1P
         negRVuJLcUGzbkiRVXH/+CAplsbgHRBsJU+otMOTbx5Bs0frhylka7NYX0pTT36t2qjP
         NGBEalUZyjnnodiu1V1AwAoIci3vETe7GRpWCq0dYxdJm1qAL8jZecklb/vqQAx0TL7q
         ovgVwlvjac4MDr7XPZ1ySe3cq9Vjaovq8Aa9hyFNcuxdmY2hQbV9eujTOyHQfzFTKd/g
         fWp1Rit1UvF1z6HOFNOfb2ixoi5efW7MZUij+LNfkReuZKJQL5X5Z3EToPAVLAzDoXtH
         ol6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313070; x=1794917870;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/NOGXHiMglGNlkAHWoIUlx58rvJ+/z9H2Q0oQTuWMl4=;
        b=oswy2ORB74ki9rbE3Xc4VWlyMs/mEK3ZDLL3XUCmMkY3JkSR2HBcEpXUcYWbmR/MYU
         sx6rnVxKYUbOuc1WWcW8Y7bA8dIYxPD/WP8PAN9Izlw02J+shDIPb7IoETNDJfLGp2D3
         nGIoTEO0CsAjmuctvEq8xRUaIu8dhCXhg4yyKlSGyvNnWxi73Pgm4Umuncxs7NoxSpYG
         oWn2OBTBUuzcR03/iOMtrYe7uBR3ak+bgvk/q4kZxO3vHkuYgT6n/07Z99TEXJ19zz4d
         YxSFP0BH9Ph2i1BMke1Ixv87ybEDmKENN5aMkFf0jx1wH6BcADQvXasqFiFttuZvq/wt
         Hx7w==
X-Gm-Message-State: APuU4Z/PHYZvI5K0849mEAfGixBS4ppw5HtF3xJwWGSWYm94mSD1dPaa
	oqVNV0/4opZSKSpz7BrZG7exRdOyk0tErStOfCCMKcsksnQrmZ2/PQUVK6qXrG07y6PXbQSW5pQ
	liN4wMc0pLzu3abhKyv73G53L0zoOmcbbwQvkW/2bP87YFbFfB5HHh4okA1QKcvxpSE5igjOOyC
	KyzZptfA3p72OVl27WXqhyhzK2PRPW4w==
X-Received: from wmbgx15.prod.google.com ([2002:a05:600c:858f:b0:4a2:8ef:a5af])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1392:b0:4a2:1e1:d55
 with SMTP id 5b1f17b1804b1-4ba02355ab0mr37537145e9.28.1794313070010; Tue, 10
 Nov 2026 04:17:50 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:41 +0100
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
Message-ID: <20261110121731.2728824-21-ardb+git@google.com>
Subject: [PATCH v2 09/10] efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
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

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm64.c                 |  2 --
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  2 --
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c |  2 --
 drivers/firmware/efi/libstub/zboot.c                 | 14 +++++++++++++-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index 62fc8e53c8a0..fdd48ba0f9f1 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -114,8 +114,6 @@ void efi_cache_sync_image(unsigned long image_base,
 	asm("ic ialluis");
 	dsb(ish);
 	isb();
-
-	efi_remap_image(image_base, alloc_size, code_size);
 }
 
 unsigned long __weak primary_entry_offset(void)
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
index c6071b0e8f1a..25ff5960771c 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -38,6 +38,17 @@ const struct efi_image_info *zboot_get_image_info(unsigned long image_base)
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
@@ -105,7 +116,8 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 		goto error;
 
 	auto image_info = zboot_get_image_info(image_base);
-	status = efi_stub_common(handle, image, image_base, cmdline_ptr,
+	status = efi_zboot_remap_image(image_info, image_base, alloc_size) ?:
+	         efi_stub_common(handle, image, image_base, cmdline_ptr,
 				 image_info);
 
 error:
-- 
2.56.0.542.g3ef89b7020-goog

