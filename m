Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026122;
	b=NgBvsaRHmCIGWEjMh9loq23vG66ppBZ+V4MatHKIdysqEqd3MgZ9xxh+4Ycu7rDxmBZi
	 gdRjuDx1wAgVk+D3Yt41r9jxCx6Z4H2LGcc5C4I2RPgFoW/4Uexur3kPhbdprtSfFT0ST
	 PNOfmhPgkgePnchdiPVxzjmhzLtWK5GDQ1xile8baQGHYFOJC4b8SfgfVzwjY0pe94UUz
	 j/u7ka7a+kAt/UFv0wiJXo6jVHMYWBklbicZHCPFFg9sc7t0CKlrzxtrHefslZHe6MMaH
	 B3yZ9Y5GM78JyXLnNdkLvQ1Qa//E9FPVm4ba5+2+/T8CNDUXz7IbuOjjionseT5fuJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026122;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=BFGKQtttUCCxiC9KvZFy5P/XBPLuepyODAMZD8pNnRE=;
	b=l36tUgx4YTkSJYyBKnR8mzXQDdd0rOHQ68sMmweKjvjhcdamG6henqnFFsePrvyTBcN6
	 J18dEwL05guQn7ESZ8B0IFw/zXHJYWsmlVap/WhNvjIILs5Q6yaOb6Hn0Tkwni37SWIR+
	 ZBJniPUfe91M4Z0jzoAhUNuoVgW1MNCF17Ys9Wbim73tBOev0OdVdy0FPEctF8CGm8vSG
	 JXTC1rePBxgE6ZuEpXWJQNWyblKGA8g/Lcy6x7xwAXr1D0MvsaVFJhNyiBey+o/NCZNzF
	 W0MMx9sT752IKV4JrCEfWFqX9pccFrX46b76Rh1Hru/cjbuqN46HHx4rLcnU7lOpeTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="hj2Id/yL";
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12948606A330
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12948606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hj2Id/yL
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so9436805e9.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026120; x=1795630920; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BFGKQtttUCCxiC9KvZFy5P/XBPLuepyODAMZD8pNnRE=;
        b=hj2Id/yLlJphsmErtCGfOdIsyqHKlSFGVmdZF7kBHFA2vCuwBXVqq591seYzBQoW3Q
         kd0d1tm411U37o8Ef8Satu+gBUoxuGMGum3DOhh2ewDlo57SpKTJqBmbuSGDQLuGn92t
         YBmErdKiHQvzkBbdk+iYvBcIZNYSTmVmsvPwToUmpBN0VgqHeJW8GYCbIZiyu1WOmyYS
         1BuVJwqlaK502q8Akz2bD3pGvkAdvbZJ5zeD8orLLhiNueMTwvZC1AnRQaP2NDIYuOCL
         XFZUfVrLHOoV8k6iPzqIRZ+g9qIqiWn6DO4Dg0OQJQi/cb0fV/BZwYzGoqx9oj0t4a4Q
         T6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026120; x=1795630920;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BFGKQtttUCCxiC9KvZFy5P/XBPLuepyODAMZD8pNnRE=;
        b=wTpjOTt1jFdV9VxwRsNoI47yXGNRBjOAvlzWwqDPielo+NJjnQWlGy0lpwlKj+b9Ev
         VHMOyjBkhbKEdt3afmcT3rADXmB1LhZpfTugQBxoaV17sqJqQ/aeMWfiI6CGq0ZLltyN
         mOt2sYMZOQNwV/Og++pBqJQFIQdQ54jKIoV3I+5lcZeYEnZFl+mCe3SwAYiZ8HX7/43m
         wgOwrvKgG5bSAz2FUQV/U5z38uLbHfPe/t/m9GVf+Ooh+HSW3WMy1WQqOMU9uMPZ2s47
         cYIOZ0vwcWTGg5tY81LNpNNdoPidiPD3ogb7UEOEPNQgpjlTrwnNsf1Rn2DE0V8aQkb0
         4Eqg==
X-Gm-Message-State: APuU4Z+a7CVP+0bjVCEKaYaH28pbTcGpqxOLYgjCutJ81YAz7pnWD4Vw
	kxUBnyj9U+V2TPioRpdhooOthtirST5jygmPmmfZiui2HIITx41fSu7AZQPnubLAph/yqeF5QeG
	N4rcjl4QL/3EeIyds3dZfQHV/rBdxQIEhcIROjxxapu9E5UJxvpGmytTj2oAVa2jROs+jsEp/d9
	BIeR1MUXtsb3nBoWheN3y0icu0Hoomeg==
X-Received: from wrqv14.prod.google.com ([2002:a5d:4b0e:0:b0:4a3:6d62:8105])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:81c5:b0:4bb:7987:fbbc
 with SMTP id 5b1f17b1804b1-4bb7d5d41e5mr64616255e9.1.1795026120017; Wed, 18
 Nov 2026 10:22:00 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:14 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21464; i=ardb@kernel.org;
 h=from:subject; bh=hdE3Rr4UdMRGoVG44vW2Nu/AA6wj0JqpCbvhKmKVIYI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm7lNuR6PWAsXbv3/Z8KaU+aGz0WPXTkdwj+hUnLf+
 s9LPxUc6ihlYRDjYpAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQAT8fNjZHgu16bxaf0/rcC7
 it/W3FpZL6Efeq6tOClnoxbvZMFtDIcYGdaw5inlB2WncmyQiww9qHkqbAGP5YXO226szw1yz56 o4QMA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-29-ardb+git@google.com>
Subject: [PATCH v4 08/19] efi/libstub: Capture loaded image information in
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
defined here, as it refers to global symbols in vmlinux. Assign the
efi_image_info._text_offset field at runtime so that generic code can
use efi_image_info to derive the base address of the loaded image. Other
fields are not used on ARM so ignore those.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi-header.S                |  2 +
 arch/loongarch/kernel/head.S                  |  1 +
 arch/riscv/kernel/head.S                      |  1 +
 drivers/firmware/efi/libstub/Makefile         |  1 +
 drivers/firmware/efi/libstub/Makefile.zboot   | 11 +++-
 drivers/firmware/efi/libstub/arm32-stub.c     |  8 ++-
 drivers/firmware/efi/libstub/arm64-stub.c     | 13 +----
 drivers/firmware/efi/libstub/efi-stub-entry.c | 22 +++----
 drivers/firmware/efi/libstub/efi-stub.c       | 10 ++--
 drivers/firmware/efi/libstub/efistub.h        | 61 ++++++++++++++++++--
 drivers/firmware/efi/libstub/image_info.S     | 19 ++++++
 drivers/firmware/efi/libstub/kaslr.c          | 17 +++---
 drivers/firmware/efi/libstub/loongarch-stub.c |  4 +-
 drivers/firmware/efi/libstub/riscv-stub.c     | 12 +---
 drivers/firmware/efi/libstub/zboot.c          | 22 +++++--
 drivers/firmware/efi/libstub/zboot.lds        |  2 +
 16 files changed, 148 insertions(+), 58 deletions(-)

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
index 1ab15d66e709..798b2ae3bb03 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -82,12 +82,15 @@ extern u32 input_data_end[] __aligned(1);
 /* entry #3 in the zimage magic table carries the kernel's BSS size */
 extern u32 zimage_magic_table[] asm("_table_start");
 
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
 	unsigned long kernel_memsize = input_data_end[-1] + zimage_magic_table[3];
 	const int pgdir_size = (4 + IS_ENABLED(CONFIG_ARM_LPAE)) * PAGE_SIZE;
@@ -122,6 +125,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 		kernel_base = round_down(alloc_base, EFI_PHYS_ALIGN);
 	}
 
+	efistub_image_info._text_offset =
+		kernel_base + TEXT_OFFSET - (u32)&efistub_image_info;
+
 	*reserve_addr = kernel_base + slack;
 	*reserve_size = alloc_size;
 
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index fe0deae78e5b..b57cccd75ab5 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -19,10 +19,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle)
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info)
 {
-	unsigned long kernel_size, kernel_codesize, kernel_memsize;
-
 	if (image->image_base != _text) {
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
 		image->image_base = _text;
@@ -32,13 +31,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
 			SEGMENT_ALIGN >> 10);
 
-	kernel_size = _edata - _text;
-	kernel_codesize = __inittext_end - _text;
-	kernel_memsize = kernel_size + (_end - _edata);
-	*image_addr = (unsigned long)_text;
-
-	return efi_kaslr_relocate_kernel(image_addr, image_size,
-					 kernel_size, kernel_codesize, kernel_memsize,
+	return efi_kaslr_relocate_kernel(image_addr, image_size, image_info,
 					 efi_kaslr_get_phys_seed(image_handle));
 }
 
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
index 5c10815d9172..edc768a54473 100644
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
 
@@ -1245,9 +1296,7 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 		     unsigned long code_size);
 efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 				       unsigned long *alloc_size,
-				       unsigned long kernel_size,
-				       unsigned long kernel_codesize,
-				       unsigned long kernel_memsize,
+				       const struct efi_image_info **image_info,
 				       u32 phys_seed);
 u32 efi_kaslr_get_phys_seed(efi_handle_t image_handle);
 
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
diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 49b05d0c0003..7cf68a612394 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -84,9 +84,7 @@ static bool check_image_region(u64 base, u64 size)
  * efi_kaslr_relocate_kernel() - Relocate the kernel (random if KASLR enabled)
  * @image_addr:		Pointer to variable carrying the image base address
  * @alloc_size:		Pointer to variable carrying the allocated size
- * @kernel_size:	Size of the text + data
- * @kernel_codesize:	Size of the text
- * @kernel_memsize:	Size of the text + data + bss
+ * @image_info:		Pointer to struct efi_image_info pointer
  * @phys_seed:		Random seed used for the relocation
  *
  * If KASLR is not enabled, this function relocates the kernel to a fixed
@@ -97,14 +95,15 @@ static bool check_image_region(u64 base, u64 size)
  */
 efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 				       unsigned long *alloc_size,
-				       unsigned long kernel_size,
-				       unsigned long kernel_codesize,
-				       unsigned long kernel_memsize,
+				       const struct efi_image_info **image_info,
 				       u32 phys_seed)
 {
-	unsigned long kernel_base = *image_addr;
+	unsigned long kernel_base	= efistub_kernel_base(*image_info);
+	unsigned long kernel_size	= efistub_kernel_size(*image_info);
+	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
+	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
+	u64 min_kimg_align		= efi_get_kimg_min_align();
 	efi_status_t status;
-	u64 min_kimg_align = efi_get_kimg_min_align();
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && phys_seed != 0) {
 		/*
@@ -148,5 +147,7 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 	efi_icache_sync(*image_addr, *image_addr + kernel_codesize);
 	efi_remap_image(*image_addr, kernel_memsize, kernel_codesize);
 
+	*(unsigned long *)image_info += *image_addr - kernel_base;
+
 	return status;
 }
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
index d0fc04d21b56..e4f9723d5055 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -28,18 +28,12 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
-				 efi_handle_t image_handle)
+				 efi_handle_t image_handle,
+				 const struct efi_image_info **image_info)
 {
-	unsigned long kernel_size, kernel_codesize, kernel_memsize;
 	efi_status_t status;
 
-	kernel_size = _edata - _start;
-	kernel_codesize = __inittext_end - _start;
-	kernel_memsize = kernel_size + (_end - _edata);
-	*image_addr = (unsigned long)_start;
-
-	status = efi_kaslr_relocate_kernel(image_addr, image_size,
-					   kernel_size, kernel_codesize, kernel_memsize,
+	status = efi_kaslr_relocate_kernel(image_addr, image_size, image_info,
 					   efi_kaslr_get_phys_seed(image_handle));
 	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
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
2.56.1.708.g77570a6a1d-goog

