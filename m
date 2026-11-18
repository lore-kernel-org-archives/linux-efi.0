Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026127;
	b=3fVO3uRUph5/zVoRZyjtnpYj8uRPgCuMhHSDuuCZ18Ntgb+Z6HYYAvNeM3/bZye76yU4
	 CYM6r4k5bIog/HBtHWewt8uCPNo8w9T7u6MbdrrfK1lH/1ufjH8Wwqt+o2ca9g4uWedxY
	 Mr4Lhv1jviwN2zUseGt6w1SPTfv5OJJrLpQ6obtnPopOkqNrNrzjs4HuIEPtSADfJsGtJ
	 k9IuFrFZ36AFy5NYom35OAhFqYc3VIY6vmZqTLChWXRQWs4HTXCfNArN4+L/ao9dem614
	 QThFcy6s8g/J/zmpOc7xIt1Hay093bmmofc1pM/pKf2GkxK5dSQV0aa7QaufCTH6o7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=IEeaARdatv0A7mhpnidkLGUlVtXUnSTDUsZkbCqBIIw=;
	b=NuDn5Mh0BoPB2VpDFrVY6oNln4DJL3SNGULAOPHfCnbLuDBqBWVb+VRkTzkpSK4YTdnb
	 A4ddYva4FySX+ax4AvMVdo0xuJHbm3MlviU2ayzlcDHQEbeSoI/P2ygr+dSr+vYy3qEd6
	 XRrY5Arv68dD4LeUED9PdxdLThPtIh/ss6NTDqm7sXCxE8pjqSCL0BQiQVLc8IC/FuZX4
	 3UdkfqP8paWeBDTuXzC9QR2si1UFoz1hmdf6Ey8p1P3oV0aB5Udm4MYDHYwFNuUOs0QUh
	 A5DEgckp7rUShOdiThgXuQ4Z3of43vz3KbQeSSSgZp6kM5V+785mSkmn0zcRAkTRyPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dZt0SAFA;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD4C606A32C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AD4C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dZt0SAFA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so9437135e9.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026125; x=1795630925; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IEeaARdatv0A7mhpnidkLGUlVtXUnSTDUsZkbCqBIIw=;
        b=dZt0SAFAxC9g85LzyYwt5UmMLYJHbD0mSlcG6xxnxdjd63HR7qr2sAflVVlFe+NY/6
         jaXjfQlpzpf6ckKbMmTZytzMLRj+rIdKcM0BUDRRVU2oikTbolNyuXk5mWkPMTFLtJLN
         BQetLVkqe2yhAFIPmh3aRxae5gtDQRS22c8t9TGsqmGDEgHe1DYRA/yaaXP1aUUKb/PL
         66WN+/8e3ZTLM7dbXKfFtNsZSHFVltm81Cgq8Vl8/DhAPrOCFv+i6JVxqK9g9BTNYB5y
         i8+yw/Zt8PKBFIrTz348lRv8jLuCTIgXwVLOb2+/yVYmlO3N+xp8MTzLexXhU754wSx+
         JPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026125; x=1795630925;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEeaARdatv0A7mhpnidkLGUlVtXUnSTDUsZkbCqBIIw=;
        b=vKSMBRfUYMqA+p9/JqZc0+/flppdDs1DUO1r/LRmvsoCF3rtuSm61++VPZjyI08LbQ
         4t3/Gee5tN+HGT5KQemhB5e4xedOdVAc2aO6Vu/OwNY6zphYv3hfZqcD1QLQtKabAqCH
         Cqe22ljSR9LXb7Zd8Mg64AsawI+hTr1/YYyAeVqGGm71E99pvDQOjBTo5vOGpab7591J
         gYZrGlkBnEkMxJFDNoq/XTNEi+hutScegcfPmdxTQsP/rZPndkQxwv5esbaN+J9ihYvM
         TtP6rzbJJWc3hmT2PHeb3bgTAGcXoKvvjJHPm5Vyr478X5UaVg/Mg0argq5YMSXxf/Na
         NCjg==
X-Gm-Message-State: APuU4Z9H+vgt3jSLAWEb4rniUKUs91zETTy1P3A2XPrQSY8ET8pc5rZ6
	3/Eh6wRqCdhKK/Wm4ZKCBjEYIE2m5pLxx6xmSk8uiHyBeCtKG8TnVs1UDo1o393iKIRGb5+yb+x
	clxQZt1ypBOsoUGR9vWkg5/d+A4jj6y0XtXNmxPxIgBq5fs+SDk9nFBGfsnEYzLZZDBtHCGFhd0
	5njNhgKERvhgulaBoXivBL1b8CIxDfbg==
X-Received: from wmsl30.prod.google.com ([2002:a05:600c:1d1e:b0:4a2:df9b:ef74])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e02:b0:4bb:6b59:aac3
 with SMTP id 5b1f17b1804b1-4bb7da44054mr69467855e9.29.1795026125277; Wed, 18
 Nov 2026 10:22:05 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:17 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4679; i=ardb@kernel.org;
 h=from:subject; bh=BY4lNS3U3HJqg99nmA1jm5uVn1J2yFNPSkQm9h6irHI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm4Wphpfm8/sXp+4V/dL0O9xUmSnwvrtj2M3pv1sN/
 9XOe3+po5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk6QmGX8xWJ/TOemt4m/Aw
 lk7+uOJa7ReJe6vtN6p/Fvh1Or37hwojw8dZU7T4rG8eFZ/mW9XoEuD1xad9vWilmfU6Dou6SLH dHAA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-32-ardb+git@google.com>
Subject: [PATCH v4 11/19] efi/libstub: Drop reserve_addr/_size params from handle_kernel_image()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The reserve_addr and reserve_size variable pointers passed to
handle_kernel_image() are no longer used, so drop them from the caller
and from the prototype.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm32-stub.c     | 2 --
 drivers/firmware/efi/libstub/arm64-stub.c     | 2 --
 drivers/firmware/efi/libstub/efi-stub-entry.c | 6 ------
 drivers/firmware/efi/libstub/efistub.h        | 2 --
 drivers/firmware/efi/libstub/loongarch-stub.c | 2 --
 drivers/firmware/efi/libstub/riscv-stub.c     | 2 --
 6 files changed, 16 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 55d4fa3177a9..3ca20d2dd4d2 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -86,8 +86,6 @@ struct efi_image_info efistub_image_info = {};
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
-				 unsigned long *reserve_addr,
-				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 6140def24c69..af38cf73cf01 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -15,8 +15,6 @@
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
-				 unsigned long *reserve_addr,
-				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index 36ea6aa2cfcc..a2fefe1ded05 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -36,9 +36,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	efi_status_t status;
 	unsigned long image_addr;
 	unsigned long image_size = 0;
-	/* addr/point and size pairs for memory management*/
-	unsigned long reserve_addr = 0;
-	unsigned long reserve_size = 0;
 
 	WRITE_ONCE(efi_system_table, systab);
 
@@ -66,8 +63,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	efi_info("Booting Linux Kernel...\n");
 
 	status = handle_kernel_image(&image_addr, &image_size,
-				     &reserve_addr,
-				     &reserve_size,
 				     image, handle, &image_info);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to relocate kernel\n");
@@ -77,7 +72,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	status = efi_stub_common(handle, image, image_info, cmdline_ptr);
 
 	efi_free(image_size, image_addr);
-	efi_free(reserve_size, reserve_addr);
 
 	return status;
 }
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index e45d16095247..4e6af37c4ecb 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1150,8 +1150,6 @@ struct efi_image_info {
  */
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
-				 unsigned long *reserve_addr,
-				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info);
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index d57e3d3557a5..8f2145bd9ad2 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -96,8 +96,6 @@ efi_status_t efi_relocate_kernel(unsigned long *image_addr,
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
-				 unsigned long *reserve_addr,
-				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 840fdd63dccf..8cd0cd9b0048 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -12,8 +12,6 @@
 
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
-				 unsigned long *reserve_addr,
-				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
-- 
2.56.1.708.g77570a6a1d-goog

