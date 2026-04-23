Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159D13793B8
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957674; cv=none; b=SYQT8Kqk0UCcWXCuHucfVilcGJLtb7fvbUeDK1FeSgBj7pVRzjSEpvTUbHIyQYPXngfiZ4Ao4gm/EEfoX4372Br3u6OcPJQh8ROM5yO729zgM6JPIm/tpV/OklP2HELK4l55u+rkQhsAMo7x/Ye2WtPj32KCkE359PgdX3w465s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957674; c=relaxed/simple;
	bh=QJhcTCp3YWRk82k5dY7bOrapMMe8ofCD/shtK0L/ecw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dnzxQQMVvWLD4UYT+QYGAgFYP9Ofnvabxh+hYayUO+eDYT87uvnR+IJXvf2EJHBab77cnnPvK/fqjK/dgHAOnT4QAosa52EyvkCajFX/+1NXIqsOYnkzvcEcsBZJmLixv+wqQqFWKo8HdgGmaIdWHbjKXcha4xQ5cSQohNihwn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SEFpaJp5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SEFpaJp5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a5523fd53so18201445e9.3
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957672; x=1777562472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rm/hickqQysiSynTiIHCGr3FHLXl71ce3ok8oWE0Hnc=;
        b=SEFpaJp5cXMYQe26/f7fcQaPmbWKGJ98AdbPqKHOGt1tiddPfdogUw3jBcliCERUhm
         d8AG/jebqK/qUB36UqGnCzxi968xerE1d2A66Eb73M/fq/t6pavEma90byq6St/YSePC
         TTxDJ+YekQzH/ycEQo/42GituZJJPam6p0d+0m2YabMSLnC4tVe0OydTQ9xt+1jmY3B9
         +cZHFG6PvjUf8WHuW3WsqLOBfh0e7uqBs544ST3sHGKs72GEHo1+AwRrGrkog6fkGfOR
         2rKrXRCZT/jeSpAFsrMXQEQOXSe6X/zs6Q8Tx1kxR4w78tMG08mzlKrxOb+2JNVLbSR1
         vJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957672; x=1777562472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rm/hickqQysiSynTiIHCGr3FHLXl71ce3ok8oWE0Hnc=;
        b=OfqRg7U3eJN3SdhPO1TGTVw09294grJDpp+0RepiHuEU8B5/j/RsI/7ts39t4lDLNE
         hVWPAFvbMtzosKAFPnHd/p0qZKxGczi1bneSZ7m+yzu6RqH9zwOm3dArRbDwRhAGABJ2
         Thd0FBzh7ym6Q2nKCHB58Ue9VrshuHKkg8NZp31UoKCkuy7L+SLEsL8dWHd+EkIn1sJJ
         Ze71S81zyIR0CLkT/TRHIxPUUooaYrhcDMPO6w7LZGfxun6BfFxHmoTknlkXv7O6f4DQ
         AnwORqPmWKZrLi3LEqUAIALMRBTAKVJNi3H76PhmWYi+HK0kOXi8u1hVwlImpBcrq/RJ
         IE4A==
X-Gm-Message-State: AOJu0YwOqC9lsxx5aVKjBxCDxbp5gBRu2+Oovb2kWNCTBSOti2abNh+d
	/dK1YisAKlNriP+jgmW3uAnV8AZW7ZA4s+udSibztCQFec2A3gApPZumGZDM0HLmHUmbfrxwOA=
	=
X-Received: from wmlu21.prod.google.com ([2002:a05:600c:2115:b0:488:7c5a:b238])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4707:b0:488:bfc3:efc
 with SMTP id 5b1f17b1804b1-488fb6e8eb5mr393522635e9.0.1776957671595; Thu, 23
 Apr 2026 08:21:11 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:36 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8578; i=ardb@kernel.org;
 h=from:subject; bh=n4XiAYaFtIBUTDvCKEmsnxORvxDae62lgJVzXOe0/QA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxckdRn8r9L9LN2ytNX68atpX434fC/3jjoqeX9+sX
 MD/Lyyuo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkqCvDX7nex3fFWyv9H/J/
 O2eQ1DS3/Gv4z5y0tqvGjz/fytO5YsvwP3Wylanm2tevEv9r7TD5oThvYZelZZZMZ9T+1Tt+MBU 0cgIA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-30-ardb+git@google.com>
Subject: [PATCH v3 11/17] efi: Use nr_map not map_end to find the last valid
 memory map entry
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, the efi.memmap struct keeps track of the start and the end of
the EFI memory map in memory, as well as the number of entries.

Let's repaint the nr_map field as the number of *valid* entries, and
update all the iterators and other memory map traversal routines
accordingly.

This allows pruning of invalid or unneeded entries by moving the
remaining entries to the start of the map, without the need for
freeing/reallocating or unmapping and remapping. Now that entries are
never added, but only removed, it is possible to retain the same
allocation throughout the boot process, and free the part that is no
longer in use afterwards.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c          | 18 ++++++++++++------
 arch/x86/platform/efi/memmap.c       |  2 +-
 arch/x86/platform/efi/quirks.c       |  2 +-
 arch/x86/platform/efi/runtime-map.c  |  4 ++--
 drivers/firmware/efi/arm-runtime.c   |  2 +-
 drivers/firmware/efi/memmap.c        |  8 +++-----
 drivers/firmware/efi/riscv-runtime.c |  2 +-
 include/linux/efi.h                  |  8 ++++----
 8 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c0195b5eab21..edbf6efe3947 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -222,7 +222,7 @@ int __init efi_memblock_x86_reserve_range(void)
 	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
 	     efi.memmap.desc_version);
 
-	memblock_reserve(pmap, efi.memmap.nr_map * efi.memmap.desc_size);
+	memblock_reserve(pmap, efi.memmap.num_valid_entries * efi.memmap.desc_size);
 	set_bit(EFI_PRESERVE_BS_REGIONS, &efi.flags);
 
 	return 0;
@@ -289,7 +289,7 @@ static void __init efi_clean_memmap(void)
 			.phys_map	= efi.memmap.phys_map,
 			.desc_version	= efi.memmap.desc_version,
 			.desc_size	= efi.memmap.desc_size,
-			.size		= efi.memmap.desc_size * (efi.memmap.nr_map - n_removal),
+			.size		= efi.memmap.desc_size * (efi.memmap.num_valid_entries - n_removal),
 			.flags		= 0,
 		};
 
@@ -533,7 +533,8 @@ static inline void *efi_map_next_entry_reverse(void *entry)
 {
 	/* Initial call */
 	if (!entry)
-		return efi.memmap.map_end - efi.memmap.desc_size;
+		return efi_memdesc_ptr(efi.memmap.map, efi.memmap.desc_size,
+				       efi.memmap.num_valid_entries - 1);
 
 	entry -= efi.memmap.desc_size;
 	if (entry < efi.memmap.map)
@@ -555,6 +556,9 @@ static inline void *efi_map_next_entry_reverse(void *entry)
  */
 static void *efi_map_next_entry(void *entry)
 {
+	if (!efi.memmap.num_valid_entries)
+		return NULL;
+
 	if (efi_enabled(EFI_64BIT)) {
 		/*
 		 * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
@@ -581,7 +585,9 @@ static void *efi_map_next_entry(void *entry)
 		return efi.memmap.map;
 
 	entry += efi.memmap.desc_size;
-	if (entry >= efi.memmap.map_end)
+	if (entry >= (void *)efi_memdesc_ptr(efi.memmap.map,
+					     efi.memmap.desc_size,
+					     efi.memmap.num_valid_entries))
 		return NULL;
 
 	return entry;
@@ -712,13 +718,13 @@ static void __init kexec_enter_virtual_mode(void)
 	efi_memmap_unmap();
 
 	if (efi_memmap_init_late(efi.memmap.phys_map,
-				 efi.memmap.desc_size * efi.memmap.nr_map)) {
+				 efi.memmap.desc_size * efi.memmap.num_valid_entries)) {
 		pr_err("Failed to remap late EFI memory map\n");
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
-	num_pages = ALIGN(efi.memmap.nr_map * efi.memmap.desc_size, PAGE_SIZE);
+	num_pages = ALIGN(efi.memmap.num_valid_entries * efi.memmap.desc_size, PAGE_SIZE);
 	num_pages >>= PAGE_SHIFT;
 
 	if (efi_setup_page_tables(efi.memmap.phys_map, num_pages)) {
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index da7483a33d68..524e9f2ef276 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -90,7 +90,7 @@ int __init efi_memmap_alloc(unsigned int num_entries,
  */
 int __init efi_memmap_install(struct efi_memory_map_data *data)
 {
-	unsigned long size = efi.memmap.desc_size * efi.memmap.nr_map;
+	unsigned long size = efi.memmap.map_end - efi.memmap.map;
 	unsigned long flags = efi.memmap.flags;
 	u64 phys = efi.memmap.phys_map;
 	int ret;
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index efb828b7e2ab..eb00130bcb66 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -410,7 +410,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	num_to_free = efi.memmap.nr_map;
+	num_to_free = efi.memmap.num_valid_entries;
 	ranges_to_free = kmalloc_array(num_to_free, sizeof(ranges_to_free[0]),
 				       GFP_KERNEL);
 	if (!ranges_to_free) {
diff --git a/arch/x86/platform/efi/runtime-map.c b/arch/x86/platform/efi/runtime-map.c
index 053ff161eb9a..fc8ca1974730 100644
--- a/arch/x86/platform/efi/runtime-map.c
+++ b/arch/x86/platform/efi/runtime-map.c
@@ -138,7 +138,7 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr,
 
 int efi_get_runtime_map_size(void)
 {
-	return efi.memmap.nr_map * efi.memmap.desc_size;
+	return efi.memmap.num_valid_entries * efi.memmap.desc_size;
 }
 
 int efi_get_runtime_map_desc_size(void)
@@ -166,7 +166,7 @@ static int __init efi_runtime_map_init(void)
 	if (!efi_enabled(EFI_MEMMAP) || !efi_kobj)
 		return 0;
 
-	map_entries = kzalloc_objs(entry, efi.memmap.nr_map);
+	map_entries = kzalloc_objs(entry, efi.memmap.num_valid_entries);
 	if (!map_entries) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 3167cab62014..e19997c09175 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -96,7 +96,7 @@ static int __init arm_enable_runtime_services(void)
 
 	efi_memmap_unmap();
 
-	mapsize = efi.memmap.desc_size * efi.memmap.nr_map;
+	mapsize = efi.memmap.desc_size * efi.memmap.num_valid_entries;
 
 	if (efi_memmap_init_late(efi.memmap.phys_map, mapsize)) {
 		pr_err("Failed to remap EFI memory map\n");
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index f1c04d7cfd71..035089791c93 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -49,7 +49,7 @@ int __init __efi_memmap_init(struct efi_memory_map_data *data)
 	}
 
 	map.phys_map = data->phys_map;
-	map.nr_map = data->size / data->desc_size;
+	map.num_valid_entries = data->size / data->desc_size;
 	map.map_end = map.map + data->size;
 
 	map.desc_version = data->desc_version;
@@ -87,10 +87,8 @@ void __init efi_memmap_unmap(void)
 		return;
 
 	if (!(efi.memmap.flags & EFI_MEMMAP_LATE)) {
-		unsigned long size;
-
-		size = efi.memmap.desc_size * efi.memmap.nr_map;
-		early_memunmap(efi.memmap.map, size);
+		early_memunmap(efi.memmap.map,
+			       efi.memmap.map_end - efi.memmap.map);
 	} else {
 		memunmap(efi.memmap.map);
 	}
diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
index 60cdf7bf141f..087a7f8a74e6 100644
--- a/drivers/firmware/efi/riscv-runtime.c
+++ b/drivers/firmware/efi/riscv-runtime.c
@@ -66,7 +66,7 @@ static int __init riscv_enable_runtime_services(void)
 
 	efi_memmap_unmap();
 
-	mapsize = efi.memmap.desc_size * efi.memmap.nr_map;
+	mapsize = efi.memmap.desc_size * efi.memmap.num_valid_entries;
 
 	if (efi_memmap_init_late(efi.memmap.phys_map, mapsize)) {
 		pr_err("Failed to remap EFI memory map\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 72e76ec54641..a8406ca92332 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -568,7 +568,7 @@ struct efi_memory_map {
 	phys_addr_t phys_map;
 	void *map;
 	void *map_end;
-	int nr_map;
+	int num_valid_entries;
 	unsigned long desc_version;
 	unsigned long desc_size;
 #define EFI_MEMMAP_LATE (1UL << 0)
@@ -803,9 +803,9 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
-	for ((md) = (m)->map;						   \
-	     (md) && ((void *)(md) + (m)->desc_size) <= (m)->map_end;	   \
-	     (md) = (void *)(md) + (m)->desc_size)
+	for (int __idx = 0;						   \
+	     (md) = efi_memdesc_ptr((m)->map, (m)->desc_size, __idx),	   \
+	     __idx < (m)->num_valid_entries; ++__idx)
 
 /**
  * for_each_efi_memory_desc - iterate over descriptors in efi.memmap
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

