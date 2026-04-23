Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A30365A00
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957678; cv=none; b=BBegEYNr7XjAYI0dduRvlsmiSNfzEFpWFMr95DkNhov7hRzHZHS9AICHMncj5UAbBGZQtI/HrAtLpmMJ2IHpg/cVdGKvA2z20/2Fo2aMkq/CAy7pzMOKuGm+75LRP+3LQZ9av5OyaBPsyrTCYPAPvFwz2NYRm1k2DsOlGuru+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957678; c=relaxed/simple;
	bh=6UTg2nGC4iZqxbau1FIEpRP2Pc8beHmLnbPtrGexZpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FXn4Wk/Dy1pR8LWYcL2TI4PajnytaoknnsTflc4ukoYJUxr6dZqtd52WqbH9JNVGCGUwaQx/gDlGwizN3Xw5AGhmVhgUQk/6wKnF6L5CZ8J8pIP+10xlkPMVUWf2iLnFgM2Hn6asXtVCAUxBtBg+zTHmfG1AI9lJXFKM54wXpqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bEb5H1vK; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bEb5H1vK"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-678a526f24aso14499a12.3
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957675; x=1777562475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SuIowFjMZ4cjeA3ecCqoefzK6wmJDnxO5W9+odyl7wM=;
        b=bEb5H1vKIHLcCtO0/gceqDtb7czfdxT5RPKVro/mehdrumC1ecCHnODsTvydUsg9nV
         EtE1yW9msgweTtTSGFuqTBHwLEMRBrvWixaLFv0Y0o9a8PnoAQlWp6w7jr6Yi1cj9qZh
         lKzu0plclgTzgzN3KZygnA6k+StFV3J7hFHRVTOGmMP40zjuM93zP1MSy78JKvyQQ0Sy
         4o6AlrcI/k0rP+G5/00b9zcIWPlwv3Be4KVlnwXegLSnK279lMEQD+KQKMNkRSlBbvFy
         mP3NYwXvsDt2xG08UqrbZ6XsIL7KI7T3effWcFR3tq6F3lXh/05J/cIhQHFOqUEpY1Rc
         5EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957675; x=1777562475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SuIowFjMZ4cjeA3ecCqoefzK6wmJDnxO5W9+odyl7wM=;
        b=a2bflMthR6hywKx3axwDP6bmwIpZMHcVhPC3AucdOl0T6QXVbtUVDAQ/7aTDF2uLXq
         zzxa3LatLjEnwMEGIz78n3nWj0LERbTOmyRm4hmYXZtQy4r3a3x8mmGwIk6xb12V705C
         50c29GB2NKGmY6o8s1x6Pnerp/LICnDXgz8H4dHjTX045y8bMcNyEY9LhXfQkmHUW7/n
         7XCl5r8IGRJ5PS+R5BYjuOWS3SzS2QzwKe2v9uEg1OUBUzqaDTZG5Z362SL/V4FME5G6
         MCyOfS4Lmlh0g62BiClGSExZHy3ys/F5N7sXqyYLMW13s0h/wQ9zTaSL9gfHbsnh8UvY
         YN8g==
X-Gm-Message-State: AOJu0Yzq4QY0YnuId2T6AI8FYRsPh3uS8+3saTgpofCk3rqQXMjBlHA8
	OYfgU0TWLW7hZlDbCbjbhP6Xpj2ow2Ula1MJbL3a0H8bRpOhL5QAjqtDp+ulweFjnZp5UpLckg=
	=
X-Received: from edcz15.prod.google.com ([2002:a05:6402:35cf:b0:678:93c2:af38])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:90b:b0:66e:41a9:1198
 with SMTP id 4fb4d7f45d1cf-672bfdd9dc0mr12404769a12.22.1776957674861; Thu, 23
 Apr 2026 08:21:14 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:39 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8508; i=ardb@kernel.org;
 h=from:subject; bh=mY2wIGuTZxHT+BE9hZpFmkeVJsQQEn8VQ5qRxln43xk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxdlzknN2/Gq/FSio+zA8uPN8mfcNxvbL2itP+c85y
 Oi2+t6zjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRoz0Mf0VVtU8azwg54/r0
 sA9bg8ckjjuTs3fl5i5YJV7N1ddYs4aRYfO+os9LHx5U79k/qZ7L4otijLpu2t1anz8q6bzMsVO Z2QA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-33-ardb+git@google.com>
Subject: [PATCH v3 14/17] x86/efi: Reuse memory map instead of reallocating it
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The EFI memory map consists of 10s to 100s of entries of around 40 bytes
each. The initial version is allocated and populated by the EFI stub,
but later on, after freeing the boot services data regions and pruning
the associated entries, a new memory map is allocated with room for only
the remaining entries, which are typically much fewer in number.

Given that the original allocation is never freed, this does not
actually save any memory currently, and it is much simpler to just move
the entries that need to be preserved to the beginning of the map, and
truncate it. That way, a lot of the complicated memory map allocation
and freeing code can simply be dropped.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h     |   5 -
 arch/x86/platform/efi/Makefile |   2 +-
 arch/x86/platform/efi/memmap.c | 109 --------------------
 arch/x86/platform/efi/quirks.c |  35 +------
 include/linux/efi.h            |   5 +-
 5 files changed, 7 insertions(+), 149 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7d8f627805df..0de92193764b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -398,11 +398,6 @@ static inline void efi_reserve_boot_services(void)
 }
 #endif /* CONFIG_EFI */
 
-extern int __init efi_memmap_alloc(unsigned int num_entries,
-				   struct efi_memory_map_data *data);
-
-extern int __init efi_memmap_install(struct efi_memory_map_data *data);
-
 enum efi_secureboot_mode __x86_efi_boot_mode(void);
 
 #define arch_efi_boot_mode __x86_efi_boot_mode()
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 500cab4a7f7c..28772e046a1b 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -2,7 +2,7 @@
 KASAN_SANITIZE := n
 GCOV_PROFILE := n
 
-obj-$(CONFIG_EFI) 		+= memmap.o quirks.o efi.o efi_$(BITS).o \
+obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o \
 				   efi_stub_$(BITS).o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
 obj-$(CONFIG_EFI_RUNTIME_MAP)	+= runtime-map.o
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
deleted file mode 100644
index 524e9f2ef276..000000000000
--- a/arch/x86/platform/efi/memmap.c
+++ /dev/null
@@ -1,109 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Common EFI memory map functions.
- */
-
-#define pr_fmt(fmt) "efi: " fmt
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/efi.h>
-#include <linux/io.h>
-#include <asm/early_ioremap.h>
-#include <asm/efi.h>
-#include <linux/memblock.h>
-#include <linux/slab.h>
-
-static phys_addr_t __init __efi_memmap_alloc_early(unsigned long size)
-{
-	return memblock_phys_alloc(size, SMP_CACHE_BYTES);
-}
-
-static phys_addr_t __init __efi_memmap_alloc_late(unsigned long size)
-{
-	unsigned int order = get_order(size);
-	struct page *p = alloc_pages(GFP_KERNEL, order);
-
-	if (!p)
-		return 0;
-
-	return PFN_PHYS(page_to_pfn(p));
-}
-
-static
-void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
-{
-	if (flags & EFI_MEMMAP_MEMBLOCK) {
-		memblock_phys_free(phys, size);
-	} else if (flags & EFI_MEMMAP_SLAB) {
-		struct page *p = pfn_to_page(PHYS_PFN(phys));
-		unsigned int order = get_order(size);
-
-		__free_pages(p, order);
-	}
-}
-
-/**
- * efi_memmap_alloc - Allocate memory for the EFI memory map
- * @num_entries: Number of entries in the allocated map.
- * @data: efi memmap installation parameters
- *
- * Depending on whether mm_init() has already been invoked or not,
- * either memblock or "normal" page allocation is used.
- *
- * Returns zero on success, a negative error code on failure.
- */
-int __init efi_memmap_alloc(unsigned int num_entries,
-		struct efi_memory_map_data *data)
-{
-	/* Expect allocation parameters are zero initialized */
-	WARN_ON(data->phys_map || data->size);
-
-	data->size = num_entries * efi.memmap.desc_size;
-	data->desc_version = efi.memmap.desc_version;
-	data->desc_size = efi.memmap.desc_size;
-	data->flags &= ~(EFI_MEMMAP_SLAB | EFI_MEMMAP_MEMBLOCK);
-	data->flags |= efi.memmap.flags & EFI_MEMMAP_LATE;
-
-	if (slab_is_available()) {
-		data->flags |= EFI_MEMMAP_SLAB;
-		data->phys_map = __efi_memmap_alloc_late(data->size);
-	} else {
-		data->flags |= EFI_MEMMAP_MEMBLOCK;
-		data->phys_map = __efi_memmap_alloc_early(data->size);
-	}
-
-	if (!data->phys_map)
-		return -ENOMEM;
-	return 0;
-}
-
-/**
- * efi_memmap_install - Install a new EFI memory map in efi.memmap
- * @data: efi memmap installation parameters
- *
- * Unlike efi_memmap_init_*(), this function does not allow the caller
- * to switch from early to late mappings. It simply uses the existing
- * mapping function and installs the new memmap.
- *
- * Returns zero on success, a negative error code on failure.
- */
-int __init efi_memmap_install(struct efi_memory_map_data *data)
-{
-	unsigned long size = efi.memmap.map_end - efi.memmap.map;
-	unsigned long flags = efi.memmap.flags;
-	u64 phys = efi.memmap.phys_map;
-	int ret;
-
-	efi_memmap_unmap();
-
-	if (efi_enabled(EFI_PARAVIRT))
-		return 0;
-
-	ret = __efi_memmap_init(data);
-	if (ret)
-		return ret;
-
-	__efi_memmap_free(phys, size, flags);
-	return 0;
-}
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index eb00130bcb66..98fdc286eb40 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -401,10 +401,8 @@ static int __init efi_add_range_to_free(u64 range_start, u64 range_end,
 
 void __init efi_unmap_boot_services(void)
 {
-	struct efi_memory_map_data data = { 0 };
 	efi_memory_desc_t *md;
-	int num_entries = 0;
-	void *new, *new_md;
+	void *new_md;
 
 	/* Keep all regions for /sys/kernel/debug/efi */
 	if (efi_enabled(EFI_DBG))
@@ -425,7 +423,6 @@ void __init efi_unmap_boot_services(void)
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
-			num_entries++;
 			continue;
 		}
 
@@ -438,7 +435,6 @@ void __init efi_unmap_boot_services(void)
 
 		/* Do not free, someone else owns it: */
 		if (md->attribute & EFI_MEMORY_RUNTIME) {
-			num_entries++;
 			continue;
 		}
 
@@ -452,23 +448,6 @@ void __init efi_unmap_boot_services(void)
 			pr_err("Failed to reallocate storage for freeable EFI regions\n");
 			return;
 		}
-
-		if (has_reservations)
-			num_entries++;
-	}
-
-	if (!num_entries)
-		return;
-
-	if (efi_memmap_alloc(num_entries, &data) != 0) {
-		pr_err("Failed to allocate new EFI memmap\n");
-		return;
-	}
-
-	new = memremap(data.phys_map, data.size, MEMREMAP_WB);
-	if (!new) {
-		pr_err("Failed to map new EFI memmap\n");
-		return;
 	}
 
 	/*
@@ -476,7 +455,7 @@ void __init efi_unmap_boot_services(void)
 	 * regions that are not tagged EFI_MEMORY_RUNTIME, since those
 	 * regions have now been freed.
 	 */
-	new_md = new;
+	new_md = efi.memmap.map;
 	for_each_efi_memory_desc(md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
 		    (md->type == EFI_BOOT_SERVICES_CODE ||
@@ -486,16 +465,12 @@ void __init efi_unmap_boot_services(void)
 			continue;
 		}
 
-		memcpy(new_md, md, efi.memmap.desc_size);
+		if (new_md != md)
+			memcpy(new_md, md, efi.memmap.desc_size);
 		new_md += efi.memmap.desc_size;
 	}
 
-	memunmap(new);
-
-	if (efi_memmap_install(&data) != 0) {
-		pr_err("Could not install new EFI memmap\n");
-		return;
-	}
+	efi.memmap.num_valid_entries = (new_md - efi.memmap.map) / efi.memmap.desc_size;
 }
 
 static int __init efi_free_boot_services(void)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a8406ca92332..5986e565a249 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -553,8 +553,7 @@ struct efi_unaccepted_memory {
 
 /*
  * Architecture independent structure for describing a memory map for the
- * benefit of efi_memmap_init_early(), and for passing context between
- * efi_memmap_alloc() and efi_memmap_install().
+ * benefit of efi_memmap_init_early().
  */
 struct efi_memory_map_data {
 	phys_addr_t phys_map;
@@ -572,8 +571,6 @@ struct efi_memory_map {
 	unsigned long desc_version;
 	unsigned long desc_size;
 #define EFI_MEMMAP_LATE (1UL << 0)
-#define EFI_MEMMAP_MEMBLOCK (1UL << 1)
-#define EFI_MEMMAP_SLAB (1UL << 2)
 	unsigned long flags;
 };
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

