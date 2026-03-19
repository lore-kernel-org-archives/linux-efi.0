Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3783B8BAE
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911184; cv=none; b=SuHPRinEfgOLXcxpyFt0mLi33gyM7NiwyaMrO/uIhcZ11o4p+GfB/2kP9onH/UKNj9WND9znXCT4UtQBgzQ72u/dvLYEXBeCrko3/35mKuPIZgGaCb8V9rkNyCEvXs5TBzt52Fuqe31jV8iMeC7WEvaR5gJLBnxiqICS7YiQ0qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911184; c=relaxed/simple;
	bh=mj1/FdNrxSJomn4MqIFLdYl2xhCRYAPFvrFp7cM1XGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S2wyFVSaf38/A+Uq6ucnkAY8UclGTPojKTRG8CNykl+QhBJYOo+ps1r8+MNgmxFREv+piCUBDeUrYtVgHAhoqiOaYHm/A+RArO3zd6OcKSOuSYQem9y20eb8EYb3PNO7oU0lEFwAw7t2cOLufqutj1JGE1dUmOFG/QmTxQXWhXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FWZ1d8y+; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FWZ1d8y+"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853466655dso9566255e9.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911181; x=1774515981; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FUd0sbvQPAQ2xS+BnxTruRhjwkkPtC2MAYLp44Di0G0=;
        b=FWZ1d8y+uyicpXySBLl5Rz1PHbCmma5CJrIfZm1F3nnwgRtiQFXuqiKwtd7d/tLzdd
         ZbStXY3oennDnoTUh2l861GRV29V8+C+mmG4gkS1ZAIIDBjjDKPA/1XmAe2BKS/ra53u
         FYaZe48LBHAt3Oh6cpv5V+fGD/WVUMBEGspknLVI9506zWT0mkLWLgxJJ91WW2gIXHeC
         7coQ15VLnKVImMksdtcntoG9fnc6tFAZqZEfd581atiAgfbyugmRXu94pn+Dq/Uj9KYy
         QgRByIFLEEK4ZZ4ApeZcVQ5rlmW2A1XRPU0O/Ql742XZzFHqxyWtCVQjy0OrQJ+hSMyG
         I2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911181; x=1774515981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUd0sbvQPAQ2xS+BnxTruRhjwkkPtC2MAYLp44Di0G0=;
        b=Z5P9YykgPg2NFchxDbP1FNiBHlNBclTQ8ZvQUsG5qFS9kcAbCEYEzI1pJdCVS2GAZ1
         ZzEMOMWyGjQnuVmlO0RWBrotI0VLhrxQuXMf1xZsh+6uD/RNYchacNHREMs0pHrmaaRs
         9ERTQ5e4j8KjaBVL/9vqrH+Me1oWhMpijBSGv/Ab+IpFKH4lOfNSf3/zhnf7lPCfaAbE
         ConcAwIseLFpVbOU+fHwJSzuMdUC1o5VMudQT23PgxKGAMo6kQyNhxjEIcKrTnKTPGrN
         mMi9f+mOD4dgRLgGXC3vdu/Nw63bZy67zmvoRmJ+M2ppn3rYT1VCcDlw9iswHq6OUi7H
         b1Ng==
X-Gm-Message-State: AOJu0Yyb1KZOVrylc1gbIB9/P8ry+t+myebXSvg8YNofiDb2JqNPjxWh
	UKiW05pUyMJGqCf39R7mSZ6q1skhao3l7FYEgTaFZMDQlF4+SJEGHYtwT3giSlA7aAfQxhvKwg=
	=
X-Received: from wmla9.prod.google.com ([2002:a05:600d:2389:b0:483:2ce9:2b05])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19d4:b0:483:6a8d:b2f9
 with SMTP id 5b1f17b1804b1-486f4440f10mr104373905e9.5.1773911181125; Thu, 19
 Mar 2026 02:06:21 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:48 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3551; i=ardb@kernel.org;
 h=from:subject; bh=RgYBBHo63dVXcto8c6eRW4IKNVj2ghfqwhRHPXlXxVo=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGm7vHDIobmpC70ggS1pj4SINEncGlW8wWrCfQ0jZalrKMRXE
 4h1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmm7vHAACgkQMG4JVi59LVxv0gD/aujA
 z6zrIy1wbJRsucHeItyXF97MaCh3f6yCiQw6osIBALb4WdyVOHpr3KsQxhZgsDHRj0VeMhhAEog 4NeVDeFUO
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-39-ardb+git@google.com>
Subject: [PATCH v2 18/19] x86/efi: Do not abuse RUNTIME bit to mark boot
 regions as reserved
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_reserve_boot_regions() marks all EFI boot services memory regions as
memblock_reserve()'d temporarily, so that they can be mapped in the EFI
page tables during the call to the SetVirtualAddressMap() runtime
service.

This means it has to take care to distinguish between regions that are
entirely unused from regions that are already covered by some prior
reservations, either by the kernel itself via memblock, or via the
firmware or bootloader via the E820 map.

For this reason, it only memblock_reserve()'s boot services regions that
are not covered by any prior memblock reservation. Otherwise, it will
set the EFI_MEMORY_RUNTIME flag for the region, which indicates to the
freeing code that runs later that the region must remain reserved.

It also sets the EFI_MEMORY_RUNTIME flag for the region if it covers any
E820 region that is not E820_RAM, so that -again- the entire region
remains reserved indefinitely.

This is inefficient, and abusing the EFI_MEMORY_RUNTIME flag for this is
not great either. It would be better to respect the actual memblock or
E820 reservations instead, which is feasible now that the freeing code
takes the MEMBLOCK_RSRV_KERN flag into account.

So drop the EFI_MEMORY_RUNTIME hack, and instead, respect existing
memblock reservations by upgrading them to MEMBLOCK_RSRV_KERN
reservations. Take E820 reservations into account by cross-referencing
them with the EFI and memblock reservations when actually returning the
pages back to the page allocator.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 29 ++++++--------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index bc9dfe7925aa..8f2dc477eee0 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -298,26 +298,13 @@ void __init efi_reserve_boot_services(void)
 		 */
 		if (!already_reserved) {
 			memblock_reserve(start, size);
-
+		} else {
 			/*
-			 * If we are the first to reserve the region, no
-			 * one else cares about it. We own it and can
-			 * free it later.
+			 * Mark existing reservations as MEMBLOCK_RSRV_KERN so
+			 * they will be respected by efi_free_boot_services().
 			 */
-			if (can_free_region(start, size))
-				continue;
+			memblock_reserved_mark_kern(start, size);
 		}
-
-		/*
-		 * We don't own the region. We must not free it.
-		 *
-		 * Setting this bit for a boot services region really
-		 * doesn't make sense as far as the firmware is
-		 * concerned, but it does provide us with a way to tag
-		 * those regions that must not be paired with
-		 * memblock_free_late().
-		 */
-		md->attribute |= EFI_MEMORY_RUNTIME;
 	}
 }
 
@@ -392,6 +379,9 @@ efi_free_unreserved_subregions(u64 range_start, u64 range_end)
 		if (start >= end)
 			continue;
 
+		if (!can_free_region(start, end - start))
+			continue;
+
 		free_reserved_area(phys_to_virt(start),
 				   phys_to_virt(end), -1, NULL);
 		freed += (end - start);
@@ -428,9 +418,8 @@ static int __init efi_free_boot_services(void)
 		if (md_start >= md_end)
 			continue;
 
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    (md->type == EFI_BOOT_SERVICES_CODE ||
-		     md->type == EFI_BOOT_SERVICES_DATA)) {
+		if (md->type == EFI_BOOT_SERVICES_CODE ||
+		    md->type == EFI_BOOT_SERVICES_DATA) {
 			u64 f = efi_free_unreserved_subregions(md_start, md_end);
 
 			/*
-- 
2.53.0.851.ga537e3e6e9-goog

