Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39763B47D3
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911178; cv=none; b=NyPzqNmB3laFzNEPoGRA7FcQLkEvr1SQsDR0Q/tYacTvpFLnIQUznUIQZUWTcSVsZc19Uw3BoIryu/MUsuK1S6v+e8Dxof4KdMXw0j2MNMN/XfJBWaqwBcI83S4mkNrpLFBXgk+9xXVmbOKiOgBd3cgz13had3vJawJLAfxkAdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911178; c=relaxed/simple;
	bh=uAp3bNwnj43nm1d/5FZow5go2uc2Pe86fT9wiWD6Jws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qgHIGUiZPWGhjbWCORJyO0EbSD94dWeoHuSb8vRB0tID2dyvo+XoyRb8BJQuUxgvNFNRECeOVj6Tkv3arC8Z4CvcSktcskLuyC7D0WvJ+uTi2YZcgNwna/JMeY8wQX0+SIRGua6U/+eQbL8KuM3y1gBwQtcq/keYI6hsAkmLeHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iDbZq4tD; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDbZq4tD"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b4e102d77so266629f8f.1
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911174; x=1774515974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hvWEMBG1+vtssKaXaA+A+ef2cjhNjvbnMsrhKNB1E1M=;
        b=iDbZq4tDWCugl/DsJ9+j3Eb/dfDT4UywvEoQiSK79kuow0fQMdI8zQdgLGL7zVKPGf
         STAnzBsXFFMaJDs+rQb5Xsh9rJRa/S1BixvQw+AnW0C6wxNdMyiaVejtkaaOnLjFUL9M
         ssA+vlbitgtIqxKsFWeUNquD0nNyaSkV0M+kLqufz8XO3/f43HxRopMeS6NImXcxqZLW
         gPk0Zz6EzK/8M+9AITXGisxJGUAehrX/oC6uFyMbHQ3rIKkwtEfapNY2fxn7GFr3RxKI
         iVm200JrC8x/P5XbhlKb8k5cB9BS0B6bUcu1v/opn5Ro10fjgIwm/bcZy9akWic2agdk
         dxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911174; x=1774515974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvWEMBG1+vtssKaXaA+A+ef2cjhNjvbnMsrhKNB1E1M=;
        b=KCavEXFuoX7MjFRtBgfDx6DOexsPCYb+LUUsjBtsBmQMlCdOnm2ZgzZIygRVKBFAhL
         LLAQp6XKAnkHSHRK8ITwEWJbmeet6hlDbYUN9PJreRMA23ezB8E5GsfkhuSPiyWyrUFL
         pbTo1RF7QKDfyy0PKvAzA5Ijt1C6iVCK13qHr3PruCucn4m+lz75dDt8emfwwBFCnjMV
         LRraG9GgVsvMEWjjJCOhuJaUB3ZREbTaa+PdkZM7hf6B5+9GjzBT2A9aeXd070hp55EQ
         G4OeVIqGEXfOsjYI9Jf++W8GjKH/90+7bH/+Na4wF7rLg9+A3mvTdd7ofSQfR8CHWCSM
         wVdA==
X-Gm-Message-State: AOJu0Yy0/NuxYm0aLeUVxYrbnNBYqqaACWAFdiX9F/C78O+lgMGF+Glh
	BPTofd1tpFtSljhvf71KZ7iuGzJb7ThUQnqx6hoAMDVYRavDwKxY5PKdviDD+A1F3LGEbU4WpQ=
	=
X-Received: from wrul18.prod.google.com ([2002:a5d:6692:0:b0:43b:45d1:f433])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d10:b0:485:3d3e:167b
 with SMTP id 5b1f17b1804b1-486f441fc5bmr105805365e9.5.1773911173849; Thu, 19
 Mar 2026 02:06:13 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:41 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=10133; i=ardb@kernel.org;
 h=from:subject; bh=kvX6bjgQom/3kqkMau2ISxTwGfxxMsz3oICe3SqhhUw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3noywwD0n+yYWzhNSefRwplS4f1PSpJdxpy45K9YFz
 AjzNg/uKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOpnsLIcDiPWeHowz+OV9ZY
 ry5MWGxotXObyXqd6QtrZruk3ff5fZjhv2vPogtblk1eZsn6wkYj+7edSmdOp9sBb52Cz6xnn9Q 3cwAA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-32-ardb+git@google.com>
Subject: [PATCH v2 11/19] efi: Use nr_map not map_end to find the last valid
 memory map entry
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

While at it, implement a version of for_each_efi_memory_desc() that
traverses the memory map in opposite order. It will be used by a
subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c          | 15 +++++++-----
 arch/x86/platform/efi/memmap.c       |  2 +-
 arch/x86/platform/efi/quirks.c       |  2 +-
 arch/x86/platform/efi/runtime-map.c  |  4 ++--
 drivers/firmware/efi/arm-runtime.c   |  2 +-
 drivers/firmware/efi/memattr.c       |  2 +-
 drivers/firmware/efi/memmap.c        |  8 +++----
 drivers/firmware/efi/riscv-runtime.c |  2 +-
 include/linux/efi.h                  | 24 ++++++++++++++++----
 9 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b60f8454a1ec..183cca8fe4a6 100644
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
 
@@ -564,7 +564,8 @@ static inline void *efi_map_next_entry_reverse(void *entry)
 {
 	/* Initial call */
 	if (!entry)
-		return efi.memmap.map_end - efi.memmap.desc_size;
+		return efi_memdesc_ptr(efi.memmap.map, efi.memmap.desc_size,
+				       efi.memmap.num_valid_entries - 1);
 
 	entry -= efi.memmap.desc_size;
 	if (entry < efi.memmap.map)
@@ -612,7 +613,9 @@ static void *efi_map_next_entry(void *entry)
 		return efi.memmap.map;
 
 	entry += efi.memmap.desc_size;
-	if (entry >= efi.memmap.map_end)
+	if (entry >= (void *)efi_memdesc_ptr(efi.memmap.map,
+					     efi.memmap.desc_size,
+					     efi.memmap.num_valid_entries))
 		return NULL;
 
 	return entry;
@@ -743,13 +746,13 @@ static void __init kexec_enter_virtual_mode(void)
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
index 8ef45014c7e7..fa580c4122c4 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -93,7 +93,7 @@ int __init efi_memmap_alloc(unsigned int num_entries,
  */
 int __init efi_memmap_install(struct efi_memory_map_data *data)
 {
-	unsigned long size = efi.memmap.desc_size * efi.memmap.nr_map;
+	unsigned long size = efi.memmap.map_end - efi.memmap.map;
 	unsigned long flags = efi.memmap.flags;
 	u64 phys = efi.memmap.phys_map;
 	int ret;
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index ae4ad6389f9e..eecaa745d352 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -367,7 +367,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * efi.memmap.num_valid_entries + 1;
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
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
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index e727cc5909cb..36f733b37df2 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -49,7 +49,7 @@ void __init efi_memattr_init(void)
 	 * just be ignored altogether.
 	 */
 	size = tbl->num_entries * tbl->desc_size;
-	if (size > 3 * efi.memmap.nr_map * efi.memmap.desc_size) {
+	if (size > 3 * efi.memmap.num_valid_entries * efi.memmap.desc_size) {
 		pr_warn(FW_BUG "Corrupted EFI Memory Attributes Table detected! (version == %u, desc_size == %u, num_entries == %u)\n",
 			tbl->version, tbl->desc_size, tbl->num_entries);
 		goto unmap;
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
index 664898d09ff5..b0c3e9648126 100644
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
@@ -803,9 +803,15 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
-	for ((md) = (m)->map;						   \
-	     (md) && ((void *)(md) + (m)->desc_size) <= (m)->map_end;	   \
-	     (md) = (void *)(md) + (m)->desc_size)
+	for (int __idx = 0;						   \
+	     (md) = efi_memdesc_ptr((m)->map, (m)->desc_size, __idx),	   \
+	     __idx < (m)->num_valid_entries; ++__idx)
+
+/* Iterate through an efi_memory_map in reverse order */
+#define for_each_efi_memory_desc_in_map_rev(m, md)			   \
+	for (int __idx = (m)->num_valid_entries - 1;			   \
+	     (md) = efi_memdesc_ptr((m)->map, (m)->desc_size, __idx),	   \
+	     __idx >= 0; --__idx)
 
 /**
  * for_each_efi_memory_desc - iterate over descriptors in efi.memmap
@@ -816,6 +822,16 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 #define for_each_efi_memory_desc(md) \
 	for_each_efi_memory_desc_in_map(&efi.memmap, md)
 
+/**
+ * for_each_efi_memory_desc_rev - iterate over descriptors in efi.memmap in
+ * reverse order
+ * @md: the efi_memory_desc_t * iterator
+ *
+ * Once the loop finishes @md must not be accessed.
+ */
+#define for_each_efi_memory_desc_rev(md) \
+	for_each_efi_memory_desc_in_map_rev(&efi.memmap, md)
+
 /*
  * Format an EFI memory descriptor's type and attributes to a user-provided
  * character buffer, as per snprintf(), and return the buffer.
-- 
2.53.0.851.ga537e3e6e9-goog

