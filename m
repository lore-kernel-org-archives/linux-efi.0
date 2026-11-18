Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026132;
	b=NIm6rg4bLfgoQL2crc4RFjUy2k+2Fnts2I0WrAbrP9QJOarPgSW+SrrBbtTy2wuVCUV3
	 kGccT1mBgrvUh7iDwaK7Wmz7bzFnsA8l6prSNHR8hCn8yNM3h7FN0vQ5AmrE0kR4JgQdE
	 tOgCnNu+5lLySi7F9LQAWnQmssyOfhVHs2MXJVKB68jptsJFUO349Vb3TqiQ6TqtPWOx1
	 GR9Yo9Pgg9a8WOKRSFW6BYx2KHhgOvDgGFPeuNimaI0qsf60gqy240FpHcXngIlYdasxK
	 Fpfw3i6fjSSOoiT+Ty0477zyEK34tzQrbt/eBK7mAgqB/Ko3dSygcikVsuQfNjWGKxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=qmGCFG2plXe8vmZtQIJVK4guRF9ed+vUOMzeyrBZ/us=;
	b=ghKATFklJNWtqg0+AzC50AaW5vz1oFj79uD+zLLpDNUw2ZzmOErI0Nh8sOC1ehWSRxqz
	 t6JX1V5NYU0crvAQa/9DYYWd8+1DzUfcXKXvmW4bIStNGLefhNIt8tUraq1TE4iyeuX4B
	 V0gJCUc8DW/OWgOipv9kT0eKTPh7n5YtK+GCtfT9u16RaqKyzQVgKji8vNQS8sewSuQhN
	 7p75SyKFo//wu8upmbs4bi3oD411LwRW3ztpN0Mk1NtasCkWOAuSzS8tTujDZEV38oh02
	 CcaJ1zkPoOxn18Hx5ABry///coC0mygf3irhAscwu1BSwnYQCJNVhUJN9fuJJFFb7kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="J/GIaRBZ";
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0834606A31C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0834606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=J/GIaRBZ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4925ef75fc4so1017648f8f.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026130; x=1795630930; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qmGCFG2plXe8vmZtQIJVK4guRF9ed+vUOMzeyrBZ/us=;
        b=J/GIaRBZfggMeIYimCgU7iOAkazn7vKJ5gkyIFr6ENpL0DljAKuhT4wdjBiZOrfIsP
         TZzxBrvK5GvmNo2AYa35jlw6B/s6pp/J937s6A+PSXGRCu+hjP6wH94W/JegrrA8VyMm
         ncOJPac4jwQsz9fPN3VsreNZDQwPMjM9Q5wG59zVBK6I9Z+edgng8X5aYMvhdkfa+nyP
         aWXhJk/9mpqv5zLLrjZb2lybkzHJT2scWFDeDjFu9Tvn9CASEzB+t+69FHThtGswNrI3
         u3PyMEtR3WjZuiw7+MblK6EKfCH9eimHWHPhxtKONIQ4oS2m00ctrgVtxPwGQ+2pipXN
         XW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026130; x=1795630930;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qmGCFG2plXe8vmZtQIJVK4guRF9ed+vUOMzeyrBZ/us=;
        b=iA/T0Rogu/I8GwuUs6ZvHPEAFERQBZVgSiPjnWTeqwHbEi0oK9OsS+7QNe2ke4Khrj
         /WMd46qRYXaEWZL/HsXuPPBqnuvyq4YnjcGLIz/CYci9rAido1sotCz2Z3I15cLfkHHg
         0xyZOoE2/zwuCHRwhQi0O8NJzkM3mF+CCmCwoCsfEc1ysBQK4XeLOPIEZg5SSIcy5fqv
         0//+Xg83iFu/fVYtIwH4QhhU16RLiOEZevbjRezJg0turrSmFdzZONUHPiQBtLJ9b28v
         LsS6XOzhO3gle9zk9FjR1J0LskeP/QP3ZhmWSBSB7WIKrR5DSTg3E9q6gC66z5UUz8wj
         e05Q==
X-Gm-Message-State: APuU4Z+p5mvRMRYTbZBhNP3pcYlpadCPYYVoBaxQKmQCZqT/plAIdisR
	tn6FPO7fmYFhp1ELI7zuXB+qDCoaatbgnpMtwfVNaSMiwGFTfuPNpGtkEpAjTDbvsjVZXJYCjzS
	7Kt4UQN7/ecN/FRB9mXIdtA7nYc4zpQCvGyTYwvHWXQ5oULudttTGJh8wwl6lVhNIGJMCI4TlCA
	hgpskqVSjyNFgTnInauGqZwuWaPneXpw==
X-Received: from wrbgf13.prod.google.com ([2002:a05:6000:27cd:b0:4a3:2183:2372])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d01:0:b0:48e:720a:ccaf
 with SMTP id ffacd0b85a97d-4a63658254amr8068198f8f.5.1795026129990; Wed, 18
 Nov 2026 10:22:09 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:19 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5588; i=ardb@kernel.org;
 h=from:subject; bh=Vn0Z0SmqUqZ8NK+fY9lRYM6IvhOk/O8WfVQkKgBtwuc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvmyUN51mqr22vUWb9L5EtnXaWMWDLpvq+koynlosUU
 teePWLVUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbC4Mzwh2PSVYaiuDVeilO2
 iE3dbZOX8lHQJNg4pOjfs7sck3qZ5zAyvA664Gm3Lvb520dKtdw3z7FNDNvDc/OidOVlr67nsWE veQA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-34-ardb+git@google.com>
Subject: [PATCH v4 13/19] efi/libstub: loongarch: Use struct efi_image_info to
 access image properties
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of exposing individual symbols to the EFI stub explicitly via
the linker script, use the generic struct efi_image_info, which accesses
the original symbols via PC-relative references from the stub itself.

This improves code reuse across architectures, and makes it easier to
add new references in a generic manner.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/loongarch/kernel/head.S                  |  3 ---
 arch/loongarch/kernel/image-vars.h            |  6 ------
 arch/loongarch/kernel/vmlinux.lds.S           |  1 -
 drivers/firmware/efi/libstub/loongarch-stub.c | 15 ++-------------
 drivers/firmware/efi/libstub/loongarch-stub.h |  4 ----
 drivers/firmware/efi/libstub/loongarch.c      | 10 +---------
 6 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/arch/loongarch/kernel/head.S b/arch/loongarch/kernel/head.S
index 69c31b0b65c5..93ffedad6aca 100644
--- a/arch/loongarch/kernel/head.S
+++ b/arch/loongarch/kernel/head.S
@@ -32,9 +32,6 @@ _head:
 pe_header:
 	__EFI_PE_HEADER
 
-SYM_DATA(kernel_asize, .long _kernel_asize);
-SYM_DATA(kernel_fsize, .long _kernel_fsize);
-
 SYM_FUNC_ALIAS(efi_primary_entry, kernel_entry)
 #endif
 
diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e557ebd46c2b..6ace4993df57 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -8,12 +8,6 @@
 #ifdef CONFIG_EFI_STUB
 
 __efistub_strcmp		= strcmp;
-__efistub_kernel_entry		= kernel_entry;
-__efistub_kernel_asize		= kernel_asize;
-__efistub_kernel_fsize		= kernel_fsize;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
-__efistub_sysfb_primary_display	= sysfb_primary_display;
-#endif
 
 #endif
 
diff --git a/arch/loongarch/kernel/vmlinux.lds.S b/arch/loongarch/kernel/vmlinux.lds.S
index ce097e25881f..f8723c1ba9a7 100644
--- a/arch/loongarch/kernel/vmlinux.lds.S
+++ b/arch/loongarch/kernel/vmlinux.lds.S
@@ -159,7 +159,6 @@ SECTIONS
 	/* header symbols */
 	_kernel_entry = ABSOLUTE(kernel_entry & PHYSADDR_MASK);
 	_kernel_asize = ABSOLUTE(_end - _text);
-	_kernel_fsize = ABSOLUTE(_edata - _text);
 	_kernel_vsize = ABSOLUTE(_end - __initdata_begin);
 	_kernel_rsize = ABSOLUTE(_edata - __initdata_begin);
 #endif
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index 8f2145bd9ad2..df6749643bb8 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -8,11 +8,6 @@
 #include <asm/efi.h>
 #include <asm/addrspace.h>
 #include "efistub.h"
-#include "loongarch-stub.h"
-
-extern int kernel_asize;
-extern int kernel_fsize;
-extern int kernel_entry;
 
 /**
  * efi_relocate_kernel() - copy memory area
@@ -100,6 +95,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
 {
+	int kernel_asize = efistub_kernel_memsize(*image_info);
+	int kernel_fsize = efistub_kernel_size(*image_info);
 	efi_status_t status;
 	unsigned long kernel_addr = 0;
 
@@ -114,11 +111,3 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	*(unsigned long *)image_info += *image_addr - (unsigned long)image->image_base;
 	return status;
 }
-
-unsigned long kernel_entry_address(unsigned long kernel_addr,
-		efi_loaded_image_t *image)
-{
-	unsigned long base = (unsigned long)image->image_base;
-
-	return (unsigned long)&kernel_entry - base + kernel_addr;
-}
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.h b/drivers/firmware/efi/libstub/loongarch-stub.h
deleted file mode 100644
index cd015955a015..000000000000
--- a/drivers/firmware/efi/libstub/loongarch-stub.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-
-unsigned long kernel_entry_address(unsigned long kernel_addr,
-		efi_loaded_image_t *image);
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 7f21e79384d3..cd19f3b574fd 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -8,7 +8,6 @@
 #include <asm/efi.h>
 #include <asm/addrspace.h>
 #include "efistub.h"
-#include "loongarch-stub.h"
 
 typedef void __noreturn (*kernel_entry_t)(bool efi, unsigned long cmdline,
 					  unsigned long systab);
@@ -59,16 +58,9 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
 	return EFI_SUCCESS;
 }
 
-unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
-		efi_loaded_image_t *image)
-{
-	return *(unsigned long *)(kernel_addr + 8) - PHYSADDR(VMLINUX_LOAD_ADDRESS) + kernel_addr;
-}
-
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 			     const struct efi_image_info *image_info, char *cmdline_ptr)
 {
-	unsigned long kernel_addr = efistub_kernel_base(image_info);
 	kernel_entry_t real_kernel_entry;
 	struct exit_boot_struct priv;
 	unsigned long desc_size;
@@ -99,7 +91,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	csr_write(CSR_DMW2_INIT, LOONGARCH_CSR_DMWIN2);
 	csr_write(CSR_DMW3_INIT, LOONGARCH_CSR_DMWIN3);
 
-	real_kernel_entry = (void *)kernel_entry_address(kernel_addr, image);
+	real_kernel_entry = efistub_kernel_entry(image_info);
 
 	real_kernel_entry(true, (unsigned long)cmdline_ptr,
 			  (unsigned long)efi_system_table);
-- 
2.56.1.708.g77570a6a1d-goog

