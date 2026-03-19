Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E088A3B27F0
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911172; cv=none; b=pcOWZWxmRcIicKkRaP2lJV7wt1P2/rCYaTa54pBf6aEPpSAiZp5e0mzZJMKBicLmnTAlveBq8V+GK2fb6be/Kh5yDnLMlICM28sSjl9Pk9KasvixYve+j8PcdoVfsyEpiOBFSFgSSqTvuZvhT5joVHkXPzlLHbu1Z95Ckyzl2Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911172; c=relaxed/simple;
	bh=Fy9MOluLOggD8cfRnDqkDt/FGOVFD/iQX9eNsrTSNHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k2WklsVUKo0IyY/KjeZNrIyDwCp0DnzJFlIsEb/cP1lEwpvNE3fkCtJHIeCuMGH3BvWd9y7CIq73sCBp0px2lH3fm1mKbdwx+zawDyqNmmSxhc4JIsnlWfneGovlnsSdFIrZfRZesBLh3+QU5PVI3a3TCtpW1CVAXb+1gEL3Ovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ToGG9nbl; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ToGG9nbl"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b3a0d25d8so397827f8f.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911167; x=1774515967; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sMI4yfdxgjto84eW4zoc8n45SmfOaq24fXHg38YbzuI=;
        b=ToGG9nblDfKt/tYJvpgXrr9djoYo1iEsv2HOcAQk+ozUGPDk7HvPi5dJ4TLnR9n+Ou
         w4idhFo0cbmXnkkqJLK+k/Pep9C5AKFb0d66xj5VO90i1mMEqkaMJdtDl5I7rTWyFCjG
         ATBj+IyFaLvWlIOSu4Hu7gJf7LtNDZPXv4cIY+KpxfD8y5aPSEkvg1zFMkejw950uLxv
         4RyHY4ZOrw216WzyE6QPHeU2UsiotjtfL5w0nDy28G6iJHt0qjzDG5Ztv/o1nyYvA7Bn
         JXU2k5eUoYBF5ldKeno7Y/cUPN70S8RdnFtHAru5ho/MG0s/rEeK19hc6cfXjHIPOjiU
         //kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911167; x=1774515967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMI4yfdxgjto84eW4zoc8n45SmfOaq24fXHg38YbzuI=;
        b=jMuWN+8Ew65T2u1gttfdxWKIbhz64FKhpR0bdlf7RaJYUUFWTUW52+YFl9Zlg0IYqZ
         8OImCNIt8Y9vRy+xNkhDUEAERGhQlJpowuWZ0IODzLvNo5GVkweNpjBPFli/HVRMsp2C
         /LGyvC5TLgawSc3bZD7DRdJf98w1f6U6GNtcTArMfjR9OVQu1h/EIJhLyV4C4BqRaU1n
         aacWWydmA9AV1kH6fsFSbt9+h68BQF3FF3rMN9V1UqARmOnd7502L8/jZjZLdbDFg6uz
         pFqffhIRBCd8aMcGYNWcX/E9B4eyJFIYg5YC4Gc3EH2MafC7t5ff0ehHOe3wu05Bew7W
         ukFw==
X-Gm-Message-State: AOJu0YwOBumMN1bY8V9MPmQ/xK8PQjWI5RYPjwQsSBWMdjdC9g28NNgS
	KPKqxdhqv7CnYP+qx89/a/TbfSIr6T6EoQQAORujLf4EFJwxPi4ZesVv5rt9hrMncW4w1ImkEg=
	=
X-Received: from wmbjx4.prod.google.com ([2002:a05:600c:5784:b0:485:4f4a:bd84])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c0a:b0:486:f8e9:add5
 with SMTP id 5b1f17b1804b1-486f8e9b51amr37917475e9.19.1773911166985; Thu, 19
 Mar 2026 02:06:06 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:35 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2714; i=ardb@kernel.org;
 h=from:subject; bh=tRLOeo/RL3/RaVOez+iRRs5FLr7HogiqFZmpRAxB1M0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3ngRZWQZRadEw5mmLFY6W3Fo9tc6Icc6pxvjeg73Lz
 qmcLYnvKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNx4WFk6Gq757L275NjizT2
 r1oitMVvmuaa9+9tbkgXvVm35UzmyypGhgd7qhRczY9bydet4GvSY928ufTO6qerZLX+5lQvvB5 izQ8A
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-26-ardb+git@google.com>
Subject: [PATCH v2 05/19] x86/efi: Omit RSRV_KERN memblock reservations when
 freeing boot regions
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of freeing all EFI boot services code and data regions that were
preliminarily reserved during early boot to work around buggy firmware,
take care to only free those parts that are not marked as
MEMBLOCK_RSRV_KERN. This marking is used by the generic implementation
of efi_mem_reserve() to mark things like informational tables that are
provided to the OS by the firmware, but where the contents of memory
have no significance to the firmware itself. Such assets are often
passed in a EFI boot service data region, leaving it to the OS to decide
whether it needs to be reserved or not.

This removes the need to mark such regions as EFI_MEMORY_RUNTIME, which
is a hack that results in a lot of complexity in updating and
re-allocating the EFI memory map, which would otherwise not need to be
modified at all. Note that x86 is the only EFI arch that does any of
this, others just treat the EFI memory map as immutable.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 40 +++++++++++++++++---
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 30b8012eafaa..906e29754026 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -536,6 +536,40 @@ void __init efi_unmap_boot_services(void)
 	}
 }
 
+static unsigned long __init
+efi_free_unreserved_subregions(u64 range_start, u64 range_end)
+{
+	struct memblock_region *region;
+	unsigned long freed = 0;
+
+	for_each_reserved_mem_region(region) {
+		u64 region_end = region->base + region->size;
+		u64 start, end;
+
+		/* memblock tables are sorted so no need to carry on */
+		if (region->base >= range_end)
+			break;
+
+		if (region_end < range_start)
+			continue;
+
+		if (region->flags & MEMBLOCK_RSRV_KERN)
+			continue;
+
+		start = PAGE_ALIGN(max(range_start, region->base));
+		end = PAGE_ALIGN_DOWN(min(range_end, region_end));
+
+		if (start >= end)
+			continue;
+
+		free_reserved_area(phys_to_virt(start),
+				   phys_to_virt(end), -1, NULL);
+		freed += (end - start);
+	}
+
+	return freed;
+}
+
 static int __init efi_free_boot_services(void)
 {
 	struct efi_freeable_range *range = ranges_to_free;
@@ -545,11 +579,7 @@ static int __init efi_free_boot_services(void)
 		return 0;
 
 	while (range->start) {
-		void *start = phys_to_virt(range->start);
-		void *end = phys_to_virt(range->end);
-
-		free_reserved_area(start, end, -1, NULL);
-		freed += (end - start);
+		freed += efi_free_unreserved_subregions(range->start, range->end);
 		range++;
 	}
 	kfree(ranges_to_free);
-- 
2.53.0.851.ga537e3e6e9-goog

