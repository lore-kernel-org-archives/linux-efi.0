Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5619437D137
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957677; cv=none; b=IZxLOqrMT17NDheD8LH1DkGNFwXLJP5uHx6GSNAk3LOVr5SgeYxTi/RfcebyhA+myCvRFaObsC++xAeMpAybFrhhNcajlFm+iW8QzGss3a6P8LGtVYuzERKygYnS365DR3+Bf+u6ryn/RpA6Y9nR8h2ZAxPSx3JkMjEzOSlR17A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957677; c=relaxed/simple;
	bh=Eqd18fIs66CS6j98MlJeICalwSHrv5VVObvH1lqDgtI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dxwcRycCmP6ZVAG9fMk5X2N932hTpxj3vTLD5ULPyXzopd2ehz+SLLLZ1HIuBF7t51V+1a4nDuTg3VMDq6gjuoZ3X7SoJFsrn5FlGDyITaGHZ1P/+d8wOpcWrYyYv8uwGb3sQBqLkIVX0jluyZ/KZ1l/d1yhmSX6FTYFZGiiUCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QHmp4PEg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHmp4PEg"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a5fb71a84so5623125e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957674; x=1777562474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=deBMwt4GdP8bouiDOJACDn+Qi42vPHSoLuOshlsff+o=;
        b=QHmp4PEgKXtpnfV1+0s8B+A800yo07cYOTRZqQ1HadgaAqRtt2fpvCYxM65TxNQuQx
         LrXhmIe5lN6DxyEAd3P00BHjDqy5HU7MX8pL+98QIcLDtNfW0X6e6AIK2Omge6gE7nwc
         ZO99jLdPeh2xTEjmUdNPfC9hXcWa2X0OGOpvUHiOIfSaJqOflR1o6F9lja/EnD/jY0Tp
         VDzBsqXBBjMoB0X7hPPcoaR/CUCErCcZMnAn/YCNuoMbXxzRC3+IotyhtO0n+1xy2ZpE
         aDGzk70wCxu9JesduJjfbm+iWM9ir6aLE+GHiQtV4D0oXdpHY0n3kSOSuuZJq8l0+4rr
         pe/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957674; x=1777562474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=deBMwt4GdP8bouiDOJACDn+Qi42vPHSoLuOshlsff+o=;
        b=VApA0vukCA/3jpokhF9AW91DRVjYqI7wPs614pMW00pqIPZeNoPTeWbrxiRP1sGTN8
         F9X3juOe+6VV4v+ugdyDj3cAk55sqse/ykk25cXT9sNVcdJXnGTu+hhzpchbQW9sJvM1
         90YN6QvxQovFbLQ4YOua6z5fjmbGrcaCzIgcVqKKQ+6MMupWBCx25QxgGHUupZiKYltZ
         X4K4nggz5cD2ncaWIdQ8XGn6wnPWL5lLDR1NFRLwBlyZmjUf4T09j7JlhIE+YxS7wk0j
         n/D7EKJco3YO8wxWk4+/VTsFfT54R2QCI5keyxxT9AaTZ4VDxbKTasZyt4x7IcpZqL76
         jvGA==
X-Gm-Message-State: AOJu0YxwNshZqfClDr38GHivoNP9ER8VD6SCo8B/j2Lil96xufBjmCNG
	YT5FHRGXBNorrEgTYPK40xl2qSq1P65dUb29Vrsgg2NiKpsKXXJByIP5wvLIsU2JQ/J8VKNwIw=
	=
X-Received: from wmbjq20.prod.google.com ([2002:a05:600c:55d4:b0:487:1fc4:8071])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b6b:b0:485:3c2e:60d5
 with SMTP id 5b1f17b1804b1-488fb8859ddmr362834385e9.2.1776957673474; Thu, 23
 Apr 2026 08:21:13 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:38 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5135; i=ardb@kernel.org;
 h=from:subject; bh=AaX0BrB4ny6TQQx+jQeJOTVDUbOld0PQ8UIy7f/AVTo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxWkLudl8iYwFN/qirmx3VD23+NG0yZJrnoXylCT1B
 oZ5PTbtKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABP5L8vI0NDi7l/w9+fujVfr
 w2fcNv4u6rBPvbtblP1YkkDacWU3N4Z/2vMvlgZ02ZxXOHt0hkXxq9tF0oXbXXo9/1/t3/ZcLfg bFwA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-32-ardb+git@google.com>
Subject: [PATCH v3 13/17] x86/efi: Update the runtime map in place
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

When creating the EFI runtime map, a copy is created containing only the
entries that will be mapped on behalf of the firmware, but the
assignment of the virtual address field is applied to both copies.

Subsequently, the copy is installed as the new EFI memory map, and the
old one is just leaked.

This means that there is no reason whatsoever to allocate and install
the copy, and it is much easier to just update the existing memory map in
place to set the virtual addresses and suppress unused entries.

So reuse the filter function used by efi_clean_memmap() to drop all
entries that are irrelevant, and then apply the existing logic to assign
the virtual addresses and create the mappings in the EFI page tables.

Note that x86_64 and i386 traverse the memory map in opposite order, so
this part remains a separate pass as before. This logic will be further
simplified in subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 82 ++++----------------
 1 file changed, 16 insertions(+), 66 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 459b5c13167a..f67ea6d4cad0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -498,27 +498,6 @@ void __init efi_init(void)
 		efi_print_memmap();
 }
 
-static void *realloc_pages(void *old_memmap, int old_shift)
-{
-	void *ret;
-
-	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
-	if (!ret)
-		goto out;
-
-	/*
-	 * A first-time allocation doesn't have anything to copy.
-	 */
-	if (!old_memmap)
-		return ret;
-
-	memcpy(ret, old_memmap, PAGE_SIZE << old_shift);
-
-out:
-	free_pages((unsigned long)old_memmap, old_shift);
-	return ret;
-}
-
 /*
  * Iterate the EFI memory map in reverse order because the regions
  * will be mapped top-down. The end result is the same as if we had
@@ -589,7 +568,7 @@ static void *efi_map_next_entry(void *entry)
 	return entry;
 }
 
-static bool should_map_region(efi_memory_desc_t *md)
+static bool should_map_region(const efi_memory_desc_t *md, int unused)
 {
 	/*
 	 * Runtime regions always require runtime mappings (obviously).
@@ -642,40 +621,14 @@ static bool should_map_region(efi_memory_desc_t *md)
  * Map the efi memory ranges of the runtime services and update new_mmap with
  * virtual addresses.
  */
-static void * __init efi_map_regions(int *count, int *pg_shift)
+static void __init efi_map_regions(void)
 {
-	void *p, *new_memmap = NULL;
-	unsigned long left = 0;
-	unsigned long desc_size;
-	efi_memory_desc_t *md;
-
-	desc_size = efi.memmap.desc_size;
-
-	p = NULL;
-	while ((p = efi_map_next_entry(p))) {
-		md = p;
+	efi_memory_desc_t *md = NULL;
 
-		if (!should_map_region(md))
-			continue;
+	efi_memmap_filter_entries(should_map_region);
 
+	while ((md = efi_map_next_entry(md)))
 		efi_map_region(md);
-
-		if (left < desc_size) {
-			new_memmap = realloc_pages(new_memmap, *pg_shift);
-			if (!new_memmap)
-				return NULL;
-
-			left += PAGE_SIZE << *pg_shift;
-			(*pg_shift)++;
-		}
-
-		memcpy(new_memmap + (*count * desc_size), md, desc_size);
-
-		left -= desc_size;
-		(*count)++;
-	}
-
-	return new_memmap;
 }
 
 static void __init kexec_enter_virtual_mode(void)
@@ -752,9 +705,8 @@ static void __init kexec_enter_virtual_mode(void)
  */
 static void __init __efi_enter_virtual_mode(void)
 {
-	int count = 0, pg_shift = 0;
-	void *new_memmap = NULL;
 	efi_status_t status;
+	unsigned long size;
 	unsigned long pa;
 
 	if (efi_alloc_page_tables()) {
@@ -762,15 +714,6 @@ static void __init __efi_enter_virtual_mode(void)
 		goto err;
 	}
 
-	efi_merge_regions();
-	new_memmap = efi_map_regions(&count, &pg_shift);
-	if (!new_memmap) {
-		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
-		goto err;
-	}
-
-	pa = __pa(new_memmap);
-
 	/*
 	 * Unregister the early EFI memmap from efi_init() and install
 	 * the new EFI memory map that we are about to pass to the
@@ -778,22 +721,29 @@ static void __init __efi_enter_virtual_mode(void)
 	 */
 	efi_memmap_unmap();
 
-	if (efi_memmap_init_late(pa, efi.memmap.desc_size * count)) {
+	size = efi.memmap.desc_size * efi.memmap.num_valid_entries;
+	if (efi_memmap_init_late(efi.memmap.phys_map, size)) {
 		pr_err("Failed to remap late EFI memory map\n");
 		goto err;
 	}
 
+	efi_merge_regions();
+	efi_map_regions();
+
 	if (efi_enabled(EFI_DBG)) {
 		pr_info("EFI runtime memory map:\n");
 		efi_print_memmap();
 	}
 
-	if (efi_setup_page_tables(pa, 1 << pg_shift))
+	size = efi.memmap.desc_size * efi.memmap.num_valid_entries;
+	if (efi_setup_page_tables(efi.memmap.phys_map,
+				  DIV_ROUND_UP(size, PAGE_SIZE)))
 		goto err;
 
 	efi_sync_low_kernel_mappings();
 
-	status = efi_set_virtual_address_map(efi.memmap.desc_size * count,
+	pa = efi.memmap.phys_map;
+	status = efi_set_virtual_address_map(size,
 					     efi.memmap.desc_size,
 					     efi.memmap.desc_version,
 					     (efi_memory_desc_t *)pa,
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

