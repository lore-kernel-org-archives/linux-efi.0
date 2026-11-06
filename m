Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974795;
	b=GW7ROYXhZBOC3h4LNbSQM+KtUHIL8Y34lNawg8gA4lSh4gfGduqG/otPhSkSAoosALOE
	 Dxzj6QydLYS4d+v1ddKmCynyQK0HXqM7QTbVuzJhweXRn1zj3Mu5yPeOGmzNn/r0Ab4i1
	 E6jijnF5xF6odT/S3598vOI6FXex+Zqu7hWeknYhU2r+MNVSmyKxenetF7j3sJe+jGeZp
	 glq5JRjv3wC3qKUo77hCnVyiFLfLsGrfAZoH29uew+JwIJ9mT8+ch/yszCH0gSWfOP5gL
	 pwjnEXCbNOF0fug6V4O4umQfw9IGRgJEH3GMJNKk/g7rWQ99uD9KHYXJ40fE+OsEbkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974795;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=z0QcCagBfVLi6rEpBGcIxe8EgJb3rLzqWMHXP0cL7/s=;
	b=aFmt3Bknohj0nGgKM/0HJgC3edaAlMP9db4LymTaCF307vOCNHu8r6iw0OjHmUVy/X/s
	 p4vyh7jKangNh23bvVF9hpt097L+lpgALqEsqgYrIZ8B5EE5EB61nm5FKtTcT4+lw5c58
	 KEp14PCdo7TFwzyQjRW/dkYBq1pHC+R6meT/0/v/qkCuBkB2depSI0UalAPPJbG0aiJt1
	 zLSr3XVMiAplnQ52sRbMjLGOKp49qERYjUqRngpib2bn13tWFGAkI4dZ0VwetLpjv2PhR
	 UgUiIM9hcttcT69BoWpAzufY75kEuVBmTiPjB5xXcpAbUQCt0fCn4VeuELoSD9GZqAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a7koeeta;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AFE606A335
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50AFE606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a7koeeta
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a211bff50bso5872555e9.2
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793974794; x=1794579594; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z0QcCagBfVLi6rEpBGcIxe8EgJb3rLzqWMHXP0cL7/s=;
        b=a7koeetaJrvpxy9KyHYOTB4dzY+OELulkmrr6p4AByH1LBvQprmYfLhxPmDBgxY0mm
         FsGPyzqGnPbTbM9BCEhLJoUwpku13Bt9rJT1ZDbzHpKQtiFhQEswdhf72uqtSRRjW9xK
         4Qjk4qe1p5VuKqxYU7zUWtbgsDZNlZEHkY3mu4ymfWULgQio7cLE4YsH2WusM5EnMzLs
         BiJLHrEMO6upiTgWKQ4wcVCwdqwekY7VCONOyi3JucpuB6E2IO1E7HEjtvhI/TnROG5j
         TNN6saAcosGM7tsB8ANzdkdw/HVPks/0eDyq/kOy0UkCFUMflrJ+sR4gO5GERFbsTaYe
         B67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974794; x=1794579594;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z0QcCagBfVLi6rEpBGcIxe8EgJb3rLzqWMHXP0cL7/s=;
        b=Bv7fO0C9BGSZ+70j6qw87zx+psKFadipzkGR6t0nSNtdSQFax86G4AkVdUiGehgWKW
         RxSBWCrzj0uDG5lTyQYFvmEGgFX9sFINxghNSCwOsHXf7d+iJUn5uiILpwXHa44/P3Nj
         0MFdLqOPs6N3VGCh79qJTCSWxd8p7Spj2K73/R81Unb8BlY0wzW9zMlrjvBbyLxrH2Ig
         ZcTo3GVi0dlVKegrrOS0AGYkrOcRpwSbs2htyHVZVFF4coPWqfZ1R63y1tBX3LyA43Ak
         6F/eW9RMY58BQet7fhMwv4yzY4SyisWailBUVwUt4G3UTT+VnH/t0W5QuFkRm1EAW4VS
         99tQ==
X-Gm-Message-State: APuU4Z8ZwTySq1haetAVLkeSEcnNBZnb7fve3fAbogaTbe2OW6jZGxaB
	JsHy7M9elFfW+YLwfq+tE0ZbN7psbswpci6h9ClDQqwArHrswOWQ5JcmVpjfkzuOl68Lb/j1ou2
	024EHeqKnB47IJ5qr3iM//vC69Q3dEZUCJACeCAZ2xsloXnkB8je7b2PJQ3q+QMx+YuFRNjX1Dw
	omZ4kwKYvh6CZXxm/qf2dmdcut+XPksQ==
X-Received: from wmpo22.prod.google.com ([2002:a05:600c:3396:b0:4a1:8e4a:36d3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b02:b0:4b6:267a:dd6e
 with SMTP id 5b1f17b1804b1-4b6ded49a38mr49076685e9.28.1793974793491; Fri, 06
 Nov 2026 06:19:53 -0800 (PST)
Date: Fri,  6 Nov 2026 15:19:40 +0100
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
Message-ID: <20261106141936.2744481-10-ardb+git@google.com>
Subject: [PATCH 3/5] efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Refactor efi_cache_sync_image() so that it is not in charge of calling
efi_remap_image(), which is really the wrong way around.

Instead, call efi_remap_image() from the primary zboot procedure, where
it is more straight-forward to obtain the code size from the loaded
image.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/efi.h           |  3 +++
 drivers/firmware/efi/libstub/arm64.c   |  2 --
 drivers/firmware/efi/libstub/efistub.h |  4 ++++
 drivers/firmware/efi/libstub/zboot.c   | 23 +++++++++++++++++++-
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e8a9783235cb..da6afd4a7a27 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -151,4 +151,7 @@ efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f);
 
 void efi_icache_sync(unsigned long start, unsigned long end);
 
+// temporary resolution for efistub_get_code_size()
+#define efistub_get_code_size(image_info) ({ extern u32 code_size; code_size; })
+
 #endif /* _ASM_EFI_H */
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index e57cd3de0a00..7ab634e37cf1 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -112,8 +112,6 @@ void efi_cache_sync_image(unsigned long image_base,
 	asm("ic ialluis");
 	dsb(ish);
 	isb();
-
-	efi_remap_image(image_base, alloc_size, code_size);
 }
 
 unsigned long __weak primary_entry_offset(void)
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 1955cdb5139a..89cd2ae57a3c 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1270,4 +1270,8 @@ void arch_accept_memory(phys_addr_t start, phys_addr_t end);
 efi_status_t efi_zboot_decompress_init(unsigned long *alloc_size);
 efi_status_t efi_zboot_decompress(u8 *out, unsigned long outlen);
 
+#ifndef efistub_get_code_size
+#define efistub_get_code_size(image_info)	0
+#endif
+
 #endif
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 97ae706c034a..27f6661253c0 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -36,6 +36,26 @@ const struct efi_image_info * __weak zboot_get_image_info(unsigned long image_ba
 	return NULL;
 }
 
+static efi_status_t efi_zboot_remap_image(const struct efi_image_info *image_info,
+					  unsigned long image_base,
+					  unsigned long image_size)
+{
+	unsigned long code_size = efistub_get_code_size(image_info);
+	efi_status_t status;
+
+	if (code_size) {
+		efi_cache_sync_image(image_base, code_size);
+
+		status = efi_remap_image(image_base, image_size, code_size);
+		if (status != EFI_SUCCESS)
+			return status;
+	} else {
+		efi_cache_sync_image(image_base, image_size);
+	}
+
+	return EFI_SUCCESS;
+}
+
 asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
@@ -103,7 +123,8 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 		goto error;
 
 	auto image_info = zboot_get_image_info(image_base);
-	status = efi_stub_common(handle, image, image_base, cmdline_ptr,
+	status = efi_zboot_remap_image(image_info, image_base, alloc_size) ?:
+	         efi_stub_common(handle, image, image_base, cmdline_ptr,
 				 image_info);
 
 error:
-- 
2.56.0.455.g6c5a503b38-goog

