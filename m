Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5E137FF7A
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957679; cv=none; b=TujWZqcp+w9wrZ/Mi1gKZBA/AzcfOLLB8Xa2cP4uDnrayoWQnhGfw4fkX7lXCLM7/qrXhDh0n8sY95r6TJOPlbHIcE8reE69OAWtvkNncmvuP4gqwyEC/LQala7QWYPlo/YWGo+dhDM2oU/QpQGDVD3u+wc37V2WSvgwwcwB55s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957679; c=relaxed/simple;
	bh=BCHBdFu7uj0WMDlyV3LNlEBXBdnZDeTgsZHS9yOthWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vCKSLyItaWSZZFV/lrpt93X+ekvSGwXTdKvikDdnGtTpXjXa1/pCIvkjkLxI0WXC2cK3PYMFoHSmzPAkSNmwrco5X6GiBYLqKeIk5ONDScMokpzbzLwukEUlrDmbYVgvHhZz+hQq95G2BuMBUNdHnDmP3Xy+Cp2V0CwkwGzvaS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wdXLftys; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wdXLftys"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso5478863f8f.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957676; x=1777562476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fua20tDRknPI0AcOnbhBXrprPjr6FkRST/bHlhqglgk=;
        b=wdXLftysjiwWCV7cIpnoYuWgFBfCFynyUF5gSciVFlsD24Igmd2KS0j6+NB3Oi5qfm
         MsJcOKHNaBEsP+A1MPQDEd9Y8uya3cZAVuJBQrBAhF9sTDxChZZHGz+sOFnth5hr/NMu
         b0HZ3KOy2B6+kg1OeofAn5Hd+YMXaBAW2vvBgD/824PKcZQGP4A3g6azu+B6ff3RlUuB
         l8osIg0Xwlch2hUYeT2LP6+ppnDWRPJTIM6LMEP3b2uzmKUnP3piFfO5bEITUKVMaVV8
         e6fqJd/aQyapBHX3ULW2lzc6Rcn4SIMEeJbG0VSEUguDSYHWsqk60H07AzkM4tbJEiKB
         Nswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957676; x=1777562476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fua20tDRknPI0AcOnbhBXrprPjr6FkRST/bHlhqglgk=;
        b=I6mqYTvZJkxI4h80rxjAD2tLYPWTMGC3eItX6x2aWZ3xstmz4djJNKH1JGZfisi+z8
         hHF/Ffy4oi4bIm0iQ8yl/nT29ye6DWT4JvOM1FONKI5GqNrsxa0Z0bqd2omx0LxIf8Tg
         wF5VrV1rPGDckVcdDta63XT5ia6XDkO7z8FZcepIFhNPpMQjYmGdsN/DatMqTxhcX8vR
         A+sCyrsUUvcMOGjeZwvAKm0172sIBptrrylQWFHbTxCQH/yZsOgayS4EFFWF6WKQOytO
         sZ7Jsw2CWXGyzdLpWsOHQF1jfo4EOc+shZNTD1eP/VFlLNjGwfO9wftqhLeub3ri6Lon
         3Tsw==
X-Gm-Message-State: AOJu0YwbfsBjYVR5hacu+6jGs/ie7BS2nIodS8db7UufhOmlZIDEoJh2
	7oBARHtoTs6KEP7iKnpGY+zBCCbWtNl9TIoH3aCadndwjkmD0/MEbsFg0tHHXjbZwXYx1w0FWA=
	=
X-Received: from wrsn16.prod.google.com ([2002:a5d:4850:0:b0:43e:ade7:8d95])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4283:b0:43d:73ff:fd59
 with SMTP id ffacd0b85a97d-43fe3db9bc9mr42465799f8f.10.1776957676034; Thu, 23
 Apr 2026 08:21:16 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:40 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3599; i=ardb@kernel.org;
 h=from:subject; bh=7zfXJlzwkp063m58UDmY7Gt1EcrqwR4mQhLXAixBhyI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxblQU1Uenk3mzE9fpL6b9KO5rile8u3uezPuHsnXq
 Z3B8up4RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjILQ1GhkUz3RZLnHjf72u2
 3OHjy4tpYqxpM890/mvQEne5I2uyR4eR4cj+Kc8+WmbF65r/kXHc9jG39dLx1K6JsVGfrgWHsNb r8AEA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-34-ardb+git@google.com>
Subject: [PATCH v3 15/17] x86/efi: Merge two traversals of the memory map when
 freeing boot regions
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Combine two traversals of the EFI memory map, one that instantiates
ranges_to_free array elements, and one that prunes EFI memory map
entries that do not need to be preserved.

This will make it easier to determine whether or not a EFI boot services
region was freed in its entirety, and this informs the decision whether
an entry needs to be preserved in the EFI runtime map.

This will allow the distinction between early reservations of EFI boot
services memory (marked with the EFI_MEMORY_RUNTIME attribute) and late
ones (marked using the MEMBLOCK_RSRV_KERN attribute) to be dropped in a
subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 58 +++++++++-----------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 98fdc286eb40..b7c8337d8f88 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -416,13 +416,23 @@ void __init efi_unmap_boot_services(void)
 		return;
 	}
 
+	new_md = efi.memmap.map;
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		bool has_reservations = false;
 
+		/*
+		 * Build a new EFI memmap that excludes any boot services data
+		 * regions that do not cover any reserved areas, since those
+		 * regions are being freed.
+		 */
+		if (new_md != md)
+			memcpy(new_md, md, efi.memmap.desc_size);
+
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
+			new_md += efi.memmap.desc_size;
 			continue;
 		}
 
@@ -433,40 +443,26 @@ void __init efi_unmap_boot_services(void)
 		 */
 		efi_unmap_pages(md);
 
-		/* Do not free, someone else owns it: */
-		if (md->attribute & EFI_MEMORY_RUNTIME) {
-			continue;
-		}
-
-		/*
-		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
-		 * map are still not initialized and we can't reliably free
-		 * memory here.
-		 * Queue the ranges to free at a later point.
-		 */
-		if (efi_add_range_to_free(start, start + size, &has_reservations)) {
-			pr_err("Failed to reallocate storage for freeable EFI regions\n");
-			return;
-		}
-	}
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+			/*
+			 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
+			 * map are still not initialized and we can't reliably free
+			 * memory here.
+			 * Queue the ranges to free at a later point.
+			 */
+			if (efi_add_range_to_free(start, start + size, &has_reservations)) {
+				pr_err("Failed to reallocate storage for freeable EFI regions\n");
+				clear_bit(EFI_MEMMAP, &efi.flags);
+				return;
+			}
+
+			/* Continue without advancing new_md so this region is omitted */
+			if (!has_reservations)
+				continue;
 
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
 		}
 
-		if (new_md != md)
-			memcpy(new_md, md, efi.memmap.desc_size);
+		/* Advance new_md so this region is preserved in the EFI memory map */
 		new_md += efi.memmap.desc_size;
 	}
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

