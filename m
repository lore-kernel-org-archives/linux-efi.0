Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974796;
	b=oMN1pNWQARYQAtYfymfJ4tewZBQtQPVZ2sYhZqtuic2nSotA4eSuubySubGuUGrrK62S
	 4PxNyBm7BNu+n/NqmVC1oVf7DxD8dWtUt5pxFU5Ylj9K5AyArKNdAJFLr5LLhCvIS+ikE
	 Jf/dqcpsXOmpzF2NzXYnD7vuuk/ztiysMBPydofui9vw9U/QSrBxFmUkvMdUieWV6SsZH
	 sl6dyHCYayjdWn6Ab93U8nIMBucFY0yStwYGeME/fgkhssyG9KYUBbW8ucxJVEmK7Y/OG
	 W2PHMU8HjxIDrgBI/RZGll/PHxB1fJcLvxu7hQ40AiUCIfsm0WSxVcLHsLH+uc8Ii2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=4m1A02l9fBqeaT4qBdXhPAjM2BemeLPvn8bESL+dSEk=;
	b=blkvFOn3AmHhZuCPmosedn796Qhu1vkJQao34AgJLs1BLlyn4RHkBrzHXwthU9BEZy50
	 Kq+W1ui3pZM0fiSq0YJLBtBdWHanvG6Fo7jbY/oD/K7HI0eO4FoOR3F0pcTkI5FSmgr/g
	 45z04S0OiUcMu0xgZQnQEAlACq675/H74EIVqQCT2f0lmx8PqDbb27ZXBK5pQ/hR2fZb3
	 n3bzMMdXzaP3/IMvTay1j5VUjHlKkx2+5c14TYSEcDoGn8S8OrKP4EJdMY7EoUyy/NB8R
	 wVj4fLXqejvL3MQrq+Rs9Z9ruyZlkXaNTptIWfSXp69KzKb6YrekpUGkUJ61Hod6P7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e7wYOP06;
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B74606A332
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47B74606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e7wYOP06
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e0461e040so654511f8f.0
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793974795; x=1794579595; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4m1A02l9fBqeaT4qBdXhPAjM2BemeLPvn8bESL+dSEk=;
        b=e7wYOP06e+gPXQRtNV4zUFpOtTNR80vJeONwmDCXRmFSUkeqPCoRkF/1Mj9WR6f3GT
         1hLIeg/ZYEKdeNV72TOcTK33Ktv2Ts6Rkp3hkDwzZXUed6fcbgiCGGvFhvRo+qCpWC/+
         hzNLBNjKXYp+xLJ6uhBybNe8yXnVCPcCW8Q/6UhAMcIw2cxkL06kTbjRGRMupe4IOWsh
         hBH7XaKWTs5vMRKqJJY1XeMAcxhV8Vf2p67frIK+Kofb7DT84sT7TsGPdtb9WugUAyyb
         2h1CJDHOOKT/jXvweiyLFZQ+Vlm8+N2rS/ivixl4rzLfz8MBKabe1ZQS+YtIVvt96uPo
         blfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793974795; x=1794579595;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4m1A02l9fBqeaT4qBdXhPAjM2BemeLPvn8bESL+dSEk=;
        b=F1HYA/fxOmijW7O/fHZ6QaKSJCTpWPJxZifTZLBKS2ltsQglHTQS9YiPg4/N4RWBdG
         1VbFwfyl3Ka5JFob2wXYL/aBr2CFX4B5TmKGrj4pL6pULzY2zgzCRjy3TbrWusxFTwpl
         j8gHq03b4BB1a+eJ+R4ujPgB5FbZJDaoO1jqsvFXGnO/hU2QJOEVbZCveIGTB75AqjQl
         mZPGvn0rymabhYNG07a89F7+FYVm3xMhfvFuHqzDu+um9JkYMJM0kanFkkJffjxshZAR
         1L53Lvha/50DjTy/s5SLIOcWk6Aaz3YNauknx5XEOL32te4Kv70NVGg40Q1l6+rf3RuM
         5+Lw==
X-Gm-Message-State: APuU4Z8cU47RPCb8biDsf4J1G1Ej4mMjPbUl4DeUK1+8uJTQV/kDbnSo
	kAlbsItalEE4g0CYpvWV03+zbR1RGpLWJRSJvtKgGU1UmVVMcN8CT6xVx0Ia7W0srtMa4u9Nbsn
	gR8rHMvTxlXg/wfQKq82FUBkTwgqyeCOA9hEImFfOHFFT8+YCp46QhjpIf77ZRH2DqD7Miv4EM6
	oLkSdXkaYfs7nenMof+6rV2aGpldCMVw==
X-Received: from wruw16.prod.google.com ([2002:a5d:6810:0:b0:48d:ee5b:2791])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:603:b0:490:9fe2:6a37
 with SMTP id ffacd0b85a97d-49275373b29mr5936762f8f.17.1793974794467; Fri, 06
 Nov 2026 06:19:54 -0800 (PST)
Date: Fri,  6 Nov 2026 15:19:41 +0100
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
Message-ID: <20261106141936.2744481-11-ardb+git@google.com>
Subject: [PATCH 4/5] efi/arm64: Expose struct efi_image_info via the image header
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The zboot compressed kernel and the uncompressed Image both contain a
copy of the EFI stub, and both are tightly coupled to the kernel image.

However, the zboot stub is not linked into vmlinux like the ordinary EFI
stub is, and so it does not have direct access to its symbols. This is
needed today for things like image size and code size, but there are
more cases coming (DRTM) where both stubs need to have a consistent view
of these things.

So add a struct efi_image_info that is built into vmlinux and exposed
via the image header, so that zboot can access it easily.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/arch/arm64/booting.rst      |  3 ++-
 arch/arm64/include/asm/efi.h              |  3 +++
 arch/arm64/include/asm/image.h            |  4 +++-
 arch/arm64/kernel/efi-header.S            |  6 ++++++
 arch/arm64/kernel/head.S                  |  3 ++-
 drivers/firmware/efi/libstub/arm64-stub.c | 14 ++++++++++++++
 drivers/firmware/efi/libstub/arm64.c      |  7 +++++++
 7 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index dae5ff9fae26..2389558bd389 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -84,7 +84,8 @@ The decompressed kernel image contains a 64-byte header as follows::
   u64 flags;			/* kernel flags, little endian */
   u64 res2	= 0;		/* reserved */
   u64 res3	= 0;		/* reserved */
-  u64 res4	= 0;		/* reserved */
+  u32 res4	= 0;		/* reserved */
+  u32 efi_image_info_offset;	/* Offset to struct efi_image_info */
   u32 magic	= 0x644d5241;	/* Magic number, little endian, "ARM\x64" */
   u32 res5;			/* reserved (used for PE COFF offset) */
 
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index da6afd4a7a27..b0c9120b9741 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -154,4 +154,7 @@ void efi_icache_sync(unsigned long start, unsigned long end);
 // temporary resolution for efistub_get_code_size()
 #define efistub_get_code_size(image_info) ({ extern u32 code_size; code_size; })
 
+struct efi_image_info {
+};
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index 9ba85173f857..10b35521cf28 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -36,6 +36,7 @@
  * @image_size:		Effective Image size
  * @flags:		kernel flags
  * @reserved:		reserved
+ * @efi_image_offset:	Offset to struct efi_image_info
  * @magic:		Magic number
  * @reserved5:		reserved, or
  *   @pe_header:	  alternatively used for PE COFF offset
@@ -49,7 +50,8 @@ struct arm64_image_header {
 	__le64 flags;
 	__le64 res2;
 	__le64 res3;
-	__le64 res4;
+	__le32 res4;
+	__le32 efi_image_info_offset;
 	__le32 magic;
 	__le32 res5;
 };
diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 329e8df9215f..62061cb0bf21 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -7,6 +7,12 @@
 #include <linux/pe.h>
 #include <linux/sizes.h>
 
+#ifdef CONFIG_EFI
+#define EFI_IMAGE_INFO_OFFSET  __efistub_efi_image_info - .L_head
+#else
+#define EFI_IMAGE_INFO_OFFSET	0
+#endif
+
 	.macro	efi_signature_nop
 #ifdef CONFIG_EFI
 .L_head:
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d6ba3c0af811..f1827e32b0e5 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -65,7 +65,8 @@
 	le64sym	_kernel_flags_le		// Informative flags, little-endian
 	.quad	0				// reserved
 	.quad	0				// reserved
-	.quad	0				// reserved
+       .long   0                               // reserved
+       .long   EFI_IMAGE_INFO_OFFSET           // Offset to struct efi_image_info
 	.ascii	ARM64_IMAGE_MAGIC		// Magic number
 	.long	.Lpe_header_offset		// Offset to the PE header.
 
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2c3869356147..8daed681f97d 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -61,3 +61,17 @@ void efi_icache_sync(unsigned long start, unsigned long end)
 {
 	caches_clean_inval_pou(start, end);
 }
+
+extern const struct efi_image_info efi_image_info;
+
+asm("	.section \".rodata\", \"a\", %progbits;			" \
+    "	.align	3;						" \
+    "	.globl	efi_image_info;					" \
+    "efi_image_info:						" \
+    "	.previous						");
+
+
+const struct efi_image_info *efistub_get_image_info(void)
+{
+	return &efi_image_info;
+}
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index 7ab634e37cf1..190cf180bb23 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -135,3 +135,10 @@ void __noreturn efi_enter_kernel(unsigned long entrypoint,
 	enter_kernel = (void *)entrypoint + primary_entry_offset();
 	enter_kernel(fdt_addr, 0, 0, 0);
 }
+
+const struct efi_image_info *zboot_get_image_info(unsigned long image_base)
+{
+	auto header = (const struct arm64_image_header *)image_base;
+
+	return (void *)image_base + header->efi_image_info_offset;
+}
-- 
2.56.0.455.g6c5a503b38-goog

