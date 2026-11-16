Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839249;
	b=5mD7N4XYdpAKi9vqhf2TGo8rdHGDcDIMSM1jcHt78bkR1Pm+Z+ZDgyaqnT4NXBs8C9vQ
	 QL/63F32Fc7uihn68SROANwxixcxtUrFoRYapg8S9vlsDqAaiU2hIPlI98P5F7v3kBkYQ
	 fmeBPEFi0G5yXCt9a8Dkfb8Wck2KCSXq8riRmdg+DJZDgyfMfnAfmBMcimkUUpH8ghlWf
	 kxATg/y+QH7XUmcwAknf36I8yAukiomH4+OHin250rBX7dX47Xc0m/QJxPLCS3gpqL8OG
	 /drXxVORuyi8fXOxBZik2bsrOAO8IBf/yh/GGVpi9W7RXb1/YfAKMRZ/ABlLaqk8Vxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=/n6m3/52gay8f6Ej6cOhY6hNu8E9Pz3qti51eQ1NNTQ=;
	b=CivG0AdBMC4fok2mH16zTawokSWuktThi0VkZM6C8YFdgsHSyu1e9MCfF9pqhrTyrcdc
	 yHhrttG3HvHdaDfwy0sVUBjBGvxe9apuNbjY49w4KxfpY+XnB1IwzkrPQqsHzE2+3ai+E
	 kNUtUAxcvd5fKkBJGMQYHo24cjGGc/T5uqZAE88JmTh1cPWbVheGc2YgnUuw+crX+Qska
	 y7QH5zIOj4LvwsGmRmdLMdE29WjokKGQAvk8vAchF/RTrLiyjNGCQAX6+aTk/27XkeeD6
	 z1mki6j9aILSCprSu06CerX9iludUZnNuwun85Xg2Eqiut0Ap6Tif4qEHFVxeNui1CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UA5ZOKq6;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0603606A330
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0603606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UA5ZOKq6
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a009f82bedso20423385e9.0
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839247; x=1795444047; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/n6m3/52gay8f6Ej6cOhY6hNu8E9Pz3qti51eQ1NNTQ=;
        b=UA5ZOKq6sjY7UyQGOl7+MvPIQMp+MOsxgz7A1VVC+tNKh4ebz7ItkIuDQkh9MxYrQN
         q8u0EbLd9eM8nZkvi+Jq1Q61re3jmdz9cmn9FK9qr1p1Nb8Zofl4kDIqwrfAO4oW8PMB
         S6lMaZL6kGwkDv6010sEEK3LjU4jPRz7JPDLGCDwVqv39RH6QXLlMetKwN/V0XEPaVz8
         nvqQe7KAMWzE/nyY8UOrxiA+RJ3fD6BCa4SPAS1HNEjhX3Q+qmQzUConKBGnH+ezPaNg
         vLRVCeTOUMNrJRvUuH1ZeI/rlq1o8pFwoO5nFftvpeNp69pXUo9IiQEGXiCTXJAp2ddt
         xQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839247; x=1795444047;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/n6m3/52gay8f6Ej6cOhY6hNu8E9Pz3qti51eQ1NNTQ=;
        b=JDi4YNL+8IJ0U92gLzQMag6OWgFkTbnjgk+ZKx0EV+SgRUGyPPaFa6EDtLAW68o2uh
         uRscVe1uV5z5wo4NEjF2vjZI1dcY2KkBW2TugjR7fHOL9rlg5Is3z6H1xgDXtEvFdNEF
         5OpWHu3oUt5M+WrHTIv1/raoSYsXfA93Lyce+2KaQtZIZJ0cxr3pBjCy4bL6VxJIMP1a
         v9OL1+WwJF/UWxDaZNPpq35MxE+ORYXf4EAmGp6Q/UPbsKYJmYs3jpWTDYASN7CzdRVw
         RvvwHoQV9BMgBdd9EdtDV01bHMS/PAFcYxFIbGyixNKJwGVCGBXt0V37XENizJ7ujDHV
         C9TQ==
X-Gm-Message-State: APuU4Z8tIsKoifuTAHTEsH6Fs0NijCoTLFQSa1hXlNr++NnFW5SSsqA5
	VASZbfmKHafk4Lt5otRxBCUeWCsE9Gol576A/Svjnxwc35fTR8nOMOIZu3b1i6EGc5+oDMmN5UO
	wxvPF5xJvx2h7bfgGeTpFkFVLijAb5SDsiQvBQWAkFZzEhztHyA9DvyUiCt9L2z9pZOk/JQ5AG7
	dmIkuLAPb7yxDL+psJ4vzs6Rdwz4t2bg==
X-Received: from wmbh17.prod.google.com ([2002:a05:600c:a111:b0:4a1:e44e:ffd0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1daa:b0:4a2:59:f568
 with SMTP id 5b1f17b1804b1-4bb55a481ccmr219045695e9.14.1794839247128; Mon, 16
 Nov 2026 06:27:27 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:31 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3432; i=ardb@kernel.org;
 h=from:subject; bh=QYWgT8z+L2wxd3Su7/3zae0d2A2rWFJt5EArtqIjNsc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30Jye2Nizu51WtW9hsrE+dFh033rbbWcDfH+5ebw0m
 /Rta9m9jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRS/MY/jvO3iD6djGz4BvV
 2LrozT0fqyuDj7NyHJj14vqh8nlTF3YzMvyt2qy7QXBh+O6ensTDtfeDZ6z92X/cXt1489atzIt DS/kA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-29-ardb+git@google.com>
Subject: [PATCH v3 12/15] efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
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
2.56.0.611.g1030f0b940-goog

