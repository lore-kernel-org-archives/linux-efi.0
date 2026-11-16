Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839242;
	b=5TQ9yGD1KAOJvaCWyJssOz6pvvi9BsdSBudTQW6KOekzi9OaUNDrTI/Qyw2jG1qsKtwV
	 8qu5fYpo/QtGI1CfK2cd0FgaMGHSjvtYsGB8SSK0EcGefn8RD//wiMiXCjSsqTvOcczQs
	 99ekniXDOLkfW3pyaiKHrtp+nOa8xz9oLxLVSXOkjbvfuD2Sp/9X42U3hqwQwliCQ0ZFW
	 MMayDLESFr9KlkjoquVJpWdhiMypYHZC/EMhTM6iiRjPAkfi+R5S71lvej0FoyiWTKrH5
	 +6ycVc2wvxlsm63oo6QpvStD8vR2FBlnJj2RBxV8TNU1j2gu+VLoYyXK2sCgxRJbqJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=W309uQy0XooJdzMwvz9qNm0IhwUCOZ7RPUmkTdvsJxY=;
	b=mWKMq3OtAOldT2DSDQE96fYPuhH+fBMpkviKrj5YcptTxRT2TCs1Pp8ypdJejWFAdyh0
	 RPHk6o5McEobOkWEfN1cy7TUMydTs1sExYpkYkr5gxx9OKTSjF/vAaOXKRLepKigKPXDu
	 ykKRFcU7N2ppLTMyA/bE8iC/A0BX0hsf6EqWjOxSG8lN43j40sQhhMCgzC/jwfCxiF9Ck
	 S1Rpfu6ECbG12CPWhOdZbuYTmAE8Rtl+AjqpXF4Vszh0KZmZDQGrlRCBLZar+RBRp4IiT
	 /ygjZZGnZXr483JwHvU3fAAMDgPsGMY35ZtkjCuNp5UmYJpDIT/w1BuK9qfjgN+dUmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ff1ISkwl;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D30606A323
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48D30606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ff1ISkwl
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-49d8ce126f6so2175178f8f.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839241; x=1795444041; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W309uQy0XooJdzMwvz9qNm0IhwUCOZ7RPUmkTdvsJxY=;
        b=Ff1ISkwlk5aS40dt98ilzm4G+tbGk57i6e9TKEUffe92MKIBqw3sVbx/UEApZmDHry
         Eyxkwsm+MUJ5NYXpoQAvDeDuKjL0qygexEY5zBK/ePPeltzZ/fcBkZxXvR5Q2lusMSsH
         dQpjCmhkKRpf876l7DkTAcPhpfQrNdI+gXJlBxZtkcMUUYzzE1RlXHt/mm5sqec98tIb
         lQiNeFr43Th2/g52U/trKaiJRDN+QEs5AzYD5+BcD/vi8PiabEuCOI/4dkqpBz7/KXyR
         zoXvAjRR05QIQ9ermiqw2cx/EbtjkeBKmugTqcrfiFCfUfvvONn355qyd5KGiuuT6OYa
         DXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839241; x=1795444041;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W309uQy0XooJdzMwvz9qNm0IhwUCOZ7RPUmkTdvsJxY=;
        b=A/vQGfjoIWNvb1GIDyLxKw8JS+/DljD0qQ21yrGyQIXd0PUpXVtKvGGz8ZOfLVAHKA
         CHlj856XJF/H535vb4iCTLIXrKZLxDmqpJPX9ZLV/BDb92UHyYb6tO//Yfb0JyICglfy
         C98Pg7XCSN8sOm7t0QZZR+afLUmxZFUI6yZhWuNheOje0HaXcYdWuSvuOXwix7D0UL3o
         Fw0n/z3FQdRytURjIzVBr7TYfGqpP3IPtGA3q3RmEEC0X3bdBitlLQ8e5xn7ZEKp4rQ9
         lx123Z1ZBLgoYoBhHSl9xsAIkK8TcvU0vd/ii3XSQbTOE4+OEt9LDuw9y1Y3GhyXdNfY
         p3JA==
X-Gm-Message-State: APuU4Z9hQZtUTnK7YbCcvUkGVjHzDh6+M6RYx4ERdSb1Mr6psUGFfC0i
	3ItnHUcUWAgNNGtq79Feaxc7rb5tFbltmBTHkXbDbJ9lEQ+EM0wWtvQkhQL2nFqC8TxR3mLgCal
	mYWivQPaHpyjmqrd3BQ7SvW3hZjOqpHUtLNlMauUP2zzX5wnVsSKCCRF0R4u5TD6GntN5n+d+Xh
	sSUmJ+wXJu6pXVZF4usb8n5gm7LzLfgQ==
X-Received: from wrnb18.prod.google.com ([2002:adf:e652:0:b0:48b:9d80:f2c3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64e4:0:b0:48f:c4fb:6bb6
 with SMTP id ffacd0b85a97d-49c70b051femr23428189f8f.12.1794839239530; Mon, 16
 Nov 2026 06:27:19 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:25 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=18119; i=ardb@kernel.org;
 h=from:subject; bh=ykE72bmdDAQg9Bz+YBYQeiUc1KfDhOTJT8FNVgBnihY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30BTuFzxNKx/fMbnTIJRSu/SteNJhjeLzK85u3Lv46
 brNngdqOkpZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBE1IwY/vD8sFK03GKzw+Gv
 VthW27aoQ6vn+VTYV0/fJ1+2xqr8uwQjw7US2b8mM79tfcDgo/uMc7PsxK+7p9o/VTO0dggwnOz cyQUA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-23-ardb+git@google.com>
Subject: [PATCH v3 06/15] efi/libstub: Capture loaded image information in
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
stub code can access these properties in a consistent manner for both
the uncompressed kernel and the EFI zboot image.

Note that zboot can only access this information after decompressing the
image, whereas code that is part of the EFI stub that gets integrated
into Linux could just grab the efi_image_info pointer as needed.

However, in order to avoid future surprises, pass the efi_image_info
pointer down via the calls into the shared stub code, replacing the
image base address field, whose value can be derived from image_info as
well as long as it is taken from the copy of the image that will
ultimately be used to boot the kernel.

ARM implements neither, but -like x86- incorporates the EFI stub into
its own decompressor and cannot incorporate struct efi_image_info as
defined here, as it refers to global symbols in vmlinux. It does not
really have a need for this either, so just define an empty struct for
it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi-header.S                |  2 +
 arch/loongarch/kernel/head.S                  |  1 +
 arch/riscv/kernel/head.S                      |  1 +
 drivers/firmware/efi/libstub/Makefile         |  1 +
 drivers/firmware/efi/libstub/Makefile.zboot   | 11 +++-
 drivers/firmware/efi/libstub/arm32-stub.c     |  5 +-
 drivers/firmware/efi/libstub/arm64-stub.c     | 17 ++++--
 drivers/firmware/efi/libstub/efi-stub-entry.c | 22 +++-----
 drivers/firmware/efi/libstub/efi-stub.c       | 10 ++--
 drivers/firmware/efi/libstub/efistub.h        | 57 ++++++++++++++++++--
 drivers/firmware/efi/libstub/image_info.S     | 19 +++++++
 drivers/firmware/efi/libstub/loongarch-stub.c |  4 +-
 drivers/firmware/efi/libstub/riscv-stub.c     |  4 +-
 drivers/firmware/efi/libstub/zboot.c          | 22 ++++++--
 drivers/firmware/efi/libstub/zboot.lds        |  2 +
 15 files changed, 145 insertions(+), 33 deletions(-)

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
index 1073dd947516..f7151a4915ba 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -76,12 +76,15 @@ void efi_handle_post_ebs_state(void)
 		      &efi_entry_state->sctlr_after_ebs);
 }
 
+struct efi_image_info efistub_image_info = {};
+
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle)
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info)
 {
 	const int slack = TEXT_OFFSET - 5 * PAGE_SIZE;
 	int alloc_size = MAX_UNCOMP_KERNEL_SIZE + EFI_PHYS_ALIGN;
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2c3869356147..c93ab8b6e9d3 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -19,9 +19,11 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle)
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info)
 {
 	unsigned long kernel_size, kernel_codesize, kernel_memsize;
+	efi_status_t status;
 
 	if (image->image_base != _text) {
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
@@ -38,9 +40,16 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	*reserve_size = kernel_memsize;
 	*image_addr = (unsigned long)_text;
 
-	return efi_kaslr_relocate_kernel(image_addr, reserve_addr, reserve_size,
-					 kernel_size, kernel_codesize, kernel_memsize,
-					 efi_kaslr_get_phys_seed(image_handle));
+	status = efi_kaslr_relocate_kernel(image_addr, reserve_addr,
+					   reserve_size, kernel_size,
+					   kernel_codesize, kernel_memsize,
+					   efi_kaslr_get_phys_seed(image_handle));
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*(unsigned long *)image_info += *image_addr - (unsigned long)_text;
+	return EFI_SUCCESS;
 }
 
 asmlinkage void primary_entry(void);
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index efa3ab8ad1c6..36ea6aa2cfcc 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -7,22 +7,17 @@
 
 #include "efistub.h"
 
-static unsigned long kernel_image_offset;
+extern const struct efi_image_info efistub_image_info;
 
-static void *kernel_image_addr(void *addr)
-{
-	return addr + kernel_image_offset;
-}
-
-struct sysfb_display_info *alloc_primary_display(void)
+struct sysfb_display_info *
+alloc_primary_display(const struct efi_image_info *image_info)
 {
 	if (IS_ENABLED(CONFIG_ARM))
 		return __alloc_primary_display();
 
-	if (IS_ENABLED(CONFIG_X86) ||
-	    IS_ENABLED(CONFIG_EFI_EARLYCON) ||
+	if (IS_ENABLED(CONFIG_EFI_EARLYCON) ||
 	    IS_ENABLED(CONFIG_SYSFB))
-		return kernel_image_addr(&sysfb_primary_display);
+		return efistub_sysfb_display_info(image_info);
 
 	return NULL;
 }
@@ -36,6 +31,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 				   efi_system_table_t *systab)
 {
 	static efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
+	const struct efi_image_info *image_info = &efistub_image_info;
 	efi_loaded_image_t *image;
 	efi_status_t status;
 	unsigned long image_addr;
@@ -72,15 +68,13 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	status = handle_kernel_image(&image_addr, &image_size,
 				     &reserve_addr,
 				     &reserve_size,
-				     image, handle);
+				     image, handle, &image_info);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to relocate kernel\n");
 		return status;
 	}
 
-	kernel_image_offset = image_addr - (unsigned long)image->image_base;
-
-	status = efi_stub_common(handle, image, image_addr, cmdline_ptr);
+	status = efi_stub_common(handle, image, image_info, cmdline_ptr);
 
 	efi_free(image_size, image_addr);
 	efi_free(reserve_size, reserve_addr);
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 6db10590f89b..bf9a9f53a95c 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -51,14 +51,15 @@ static bool flat_va_mapping = (EFI_RT_VIRTUAL_OFFSET != 0);
 void __weak free_primary_display(struct sysfb_display_info *dpy)
 { }
 
-static struct sysfb_display_info *setup_primary_display(void)
+static struct sysfb_display_info *
+setup_primary_display(const struct efi_image_info *image_info)
 {
 	struct sysfb_display_info *dpy;
 	struct screen_info *screen = NULL;
 	struct edid_info *edid = NULL;
 	efi_status_t status;
 
-	dpy = alloc_primary_display();
+	dpy = alloc_primary_display(image_info);
 	if (!dpy)
 		return NULL;
 	screen = &dpy->screen;
@@ -160,9 +161,10 @@ efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr)
 
 efi_status_t efi_stub_common(efi_handle_t handle,
 			     efi_loaded_image_t *image,
-			     unsigned long image_addr,
+			     const struct efi_image_info *image_info,
 			     char *cmdline_ptr)
 {
+	unsigned long image_addr = efistub_kernel_base(image_info);
 	struct sysfb_display_info *dpy;
 	efi_status_t status;
 
@@ -170,7 +172,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 	if (status != EFI_SUCCESS)
 		return status;
 
-	dpy = setup_primary_display();
+	dpy = setup_primary_display(image_info);
 
 	efi_retrieve_eventlog();
 	efi_bli_set_variables(image);
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index f5eec8c12894..bb8e360fee7b 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1135,6 +1135,16 @@ efi_status_t efi_load_initrd(efi_loaded_image_t *image,
 			     unsigned long soft_limit,
 			     unsigned long hard_limit,
 			     const struct linux_efi_initrd **out);
+
+struct efi_image_info {
+	s32	_text_offset;
+	s32	__inittext_end_offset;
+	s32	_edata_offset;
+	s32	_end_offset;
+	s32	entry_offset;
+	s32	sysfb_primary_display_offset;
+};
+
 /*
  * This function handles the architcture specific differences between arm and
  * arm64 regarding where the kernel image must be loaded and any memory that
@@ -1146,12 +1156,51 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle);
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info);
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
+void *efistub_kernel_entry(const struct efi_image_info *image_info)
+{
+	return offset_to_ptr(&image_info->entry_offset);
+}
+
+static inline
+void *efistub_sysfb_display_info(const struct efi_image_info *image_info)
+{
+	auto offset = &image_info->sysfb_primary_display_offset;
+
+	return *offset ? offset_to_ptr(offset) : NULL;
+}
 
 /* shared entrypoint between the normal stub and the zboot stub */
 efi_status_t efi_stub_common(efi_handle_t handle,
 			     efi_loaded_image_t *image,
-			     unsigned long image_addr,
+			     const struct efi_image_info *image_info,
 			     char *cmdline_ptr);
 
 efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr);
@@ -1173,7 +1222,9 @@ efi_enable_reset_attack_mitigation(void) { }
 
 void efi_retrieve_eventlog(void);
 
-struct sysfb_display_info *alloc_primary_display(void);
+struct sysfb_display_info *
+alloc_primary_display(const struct efi_image_info *image_info);
+
 struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);
 
diff --git a/drivers/firmware/efi/libstub/image_info.S b/drivers/firmware/efi/libstub/image_info.S
new file mode 100644
index 000000000000..587a3eaff1c3
--- /dev/null
+++ b/drivers/firmware/efi/libstub/image_info.S
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/init.h>
+
+	__INITRODATA
+
+	.p2align	3
+	.globl		__efistub_efistub_image_info
+__efistub_efistub_image_info:
+0:	.long	_text - .
+	.long	__inittext_end - 0b
+	.long	_edata - 0b
+	.long	_end - 0b
+	.long	efi_primary_entry - .
+#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
+	.long	sysfb_primary_display - .
+#else
+	.long	0
+#endif
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index c87ac7025107..d57e3d3557a5 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -99,7 +99,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle)
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info)
 {
 	efi_status_t status;
 	unsigned long kernel_addr = 0;
@@ -112,6 +113,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	*image_addr = kernel_addr;
 	*image_size = kernel_asize;
 
+	*(unsigned long *)image_info += *image_addr - (unsigned long)image->image_base;
 	return status;
 }
 
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 5cbc50a814e1..0ddbe7cc8628 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -28,7 +28,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle)
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info)
 {
 	unsigned long kernel_size, kernel_codesize, kernel_memsize;
 	efi_status_t status;
@@ -46,6 +47,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
 
+	*(unsigned long *)image_info += *image_addr - (unsigned long)_start;
 	return status;
 }
 
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4a5ffe164873..4cff756902ad 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -26,9 +26,18 @@ void __weak efi_cache_sync_image(unsigned long image_base,
 	// executable code loaded into memory to be safe for execution.
 }
 
-struct sysfb_display_info *alloc_primary_display(void)
+struct sysfb_display_info *
+alloc_primary_display(const struct efi_image_info *image_info)
 {
-	return __alloc_primary_display();
+	return efistub_sysfb_display_info(image_info);
+}
+
+static
+const struct efi_image_info *zboot_get_image_info(unsigned long image_base)
+{
+	extern const u32 efistub_image_info_offset;
+
+	return (void *)image_base + efistub_image_info_offset;
 }
 
 asmlinkage efi_status_t __efiapi
@@ -93,9 +102,14 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	}
 
 	// Decompress the payload into the newly allocated buffer
-	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
-	         efi_stub_common(handle, image, image_base, cmdline_ptr);
+	status = efi_zboot_decompress((void *)image_base, alloc_size);
+	if (status != EFI_SUCCESS)
+		goto error;
+
+	auto image_info = zboot_get_image_info(image_base);
+	status = efi_stub_common(handle, image, image_info, cmdline_ptr);
 
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
2.56.0.611.g1030f0b940-goog

