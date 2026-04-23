Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DD6363C7A
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957666; cv=none; b=qikNmWK75eGM4EAwLdxL3ohg5VFdVvx7mrD5XaPA3ZTjdZuHDDYabKYFaI5oN0dlUsltFqVXwikgLVGvDX0T6RijSeiNz2OjwSdZ8DW9Kh/sDh8YxXFQ5DQymeCvTnij3IbOLLfPJUXyfn/TOq9niCueTm+9Mczrw3BP+TvIYEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957666; c=relaxed/simple;
	bh=/OVhF57WbQigCK5DeTOM6aYd0BdynAOnjWEYScbyD2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MS0vEJ6y3q7/Mlv1zYw/pO12u3QPjLB7z4/Z0zygT6QLuOM+V7/lPoQ5JdC8D4uMau7OgnzmiK42fP1brAJmgGaRaa4FPRuUfrhUnW+CqMWB4L2mxjvNFTA1EO6QobAlKWyLgFPS8ynKeGnSqrUfroJJ4kpz9coSjvDKP8ZzBA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxq53Qgj; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxq53Qgj"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a589c7879so17464315e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957664; x=1777562464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5s0+CUEMaJcjjFm/1CcbVMArs93hKlDfpfsoFtL45Lw=;
        b=fxq53Qgjns/E3D7z0LcC/AipKRVqwH93SSequh03Mliqp8j5OHIKhPl63RHjGZoY94
         zVG8iB+BBg7z6Epcnp0uMLgp3Tx0bTJF3o+V/wkYLIXj2A6tmLINhUD1AN/AyDdWDflE
         ktj6MG7B9NdSfIEX4c9SpjnUF3a4zV8gejDS5PSi8X/7xJYk7jJ1nB44sxr23JWqp4y6
         h3/m8UHnPT/qUKecpDha0m4mCxZxk0SChwmNqek1TxdoU+xe32kc0DdSB0VlzHMG2LeS
         8FNXb1p8YilYnTgOSN52oijyd4gPm1CQYSS9APVC+en0t3+v8sCphpXfRf76qpBab3h0
         ZEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957664; x=1777562464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5s0+CUEMaJcjjFm/1CcbVMArs93hKlDfpfsoFtL45Lw=;
        b=g2Uo2P54dr13IyzcT/Io1HZzpf0PXCc4HGx4ug7VUf0av5nqU2ANy+Jdqq9mz63XbI
         QEhHGJZjEGXISVCG10/pwVFvcdY0hwiLs74khcIXvR+Y2y/y0SaPnSw5MgihGGCvHkOU
         3+2RNKxFPDD6J9Oc3NekMb+BysiHZWjzsvYwtDuj6muvbFqxIU7Oz49fihNV5ITfFlw/
         wNHCaFqXs8bNpniy6IWJYsycxPypTFAt8ajorDTKFiKBW2KUPsQO8VRL3HK1425D2cSt
         yuZzocWR4jm9ZegCzmYZkSUS7fkdsOkao4zv9DjWAkX5QfRiAGF9RBVmYSWp/oUg1N9j
         80oA==
X-Gm-Message-State: AOJu0YxCPcUSra2hczM98SYAACz3X6YYy4xBkdqYhFW6GhR6yW9CmcFJ
	nU0rk794uNoFEcWcr/7OppeU0+Ji1A7BffUcKGw5JAu/cXHZzzJG3DYLL+nIYV4A5BTQ9M+oiQ=
	=
X-Received: from wmim14.prod.google.com ([2002:a7b:cb8e:0:b0:485:4f4a:bd84])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a410:b0:48a:5821:6006
 with SMTP id 5b1f17b1804b1-48a5821692dmr132219625e9.4.1776957663617; Thu, 23
 Apr 2026 08:21:03 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:29 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1907; i=ardb@kernel.org;
 h=from:subject; bh=x0whcXz7bSCxvxkEWlMbHW/Kp62wz+iO//Bp/09SSqE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxf7IWZ7ndT7IHZ6m1Zrzd9JvkTZxP+3oZ2vPS+hvO
 rhz7yrdjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCR5B5Ghn0HshbqazK+y0hx
 cplcer10bm7q9aooNvtFQcbJX5VEtjL8T2SoLF2ok8PhZeUp0fqJU8whgnVuQBrHZRZHvV6tzLX sAA==
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-23-ardb+git@google.com>
Subject: [PATCH v3 04/17] x86/efi: Defer sub-1M check from unmap to free stage
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
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
index 4d8de7c6ce59..e2e57e9201a9 100644
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
2.54.0.rc2.544.gc7ae2d5bb8-goog

