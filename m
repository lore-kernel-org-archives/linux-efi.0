Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907433B4E9D
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911177; cv=none; b=FkcT+akXgQ9mUTFDYmBMFHqEqXSLLF1fN5JES7MDeCjEtXBUBRhYLcMBJhRRomJYEoDiuB/E6LlVgTFqTDgNRBK65ZkZcuo/jL8Mq57WBzbcwXafIBL0mdXz+CdnvpgsYlVFYabE0xHn4f3sb5DQ+mHkNyoslqwB6wqfv3Fes28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911177; c=relaxed/simple;
	bh=vSc9gvmi0wPzgh7KJsC1mdV0JebdP0SL03rCP7lN6is=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=And6PtepmFv8EPpzVlwiYXzexG3y1ZXN8B0AfsFNnZj5X3QMFfufcrw1rWMi6OsSHd5YOawnh2Fv+30kkUs0z2l3C12S20w1h/by5humquNnKiWhoDJPFtwj7DQuiFFd4+1zEfcvZJIP7BLu/dp/YoBt7aQF6DRL1vwVtrHcSHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HYKsgzM0; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HYKsgzM0"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4362197d1easo486517f8f.2
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911173; x=1774515973; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iCBt8tT5p3mHgHNAvRatHWbwLoCmzdFJgF+LJbDgnnY=;
        b=HYKsgzM0hojKMSs5K04Vi2lw0S9qfl3W1cB+wG/1u9xlVFVDZSHFKGqGH3CF95NCb0
         je6LaZilhX+Y5Iz1B5S68ffn79CW5sCZRIwgc4765KobKy/o0F2mN82wwQ2umBc2BRWw
         IqWgh4mXmuJTs0d0pAkQQCbP/DUrxe2dHNq8i3tKCqrv9Jc1KTb5LNbQObhXJU41j4ze
         zsoe/Ny9zBSYFAnsyid35Y9D5wcse9dRiyOw4I/ntJaO0ZGym2qKUmQb6pyT4DfTGQ0s
         qQ2L+q5B6aK6rgsA6eJXjt+mBhX5agieqO05oralO+Y4Dpl52FiOwkpryq8aRuEswvGc
         IoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911173; x=1774515973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCBt8tT5p3mHgHNAvRatHWbwLoCmzdFJgF+LJbDgnnY=;
        b=OqwPFVJ6Zth2uyT0VQZfKeyqasQ0UvvPsRVYa/SfGr7Q79BjL8tpiix5dVDB9JhdyC
         sHkJZsoZcn106OtWVrbrQFftSSPyfgqbacqAdKSuJHzqKwN+7zNYoGpInenMetABdZ2d
         0Wp+kARCsOeiqdZCGrLuyGTUzPdkjCS08RDuprZsLe9+Iria/mBfTr+4B3H5rTrALJkc
         5G4958IvAozxVunyml8kmBsdc7boAlmNwLiHWgQzCQdtcy8nwdInHgcXa00f20xeVw5H
         lfuA4AC9hSaE1yhBR/ctJC9J7GfRZvq4wlSZG9PSvrSmKZDIxYIl/Oq3oBPST1KzjLwt
         xNwA==
X-Gm-Message-State: AOJu0YzAwHIWKFAE2MggFudAKFkKB273FFFY8NOkBcz8D068D4bY0kuI
	DZluh0eOax4ySE4s3gV7qT4GHrQJJmWUc+5HUOCdxp2bSf1cFZI9ij7Jlm3Vur0gJCGaFbWX1Q=
	=
X-Received: from wrua10.prod.google.com ([2002:a5d:4d4a:0:b0:43a:5b:6a88])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:240c:b0:439:b791:f920
 with SMTP id ffacd0b85a97d-43b527aa3dfmr12107986f8f.17.1773911172656; Thu, 19
 Mar 2026 02:06:12 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:40 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9050; i=ardb@kernel.org;
 h=from:subject; bh=KHztfi82Kf5HDtfcwgQyx5hl7BAgKVNcVh63vdm/NJE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3njTlctWeZXV3Nh3NTDloeei237f3SW1pZk0HE2YF3
 q2atWVtRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjItTJGhl39vA4b5BflzL+U
 0up8Tebq3U6VskCpZUnXVlV8mqqqupGR4XeoVFzz3P9dHnfbWCukN+oumOK9/lKAUcpBH+VpP+3 4GAA=
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-31-ardb+git@google.com>
Subject: [PATCH v2 10/19] x86/efi: Do not rely on EFI_MEMORY_RUNTIME bit and
 avoid entry splitting
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that efi_mem_reserve() has been updated to rely on RSRV_KERN
memblock reservations, it is no longer needed to mark memblock reserved
boot services regions as EFI_MEMORY_RUNTIME. This means that it is no
longer needed to split existing entries in the EFI memory map, removing
the need to re-allocate/copy/remap the entire EFI memory map on every
call to efi_mem_reserve().

So drop this functionality - it is no longer needed.

Note that, for the time being, the E820 map needs to be consulted to
decide whether or not an entry with the EFI_MEMORY_RUNTIME bit cleared
needs to be preserved in the runtime map or not. However, this will be
superseded and removed by a subsequent patch, which combines the map
compaction with the actual freeing, in which case the freeing logic can
answer this question directly.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h     |   4 -
 arch/x86/platform/efi/memmap.c | 138 --------------------
 arch/x86/platform/efi/quirks.c |  62 +--------
 3 files changed, 6 insertions(+), 198 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 51b4cdbea061..b01dd639bf62 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -396,10 +396,6 @@ extern int __init efi_memmap_alloc(unsigned int num_entries,
 				   struct efi_memory_map_data *data);
 
 extern int __init efi_memmap_install(struct efi_memory_map_data *data);
-extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
-					 struct range *range);
-extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
-				     void *buf, struct efi_mem_range *mem);
 
 extern enum efi_secureboot_mode __x86_ima_efi_boot_mode(void);
 
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 023697c88910..8ef45014c7e7 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -110,141 +110,3 @@ int __init efi_memmap_install(struct efi_memory_map_data *data)
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
index 13d9e036a23a..ae4ad6389f9e 100644
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
@@ -446,7 +392,8 @@ void __init efi_unmap_boot_services(void)
 		efi_unmap_pages(md);
 
 		/* Do not free, someone else owns it: */
-		if (md->attribute & EFI_MEMORY_RUNTIME) {
+		if ((md->attribute & EFI_MEMORY_RUNTIME) ||
+		    !can_free_region(start, size)) {
 			num_entries++;
 			continue;
 		}
@@ -485,8 +432,11 @@ void __init efi_unmap_boot_services(void)
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
2.53.0.851.ga537e3e6e9-goog

