Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE2381B01
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957680; cv=none; b=KselCOEHymBF+YY6oDDuX8ha+qy1CVCSlJu9yo6hWlkEli/u8iVItkstyU46RB9QFCk8wID9lhxSYNH1DCZioKAWkyoEKA3kN6zywpFv8nrqhZQSQwRmA7RJFMKFaqCs3HgXzQg2j5zn5oBbCf72TVLScC5twWANOWncUXiDDKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957680; c=relaxed/simple;
	bh=/FrkEXbR6BKCZAc2NMh4D/rpko7QrXBn+oyA+ZQFggY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YLKz59l77b2nR6M3CTUr2iun0XNccp3Msrkhx8u88v3ot6J5S2l9WQ+SzdKsPM3KhPKN5ZzXFtptRpfcedBcEPjy+CRTmvAQAfSFkByPzMxJAcpzu7FwCmE4DYOIDqAfQmHtnaPkHrJYtWI5aeSmzR5lJepaTlkEujrE5TkFC2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kTkvAk1V; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kTkvAk1V"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488c2cc0cbaso48834135e9.3
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957677; x=1777562477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CMx9vXyaaNF/GCKNIFsaZ8/8V2fmYY75CqyB0473Pr8=;
        b=kTkvAk1V67gtzYIeHBvBbHCj4HO9PwPpelnHtdXhs0eZF2+UQGYBG5R3yJ2bqN+5/b
         fxFtlSyRi1VWWBFIEPpVDYgzfp7vTJdUfubPZJRE1eNSPsw5re/K6mUdn9SRy7195T95
         MGm/lnTes4kSF5xmgocDzK9MChEbOhMHHk87x82turmTK/g8cPXwwaKM8fkfmxqZ+OPj
         bhKqcg0jjSCtWFHCuh+FL6a5AeNrjeOal+uZqOegqWyl8DyF8u+7aReUi2gwXAdi7ZD2
         e3NWQ10zn1NVGVcGkOerqcIduoc/82px0hpEgFFbDHdAbupCYkTNrn7LQSu6+iqMTNAo
         M5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957677; x=1777562477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CMx9vXyaaNF/GCKNIFsaZ8/8V2fmYY75CqyB0473Pr8=;
        b=sWgDlQXX0NQTnNlbZAjt1Cz3Iyjgl3+DFbzuzzNTPDrYWbwC80MQEL9iUbabu26847
         GeCpsCpggiUZFc2VG7T8u1j+iVXWlGSQOVm9+3kO+Dl9n9CfOhHTZ3V+bgnmPMEhTKgt
         74/CdtV8H0/qQ9Ubx8zFbE0x3ZLuwihgdWx/haj76J345o90L8EfjTGv8Dsyk/MF6oQg
         gN5z9tK6pPOqmCMEz+uz6bZcwdUFvvY8XSvjD1N1S/Fs3URHZRqsfVaI14R+kRTwvnAy
         IiUF3HELWuOeAtKonkutMIEMCthni3b4q+e0wtDw7Sqjj58c0cRIweyIHw2JaKBEhZXW
         fw7w==
X-Gm-Message-State: AOJu0Yy4+aSlILiBCW0UpnakhUlQZWkIuzy7bWcejKo4drAkEQZpRy8e
	tdi8a/dqYWGQKxNcce+aqKsK45S4HTVReU+N3E59sUYZkrM7qc6I7r/btEUdgKCt2G3BDcTr7A=
	=
X-Received: from wrob7.prod.google.com ([2002:adf:ee87:0:b0:43d:7d01:5235])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8588:b0:489:2005:b36e
 with SMTP id 5b1f17b1804b1-4892005b4e9mr157083885e9.19.1776957677108; Thu, 23
 Apr 2026 08:21:17 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:41 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4160; i=ardb@kernel.org;
 h=from:subject; bh=5pSlsIgmqgTBkw/HCh3I/VbXVQ1Fg4Uy0UDAtPG9sW0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxQUmmwn/f0w/cHrWgvfrfkxrrt0TvdbJr7E17cxsA
 edzDw5LdpSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJ7D/ByPDFf2uCulFkR98z
 Bas9G7a9XTVTaUFCTCDbTMV5x663epUwMlx4cklu8mTGsKxQ5eifK8zPSUttU2CuzGM68muRD+s 1eT4A
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-35-ardb+git@google.com>
Subject: [PATCH v3 16/17] x86/efi: Avoid EFI_MEMORY_RUNTIME for early EFI boot
 memory reservations
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, memblock reservations of EFI boot services memory made before
all EFI boot services memory is temporarily reserved are upgraded, by
being marked with the EFI_MEMORY_RUNTIME bit, and this results in the
entire region to remain reserved permanently, regardless of the size of
the original memblock reservation that triggered this.

This is a hack, and may be quite inefficient in cases where the firmware
does a good job of merging memory map entries.

So instead, rely on the MEMBLOCK_RSRV_KERN flag, by marking existing
memblock reservations with this flag before creating the new, temporary
ones with the flag cleared. This unifies the treatment of early vs late
memblock reservations inside EFI boot services memory, and avoids
clobbering the EFI memory map.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 66 ++++++--------------
 1 file changed, 18 insertions(+), 48 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index b7c8337d8f88..fc6a15c2ace6 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -273,7 +273,6 @@ void __init efi_reserve_boot_services(void)
 		u64 start = max(md->phys_addr, SZ_1M);
 		u64 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 		u64 size = end - start;
-		bool already_reserved;
 
 		if (end <= start)
 			continue;
@@ -282,37 +281,11 @@ void __init efi_reserve_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		already_reserved = memblock_is_region_reserved(start, size);
+		/* upgrade existing reservations to MEMBLOCK_RSRV_KERN */
+		if (memblock_is_region_reserved(start, size))
+			memblock_reserved_mark_kern(start, size);
 
-		/*
-		 * Because the following memblock_reserve() is paired
-		 * with free_reserved_area() for this region in
-		 * efi_free_boot_services(), we must be extremely
-		 * careful not to reserve, and subsequently free, critical
-		 * regions of memory that somebody else has already reserved.
-		 */
-		if (!already_reserved) {
-			memblock_reserve(start, size);
-
-			/*
-			 * If we are the first to reserve the region, no
-			 * one else cares about it. We own it and can
-			 * free it later.
-			 */
-			if (can_free_region(start, size))
-				continue;
-		}
-
-		/*
-		 * We don't own the region. We must not free it.
-		 *
-		 * Setting this bit for a boot services region really
-		 * doesn't make sense as far as the firmware is
-		 * concerned, but it does provide us with a way to tag
-		 * those regions that must not be paired with
-		 * memblock_phys_free().
-		 */
-		md->attribute |= EFI_MEMORY_RUNTIME;
+		memblock_reserve(start, size);
 	}
 }
 
@@ -443,25 +416,22 @@ void __init efi_unmap_boot_services(void)
 		 */
 		efi_unmap_pages(md);
 
-		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
-			/*
-			 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
-			 * map are still not initialized and we can't reliably free
-			 * memory here.
-			 * Queue the ranges to free at a later point.
-			 */
-			if (efi_add_range_to_free(start, start + size, &has_reservations)) {
-				pr_err("Failed to reallocate storage for freeable EFI regions\n");
-				clear_bit(EFI_MEMMAP, &efi.flags);
-				return;
-			}
-
-			/* Continue without advancing new_md so this region is omitted */
-			if (!has_reservations)
-				continue;
-
+		/*
+		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
+		 * map are still not initialized and we can't reliably free
+		 * memory here.
+		 * Queue the ranges to free at a later point.
+		 */
+		if (efi_add_range_to_free(start, start + size, &has_reservations)) {
+			pr_err("Failed to reallocate storage for freeable EFI regions\n");
+			clear_bit(EFI_MEMMAP, &efi.flags);
+			return;
 		}
 
+		/* Continue without advancing new_md so this region is omitted */
+		if (!has_reservations)
+			continue;
+
 		/* Advance new_md so this region is preserved in the EFI memory map */
 		new_md += efi.memmap.desc_size;
 	}
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

