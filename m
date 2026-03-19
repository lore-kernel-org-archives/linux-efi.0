Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2518A3B27E3
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911185; cv=none; b=stovC5rwaVEEqNdvXER8IUkqtPEx2LOxEjGA0GJyRSG4JLvnTUSaYGOT9HZdfPWiFp3Qk7EgtXB2tnedckwwRn6kkCJrChnD0D2wX7SrwHusY/R5x250uSe3qJyjQb9W8lf94c3TYtg3JZxAxbrGJLvbMKZfLp5x6zTJ50TFZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911185; c=relaxed/simple;
	bh=nI4mHJyEteFzkyvhEuW7RcAeMyYIXmhiDsYHb2L7p68=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dsd3e8qwn7vneJStYQljr4iYPjIaZXnuw8YNThD0q2i0L2CRnOdayKhz1/NqUjbE9XzKgclbO9MjF7XZ2SwERIkPybvtFjO+cA3/hjPEiDnq+PcYfo2mIuZ+VQlWFzN6pTiatgHBYqDSQfkaff0jC0b61jkpL9hThQ7PRhxr7Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=neXXHhvo; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="neXXHhvo"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48544725bdeso4008895e9.2
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911180; x=1774515980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=URGE+FNnkxaT+QXVuJx3nb8mizqLFv3DlCZi6MMrS8M=;
        b=neXXHhvoiuF3UPY1TF+kV9uWak3RFLPiHxDGCNEuF+Ic5DWqbmOfIPiVRyEGcwPzCd
         T6WUc1Z/gou4xPtlSgmvvb+tdgOeHKzURrLeRsEto9WHb/ZHX/Yvq1Bb94/iSO847E0H
         ClrHhMyhmMk/WcuWV5YM1lQHxruckzk6YU3kqlnQk/TxRivvyOEo5l5v5kFcRYxjAJin
         +yZPPSgzhN2Tz05pl60nM4BpmkC8IIjdCKC00lWGFs9Marg7aFMZZjcWOWHsd+1ASgKJ
         AeLstJVPxqfhJEVmzxzg2y0FgCTXCByfac/BbAFShcsbEjxept1CEM/+LiOBTTXVo6xk
         iR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911181; x=1774515981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=URGE+FNnkxaT+QXVuJx3nb8mizqLFv3DlCZi6MMrS8M=;
        b=Kh58zKYOtt3+WVmW6XL48D/kClaLaEsU05fgQv7TdmEegjl05R+RWmJYuJXu1r/8je
         0QLeqwLtDxVZtcz5sjQXsJgZCCH2GUVV7Z6k3btk5F0FTPgehPQsn+AcEDQQ0g8qSoYv
         ErRvLHN54QAxDZ5ljSOAeAlXr5cMunKZUvyTmoLltYOJHDPqmBobd+lmY+UlIhV+JEny
         /gwrrYYkXei+3VZg+3lsJti4O2Ntf6mCm1fXA6cetIjMXTwyPk8U4VtstyHASUJDwkDM
         xzTftj84izcGb9XdlvVW25ak1PW+rrOhbrG4rtYwardxZZCojCcfhUIDX94icqdniDub
         WKWA==
X-Gm-Message-State: AOJu0YyiE2Abzi7NCWfn9aKnKsVHOFuolVlPp4Is6brN1KjMYPMETCxd
	yBiTRpNKG6iEV418RlEC9v4GiaTzr5nnO3x0x73b7vDrER/DmRzdzzsnrN9pzOXM9GHKVlSv7Q=
	=
X-Received: from wrwr1.prod.google.com ([2002:a5d:6941:0:b0:439:cf20:ddf7])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:198f:b0:485:5981:1411
 with SMTP id 5b1f17b1804b1-486f4472ee8mr109908875e9.23.1773911180344; Thu, 19
 Mar 2026 02:06:20 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:47 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5938; i=ardb@kernel.org;
 h=from:subject; bh=eNWFdjaeeovD+4Yb/UStx9oLjOGRMrmlsCh1tKCjcgI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nvy39kftbt9f8+z3rwD9C1rfEnQ6+97uatHlyVg7M
 4A5Le9gRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiI+QuG/94rHGOtDsv8Mdb5
 U9hRKR+bPGFi3d75roz8ftfN52mXzmRk6Fi306h9rczpvav4ddku2jw/UfM+Y6I8p6L1A2ur2ux cRgA=
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-38-ardb+git@google.com>
Subject: [PATCH v2 17/19] x86/efi: Defer compaction of the EFI memory map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, the EFI memory map is compacted early at boot, to leave only
the entries that are significant to the current kernel or potentially a
kexec'ed kernel that comes after, and to suppress all boot services code
and data entries that have no correspondence with anything that either
the firmware or the kernel treats as reserved for firmware use.

Given that actually freeing those regions to the page allocator is not
possible yet at this point, those suppressed entries are converted into
yet another type of temporary memory reservation map, and freed during
an arch_initcall(), which is the earliest convenient time to actually
perform this operation.

Given that compacting the memory map does not need to occur that early
to begin with, move it to the arch_initcall(). This removes the need for
the special memory reservation map, as the entries still exist at this
point, and can be consulted directly to decide whether they need to be
preserved in their entirety or only partially.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 110 +++++++-------------
 1 file changed, 39 insertions(+), 71 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index dc90c35480f8..bc9dfe7925aa 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -347,36 +347,11 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
 		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
 }
 
-struct efi_freeable_range {
-	u64 start;
-	u64 end;
-};
-
-static struct efi_freeable_range *ranges_to_free;
-
 void __init efi_unmap_boot_services(void)
 {
 	efi_memory_desc_t *md;
-	void *new_md;
-	int idx = 0;
-	size_t sz;
 
-	/* Keep all regions for /sys/kernel/debug/efi */
-	if (efi_enabled(EFI_DBG))
-		return;
-
-	sz = sizeof(*ranges_to_free) * efi.memmap.num_valid_entries + 1;
-	ranges_to_free = kzalloc(sz, GFP_KERNEL);
-	if (!ranges_to_free) {
-		pr_err("Failed to allocate storage for freeable EFI regions\n");
-		return;
-	}
-
-	new_md = efi.memmap.map;
 	for_each_efi_memory_desc(md) {
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
 			continue;
@@ -385,47 +360,10 @@ void __init efi_unmap_boot_services(void)
 		/*
 		 * Before calling set_virtual_address_map(), EFI boot services
 		 * code/data regions were mapped as a quirk for buggy firmware.
-		 * Unmap them from efi_pgd before freeing them up.
+		 * Unmap them from efi_pgd, they will be freed later.
 		 */
 		efi_unmap_pages(md);
-
-		/* Do not free, someone else owns it: */
-		if ((md->attribute & EFI_MEMORY_RUNTIME) ||
-		    !can_free_region(start, size)) {
-			continue;
-		}
-
-		/*
-		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
-		 * map are still not initialized and we can't reliably free
-		 * memory here.
-		 * Queue the ranges to free at a later point.
-		 */
-		ranges_to_free[idx].start = start;
-		ranges_to_free[idx].end = start + size;
-		idx++;
 	}
-
-	/*
-	 * Build a new EFI memmap that excludes any boot services
-	 * regions that are not tagged EFI_MEMORY_RUNTIME, since those
-	 * regions have now been freed.
-	 */
-	new_md = efi.memmap.map;
-	for_each_efi_memory_desc(md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    (md->type == EFI_BOOT_SERVICES_CODE ||
-		     md->type == EFI_BOOT_SERVICES_DATA) &&
-		    can_free_region(md->phys_addr,
-				    md->num_pages << EFI_PAGE_SHIFT)) {
-			continue;
-		}
-
-		memcpy(new_md, md, efi.memmap.desc_size);
-		new_md += efi.memmap.desc_size;
-	}
-
-	efi.memmap.num_valid_entries = (new_md - efi.memmap.map) / efi.memmap.desc_size;
 }
 
 static unsigned long __init
@@ -464,27 +402,57 @@ efi_free_unreserved_subregions(u64 range_start, u64 range_end)
 
 static int __init efi_free_boot_services(void)
 {
-	struct efi_freeable_range *range = ranges_to_free;
 	unsigned long freed = 0;
+	efi_memory_desc_t *md;
+	void *new_md;
+
+	/* No EFI memory map or it came from the preceding kernel? */
+	if (efi_setup || !efi_enabled(EFI_MEMMAP))
+		return 0;
 
-	if (!ranges_to_free)
+	/* Keep all regions for /sys/kernel/debug/efi */
+	if (efi_enabled(EFI_DBG))
 		return 0;
 
-	while (range->start) {
+	new_md = efi.memmap.map;
+	for_each_efi_memory_desc(md) {
 		/*
 		 * Don't free memory under 1M for two reasons:
 		 * - BIOS might clobber it
 		 * - Crash kernel needs it to be reserved
 		 */
-		u64 start = max(range->start, SZ_1M);
+		u64 md_start = max(md->phys_addr, SZ_1M);
+		u64 md_end = md->phys_addr + md->num_pages * EFI_PAGE_SIZE;
+		bool preserve_entry = md->attribute & EFI_MEMORY_RUNTIME;
 
-		if (start >= range->end)
+		if (md_start >= md_end)
 			continue;
 
-		freed += efi_free_unreserved_subregions(start, range->end);
-		range++;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    (md->type == EFI_BOOT_SERVICES_CODE ||
+		     md->type == EFI_BOOT_SERVICES_DATA)) {
+			u64 f = efi_free_unreserved_subregions(md_start, md_end);
+
+			/*
+			 * Omit the memory map entry of this region only if it
+			 * has been freed entirely. This ensures that boot data
+			 * regions for things like ESRT and BGRT tables carry
+			 * over correctly during kexec.
+			 */
+			if (f < md_end - md_start)
+				preserve_entry = true;
+
+			freed += f;
+		}
+
+		if (preserve_entry) {
+			if (new_md != md)
+				memcpy(new_md, md, efi.memmap.desc_size);
+			new_md += efi.memmap.desc_size;
+		}
 	}
-	kfree(ranges_to_free);
+
+	efi.memmap.num_valid_entries = (new_md - efi.memmap.map) / efi.memmap.desc_size;
 
 	if (freed)
 		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
-- 
2.53.0.851.ga537e3e6e9-goog

