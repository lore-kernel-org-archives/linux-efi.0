Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026120;
	b=b3JkopGZ0UFfoiVxlso1V3F0AxV8LJY+80MMxEg/xs5ku28ttQFDuwWkZUvKJqx6QAoj
	 1FRumY1K+AjjBH7E580D7tgZEMWuJe3jUfKgeEi2yfPcO5bQ256Yay2MAfhr9JXruig+b
	 ltzA58rt2MhVB/iNIsOVq/VFiAkZ7m82ZixrREltW8Ljkr9Rd35eCIcGzWbSxfoPPw1yn
	 fpDqVHpD3p0i8cIu2IYjux7tyPDFYGVBYYpWWcetK4PxIS8oW6MWym0g3j3jXjmNYkmwC
	 XODmNvHOzhjvrBFnlstXnC2ToQHcovspWKURyeJ/BBclemAQ81/CCUk8lBs6967fbJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=M1Jz1/QbPHolNpw7hViozPe0OhTh9e6urlvNZ1PN/CE=;
	b=dkY8y/OT+UBp/1EsWicNvlXg1ua/dFlaxlmf3Dn2sAKRtX1UvQKoQOS5E8TECDr0WMgj
	 5a3Wc/koSrtAXNOqmAGEgP45TE97Y9K9qTk2PrXxKmkaaLy2iGsqJ7IcO1kRPnxAxxLEj
	 7e1PHFe5dDhPIIZZQ7Iibnj+BU08BnGIBkyaRLTjODONrvR39DaJHoU8Wvv1uU1Mb3/DO
	 xoZyUOSsORjqV0y9FQ8kzs+tRvHHVz4IZ2aUVg1Vq2h8XX9K2d8/9Bc9niHImJKzkTagg
	 RXbiTkljtniwWFWObisUQ30XgdUXc5R+srvavDx91p4sYNAwpa42B5BZmOa1YuVKVLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UjYXY9fh;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38372606A320
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38372606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UjYXY9fh
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c50b170ec5aso45385566b.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026119; x=1795630919; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M1Jz1/QbPHolNpw7hViozPe0OhTh9e6urlvNZ1PN/CE=;
        b=UjYXY9fhn2lDkzPNFKYIB6nhB02hTGCCLvcwPX0+0F3IVyLJZPgaJ1ZppfBxGEhYZ2
         ds+u06ofy647PWybogHo87BpWs32E4TxMP+3CQHXgIaFgH77lxxgf5XvXR4V9ho8fP0e
         VK7yxC62gbwM54Hqk500zFE4Ki1NKsr8pOHUyW5aVsiPin0JW8+FjgvqIKa7sBVGS38I
         Bq+Zw6Gy+p7bJvc1f8WaM6750FptlQYJ17A6B6UoqbPCtK5hXbADiNDVLgFz3ChAvH44
         lyNdaDj6h07WV1J0IinHInGEFR1B09C0Pu4alFHRbRpj6vl4hN5cUy/Nzj9gxWiNzwan
         qU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026119; x=1795630919;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M1Jz1/QbPHolNpw7hViozPe0OhTh9e6urlvNZ1PN/CE=;
        b=FyqgeB71YgyF89xzPwO4uDTUOzxP1Vt2K/usurPs6SWRPM3vCZyG5qXOqLeZqI4AFz
         1D6fGzPHrOI0RVJ+osYGGa04CBdFq1ZNA4rNJ+VcHYcs8BQ6WfEovwTDxPOS38r+5h+X
         4JCSBTTJ7qG6OjFI/4Yy6TUMr1c63TJChUkCSlxc52VyDYv//ZmAlCt2AXgOPI02vG6y
         0mCi9qr+3yz27cSusB+HwNuDpEMdV8oPnVbH0zd7idG1lFO4ACuWo88PA7jur1d0DoxE
         6uixGDxnClyvbi5u5jv5r/y6uJ1JxweR5pN4E7IQn5OGxosg8p/+0tG5JJOUeo6FSwne
         TW9w==
X-Gm-Message-State: APuU4Z+c60IWt+Qt+cBeByKpSxkASb4CWbB9NaW7lyayYO7Gw9N19D1s
	YlOMbvLVGFnaINepSQifhY21ROsruH1iJuOdeGrP8KUBy5y71SxURNIamW8VfLFIMrszSy1fwo+
	/Z81jZo0EIojwRsbcMW/9YG1+pIr5KvRjmlWqA/2S3tSywm2w9g4LYCyQObMUkqBOXtWDplReNT
	SRmHxOzJzox4wnsXTzQ56AMruXs1jpMg==
X-Received: from ejbjo16.prod.google.com ([2002:a17:906:f6d0:b0:c4d:2462:39ce])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7f94:b0:c41:4d5:e97c
 with SMTP id a640c23a62f3a-c510e361646mr311603866b.37.1795026118221; Wed, 18
 Nov 2026 10:21:58 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:13 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6557; i=ardb@kernel.org;
 h=from:subject; bh=UpOlRDfxgKbTpCknhkTVYs14c9RoP6u0s/Oh13lIEDY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvmzm2ncdETfvsKw8rxd7+8/mufGDvsrVFrJMOrXz+Z
 dMcgdOLOkpZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEFi5hZNibunG1wdlpO5qu
 r1/meKdsX//eQud1DGdlLrUy3SjRe+jHyDDXbGe7/YmN0aueTz2kd0pxy6GZ7tL56YaJBrPObFj oLsUOAA==
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-28-ardb+git@google.com>
Subject: [PATCH v4 07/19] efi/libstub: Avoid reserve_addr/_size in efi_kaslr_relocate_kernel()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Avoid reserve_addr and reserve_size to carry the information about the
allocated space for the relocated kernel, and instead, use a single
alloc_size output parameter that is wired to image_size.

While at it, don't use the alloc_size as an in/out parameter, but only
use it to return the allocated size (and leave it as 0x0 if the image
is going to execute in place)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |  3 +-
 drivers/firmware/efi/libstub/efistub.h    |  3 +-
 drivers/firmware/efi/libstub/kaslr.c      | 30 +++++++++-----------
 drivers/firmware/efi/libstub/riscv-stub.c |  4 +--
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2c3869356147..fe0deae78e5b 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -35,10 +35,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	kernel_size = _edata - _text;
 	kernel_codesize = __inittext_end - _text;
 	kernel_memsize = kernel_size + (_end - _edata);
-	*reserve_size = kernel_memsize;
 	*image_addr = (unsigned long)_text;
 
-	return efi_kaslr_relocate_kernel(image_addr, reserve_addr, reserve_size,
+	return efi_kaslr_relocate_kernel(image_addr, image_size,
 					 kernel_size, kernel_codesize, kernel_memsize,
 					 efi_kaslr_get_phys_seed(image_handle));
 }
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index f5eec8c12894..5c10815d9172 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1244,8 +1244,7 @@ const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
 void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 		     unsigned long code_size);
 efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
-				       unsigned long *reserve_addr,
-				       unsigned long *reserve_size,
+				       unsigned long *alloc_size,
 				       unsigned long kernel_size,
 				       unsigned long kernel_codesize,
 				       unsigned long kernel_memsize,
diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index b34e4599f0f6..49b05d0c0003 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -82,9 +82,8 @@ static bool check_image_region(u64 base, u64 size)
 
 /**
  * efi_kaslr_relocate_kernel() - Relocate the kernel (random if KASLR enabled)
- * @image_addr:		Pointer to the current kernel location
- * @reserve_addr:	Pointer to the relocated kernel location
- * @reserve_size:	Size of the relocated kernel
+ * @image_addr:		Pointer to variable carrying the image base address
+ * @alloc_size:		Pointer to variable carrying the allocated size
  * @kernel_size:	Size of the text + data
  * @kernel_codesize:	Size of the text
  * @kernel_memsize:	Size of the text + data + bss
@@ -97,13 +96,13 @@ static bool check_image_region(u64 base, u64 size)
  * Return:	status code, EFI_SUCCESS if relocation is successful
  */
 efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
-				       unsigned long *reserve_addr,
-				       unsigned long *reserve_size,
+				       unsigned long *alloc_size,
 				       unsigned long kernel_size,
 				       unsigned long kernel_codesize,
 				       unsigned long kernel_memsize,
 				       u32 phys_seed)
 {
+	unsigned long kernel_base = *image_addr;
 	efi_status_t status;
 	u64 min_kimg_align = efi_get_kimg_min_align();
 
@@ -112,8 +111,8 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 		 * If KASLR is enabled, and we have some randomness available,
 		 * locate the kernel at a randomized offset in physical memory.
 		 */
-		status = efi_random_alloc(*reserve_size, min_kimg_align,
-					  reserve_addr, phys_seed,
+		status = efi_random_alloc(kernel_memsize, min_kimg_align,
+					  image_addr, phys_seed,
 					  EFI_LOADER_CODE, 0, EFI_ALLOC_LIMIT);
 		if (status != EFI_SUCCESS)
 			efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
@@ -122,33 +121,32 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 	}
 
 	if (status != EFI_SUCCESS) {
-		if (!check_image_region(*image_addr, kernel_memsize)) {
+		if (!check_image_region(kernel_base, kernel_memsize)) {
 			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
-		} else if (IS_ALIGNED(*image_addr, min_kimg_align) &&
-			   (*image_addr + kernel_memsize) < EFI_ALLOC_LIMIT) {
+		} else if (IS_ALIGNED(kernel_base, min_kimg_align) &&
+			   (kernel_base + kernel_memsize) < EFI_ALLOC_LIMIT) {
 			/*
 			 * Just execute from wherever we were loaded by the
 			 * UEFI PE/COFF loader if the placement is suitable.
 			 */
-			*reserve_size = 0;
 			return EFI_SUCCESS;
 		}
 
-		status = efi_allocate_pages_aligned(*reserve_size, reserve_addr,
+		status = efi_allocate_pages_aligned(kernel_memsize, image_addr,
 						    ULONG_MAX, min_kimg_align,
 						    EFI_LOADER_CODE);
 
 		if (status != EFI_SUCCESS) {
 			efi_err("Failed to relocate kernel\n");
-			*reserve_size = 0;
 			return status;
 		}
 	}
 
-	memcpy((void *)*reserve_addr, (void *)*image_addr, kernel_size);
-	*image_addr = *reserve_addr;
+	memcpy((void *)*image_addr, (void *)kernel_base, kernel_size);
+	*alloc_size = kernel_memsize;
+
 	efi_icache_sync(*image_addr, *image_addr + kernel_codesize);
-	efi_remap_image(*image_addr, *reserve_size, kernel_codesize);
+	efi_remap_image(*image_addr, kernel_memsize, kernel_codesize);
 
 	return status;
 }
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 5cbc50a814e1..d0fc04d21b56 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -37,10 +37,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	kernel_codesize = __inittext_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
-	*reserve_size = kernel_memsize;
 
-	status = efi_kaslr_relocate_kernel(image_addr,
-					   reserve_addr, reserve_size,
+	status = efi_kaslr_relocate_kernel(image_addr, image_size,
 					   kernel_size, kernel_codesize, kernel_memsize,
 					   efi_kaslr_get_phys_seed(image_handle));
 	if (status != EFI_SUCCESS)
-- 
2.56.1.708.g77570a6a1d-goog

