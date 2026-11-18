Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026135;
	b=GRskwTILhLu5WzMNWwz7bLLXR3OZGeVn22W07AUw/qjGjE5uuBQuajoX7SdUHpMJgQYM
	 3eH5rDWZmZaXXmbQRNZMPCPGAdcV0RdGU3cRuTPfHaWTUpV4nDswsT8ILlU5ugO/5sMAe
	 FBDYgrAp4jPfGUiWj2LDTSMNGlGHcTsGMqzQZhQ46CrBiR7h7K1eSRY1oMut4RMNCQo+r
	 UPQiAQr5kIzBmwtCLyq5x3hZbhAC9+piezNTgWdARcvU96ZDNBBWjDc+GYqDXA4O3SRIc
	 YXqpqW14SM53IXvyy3aa68s6QxZKZxXLJ7qDZhpPHliid+xgZv8f09lHpYPylEeqDzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026135;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=6V1QA3P52x46nv3P41ByzMEuwbndT8/SrZmGlBnbrBs=;
	b=zG5e2n5TvhlbE8DDSENFIiBUTdskjpn0Vg+lVFHOBmFUhOPrjonVdk+kV4sSNurveUU6
	 lRmYzndZ3iLoRxOeVimZ9193xV6N6PacWTwGxiKx8kCcXgZ9m94aQRDVILqMyOvOVj5Nm
	 AdTZakCCiGUDyuXUW2CS9mSyEzUZ0CQSuhZnrXebFWuOPcX2F1PmmM4qembiOAsXnp9lI
	 3nIuCwsAWVFo0gAreEUFQ0heXE/Klptyj4S7Vll7a6lTFqbhAEjuQqKHsX2QNKaCvM3XS
	 /pLlZ9nzaW0iJgDdeHZDKsklwjGb8RzLJF2qiEm/HTfKSc5e+1xnIuZ6KkB2HwDwQZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WW47wHrn;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5EB606A320
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF5EB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WW47wHrn
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b57668479aso1520165a12.0
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026133; x=1795630933; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6V1QA3P52x46nv3P41ByzMEuwbndT8/SrZmGlBnbrBs=;
        b=WW47wHrnFr5cNTbAegy4jMjosMen9zwIZEpMo1hJv0cMusJi6GryZGYjE2KTNlsIUx
         /xvFx1gB2uMq90f1KfXqixYNobDiAQrdB7D0RtPqNstvVVdTFm/w1g68lU9Aw2aI1a8f
         DaMNvkDTG9t3F0aLIC6gkaJa/yu1o9l3bZPovG8Bjop9IQgNRZe/nbTewGKjmV4zIKt7
         wTWE9c+3QdXhxYoMlnuExxvA7oBQRuTWNX9Q4WivOIm7eHrt2XKrXZy9AsnD2Z3aT0Xp
         6teuuU76gg0urlpzsmuZkaVxuSeMTqC1irN6KKXeUO+2hMaPxiRbE+LOZEnLrmZFYhGF
         QqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026133; x=1795630933;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6V1QA3P52x46nv3P41ByzMEuwbndT8/SrZmGlBnbrBs=;
        b=2rxbOphH0/EEGaU+sygih7UrO50Wp3fVMm9bBqK7KwSMrxYiIXEpgZpJPx8Hme4Flt
         rguPU1bVrhAlbGzC0O5+ScThm1BkRKGvmGOFhP4njd7zuq/Tlv2Fqf0jfOqIsuLw7n2w
         nR/Gg9CZFVZDGbHlN2an9K50eIhnq8R+oQtRZ1URcluNjgIWI41ctitB2AalTi+42hQi
         VmW9oQQQMeQCN9UrdNJ7qV1LkfLukivYPPEAgYVA8TlUddd1Dn1FGi2nTWCHIDb9mASN
         uw6btWs3GAbqbH2QuDTad+tZs9LxXQrVOzx+BgtfLJa8EztMhgSUzgMYKbLDwsZ3ZfTi
         N8Dw==
X-Gm-Message-State: APuU4Z/nVnpC5XcQnWwQkz82/bLyZFv+YfEeiFGsv4GfJGYAVaCMmFVm
	sIf3MuqbhIqa3VxmhgYdhnWl4nZKTb/3BOhI2Hp9SWMz8PFv7ojFN5aZicX0OvFUS28HpBmS61H
	2xJdpLGaz1OE/cEvGUEYM73hcRYINC7Ft32BceCfPHXPzXObJjfWL89U6vDaZyshoMvKzrh1d2A
	tsT1CpN2uLewWkEEgjWq7V/yBS2b5USg==
X-Received: from edew2-n1.prod.google.com ([2002:a05:6402:a202:10b0:6b5:71b1:5396])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1f14:b0:6b5:8719:6d51
 with SMTP id 4fb4d7f45d1cf-6b887ebcae0mr3272336a12.32.1795026132980; Wed, 18
 Nov 2026 10:22:12 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:21 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3998; i=ardb@kernel.org;
 h=from:subject; bh=ScJHVhvjJW7cZodEmI3s6Cu3UVcx7Ou1mV7bexdNsCg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm+XHVDP+rDqpPevtwVUH9HN5H0z+4TiXyzef2ytjQ
 WGR+pnWjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARgTiG/26JnzVEZXSTBTIv
 WAWbGX+pc2v625DpGBy5NU8yO96ameGfAdeGb2bd6xq27tfckbBu19bz8pZxd/nDMva/DQ7bf/A kPwA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-36-ardb+git@google.com>
Subject: [PATCH v4 15/19] efi/libstub: Make efi_remap_image() return efi_status_t
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
index 4e6af37c4ecb..27b60ad81264 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1291,8 +1291,8 @@ struct efi_smbios_type4_record {
 const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
 				  const u8 *offset);
 
-void efi_remap_image(unsigned long image_base, unsigned alloc_size,
-		     unsigned long code_size);
+efi_status_t efi_remap_image(unsigned long image_base, unsigned alloc_size,
+			     unsigned long code_size);
 efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 				       unsigned long *alloc_size,
 				       const struct efi_image_info **image_info,
-- 
2.56.1.708.g77570a6a1d-goog

