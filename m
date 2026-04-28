Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2454837C10C
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777395983; cv=none; b=tJDAyC/Cw5J6rguAN5kN3Pyb5QHLd2LYqfZ3w6+hlsA6Ndln0dcivnx0TUboKR8FegExO9azDJhr/gdqYyKdIWnnxEry1po99dAjFkaWrLm0LboCLIIZIAUIKymRYnlpBkdxEfQLevCerVNfmQykhH9kxIcDjNZGJ9q0nZ/EoTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777395983; c=relaxed/simple;
	bh=c+2/awzy74Z2h/SDUS6k90+HIyriGQgGiojel2LpT0g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=c4PbJ7+BQhzFTL7//OAq0eW2nGrvitKaMF0Gozu+ar/hd5Y0P4t5tHDz1zCI4aBwG4EtEOB4LQfVgJEgu5ztLMY2ECpThMXfyfLxvA8luziYQqNwDPGZOaRa19yPKuzWqYHP6jQd58H2ImSx90FZOFYZbq9lFakRcifvA3LBK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTzByude; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTzByude"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a5775d647so71537925e9.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777395979; x=1778000779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KOpZdaEjj+gbtaZU0EkN2PPohIqg1Dj7zfyUugB3N1I=;
        b=jTzByudeTYGsOoSbI7Y4i7OvMPBwgS/ErWcpweJuLr9RUHrux0uoEBvdCBhV39zncR
         DoFnxUA6GMUBXJrzxdoL7B1FqCuzkMGdDX3zYaqJuw6RQTuy9/HYodW59VrvfHwpncmt
         tQ/FDLQ+zmVLC8L+jk4S1Nn5K0ELgk94Y0uJzcsT35g0YsHIgpxJn5qD33DkvMyG1Uvl
         EeAsicPiUQ/FD4hkx3vfenGRfWfi+OtT9QpcNhCGTq3GNQHMa0GLLC1HBv32rlDp6x5/
         fz+vg6zNZkt5qaIIrRW1TcBYjrzw0Xp7zDPhZHC/nuJW12hRbneA6RivzaUOOyFF/xcg
         OO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777395979; x=1778000779;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KOpZdaEjj+gbtaZU0EkN2PPohIqg1Dj7zfyUugB3N1I=;
        b=fMTi74L3qdqQKLF74CPfgbyWw9oxVCVu0oxgxT1BT4A2HKfRMONLoJb1oauhGdkcIO
         anLyLGHZFClwT2388OikIp9GHqM/fCIQ9LHR+PBItozMD597eISIxcnIkWSg43hAkr9+
         X/uUj7kc1FJUe5ppHhKMZgPVGdKwXaRmptz3RZx6x7xRuAuSlbRq4wQyzgcOz81pdwmi
         7Aa/3Pv9GeSFEBWm9WjP7slfGHkln225J0UYWIeWZyP3/GJsK38vTXtIiVrK1XaQZffZ
         WlSSNeGWgJzxEionUS279VxTJQPwNqqz7pQNHTzFfffH6DH4ixCP0l/DcH1bzD7diRPM
         dP6Q==
X-Gm-Message-State: AOJu0YyZOA9BM4b79Z5h+6T2uu5d+ZSRb8AhqmoCOaVRR1Iu8E3zMlzd
	aY+aiKdiOAfvwdQI8ySU6sFDCshKNYJgA9hyqI6a4SMx/E6+/GPr+6bNI1SAA4g5YLZfgnK5t+U
	mrnXnzFsTqmHkzdO4E6WV3eaQ35SCKPs3YbTKPnxt2QuuKEB70mrAK9sO8VKcF4p8o9uTihPiPG
	2QkroLS0rG/8GNWERm6c7xIVHGvkARLA==
X-Received: from wmfo22.prod.google.com ([2002:a05:600c:2e16:b0:489:201f:2a3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b8d:b0:489:1f98:71e3
 with SMTP id 5b1f17b1804b1-48a77b21791mr61603635e9.28.1777395979381; Tue, 28
 Apr 2026 10:06:19 -0700 (PDT)
Date: Tue, 28 Apr 2026 19:06:09 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=13853; i=ardb@kernel.org;
 h=from:subject; bh=Ogw+V1Jv1iCQamapU07OKqJABqC5PJHPFRx1dISjulY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPDS0bZrF2ir4/z7W9eePtK2evGgLNB7Qc1tmdyex6pP
 /zPeMrMjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRNGNGhpU6khofXX5Hfxab
 q5JXczHvK9vjtcoTztVYn9+1sFq3yZCR4UbnOvbeNzPU1S+6hHVujHix4tUNv6eVDeXLTvqJFz/ Q5QAA
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428170608.3561937-2-ardb+git@google.com>
Subject: [PATCH] efi/libstub: Move efi_relocate_kernel() into its only
 remaining user
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Rui <r@hev.cc>, Huacai Chen <chenhuacai@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

LoongArch is the only arch that still uses efi_relocate_kernel(), so
before making changes to it that LoongArch needs, turn it into a private
function. Move efi_low_alloc_above() into mem.c while at it, and drop
the relocate.c source file altogether.

Cc: WANG Rui <r@hev.cc>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Unless there are any objections, I will queue this up and rebase the
LoongArch changes adding efi_cache_sync_image() on top of it.

 drivers/firmware/efi/libstub/Makefile         |   2 +-
 drivers/firmware/efi/libstub/efistub.h        |   7 -
 drivers/firmware/efi/libstub/loongarch-stub.c |  79 ++++++++++
 drivers/firmware/efi/libstub/mem.c            |  82 ++++++++++
 drivers/firmware/efi/libstub/relocate.c       | 166 --------------------
 5 files changed, 162 insertions(+), 174 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 983a438e35f3..cfedb3025c26 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -66,7 +66,7 @@ KBUILD_AFLAGS			:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
 				   file.o mem.o random.o randomalloc.o pci.o \
 				   skip_spaces.o lib-cmdline.o lib-ctype.o \
-				   alignedmem.o relocate.o printk.o vsprintf.o
+				   alignedmem.o printk.o vsprintf.o
 
 # include the stub's libfdt dependencies from lib/ when needed
 libfdt-deps			:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c \
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 979a21818cc1..fd91fc15ec81 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1104,13 +1104,6 @@ efi_status_t efi_allocate_pages_aligned(unsigned long size, unsigned long *addr,
 efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
 				 unsigned long *addr, unsigned long min);
 
-efi_status_t efi_relocate_kernel(unsigned long *image_addr,
-				 unsigned long image_size,
-				 unsigned long alloc_size,
-				 unsigned long preferred_addr,
-				 unsigned long alignment,
-				 unsigned long min_addr);
-
 efi_status_t efi_parse_options(char const *cmdline);
 
 void efi_parse_option_graphics(char *option);
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index 736b6aae323d..8c538a5243d9 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -14,6 +14,85 @@ extern int kernel_asize;
 extern int kernel_fsize;
 extern int kernel_entry;
 
+/**
+ * efi_relocate_kernel() - copy memory area
+ * @image_addr:		pointer to address of memory area to copy
+ * @image_size:		size of memory area to copy
+ * @alloc_size:		minimum size of memory to allocate, must be greater or
+ *			equal to image_size
+ * @preferred_addr:	preferred target address
+ * @alignment:		minimum alignment of the allocated memory area. It
+ *			should be a power of two.
+ * @min_addr:		minimum target address
+ *
+ * Copy a memory area to a newly allocated memory area aligned according
+ * to @alignment but at least EFI_ALLOC_ALIGN. If the preferred address
+ * is not available, the allocated address will not be below @min_addr.
+ * On exit, @image_addr is updated to the target copy address that was used.
+ *
+ * This function is used to copy the Linux kernel verbatim. It does not apply
+ * any relocation changes.
+ *
+ * Return:		status code
+ */
+static
+efi_status_t efi_relocate_kernel(unsigned long *image_addr,
+				 unsigned long image_size,
+				 unsigned long alloc_size,
+				 unsigned long preferred_addr,
+				 unsigned long alignment,
+				 unsigned long min_addr)
+{
+	unsigned long cur_image_addr;
+	unsigned long new_addr = 0;
+	efi_status_t status;
+	unsigned long nr_pages;
+	efi_physical_addr_t efi_addr = preferred_addr;
+
+	if (!image_addr || !image_size || !alloc_size)
+		return EFI_INVALID_PARAMETER;
+	if (alloc_size < image_size)
+		return EFI_INVALID_PARAMETER;
+
+	cur_image_addr = *image_addr;
+
+	/*
+	 * The EFI firmware loader could have placed the kernel image
+	 * anywhere in memory, but the kernel has restrictions on the
+	 * max physical address it can run at.  Some architectures
+	 * also have a preferred address, so first try to relocate
+	 * to the preferred address.  If that fails, allocate as low
+	 * as possible while respecting the required alignment.
+	 */
+	nr_pages = round_up(alloc_size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
+			     EFI_LOADER_DATA, nr_pages, &efi_addr);
+	new_addr = efi_addr;
+	/*
+	 * If preferred address allocation failed allocate as low as
+	 * possible.
+	 */
+	if (status != EFI_SUCCESS) {
+		status = efi_low_alloc_above(alloc_size, alignment, &new_addr,
+					     min_addr);
+	}
+	if (status != EFI_SUCCESS) {
+		efi_err("Failed to allocate usable memory for kernel.\n");
+		return status;
+	}
+
+	/*
+	 * We know source/dest won't overlap since both memory ranges
+	 * have been allocated by UEFI, so we can safely use memcpy.
+	 */
+	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
+
+	/* Return the new address of the relocated image. */
+	*image_addr = new_addr;
+
+	return status;
+}
+
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
 				 unsigned long *reserve_addr,
diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
index 9c82259eea81..59f3f83de50c 100644
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -124,3 +124,85 @@ void efi_free(unsigned long size, unsigned long addr)
 	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	efi_bs_call(free_pages, addr, nr_pages);
 }
+
+/**
+ * efi_low_alloc_above() - allocate pages at or above given address
+ * @size:	size of the memory area to allocate
+ * @align:	minimum alignment of the allocated memory area. It should
+ *		a power of two.
+ * @addr:	on exit the address of the allocated memory
+ * @min:	minimum address to used for the memory allocation
+ *
+ * Allocate at the lowest possible address that is not below @min as
+ * EFI_LOADER_DATA. The allocated pages are aligned according to @align but at
+ * least EFI_ALLOC_ALIGN. The first allocated page will not below the address
+ * given by @min.
+ *
+ * Return:	status code
+ */
+efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
+				 unsigned long *addr, unsigned long min)
+{
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
+	efi_status_t status;
+	unsigned long nr_pages;
+	int i;
+
+	status = efi_get_memory_map(&map, false);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	/*
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints.
+	 */
+	if (align < EFI_ALLOC_ALIGN)
+		align = EFI_ALLOC_ALIGN;
+
+	size = round_up(size, EFI_ALLOC_ALIGN);
+	nr_pages = size / EFI_PAGE_SIZE;
+	for (i = 0; i < map->map_size / map->desc_size; i++) {
+		efi_memory_desc_t *desc;
+		unsigned long m = (unsigned long)map->map;
+		u64 start, end;
+
+		desc = efi_memdesc_ptr(m, map->desc_size, i);
+
+		if (desc->type != EFI_CONVENTIONAL_MEMORY)
+			continue;
+
+		if (desc->attribute & EFI_MEMORY_HOT_PLUGGABLE)
+			continue;
+
+		if (efi_soft_reserve_enabled() &&
+		    (desc->attribute & EFI_MEMORY_SP))
+			continue;
+
+		if (desc->num_pages < nr_pages)
+			continue;
+
+		start = desc->phys_addr;
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
+
+		if (start < min)
+			start = min;
+
+		start = round_up(start, align);
+		if ((start + size) > end)
+			continue;
+
+		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
+				     EFI_LOADER_DATA, nr_pages, &start);
+		if (status == EFI_SUCCESS) {
+			*addr = start;
+			break;
+		}
+	}
+
+	if (i == map->map_size / map->desc_size)
+		return EFI_NOT_FOUND;
+
+	return EFI_SUCCESS;
+}
diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/efi/libstub/relocate.c
deleted file mode 100644
index d4264bfb6dc1..000000000000
--- a/drivers/firmware/efi/libstub/relocate.c
+++ /dev/null
@@ -1,166 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <linux/efi.h>
-#include <asm/efi.h>
-
-#include "efistub.h"
-
-/**
- * efi_low_alloc_above() - allocate pages at or above given address
- * @size:	size of the memory area to allocate
- * @align:	minimum alignment of the allocated memory area. It should
- *		a power of two.
- * @addr:	on exit the address of the allocated memory
- * @min:	minimum address to used for the memory allocation
- *
- * Allocate at the lowest possible address that is not below @min as
- * EFI_LOADER_DATA. The allocated pages are aligned according to @align but at
- * least EFI_ALLOC_ALIGN. The first allocated page will not below the address
- * given by @min.
- *
- * Return:	status code
- */
-efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
-				 unsigned long *addr, unsigned long min)
-{
-	struct efi_boot_memmap *map __free(efi_pool) = NULL;
-	efi_status_t status;
-	unsigned long nr_pages;
-	int i;
-
-	status = efi_get_memory_map(&map, false);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	/*
-	 * Enforce minimum alignment that EFI or Linux requires when
-	 * requesting a specific address.  We are doing page-based (or
-	 * larger) allocations, and both the address and size must meet
-	 * alignment constraints.
-	 */
-	if (align < EFI_ALLOC_ALIGN)
-		align = EFI_ALLOC_ALIGN;
-
-	size = round_up(size, EFI_ALLOC_ALIGN);
-	nr_pages = size / EFI_PAGE_SIZE;
-	for (i = 0; i < map->map_size / map->desc_size; i++) {
-		efi_memory_desc_t *desc;
-		unsigned long m = (unsigned long)map->map;
-		u64 start, end;
-
-		desc = efi_memdesc_ptr(m, map->desc_size, i);
-
-		if (desc->type != EFI_CONVENTIONAL_MEMORY)
-			continue;
-
-		if (desc->attribute & EFI_MEMORY_HOT_PLUGGABLE)
-			continue;
-
-		if (efi_soft_reserve_enabled() &&
-		    (desc->attribute & EFI_MEMORY_SP))
-			continue;
-
-		if (desc->num_pages < nr_pages)
-			continue;
-
-		start = desc->phys_addr;
-		end = start + desc->num_pages * EFI_PAGE_SIZE;
-
-		if (start < min)
-			start = min;
-
-		start = round_up(start, align);
-		if ((start + size) > end)
-			continue;
-
-		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
-				     EFI_LOADER_DATA, nr_pages, &start);
-		if (status == EFI_SUCCESS) {
-			*addr = start;
-			break;
-		}
-	}
-
-	if (i == map->map_size / map->desc_size)
-		return EFI_NOT_FOUND;
-
-	return EFI_SUCCESS;
-}
-
-/**
- * efi_relocate_kernel() - copy memory area
- * @image_addr:		pointer to address of memory area to copy
- * @image_size:		size of memory area to copy
- * @alloc_size:		minimum size of memory to allocate, must be greater or
- *			equal to image_size
- * @preferred_addr:	preferred target address
- * @alignment:		minimum alignment of the allocated memory area. It
- *			should be a power of two.
- * @min_addr:		minimum target address
- *
- * Copy a memory area to a newly allocated memory area aligned according
- * to @alignment but at least EFI_ALLOC_ALIGN. If the preferred address
- * is not available, the allocated address will not be below @min_addr.
- * On exit, @image_addr is updated to the target copy address that was used.
- *
- * This function is used to copy the Linux kernel verbatim. It does not apply
- * any relocation changes.
- *
- * Return:		status code
- */
-efi_status_t efi_relocate_kernel(unsigned long *image_addr,
-				 unsigned long image_size,
-				 unsigned long alloc_size,
-				 unsigned long preferred_addr,
-				 unsigned long alignment,
-				 unsigned long min_addr)
-{
-	unsigned long cur_image_addr;
-	unsigned long new_addr = 0;
-	efi_status_t status;
-	unsigned long nr_pages;
-	efi_physical_addr_t efi_addr = preferred_addr;
-
-	if (!image_addr || !image_size || !alloc_size)
-		return EFI_INVALID_PARAMETER;
-	if (alloc_size < image_size)
-		return EFI_INVALID_PARAMETER;
-
-	cur_image_addr = *image_addr;
-
-	/*
-	 * The EFI firmware loader could have placed the kernel image
-	 * anywhere in memory, but the kernel has restrictions on the
-	 * max physical address it can run at.  Some architectures
-	 * also have a preferred address, so first try to relocate
-	 * to the preferred address.  If that fails, allocate as low
-	 * as possible while respecting the required alignment.
-	 */
-	nr_pages = round_up(alloc_size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
-	status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
-			     EFI_LOADER_DATA, nr_pages, &efi_addr);
-	new_addr = efi_addr;
-	/*
-	 * If preferred address allocation failed allocate as low as
-	 * possible.
-	 */
-	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc_above(alloc_size, alignment, &new_addr,
-					     min_addr);
-	}
-	if (status != EFI_SUCCESS) {
-		efi_err("Failed to allocate usable memory for kernel.\n");
-		return status;
-	}
-
-	/*
-	 * We know source/dest won't overlap since both memory ranges
-	 * have been allocated by UEFI, so we can safely use memcpy.
-	 */
-	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
-
-	/* Return the new address of the relocated image. */
-	*image_addr = new_addr;
-
-	return status;
-}
-- 
2.54.0.545.g6539524ca2-goog

