Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839248;
	b=h3mPMly4TSbodUbW+Jy0CNsgRTESPUD6ZCtUv/l+eK1+pMscqq/qxy+YFuyF0gTKvuo0
	 TivHvBJ0154Xrajh03IVdSC0NyrxtTS/slTgNp86h1zv3aL2ptlctFIs45RkQdsMqRyqi
	 dPfNoeVUpQYyro6OLjUTkuXbBEW/elcGfAi9mUga1nD+hR5unkRP3KS18ExVG8EU3rImT
	 bjCukidwd3rSelqNzSPTAIbLiUmPuSDoN8ZDfpfKdZ2/1Zz6cHw/DUpxjldDDYGnXjqcf
	 u9/ZePMxa2n0JvBfUC1YumV/7fShKRCBgxBxbiJhcgg22Vll0f/1m0RBge6WzmYW0VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839248;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=cV64o3SIMgxbdBJ/g1LGVun+1S1o6sl5wdO0gO6pEOs=;
	b=g1RxJ4uUC74/76kF0/hbqLhD1bwvRBw0U6W9Dt5JO59Vw/QD8VsajaoGiwDFYOaOeFRf
	 4vbIqbhC4hm+r1f9T0F3WUmfwyRTwwWYFrM+eNEeLYJrZI7zrd9z74NIiGgY3V4ArYYtF
	 2cZzAE5Ui5kw0WIACvhQ9y0yGBAcsIUzPmwvBeBmEN7br0qkBRJ/8uSpxNLVaTcORFu7T
	 qTbTgY2E5ElMyrAFHItdwOnD+nW2PEdINe43LJILMPYGAPp8eFBDBUZPjXhFJbD49VWh4
	 k0GcsiOQCQvlvoJsiUT0lgyD7y6A5gmXnYB+QKZps3jTE7QvKLpKjzg8tASXaB0n3TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Omv0hDa3;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57F2606A323
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B57F2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Omv0hDa3
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4bb6bbc025aso10959375e9.3
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839246; x=1795444046; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cV64o3SIMgxbdBJ/g1LGVun+1S1o6sl5wdO0gO6pEOs=;
        b=Omv0hDa3LH30q+v+dYEDR041VeugBEVh2cqQQbP66pxktYk76W/cb9e32QSvDigGZ7
         XZTRhyB1yoworjue/lsuSJCtNXXi89pH2AbTYNoU7DJcu9AtHhSVd/uHnNpKMJORgfHx
         Kz8Y0OljseT0AXos3/NHUu0yxXqOxQH1VPGVKTDfcNBh/IS5cHVha0kQEeWoDIjDNgfR
         1bvGM2iNQVUTeQRLMJOdQpUNIZyse/rjb+/AD25bAKO3GsNboE/Yhzm87SzXuC1UqZ/N
         EcjoxZ05Xgk0828XUHdY4Q4LHgu9Yp9Uwb1fuwOufHru/f9V5ys5xe+9vpuB0LmOyStu
         y30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839246; x=1795444046;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cV64o3SIMgxbdBJ/g1LGVun+1S1o6sl5wdO0gO6pEOs=;
        b=XQHFeYTO72bgiMgYFVs5PY/qs2BaufzzIrFHLi6hcQX6xKTYE/kF2wTQpJDWDcZtRF
         8zMr+ypO3dwb6mwE3V1H3xdRd/wQ1i5IE6t0axJVURkRdVJihH6uA47TJ/ptEuRoELwu
         mu9NRKE2lSxYPMihDgp89uKrQPkbygZMVMdzUX4XbVwjg/QY3ISuRq3sNEY7BqRvF0gy
         a5TQ+RzJ9afSpTZtASKMaRC7LKgxNjadqlsewEl+yTPwxFzbGl5Ud7WoGzB2rs4EDcbj
         7NL/mk9OaHvIF5zxpQzFVpdC2B02YrFlvBdoRBoPIWqQvf3ECHY9qRSZR3mjKNEqbWqt
         +pRw==
X-Gm-Message-State: APuU4Z8wf+3HoqQub48CTkcf3n7Zi8fPzZBJpDhERiAxA8zNo1ynMO/m
	xkDqOn2OFn8xvFlNjcHOpLhsAPY9Dbgo+68XQBsWqETni0oJkxz46ZCfopirwsYFZXD0lVwRkIJ
	ZUwL6GY2+QzEchyKRgVfMayxAa23LbRbZN9oj1xIbR3lowLd8OA8DgWGr+z+D/qxEm1rZBLGYoT
	lWZFlBqFVUAlfcHjaT1YJZlcIdVnr/tA==
X-Received: from wmaz14.prod.google.com ([2002:a05:600c:6d8e:b0:4a2:1459:4ee8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d91:b0:4bb:6861:657d
 with SMTP id 5b1f17b1804b1-4bb686166e8mr129134925e9.21.1794839245593; Mon, 16
 Nov 2026 06:27:25 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:30 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3987; i=ardb@kernel.org;
 h=from:subject; bh=1pJ9yJPUym3K5Fr1m3ICy12CXT7e7//ufFV5i6KSJ2A=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30Cwpb4e+Lf8evjZ7eOlnnp2IcFf6/W3Hd5+4l/F6y
 4aQnccmdZSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJnDBkZLhnZrt++mGzFxlG
 gs4HJd4s9ivede5g+IVn8TfkjXinfbNk+O96vXDW6o77TO98ur/w36+Zc/bk1Kubmw4+s+dROh6 ysoEJAA==
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-28-ardb+git@google.com>
Subject: [PATCH v3 11/15] efi/libstub: Make efi_remap_image() return efi_status_t
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_remap_image() uses the EFI Memory Attributes Protocol to remap code
and data regions with the appropriate permissions. This could fail for a
variety of regions, all of which are currently ignored.

So relay the failure status code if any occur when invoking the
protocol. Locating the protocol itself is allowed to fail, as remapping
the image is likely unnecessary in the first place if the protocol does
not exist.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 15 ++++++++++-----
 drivers/firmware/efi/libstub/efistub.h         |  4 ++--
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 8e43eb3f418b..e50deec99686 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -697,9 +697,11 @@ efi_status_t efi_wait_for_key(unsigned long usec, efi_input_key_t *key)
  * region of the loaded image read-only/executable, and the remainder
  * read-write/non-executable. The code region is assumed to start at the base
  * of the image, and will therefore cover the PE/COFF header as well.
+ *
+ * Return: EFI_SUCCESS on success, other EFI status codes on failure.
  */
-void efi_remap_image(unsigned long image_base, unsigned alloc_size,
-		     unsigned long code_size)
+efi_status_t efi_remap_image(unsigned long image_base, unsigned alloc_size,
+			     unsigned long code_size)
 {
 	static efi_guid_t guid = EFI_MEMORY_ATTRIBUTE_PROTOCOL_GUID;
 	efi_memory_attribute_protocol_t *memattr;
@@ -710,10 +712,12 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 	 * If the firmware implements the EFI_MEMORY_ATTRIBUTE_PROTOCOL, let's
 	 * invoke it to remap the text/rodata region of the decompressed image
 	 * as read-only and the data/bss region as non-executable.
+	 * Don't bother if the protocol does not exist: it means all memory is
+	 * read-write-exec anyway.
 	 */
 	status = efi_bs_call(locate_protocol, &guid, NULL, (void **)&memattr);
 	if (status != EFI_SUCCESS)
-		return;
+		return EFI_SUCCESS;
 
 	// Get the current attributes for the entire region
 	status = memattr->get_memory_attributes(memattr, image_base,
@@ -721,7 +725,7 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 	if (status != EFI_SUCCESS) {
 		efi_warn("Failed to retrieve memory attributes for image region: 0x%lx\n",
 			 status);
-		return;
+		return status;
 	}
 
 	// Mark the code region as read-only
@@ -729,7 +733,7 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 						EFI_MEMORY_RO);
 	if (status != EFI_SUCCESS) {
 		efi_warn("Failed to remap code region read-only\n");
-		return;
+		return status;
 	}
 
 	// If the entire region was already mapped as non-exec, clear the
@@ -749,4 +753,5 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 		if (status != EFI_SUCCESS)
 			efi_warn("Failed to remap data region non-executable\n");
 	}
+	return status;
 }
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index b985ababbe66..634e52aa6dcc 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1293,8 +1293,8 @@ struct efi_smbios_type4_record {
 const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
 				  const u8 *offset);
 
-void efi_remap_image(unsigned long image_base, unsigned alloc_size,
-		     unsigned long code_size);
+efi_status_t efi_remap_image(unsigned long image_base, unsigned alloc_size,
+			     unsigned long code_size);
 efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 				       unsigned long *reserve_addr,
 				       unsigned long *reserve_size,
-- 
2.56.0.611.g1030f0b940-goog

