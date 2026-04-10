Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D7A39A072
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808035; cv=none; b=LrWoveipnPjrO3ofY+aHOeetXhNxH+BIY9RSXwH9D0YTFyGXAAllVmMh3tDjBQchxJqw1IoOJXKbugN7EHtviG9DXeB37xk3bW8/DuiGWT8Zrp6XXs2lne++t1BZMSBrkxUWDvlqYqQzzXiy+EFeTxd2G7+1NMbGxOmtSFPFh28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808035; c=relaxed/simple;
	bh=nhSKk3yiZTlmuLZlKrP4M/EwgJGoUmv6HuP/CfHcubE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jLvgcuQF+SvD8Fri4uc3gj29RSeRcD8k8zhOsI1WbY15CMjiIZsRDz/HI4FZAjDjGszc7cT+x6yzmFlfw9G+LAuyVWLg2Z5GYVR/kT+qHA84IF7TPPK4gyD3TjbFWCvmdlmgypS94xH47YlMkXAIFZzTmav5bGBGlxq35D33GaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGR7ZU1C; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGR7ZU1C"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso4476085e9.3
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808032; x=1776412832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh+VwlSPoKJfKmdjpjK1njBuyxMj3AtXQ5UacMb0+Mg=;
        b=MGR7ZU1Cg0tQ6ykq53SSZmTKbEypuBPwThtOVATo8LzWmpDqzdALf8hvybqaw48hhI
         aBYNECpxUDl7oGTxNWKN28g+yCKqm6Z/8WKmKatC47QJeWfFQWeGw+lkVFxjAJZBozYw
         SYIit7yyds3WsZJpmP8MhwfNA8ne1NYcUnXCmYR3YissVIKI8xrcFDSBLHr0ZKPENLkg
         DCjCIcvt/pdMIpPTTkdv4NzvYh4e9gM8lwNFx1pPLXH7Nzzv2szzth95gW6RmyWCIn4T
         Gv/SCZ7tb/hyfkuKpdYB07VkHtyexmkN4LLkrOd0G2L7bX7hwMyH550fOPVR27hiJP5G
         N0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808032; x=1776412832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh+VwlSPoKJfKmdjpjK1njBuyxMj3AtXQ5UacMb0+Mg=;
        b=GSyNDY+NvcRFrdHY4Nn05+N4SYzmqknFl5NA4Of5RwX3Ky0+i0SkN7jR7Dok3B28rR
         2hgoJ2Om/ILr0HW8puUTcgMlHlbKPzthAtSDB17stMjktNIaxirdNOkz//kJUNuJ1+pV
         k8aGDbRkxrd2oV3xmDcj6OW4EZ9s0FN2GdPCej/JG8jluawMeWBbqkgWooxJu4uiwNy2
         hacwt8nCp6O08aD26A0YzlWz6M/o15wSWHfDUjZyVBIfCQeIRy2wOIyJ+U8yRKJAw0/3
         noJY6QgTWhTZ6fyA9zKByks1pJXYDVF32ZtoyQBHZ8CzxrlxdPiG2SWMBehQf5KIdz1n
         816g==
X-Gm-Message-State: AOJu0YxKXop81G3KOr+aFmVZNWbX6jiTCBzXqUetF6p7O793BnR4+bhe
	e4ojJDjDzI9QWyOv2zjl9A/QUI4qrYn+rNuyCuZ3wnPBQkXPNOm4dfXd2DbnObDT7mpykCwaJ6M
	jzuFCIeGr8OIISrS1t3vXaDpBfl1I7Uw2y2gC4WdhLil8lLWf6g2IuvmJ77vc9UnqeXIlWHGfeN
	8jx2/ab4CSnhuwzU1ppJjIG6GyacN85Q==
X-Received: from wrbdi3.prod.google.com ([2002:a05:6000:ac3:b0:43b:865c:710a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c171:b0:488:a894:b27a
 with SMTP id 5b1f17b1804b1-488d67f0105mr26435495e9.8.1775808031836; Fri, 10
 Apr 2026 01:00:31 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:54 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1904; i=ardb@kernel.org;
 h=from:subject; bh=6FE52P5VWh4lK//afSy92y8GicT/whGYEMZykED7ys4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPG2r+qXI/vRh02LZDY9/bdqZD5V5dHta8KMzKS8Nlwt
 0BmwtbcjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCR5TIM/4srEm5Mai7usGP7
 dc49T1rs91zvRez58Rcqevs7g748aWT471j1p0N+ktjlSYui1Dg8/BgL90cYRLUJPXjxQ/H7wuf J3AA=
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-13-ardb+git@google.com>
Subject: [PATCH 4/7] x86/efi: Defer sub-1M check from unmap to free stage
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

As a first step towards moving the free logic to a later stage
altogether, and only keeping the unmap and the realmode trampoline hack
during the early stage of freeing the boot service code and data
regions, move the logic that avoids freeing memory below 1M to the later
stage.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 28 +++++++++-----------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 05ef1b06c25d..999c9277c49c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -468,18 +468,6 @@ void __init efi_unmap_boot_services(void)
 			size -= rm_size;
 		}
 
-		/*
-		 * Don't free memory under 1M for two reasons:
-		 * - BIOS might clobber it
-		 * - Crash kernel needs it to be reserved
-		 */
-		if (start + size < SZ_1M)
-			continue;
-		if (start < SZ_1M) {
-			size -= (SZ_1M - start);
-			start = SZ_1M;
-		}
-
 		/*
 		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
 		 * map are still not initialized and we can't reliably free
@@ -537,12 +525,20 @@ static int __init efi_free_boot_services(void)
 	if (!ranges_to_free)
 		return 0;
 
-	while (range->start) {
-		void *start = phys_to_virt(range->start);
+	while (range->start || range->end) {
+		/*
+		 * Don't free memory under 1M for two reasons:
+		 * - BIOS might clobber it
+		 * - Crash kernel needs it to be reserved
+		 */
+		unsigned long s = max(range->start, SZ_1M);
+		void *start = phys_to_virt(s);
 		void *end = phys_to_virt(range->end);
 
-		free_reserved_area(start, end, -1, NULL);
-		freed += (end - start);
+		if (start < end) {
+			free_reserved_area(start, end, -1, NULL);
+			freed += (end - start);
+		}
 		range++;
 	}
 	kfree(ranges_to_free);
-- 
2.53.0.1213.gd9a14994de-goog

