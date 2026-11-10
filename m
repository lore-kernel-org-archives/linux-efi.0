Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313066;
	b=u/WSHAtOQgySi60T2AgE4xAQ5qr/ht+oj7EGbNl50ZIjKfcADHjGykr+pCSsQPHQawcw
	 V0SmkWks0DtJcsemn8Ubbbl68h1sY/x723ffjlwQfRV9MvT60x5NcvUYOsWYcWgCfEWoQ
	 YICa9wVcCNANm9eiaZ3ydGACNfgfKaf4nBcYNhTyL4FoHUbrayiPOxjbm2wfVOZgcEcfl
	 VPnDKobof+yQCqR3o/07Hc2ec0+jeD0FWMG2yYf0SklyPdRhckGV4frOLmZcCY89zQtAA
	 QE9uAb6cRVmAwvjiDj8sDuYuUF9TcFoNYGPXHeXDvPfRvQ5jlcMsKo3bq27gNH9D3eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=PPBeufobmuc6RIQJ83QzjXbUu8OMDbjvKvPLOTqlXsk=;
	b=ThcHwdc04J2Rq2bUfosgPwO/otzvdgBTIepvHMB9btFy714JL0cwwj1FIk5RalWKANsD
	 cYbOsXsz3y7uZB2DXyxuVLeLu4cC0OwzmQt3HnoqRLQC+26axi3wrY2K3hCLjf2kJb4iC
	 L6uIKHZpBI1Z2hjTQDbYUztbTkG/NkIfQaXMuZBH2cQKv6y5ncfqtnCxeDIys4m8BD78F
	 aoBx6WTCYO4BiLmARB000YAP1yVpeFisZhYpu+58aC+u/bGiA2Yi78ctANAv2fwnwBzlo
	 kYdcOzQ9/z/6XT44EpGlg49DfW6VX+od8YLDv+7Cy2I+dDEy2+gXom3vweIOzs8zPtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DTGqZnYx;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A183606A321
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A183606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DTGqZnYx
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-490ab0a20ebso1546141f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 04:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794313064; x=1794917864; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PPBeufobmuc6RIQJ83QzjXbUu8OMDbjvKvPLOTqlXsk=;
        b=DTGqZnYxVvecrpTIZNY3G5dzdrjeZZnt/2qokLY1DjjUWAopIuLbl2I11edlo1Fn8Y
         KjQbT7BhPSlPixRjk3y4Dm+04V4920nMGUTjnON6M4A1+S2k1AtUNHcBN6UljuF+qFjq
         3HEqdBPQw9eh+Gm8HxSBTRpmEGsXwJOtWX5rcSSZUodQl8LnroXpF1c70HVZDXxDWpl/
         OjOKv4rqo6P9FCIH6WBkX8FdOwsoFYVHmFBf9FzhCGD38bVpnFW4aw/8rvueGpDWr6sc
         GVTEYfwpjPF1Kc9y82tkzIg2dnIokdxHV/l9sTb4jpQZyszwF1kbq8yqzEtY9BpLOtsv
         ZrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313064; x=1794917864;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PPBeufobmuc6RIQJ83QzjXbUu8OMDbjvKvPLOTqlXsk=;
        b=0PjWhgeMCPRmWx8CIctW84L2uZxjD2kK6sk0K+9kMjZOnciyu+ZkIJEwWWC3UC567C
         HDQTmkoikSTSsqTamGDloDC/mHsMshahMKPsNOjBHVqmt92xYEUPwWNHHXd49AhzdqcT
         mxILaQCN/YgSEbeNb05ZENca5g/lZkmd7QJ/9kf4y9OELuBM2+AJG9Lo+oxcuG0Lzd98
         y8A7aNLQ/fLVzWKKpWW8vLhepO+GEgN+zdhf270zbOTGtaDEPMcRq8wqJXQz6W0gpGgd
         rhUUCdWqSWdKMgEL67x4++kK8Ld/GB++7nfYQ6Y7vKCKJionuqTX6S8S86pQiHJWmNpK
         4Y4w==
X-Gm-Message-State: APuU4Z/6r9/7fn3M4zifyzMHUwtXFDS7ictvE5aV1/+bcQm3sVVxgZhG
	lk3CCOeOZz0vKFBo1z7hh1acWpM6NIa/ERwQfEOI628NJi66j/sRoZchQi+rMYxWinrQlTDjf8R
	w1sisImrJFORs/PCziaIu2QQffvsq8FfREmjnfRCkjNe3J8RdnRtf1OCDweAMXkQrys6v942Wii
	hUInaJE3HcEoT69ijRpq+dl29oUFCUqQ==
X-Received: from wrsh7.prod.google.com ([2002:adf:fd47:0:b0:493:19d2:af6a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:993:b0:491:4e13:fde3
 with SMTP id ffacd0b85a97d-4982e7379d4mr4015466f8f.13.1794313063487; Tue, 10
 Nov 2026 04:17:43 -0800 (PST)
Date: Tue, 10 Nov 2026 13:17:36 +0100
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
Message-ID: <20261110121731.2728824-16-ardb+git@google.com>
Subject: [PATCH v2 04/10] efi/libstub: Capture loaded image information in
 struct efi_image_info
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Define a struct efi_image_info that carries properties of the loaded
kernel image, and pass a pointer to it to efi_stub_common() so that EFI
stub code can access there properties in a consistent manner for both
the uncompressed kernel and the EFI zboot image.

Note that zboot can only access this information after decompressing the
image, whereas code that is part of the EFI stub that gets integrated
into Linux can just grab the efi_image_info pointer as needed.

ARM implements neither, but -like x86- incorporates the EFI stub into
its own decompressor. It has no need for this functionality, so emit a
dummy struct to satisfy the linker.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi-header.S                |  2 +
 arch/loongarch/kernel/head.S                  |  1 +
 arch/riscv/kernel/head.S                      |  1 +
 drivers/firmware/efi/libstub/Makefile         |  1 +
 drivers/firmware/efi/libstub/Makefile.zboot   | 11 ++++-
 drivers/firmware/efi/libstub/arm32-stub.c     |  3 ++
 drivers/firmware/efi/libstub/efi-stub-entry.c | 10 ++++-
 drivers/firmware/efi/libstub/efi-stub.c       |  3 +-
 drivers/firmware/efi/libstub/efistub.h        | 44 +++++++++++++++++++-
 drivers/firmware/efi/libstub/image_info.S     | 12 ++++++
 drivers/firmware/efi/libstub/zboot.c          | 17 +++++++-
 drivers/firmware/efi/libstub/zboot.lds        |  2 +
 12 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 329e8df9215f..54ca61d03403 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -7,6 +7,8 @@
 #include <linux/pe.h>
 #include <linux/sizes.h>
 
+SYM_FUNC_ALIAS(efi_primary_entry, primary_entry)
+
 	.macro	efi_signature_nop
 #ifdef CONFIG_EFI
 .L_head:
diff --git a/arch/loongarch/kernel/head.S b/arch/loongarch/kernel/head.S
index 601ddd78b233..69c31b0b65c5 100644
--- a/arch/loongarch/kernel/head.S
+++ b/arch/loongarch/kernel/head.S
@@ -35,6 +35,7 @@ pe_header:
 SYM_DATA(kernel_asize, .long _kernel_asize);
 SYM_DATA(kernel_fsize, .long _kernel_fsize);
 
+SYM_FUNC_ALIAS(efi_primary_entry, kernel_entry)
 #endif
 
 	__REF
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 1631fd6bc786..6c81f32be70b 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -28,6 +28,7 @@ SYM_CODE_START(_start)
 	 * that expects this header format!!
 	 */
 #ifdef CONFIG_EFI
+SYM_FUNC_ALIAS(efi_primary_entry, _start_kernel)
 	/*
 	 * This instruction decodes to "MZ" ASCII required by UEFI.
 	 */
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index bbab12b8eb4b..9dc6a707fd79 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -107,6 +107,7 @@ lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
 
 targets				:= $(lib-y)
 lib-y				:= $(patsubst %.o,%.stub.o,$(lib-y))
+lib-$(CONFIG_EFI_GENERIC_STUB)	+= image_info.o
 
 # Even when -mbranch-protection=none is set, Clang will generate a
 # .note.gnu.property for code-less object files (like lib/ctype.c),
diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 52baacf3e9d9..e2769bbec963 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -26,9 +26,18 @@ zboot-size-len-$(CONFIG_KERNEL_ZSTD)	:= 4
 $(obj)/vmlinuz: $(obj)/vmlinux.bin FORCE
 	+$(call if_changed,$(zboot-method-y))
 
+# subtract the two symbol values to obtain the offset of struct efi_image_info
+get_image_info_offset = $(shell $(NM) -n $(objtree)/vmlinux |\
+			grep -E ' _text$$| __efistub_efistub_image_info$$' |\
+			awk 'NR == 1 { a = toupper($$1) } \
+			     NR == 2 { print "obase=16; ibase=16; " toupper($$1) "-" a }' |\
+			bc)
+
 # avoid eager evaluation to prevent references to non-existent build artifacts
 OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) $(EFI_ZBOOT_OBJCOPY_FLAGS) \
-			  --rename-section .data=.gzdata,load,alloc,readonly,contents
+			 --rename-section .data=.gzdata,load,alloc,readonly,contents \
+			 --add-symbol efistub_image_info_offset=0x$(get_image_info_offset)
+
 $(obj)/vmlinuz.o: $(obj)/vmlinuz FORCE
 	$(call if_changed,objcopy)
 
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 1073dd947516..53ade94f4bdb 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -132,3 +132,6 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 
 	return EFI_SUCCESS;
 }
+
+/* expose a dummy struct - ARM does not use this anyway */
+struct efi_image_info efistub_image_info = {};
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index efa3ab8ad1c6..c173c0dd8454 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -27,6 +27,13 @@ struct sysfb_display_info *alloc_primary_display(void)
 	return NULL;
 }
 
+const struct efi_image_info *efistub_get_image_info(void)
+{
+	extern const struct efi_image_info efistub_image_info;
+
+	return &efistub_image_info;
+}
+
 /*
  * EFI entry point for the generic EFI stub used by ARM, arm64, RISC-V and
  * LoongArch. This is the entrypoint that is described in the PE/COFF header
@@ -80,7 +87,8 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 
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
index f5eec8c12894..394796472cc0 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1148,11 +1148,53 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle);
 
+struct efi_image_info {
+	s32	_text_offset;
+	s32	__inittext_end_offset;
+	s32	_edata_offset;
+	s32	_end_offset;
+	s32	entry_offset;
+};
+
+const struct efi_image_info *efistub_get_image_info(void);
+const struct efi_image_info *zboot_get_image_info(unsigned long image_base);
+
+static inline
+unsigned long efistub_kernel_base(const struct efi_image_info *image_info)
+{
+	return (unsigned long)offset_to_ptr(&image_info->_text_offset);
+}
+
+static inline
+unsigned long efistub_kernel_size(const struct efi_image_info *image_info)
+{
+	return image_info->_edata_offset - image_info->_text_offset;
+}
+
+static inline
+unsigned long efistub_kernel_memsize(const struct efi_image_info *image_info)
+{
+	return image_info->_end_offset - image_info->_text_offset;
+}
+
+static inline
+unsigned long efistub_kernel_codesize(const struct efi_image_info *image_info)
+{
+	return image_info->__inittext_end_offset - image_info->_text_offset;
+}
+
+static inline
+unsigned long efistub_kernel_entry_offset(const struct efi_image_info *image_info)
+{
+	return image_info->entry_offset - image_info->_text_offset;
+}
+
 /* shared entrypoint between the normal stub and the zboot stub */
 efi_status_t efi_stub_common(efi_handle_t handle,
 			     efi_loaded_image_t *image,
 			     unsigned long image_addr,
-			     char *cmdline_ptr);
+			     char *cmdline_ptr,
+			     const struct efi_image_info *image_info);
 
 efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/image_info.S b/drivers/firmware/efi/libstub/image_info.S
new file mode 100644
index 000000000000..3d3dded0f451
--- /dev/null
+++ b/drivers/firmware/efi/libstub/image_info.S
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#define REL_REF(sym)	.long	sym - 0b
+
+	.globl		__efistub_efistub_image_info
+	.p2align	3
+__efistub_efistub_image_info:
+0:	REL_REF(_text)
+	REL_REF(__inittext_end)
+	REL_REF(_edata)
+	REL_REF(_end)
+	REL_REF(efi_primary_entry)
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4a5ffe164873..c6071b0e8f1a 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -31,6 +31,13 @@ struct sysfb_display_info *alloc_primary_display(void)
 	return __alloc_primary_display();
 }
 
+const struct efi_image_info *zboot_get_image_info(unsigned long image_base)
+{
+	extern const u32 efistub_image_info_offset;
+
+	return (void *)image_base + efistub_image_info_offset;
+}
+
 asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
@@ -93,9 +100,15 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
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
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index 367907eb7d86..e1365907f805 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -24,6 +24,8 @@ SECTIONS
 		. = ALIGN(4);
 		__efistub_code_size = .;
 		LONG(zboot_code_size);
+		__efistub_efistub_image_info_offset = .;
+		LONG(efistub_image_info_offset);
 
 		_etext = ALIGN(4096);
 		. = _etext;
-- 
2.56.0.542.g3ef89b7020-goog

