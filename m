Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974794;
	b=GSLby6/m91J8Sjf0Y3v27bT2FNqoA1/VpksyLcVgrEyg9zdkEujXOWIiXMKvxcWOzQpp
	 8jGGwGCAscwr1G50aE6EUyfiN7dWJdCgdo+ELVdx05k+DMic2FGzLOucwchWB9VVdFqRd
	 BoEhgRK395unVROI1Kh+TVuScq7eQgrTIe4N1hxcScYC7ElmuTw7BfZe2QTSslPlkHuEm
	 U7yzy1Q0Ua7GgFSEZFbnji867NoZ41kJpJngvUgQ8qNdBIQjlydfE7FEK+wwa664Mg6hD
	 nLGqqEUk5YF2V1xKv1z2jGZqXLXsMVgqYlaVaCRBRc5miZ3mRXrG8JwHjuSc2WsYEXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=0tnMr9KEjuROPAq10Z+5/qoKIgPgadWx4j+MtBV+tDs=;
	b=BAXNarVQCpTXw5ROE0GlyR1IBZxIQ8HjS2N7Mzhn4QFhvCZckdmviaS7W47sudf8CTUZ
	 gUUvHqbBGNuf3tIVhR/VwixC6SLjQCZuL6rOKJqPGckTXY9CMfRqWO2YXvL7NLpkn3MpJ
	 A8uTU4+pgGuP9WPE61lLT0y2OMISUvFaPi3N4bPloQJ8e80GO5BdK4WK5Ro5ssGwjjcXr
	 j+1NYm1gSv5Q/RHdYYRPAmlqHdt03ZzwE1rUj5BkZHq4KYKjP60ndpzwAKsgGgQboSmSm
	 ZWBvFJxFQSYJbDDy35oyk9KsN36it2bBj8NJXIsEub6llsSahLovRGevHnIscQ4SLTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JhLL9Iwh;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214C9606A334
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 214C9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JhLL9Iwh
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4ae2756fa7aso5376795e9.0
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793974792; x=1794579592; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0tnMr9KEjuROPAq10Z+5/qoKIgPgadWx4j+MtBV+tDs=;
        b=JhLL9IwhSXyxSLjUUbOkkQv4PE4WoAzHTjLQncd5PViwUufKiBEnIaWZLZqmN/nsET
         53XDZ0k9vumdkRLmQyx14e+0TkqZ0YqwWH4b7AhiUMWD4YXFNfZAPFqoypj7sDA6RjIU
         tPT70NrCQg8KxFXewIheKUej1HllCeTuemoZOVWHrUdj1k21VW3Kv6vg8jQjWYQW1eE1
         0Fopt0QD3kOkyCfJx/R/KyCTnjzPH3UWcQyWtaQVeAiN5UoSz9MSM+etmZo/cGVMdqdb
         fHUXD5slx33SqVkIm6hfQyAxNo4HpHgLtEh2M0bysLyAvXMGiiNdeAyEkJBgCU1bmfgB
         Em6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974792; x=1794579592;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0tnMr9KEjuROPAq10Z+5/qoKIgPgadWx4j+MtBV+tDs=;
        b=wBl/XFslYOMdc8YHsi/k1YuIMva456Q1F9pnylNgQmI/icjRAoi/htZxiI/Tm0FMc8
         axa4gkBq/aYGuq1SEoHiEdl7ccyzWp+jVBYvLTBvUSYZUqNmWlpOV6pdHy4Luxn8Xvq3
         Ay3QGubT49/VBNIjJtvC1V30Nou+zzbPpuyL++RPHugTdtbsy52LHJgLjosYHl1oP1EZ
         j708KuYJyvjWZUrU4Wj9TpMPu3CueiIM/89S4ZXUaYtitxNnx5cimHF3mNMWG/yN+sE/
         CzKV2yqj3OzBsq5UPvEZIi1F+7uIteiELSWKpqPT3kTSYOZxt5mOAc6bK4e4Ir4pNE2S
         cTDw==
X-Gm-Message-State: APuU4Z/v1edQBdPYz9CxZcJktLA66ay68rnoJxPnx5qOsAbg764pdLr/
	a7tbHuQDyQNFepcBLuxNQV5Srq7erpNXv22cMU4akpFUU5TxAklJZ/Gj5LHCz7ltB0IV7qBJxF8
	RCjBRTXuIuO7q4jj7SuTQYrXtJ+thFdcZC10pYTGjfV3OnVqiI40Z5S5Qiw0NoW7uDo9lW9hInQ
	06HpzgZM5Q/sCI8oOjSDP16kL2mxW+Dg==
X-Received: from wmco28.prod.google.com ([2002:a05:600c:a31c:b0:4a2:11fa:1981])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4454:b0:4a0:1b21:2628
 with SMTP id 5b1f17b1804b1-4b6dfba8640mr46219565e9.23.1793974792222; Fri, 06
 Nov 2026 06:19:52 -0800 (PST)
Date: Fri,  6 Nov 2026 15:19:39 +0100
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
Message-ID: <20261106141936.2744481-9-ardb+git@google.com>
Subject: [PATCH 2/5] efi/libstub: Pass a struct efi_image_info to efi_stub_common()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Pass a struct efi_image_info pointer to efi_stub_common() so that
architectures can expose properties of the image being loaded in a
consistent manner for both the uncompressed kernel and the EFI zboot
image.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-entry.c |  8 +++++++-
 drivers/firmware/efi/libstub/efi-stub.c       |  3 ++-
 drivers/firmware/efi/libstub/efistub.h        |  8 +++++++-
 drivers/firmware/efi/libstub/zboot.c          | 15 +++++++++++++--
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index efa3ab8ad1c6..ff559708dfe7 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -27,6 +27,11 @@ struct sysfb_display_info *alloc_primary_display(void)
 	return NULL;
 }
 
+const struct efi_image_info * __weak efistub_get_image_info(void)
+{
+	return NULL;
+}
+
 /*
  * EFI entry point for the generic EFI stub used by ARM, arm64, RISC-V and
  * LoongArch. This is the entrypoint that is described in the PE/COFF header
@@ -80,7 +85,8 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 
 	kernel_image_offset = image_addr - (unsigned long)image->image_base;
 
-	status = efi_stub_common(handle, image, image_addr, cmdline_ptr);
+	status = efi_stub_common(handle, image, image_addr, cmdline_ptr,
+				 efistub_get_image_info());
 
 	efi_free(image_size, image_addr);
 	efi_free(reserve_size, reserve_addr);
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 6db10590f89b..ee5931eed59c 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -161,7 +161,8 @@ efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr)
 efi_status_t efi_stub_common(efi_handle_t handle,
 			     efi_loaded_image_t *image,
 			     unsigned long image_addr,
-			     char *cmdline_ptr)
+			     char *cmdline_ptr,
+			     const struct efi_image_info *image_info)
 {
 	struct sysfb_display_info *dpy;
 	efi_status_t status;
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index b09d6c535ab5..1955cdb5139a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1148,11 +1148,17 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle);
 
+struct efi_image_info;
+
+const struct efi_image_info *zboot_get_image_info(unsigned long image_base);
+const struct efi_image_info *efistub_get_image_info(void);
+
 /* shared entrypoint between the normal stub and the zboot stub */
 efi_status_t efi_stub_common(efi_handle_t handle,
 			     efi_loaded_image_t *image,
 			     unsigned long image_addr,
-			     char *cmdline_ptr);
+			     char *cmdline_ptr,
+			     const struct efi_image_info *image_info);
 
 efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4a5ffe164873..97ae706c034a 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -31,6 +31,11 @@ struct sysfb_display_info *alloc_primary_display(void)
 	return __alloc_primary_display();
 }
 
+const struct efi_image_info * __weak zboot_get_image_info(unsigned long image_base)
+{
+	return NULL;
+}
+
 asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
@@ -93,9 +98,15 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	}
 
 	// Decompress the payload into the newly allocated buffer
-	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
-	         efi_stub_common(handle, image, image_base, cmdline_ptr);
+	status = efi_zboot_decompress((void *)image_base, alloc_size);
+	if (status != EFI_SUCCESS)
+		goto error;
+
+	auto image_info = zboot_get_image_info(image_base);
+	status = efi_stub_common(handle, image, image_base, cmdline_ptr,
+				 image_info);
 
+error:
 	efi_free(alloc_size, image_base);
 	return status;
 }
-- 
2.56.0.455.g6c5a503b38-goog

