Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9FA3783B0
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957674; cv=none; b=E+vMOWFN94PaUq5jgviWHG1Kovgc1AT+VtjosxGO3qszN3rVm3lShLXlUot1QSAuB5OZzesWBLJ+11ZKqd1qOBY5zjzRSCwjyL075x0x+TDwGuK4ZMy8B1D3To7LvAgN7n4yTm/zf7xjgrym5BnCXRsr6HnaKBEVzUlWc5GYLTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957674; c=relaxed/simple;
	bh=tiRoGkPFrmHA8DhoFA6DaUdZvOus7sOeLm2EdZ9QXNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=No0otZRujpg2744/FtCbVfSItwMuNIU/8vZaL3k01bghdvUKq4fJ2RlqeJhw1n2KqDsUPIg7zG8qLn6oiP38wkPs8qhDX75Kvt6d+OpXQ8QT7lUegQHbL/QUHCxYBBzTmi/gceL+xRmClje388WfKk/FnMAeruYGUIs6rPnmf+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wgf22wtM; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wgf22wtM"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a55ecc32cso27341805e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957671; x=1777562471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EqIsK2LttDMvDAmHIy33jLO4k6bzz8jvDDP3urmiklw=;
        b=Wgf22wtM/iCv10rXW35YWxzJjE+RtqZcX7J0Tr+HMzJOQg/VqwcDJn12WXryc56ET4
         7+bJOdAfXCfzkmXkmaBQ8gQwagyEssu4UkwQSSVtgP1XkF1/ex6s/VyTSCCDpv0777qu
         PXDsuiTEB1RQlRrqNHp8lAfdUu04yrO7ETVebfleqbhM8tz7eJcH9ZUR6HItB64Sxec5
         EbMzjhXmwHJ/R1OWTDOUGsTSy/OZASu+qe+Lf/i8XOX9ysNvzTrU3qxcWDALJGVEYhbI
         3mC6l3ElRySFZUC1fW051nttSJLcTlvBy5fMj+Rb/xpGfywTVCk2JMtzshKN7nBUMRTl
         jEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957671; x=1777562471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EqIsK2LttDMvDAmHIy33jLO4k6bzz8jvDDP3urmiklw=;
        b=TDGCLfUclrXCpS911UU4CPm6PtY9YgF+QZCxxmf1JVSOJhNb22Q/kbwdYECZZgmba4
         4h4qO3iS6HbT0ujwefByGYJkDW0ZyLsjDGAhvsSAzKNoa9/Q6J1Srl9XA8JRMrlH2z+W
         zHW9ehazbi4b0YTRZOBEHYu91o8X9EaC9Dy1ZyqRT+s00wAOg1pKl7Kxk67wA+WQyOzX
         3GLhYk1LNfB18AlEyoCKRMQXoSZyYfJWIsNcZ+HsTgCTXNh6CfZcGJ0IfDL2dp4G0208
         a6TjZr60M+60PcXRdyue/MF6cDlLyLz3tVkFiV/Of90jgITSVpxapPlrEhO1o2MGTvyH
         HGww==
X-Gm-Message-State: AOJu0Yxsp8MBm2q2y3kGyzBMJ0W4F75J9QSZq0eMGiYoYCcXa40vVeO3
	xnPACOgfunZzwpchpojs9Kee4o7OP75myLyeumXB4OOqd20Qpimw1dN9vLCO6d/vPTJOxxkUbw=
	=
X-Received: from wmbz10.prod.google.com ([2002:a05:600c:c08a:b0:488:c1c7:5024])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3596:b0:48a:563c:c8c5
 with SMTP id 5b1f17b1804b1-48a563cd1b2mr172866315e9.8.1776957670758; Thu, 23
 Apr 2026 08:21:10 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:35 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=10109; i=ardb@kernel.org;
 h=from:subject; bh=dWoVGXM0HSTwZN50WA1NRBKn6uv2bVPhj6xEuCOuz6w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxXHnK+le10oeHFgvLrjjnsnG3MNPuwT0dTTy/+6/b
 uqcfmhvRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiI2VWGf7Zit/eLMnX++18e
 59BYVbtaI8+dt/SgfMEeiX+39xr/smZkmDL/gLzP91NHzgdYfp2gNdXlxReJJOafwuZlr+L3zfb UZwQA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-29-ardb+git@google.com>
Subject: [PATCH v3 10/17] x86/efi: Do not rely on EFI_MEMORY_RUNTIME bit and
 avoid entry splitting
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that efi_mem_reserve() has been updated to rely on RSRV_KERN
memblock reservations, it is no longer needed to mark memblock reserved
boot services regions as EFI_MEMORY_RUNTIME. This means that it is no
longer needed to split existing entries in the EFI memory map, removing
the need to re-allocate/copy/remap the entire EFI memory map on every
call to efi_mem_reserve().

So drop this functionality - it is no longer needed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h     |   4 -
 arch/x86/platform/efi/memmap.c | 138 --------------------
 arch/x86/platform/efi/quirks.c |  77 +++--------
 3 files changed, 17 insertions(+), 202 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index f291845b403a..7d8f627805df 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -402,10 +402,6 @@ extern int __init efi_memmap_alloc(unsigned int num_entries,
 				   struct efi_memory_map_data *data);
 
 extern int __init efi_memmap_install(struct efi_memory_map_data *data);
-extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
-					 struct range *range);
-extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
-				     void *buf, struct efi_mem_range *mem);
 
 enum efi_secureboot_mode __x86_efi_boot_mode(void);
 
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 697a9a26a005..da7483a33d68 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -107,141 +107,3 @@ int __init efi_memmap_install(struct efi_memory_map_data *data)
 	__efi_memmap_free(phys, size, flags);
 	return 0;
 }
-
-/**
- * efi_memmap_split_count - Count number of additional EFI memmap entries
- * @md: EFI memory descriptor to split
- * @range: Address range (start, end) to split around
- *
- * Returns the number of additional EFI memmap entries required to
- * accommodate @range.
- */
-int __init efi_memmap_split_count(efi_memory_desc_t *md, struct range *range)
-{
-	u64 m_start, m_end;
-	u64 start, end;
-	int count = 0;
-
-	start = md->phys_addr;
-	end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
-
-	/* modifying range */
-	m_start = range->start;
-	m_end = range->end;
-
-	if (m_start <= start) {
-		/* split into 2 parts */
-		if (start < m_end && m_end < end)
-			count++;
-	}
-
-	if (start < m_start && m_start < end) {
-		/* split into 3 parts */
-		if (m_end < end)
-			count += 2;
-		/* split into 2 parts */
-		if (end <= m_end)
-			count++;
-	}
-
-	return count;
-}
-
-/**
- * efi_memmap_insert - Insert a memory region in an EFI memmap
- * @old_memmap: The existing EFI memory map structure
- * @buf: Address of buffer to store new map
- * @mem: Memory map entry to insert
- *
- * It is suggested that you call efi_memmap_split_count() first
- * to see how large @buf needs to be.
- */
-void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
-			      struct efi_mem_range *mem)
-{
-	u64 m_start, m_end, m_attr;
-	efi_memory_desc_t *md;
-	u64 start, end;
-	void *old, *new;
-
-	/* modifying range */
-	m_start = mem->range.start;
-	m_end = mem->range.end;
-	m_attr = mem->attribute;
-
-	/*
-	 * The EFI memory map deals with regions in EFI_PAGE_SIZE
-	 * units. Ensure that the region described by 'mem' is aligned
-	 * correctly.
-	 */
-	if (!IS_ALIGNED(m_start, EFI_PAGE_SIZE) ||
-	    !IS_ALIGNED(m_end + 1, EFI_PAGE_SIZE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	for (old = old_memmap->map, new = buf;
-	     old < old_memmap->map_end;
-	     old += old_memmap->desc_size, new += old_memmap->desc_size) {
-
-		/* copy original EFI memory descriptor */
-		memcpy(new, old, old_memmap->desc_size);
-		md = new;
-		start = md->phys_addr;
-		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
-
-		if (m_start <= start && end <= m_end)
-			md->attribute |= m_attr;
-
-		if (m_start <= start &&
-		    (start < m_end && m_end < end)) {
-			/* first part */
-			md->attribute |= m_attr;
-			md->num_pages = (m_end - md->phys_addr + 1) >>
-				EFI_PAGE_SHIFT;
-			/* latter part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->phys_addr = m_end + 1;
-			md->num_pages = (end - md->phys_addr + 1) >>
-				EFI_PAGE_SHIFT;
-		}
-
-		if ((start < m_start && m_start < end) && m_end < end) {
-			/* first part */
-			md->num_pages = (m_start - md->phys_addr) >>
-				EFI_PAGE_SHIFT;
-			/* middle part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->attribute |= m_attr;
-			md->phys_addr = m_start;
-			md->num_pages = (m_end - m_start + 1) >>
-				EFI_PAGE_SHIFT;
-			/* last part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->phys_addr = m_end + 1;
-			md->num_pages = (end - m_end) >>
-				EFI_PAGE_SHIFT;
-		}
-
-		if ((start < m_start && m_start < end) &&
-		    (end <= m_end)) {
-			/* first part */
-			md->num_pages = (m_start - md->phys_addr) >>
-				EFI_PAGE_SHIFT;
-			/* latter part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->phys_addr = m_start;
-			md->num_pages = (end - md->phys_addr + 1) >>
-				EFI_PAGE_SHIFT;
-			md->attribute |= m_attr;
-		}
-	}
-}
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index ce06a388fc11..efb828b7e2ab 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -239,63 +239,9 @@ EXPORT_SYMBOL_GPL(efi_query_variable_store);
  * buggy implementations we reserve boot services region during EFI
  * init and make sure it stays executable. Then, after
  * SetVirtualAddressMap(), it is discarded.
- *
- * However, some boot services regions contain data that is required
- * by drivers, so we need to track which memory ranges can never be
- * freed. This is done by tagging those regions with the
- * EFI_MEMORY_RUNTIME attribute.
- *
- * Any driver that wants to mark a region as reserved must use
- * efi_mem_reserve() which will insert a new EFI memory descriptor
- * into efi.memmap (splitting existing regions if necessary) and tag
- * it with EFI_MEMORY_RUNTIME.
  */
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 {
-	struct efi_memory_map_data data = { 0 };
-	struct efi_mem_range mr;
-	efi_memory_desc_t md;
-	int num_entries;
-	void *new;
-
-	if (efi_mem_desc_lookup(addr, &md) ||
-	    md.type != EFI_BOOT_SERVICES_DATA) {
-		pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);
-		return;
-	}
-
-	if (addr + size > md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT)) {
-		pr_err("Region spans EFI memory descriptors, %pa\n", &addr);
-		return;
-	}
-
-	size += addr % EFI_PAGE_SIZE;
-	size = round_up(size, EFI_PAGE_SIZE);
-	addr = round_down(addr, EFI_PAGE_SIZE);
-
-	mr.range.start = addr;
-	mr.range.end = addr + size - 1;
-	mr.attribute = md.attribute | EFI_MEMORY_RUNTIME;
-
-	num_entries = efi_memmap_split_count(&md, &mr.range);
-	num_entries += efi.memmap.nr_map;
-
-	if (efi_memmap_alloc(num_entries, &data) != 0) {
-		pr_err("Could not allocate boot services memmap\n");
-		return;
-	}
-
-	new = early_memremap_prot(data.phys_map, data.size,
-				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
-	if (!new) {
-		pr_err("Failed to map new boot services memmap\n");
-		return;
-	}
-
-	efi_memmap_insert(&efi.memmap, new, &mr);
-	early_memunmap(new, data.size);
-
-	efi_memmap_install(&data);
 	e820__range_update(addr, size, E820_TYPE_RAM, E820_TYPE_RESERVED);
 	e820__update_table(e820_table);
 }
@@ -404,7 +350,8 @@ struct efi_freeable_range {
 static struct efi_freeable_range *ranges_to_free __initdata;
 static int num_to_free __initdata;
 
-static int __init efi_add_range_to_free(u64 range_start, u64 range_end)
+static int __init efi_add_range_to_free(u64 range_start, u64 range_end,
+					bool *has_reservations)
 {
 	struct memblock_region *region;
 	static int idx __initdata;
@@ -420,15 +367,18 @@ static int __init efi_add_range_to_free(u64 range_start, u64 range_end)
 		if (region_end < range_start)
 			continue;
 
-		if (region->flags & MEMBLOCK_RSRV_KERN)
-			continue;
-
 		start = PAGE_ALIGN(max(range_start, region->base));
 		end = PAGE_ALIGN_DOWN(min(range_end, region_end));
 
 		if (start >= end)
 			continue;
 
+		if ((region->flags & MEMBLOCK_RSRV_KERN) ||
+		    !can_free_region(start, end - start)) {
+			*has_reservations = true;
+			continue;
+		}
+
 		ranges_to_free[idx].start = start;
 		ranges_to_free[idx].end = end;
 
@@ -471,6 +421,7 @@ void __init efi_unmap_boot_services(void)
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		bool has_reservations = false;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
@@ -497,10 +448,13 @@ void __init efi_unmap_boot_services(void)
 		 * memory here.
 		 * Queue the ranges to free at a later point.
 		 */
-		if (efi_add_range_to_free(start, start + size)) {
+		if (efi_add_range_to_free(start, start + size, &has_reservations)) {
 			pr_err("Failed to reallocate storage for freeable EFI regions\n");
 			return;
 		}
+
+		if (has_reservations)
+			num_entries++;
 	}
 
 	if (!num_entries)
@@ -526,8 +480,11 @@ void __init efi_unmap_boot_services(void)
 	for_each_efi_memory_desc(md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
 		    (md->type == EFI_BOOT_SERVICES_CODE ||
-		     md->type == EFI_BOOT_SERVICES_DATA))
+		     md->type == EFI_BOOT_SERVICES_DATA) &&
+		    can_free_region(md->phys_addr,
+				    md->num_pages << EFI_PAGE_SHIFT)) {
 			continue;
+		}
 
 		memcpy(new_md, md, efi.memmap.desc_size);
 		new_md += efi.memmap.desc_size;
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

