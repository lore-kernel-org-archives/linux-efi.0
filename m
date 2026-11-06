Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974793;
	b=apJsFP4AwSTp/doFVCuRkIjFelH1ES9H40allti4vrKpd3ebb5IzeD4qm1ZiRahVDNkp
	 4tRqXhu1S/iy3c7WUHmAOhbNwJPSZE5LvhycrGO2gRG57Sd/z8TMx4/KMdrDuvfqD2ynh
	 4WG+ogSTMA1Fj4KGfgsQExWuWmj/q9iwdAjaIGDcJ/kj1di2wTks+UPDvRWmPQZoIFt8H
	 vEvAWqoamZV47nORF1++Dm8tJ3cjV3NMUOBQi/QgrATcBpqEYFtA8v5/jP+shkp/JZuFr
	 eBEP5hskGohGWrq22uWtVqcy8ICvypm2U1sEMMg1mSkjAmpOyxJNHKToBuuBa2uwPnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974793;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Pq7HU0c5zDLc3H6/f5sVG7kyw7kaKqt44IjPJ2El8M4=;
	b=gDWh95v8L0WVZ/kHeFj2m7Pr2jJehSk5eaKEZ+cPxlRkj3zpscZoSJnJqpEnOEDPWEYB
	 XvU/N4YQdEFVua2jAs45a8vcrAsUV/+Bl3xyAGhRNfwP3v1xxiNU8CLvM0Zzy59wO3kxU
	 W9LZKbG3KA0l90BEBtxKICEY+xqutXxtAhsQ8/rTJp4u1R9trYfij72Ss+kcrUeM8UpQi
	 HWO2scZzp2ono1eYN4ZoDIknStpESTgfXXoIa/cFVMPeHbytCAPGbc85yMJO0/XA6oFst
	 t5EIRaxyJbPJTAWuaCdeDggM28O/pvHmahHrm0v9WY1CZ9HeAEFVTefPc18guqswiig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gUmSjAHI;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4D9606A334
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C4D9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gUmSjAHI
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e4d1e29f3so701715f8f.3
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793974791; x=1794579591; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pq7HU0c5zDLc3H6/f5sVG7kyw7kaKqt44IjPJ2El8M4=;
        b=gUmSjAHIVkWdLIs7qGeEnjTJLmvSbiX10ynBhTi0Vf21PmfqVyz8j9g9UI5CT461m6
         pVKtHiF9bpEYk/m69lnDwh6BDzY8pJEeOEFuFfq/gFAr4qwG7rQlLRgemZi7gu0GU5bU
         mondTHBvQJVK814ziFHkDhx0HGWIs2zZq8Ili9OudGNKUNUsRx42lN20OGCttmvy41DX
         flAN7h32eANBzXFTKRKuaGIafLZzF0i/E56i2EeW2v0aGffvBlQ7CAlq/P8qwmZbS74a
         ABAvHCxvyJm3TkcvbJZSer4qSau5Yy8DJ7X4wycxhtUc6Rj84ZOgQVU3lEmvZ55p0bs0
         SWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974791; x=1794579591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pq7HU0c5zDLc3H6/f5sVG7kyw7kaKqt44IjPJ2El8M4=;
        b=yz0xJYVcHNHnTVSjMvbKNi8tPhzyaw3jK+iCF+y3Sst9L82+SCZg9devw0dfnXq1qU
         4sgn27jE1O74KXDzpZXYxLIZBmplbMglWC6ZqiF8JSDuhdqoWlsI763tcBbIYudocEeN
         rhGRviL1pNfYH3b5XdkqXRYn3V8v4fkBPrVnsphg9LSkFHByE68/mrtHevUF1J1KPnRG
         t8S+HGEYubyqpDcapyOZFRJvb9SR8nPf91/pAP4hE6pjs7+k4tZ0zurxE+5KC620gtn9
         l0D+LwtFCc+OQbVR6jgg19nfjBowTxAv9R0ncWaTalFZ+q763jpmlvvHgoJqUehF606n
         CejA==
X-Gm-Message-State: APuU4Z/en0YJnGdienCt/12qTFHOiQYo/5UtUeBI/XN3cRqulRyz8tCN
	YLP2N4zQUI0cpm5tcQbQB1a0lImJvLqrrzJlXkzdd4QQumq4wU/qeN268lC4EPU5MGSQBCTGftc
	HFSM1j9EwRdCJvUbI2ATQPv/xpOWzwuMqI8+cQqTrQRB1aO5VZdcXHyHpPPRsr/8befDdot8+V3
	2k6p6BU3gHZZAQDHnU7ttCfj8paW2aEA==
X-Received: from wrcz11.prod.google.com ([2002:a05:6000:454b:b0:48e:514c:983d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2004:b0:48d:ba3b:af36
 with SMTP id ffacd0b85a97d-49277219922mr5315232f8f.37.1793974791162; Fri, 06
 Nov 2026 06:19:51 -0800 (PST)
Date: Fri,  6 Nov 2026 15:19:38 +0100
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
Message-ID: <20261106141936.2744481-8-ardb+git@google.com>
Subject: [PATCH 1/5] efi/libstub: Make efi_remap_image() return efi_status_t
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
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
 drivers/firmware/efi/libstub/efi-stub-helper.c | 13 ++++++++-----
 drivers/firmware/efi/libstub/efistub.h         |  4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 8e43eb3f418b..b2ad081cf324 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -698,8 +698,8 @@ efi_status_t efi_wait_for_key(unsigned long usec, efi_input_key_t *key)
  * read-write/non-executable. The code region is assumed to start at the base
  * of the image, and will therefore cover the PE/COFF header as well.
  */
-void efi_remap_image(unsigned long image_base, unsigned alloc_size,
-		     unsigned long code_size)
+efi_status_t efi_remap_image(unsigned long image_base, unsigned alloc_size,
+			     unsigned long code_size)
 {
 	static efi_guid_t guid = EFI_MEMORY_ATTRIBUTE_PROTOCOL_GUID;
 	efi_memory_attribute_protocol_t *memattr;
@@ -710,10 +710,12 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
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
@@ -721,7 +723,7 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 	if (status != EFI_SUCCESS) {
 		efi_warn("Failed to retrieve memory attributes for image region: 0x%lx\n",
 			 status);
-		return;
+		return status;
 	}
 
 	// Mark the code region as read-only
@@ -729,7 +731,7 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 						EFI_MEMORY_RO);
 	if (status != EFI_SUCCESS) {
 		efi_warn("Failed to remap code region read-only\n");
-		return;
+		return status;
 	}
 
 	// If the entire region was already mapped as non-exec, clear the
@@ -749,4 +751,5 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 		if (status != EFI_SUCCESS)
 			efi_warn("Failed to remap data region non-executable\n");
 	}
+	return status;
 }
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index f5eec8c12894..b09d6c535ab5 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1241,8 +1241,8 @@ struct efi_smbios_type4_record {
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
2.56.0.455.g6c5a503b38-goog

