Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313071;
	b=A9jHDhC+aX1LBuP40qGpJjOnCvzJ+GNicuHtl1y4sHDqeHo+zUZegtEk0MKJEewhjPmZ
	 f7t1fWLEyOVqKsF/xHfjTGaOc+2u0OeVPj20WBM7ExODf4o7Dx8zAGTNk60sGRrxDyIBw
	 AQ2dZq+GbwNqaQBfajGYgrWfHZHIejO1fX151duJv9HdzJjxa031khxiKGPsx0kBHIKH9
	 aAtjaVfLIxdvHEyWUehTMbFRYht9gE/zEvTPXAe4lMQST/51NBd2iCcqFvTHm+6e5lL+T
	 1nVT4KCKXL2eac2sLWXyJVHF+wOmbyVHfMmKcQmw4HGNkwoNui0m+m9FKr1rqsj8g0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313071;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=XeENm8YGI/YCcxTaf8fM3RRrPARxs0Acfc/5LAWqFwc=;
	b=HOK5DpJ1GR6C5N+VldoSUNnZRzc9FVT4SES53lNWl7gye4BR2cHg2FWJM4PFhD7sd8Nq
	 5AEgcz+bl+mHp1TbfqjZaUptpir6W9vASXrZ25JhJ5zFg0qdXWj0Zs0uUnWcIKGU3chci
	 bZoGTlxLJsjIYLqT604yRlJNdK2hR94NOBjRtNOJhwNYyX9D7F0GNGTPP+8Lf3j7+Uwu9
	 eTSKAmCYxmiPTZVBFEA5c88AN+aqmHE0+yUvDyTUCDfAXrF4d8dpn7YLmEWKPBiooySDB
	 JZzE4vVtcQr3uD+E8g7wqnKbtPau9aCKklVlKQqufXmnVm8P2Yu1TY7h4PJxqeuGsBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CJdXwGOK;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665B606A321
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C665B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CJdXwGOK
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a214a5f8a1so19812675e9.0
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313069; x=1794917869; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XeENm8YGI/YCcxTaf8fM3RRrPARxs0Acfc/5LAWqFwc=;
        b=CJdXwGOKqUeVIsELzV1pwsOH3PdFfmyd0U/1G8HPVUOXgux97pVlE0X0oD2FqK+VfM
         whIQg/xZL3HpEOrX4Du64QTiux+Pfc9Uat1w4Yuiqp4xxmHTUUS89bsIWcTPFyBFzWhs
         i7RXCoxxCO7lasugVEhZwPkYRcFK+GGKoQ2t7284M+1KWyrlrQDPpnKQMTvu7E7+Thk9
         jQgp2N9rak6lnRHmOmxSaTO5NFk3Aogvq2p/ZhKdJ59ZKgBA9MBeOAPdyNqLSdzi7bYW
         AHTivMdySVp4wm7UDBuH4DLk+E5W3MEq/iB4YegJc2G7aWh5KaVcMquSVgFdTQTUTvNZ
         CzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313069; x=1794917869;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XeENm8YGI/YCcxTaf8fM3RRrPARxs0Acfc/5LAWqFwc=;
        b=dZ1gmHwzOKOsVwLXPzDshexcf1UdvHKjRjjH1XPPs9PGDct7Z5YntFIG9ma76tXrvZ
         YsIlb0jenooHPL5fgpWK9QnZJVSyi/uiyD06JB+1huoB+YtbOCi96q2v73H+xPjaqiZj
         Taq4d5lVVyfksYUenRfSS7Hd1xzHyBB28PY1L+nhA3hgGzL8TujO1d+vkZ2fbcYfO3ba
         Nev1+/Uy+lQ8rrLn+kJctWFmHoejw3Y630uwsLQ05LKyNS1arVc1hM0T9PxleJk8E/F1
         DuL5usob57T2uCGdFHycHqaP9IuPsm57Ty1UuPs38OEIn0x+BTwaOnzT4ykAvXBaCFQ+
         EZuQ==
X-Gm-Message-State: APuU4Z8qir3X9AZ3VXlwdu4wVh+pwu+zxfCgpOHdF2QXdRJVMsHJCpay
	2oqYGE0X8Pcumc/VNwChyX0WGd4cvsgkUeYr6ylIKPkQtxipVLpyIpppPf0+NUnA5r22wd7IbaL
	kEYgDP6vikz+a/kJ1cQBB6VBUivtVQd6Flr+8MIUGaXoPOADzLJHOJ8UOKh7tWZ2L+8PrO2cn4f
	Jbz9GDal3OhpSQEC7xHnt5ohb2ZWV2PQ==
X-Received: from wmpj1.prod.google.com ([2002:a05:600c:4881:b0:4ae:2747:b6c5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b33:b0:4a4:4d57:8487
 with SMTP id 5b1f17b1804b1-4ba0233684bmr40944525e9.5.1794313068535; Tue, 10
 Nov 2026 04:17:48 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:40 +0100
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
Message-ID: <20261110121731.2728824-20-ardb+git@google.com>
Subject: [PATCH v2 08/10] efi/libstub: Make efi_remap_image() return efi_status_t
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
index 394796472cc0..e2a9339f3e2c 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1283,8 +1283,8 @@ struct efi_smbios_type4_record {
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
2.56.0.542.g3ef89b7020-goog

