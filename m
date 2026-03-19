Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317163B8921
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911183; cv=none; b=Z0RtXmMUl9H7P5AU9i+byLuFeKCUknQ98QIJ5AnSJNBFNs0jzdvowt2sZjK4xgp3AO1r6jZMQ2kbnrDir3oyiKaASTDAJBSpxElR3co6ubBa5VJp2Z8qzoE9H3i4627gYUFfVujMrhPV7F+9UZ2+Oa5kQGMOmH7vyjnSgvywuVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911183; c=relaxed/simple;
	bh=t3nPoGOyUjM7hYdKWk6iAYk/xsxkEy+tCPQyZ8JyK60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZ0Mc5wifFiAxALec8hHiPFcrjuFRqBzmmPykrIZi+4J0fiuX6EWTxuTV7wEMQRlPAPB1DSeh/pYkhh2vjdx1B/5Deg+EwSU6sDZy+TJJmj0yB6Y1Z+5bKP8+nLj4Io+ZBV5T9HvWwiGwcBf9skbuvg1Q7LZnO3ZaP1DBvbASTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a8c4DMRA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a8c4DMRA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48535f4d5e1so6696475e9.0
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911179; x=1774515979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nLbx4kYoDNEcWBWJkoMx59qTYGPcW/RbepHiDjr2l9w=;
        b=a8c4DMRAXRZZsuolnX6oRwjezlmnquQm5JkZ8Cp0nEYcftgc2+gmEUY5sE291qC16t
         xmDOnsnxxJ0OjjOo7Nr2OBo8UQTznrArPpdpwkGLaZOPNaPRWsSiBeXCzteRNkVkxx9M
         E9D1g1+adCQy1fQq3mCa3rHJm1BhNOKAVerfdPnDjVtfIHhepnZQm7hd4k6BD/XMAR62
         34PDhnWbeo5FObkHK3eIp0DkSJw9Mo7bMCOczgoQQaR3AgmDCH6leT9qYR9m83Gx7Ndp
         cbwqKaKuoO8Eb6p/Zkb2fwvQ+e/BUraNbC7SpYJ3jpOs0I3ftksoKaPv/RiLIZkRLYbf
         xoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911179; x=1774515979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLbx4kYoDNEcWBWJkoMx59qTYGPcW/RbepHiDjr2l9w=;
        b=FVZt22/yUuMm84eJqHlE/KjbtJYJYR7jumLIzC1APnGyjRHxrXNMX76EprUuBTliQr
         yJ6E1YrLaiYGaUzMzPfiCFJxKotrOpG1tYjP0Qmo8yPGKdc74xrP/p/44ssRnkiqIUgX
         5yCGdkV+UaIeX5+7EGn6pNvZLuQaumSKi2er2shEfJttc3RmBTxp/Ep8gYM728Hs19y7
         PlHJTT2ytj0sJfN3VvW/beWTNXsmE2n64XKIFtB/TZoZ1l6wPL4575Mvv8SJxbAruXn7
         AJ8V4shb8ANFSE5ZLj88CCSHX0RRIqlBGyOGKlmwT7qeSpRbqGdSTLIQKVPET4wPwrgB
         Mi4g==
X-Gm-Message-State: AOJu0Yzsj8eoT+EctP5FZcfMjbTjx5QKI9eXocRx0a81RfZKt48enhEh
	SIY0ij+5Rr1fxivrYkmEnqK3hfAL5GGrJa3ZwtHBmVcC7CoYo4oXlVct96iYhOIEJxqPyiYlQw=
	=
X-Received: from wmdd6.prod.google.com ([2002:a05:600c:a206:b0:485:3f38:3dd2])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b95:b0:486:fc46:be9e
 with SMTP id 5b1f17b1804b1-486fc46c095mr12817435e9.24.1773911179440; Thu, 19
 Mar 2026 02:06:19 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:46 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8551; i=ardb@kernel.org;
 h=from:subject; bh=WbQDZgAuzEkcDHmpW7jdUizVT209J0oavj2ncp5TycQ=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGm7vG6gdoNi8n4/Q9w++NnvTrfzQHIW/IagFmcE96HWm1dtV
 Ih1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmm7vG4ACgkQMG4JVi59LVx0JwD+Ksoc
 DlvEzSIjnSSSSvgr4/2kKWaJ0mnFScvYmGYTqykBAKvh2UPqDhm5xcD9IXG3TVeTjgQ1WDYRsgy FEb3SNaEP
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-37-ardb+git@google.com>
Subject: [PATCH v2 16/19] x86/efi: Reuse memory map instead of reallocating it
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
 arch/x86/platform/efi/memmap.c | 112 --------------------
 arch/x86/platform/efi/quirks.c |  30 +-----
 include/linux/efi.h            |   5 +-
 5 files changed, 6 insertions(+), 148 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 44cdd3c1055e..f21b9e85f544 100644
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
 extern enum efi_secureboot_mode __x86_ima_efi_boot_mode(void);
 
 #define arch_ima_efi_boot_mode	__x86_ima_efi_boot_mode()
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
index fa580c4122c4..000000000000
--- a/arch/x86/platform/efi/memmap.c
+++ /dev/null
@@ -1,112 +0,0 @@
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
-		if (slab_is_available())
-			memblock_free_late(phys, size);
-		else
-			memblock_phys_free(phys, size);
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
index eecaa745d352..dc90c35480f8 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -356,12 +356,10 @@ static struct efi_freeable_range *ranges_to_free;
 
 void __init efi_unmap_boot_services(void)
 {
-	struct efi_memory_map_data data = { 0 };
 	efi_memory_desc_t *md;
-	int num_entries = 0;
+	void *new_md;
 	int idx = 0;
 	size_t sz;
-	void *new, *new_md;
 
 	/* Keep all regions for /sys/kernel/debug/efi */
 	if (efi_enabled(EFI_DBG))
@@ -374,13 +372,13 @@ void __init efi_unmap_boot_services(void)
 		return;
 	}
 
+	new_md = efi.memmap.map;
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
-			num_entries++;
 			continue;
 		}
 
@@ -394,7 +392,6 @@ void __init efi_unmap_boot_services(void)
 		/* Do not free, someone else owns it: */
 		if ((md->attribute & EFI_MEMORY_RUNTIME) ||
 		    !can_free_region(start, size)) {
-			num_entries++;
 			continue;
 		}
 
@@ -409,26 +406,12 @@ void __init efi_unmap_boot_services(void)
 		idx++;
 	}
 
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
-	}
-
 	/*
 	 * Build a new EFI memmap that excludes any boot services
 	 * regions that are not tagged EFI_MEMORY_RUNTIME, since those
 	 * regions have now been freed.
 	 */
-	new_md = new;
+	new_md = efi.memmap.map;
 	for_each_efi_memory_desc(md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
 		    (md->type == EFI_BOOT_SERVICES_CODE ||
@@ -442,12 +425,7 @@ void __init efi_unmap_boot_services(void)
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
 
 static unsigned long __init
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b0c3e9648126..58279538d9d8 100644
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
2.53.0.851.ga537e3e6e9-goog

