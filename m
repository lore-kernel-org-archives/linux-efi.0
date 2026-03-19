Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536843B7B84
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911182; cv=none; b=LEyCHpsW7jnI9GnGKjpOxehMClTSiv7MYbxBVG1jy15i1q2qPw9otg6DtMp6wWjdi/iJVRgkwctF2Ru9os/1jexujy1cnO6uOdaD55yHZEm63UcU1Nc4RWpO5tu4TgblOPzyPkmMsHNgGowSyiZ04RLbpm9lGLsLTGJ1EUhWTxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911182; c=relaxed/simple;
	bh=5L36GgwG9oV73XOZeL4vV75HgPZS6IG/54OunU8ZP+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QUYNkAn36e8JgFgCqjEl4gTwPf4k496uY3t3r66SE+l2FvNWoBGQHJQz7yJ/EXtXleDur6A0CbXrG/sWLpISAbyWUxxM2Q2JqVAoc9jl5IhCbdO/B4M0WFr5kQt5/N99DdrkNgKR/Et6hjsomuVYoKlXMrH/95LgLkFSJIiDJ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U8naiSs8; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U8naiSs8"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-66802fe028aso1184333a12.0
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911179; x=1774515979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wclTurTdnWGKGBQy4DZr4fdQXetijg29sgghGdGIfUI=;
        b=U8naiSs8A0/xemXYHF/GpziN06BoEMGMx3oHjQ71CpmaE4dx5imFR17O7otYoYO5jG
         d0YStooHqAIhxVlcjms5eJPg6DYG9kO4ZKvFiIIBKJ331cYFk7W/Iw6vn6lD3FDlIT9O
         EAIb6ca7elVQOVxshHNfTJRCF2d9Qhry1ZItKkWFnSw255CbkzCegM3U1LQlyC14q5z/
         infN2aiFe/iWH6y3zI/zDlSIki0yQQPVNRjNi7NOohUs4oGIU5GwQvZj9BiXsVd+0Ddm
         1aLCQEaXCgved+6Bfgo4JhgAdqCjXk6eQ7Ka/R9Bf6n8gshEzbBVHr/QBDH6TwJ702dm
         8yZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911179; x=1774515979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wclTurTdnWGKGBQy4DZr4fdQXetijg29sgghGdGIfUI=;
        b=gghU7BceHsilZ0pOx/byGtGgnpHYdEOEK7vxYAB+EDximzfBFQGopJ3GEOPBzO7u9Z
         ecsx1ZMGjyXIIGPqy4jaEwFVKkg/7FteKcssYfWdAS6qZqqcZYzr8/siYX7gEN9MmixB
         0G8H/RwIf0x8sYPU8H4+H+HcHIkc6xNzzVudjjUQsBEEI7zNEj4z4vKL9/aylPTp1eps
         Ot/GdEleUKIZVloKObkuhc1qY5zAqLyGSUfFLnAoBteJthHHhNaYMpfSrvDMM/fdyhZ2
         zqrZL2N34fDgqECSjH835F7GlCBdBNZEXYGXzqC3sRCg8ERrffbR+X/CBR7oyAguOCQ8
         0Qwg==
X-Gm-Message-State: AOJu0YzeDeDDS3yz7hHOL3rrW1GWsS7f/1nd6uUQF74J9hm9XC+vGdtY
	RJvdpqncUfr0a+1nFqGTjtIgaXhTTWcHR/bEKvfA8LT2BumD5TQXLoOP69pK4LiY04F7/CvDvA=
	=
X-Received: from eddq7.prod.google.com ([2002:a05:6402:5187:b0:667:94ad:60ed])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27ca:b0:667:53aa:d27e
 with SMTP id 4fb4d7f45d1cf-667b2ff64d0mr4218306a12.18.1773911178384; Thu, 19
 Mar 2026 02:06:18 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:45 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4012; i=ardb@kernel.org;
 h=from:subject; bh=osR4eXnUzICwAqwqWOcXt+WcNC9ItrGU/4bEgYiufqI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3ntz7+v/3iuzbtW97YHWT+IYpWpr8P08ebnpx2muJs
 uwBxm77jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARG1ZGhqVbUhuXfnj0qvSg
 uqHOBreweDW9uinB/w0Zt3CvUOd+Y8PIsGHapeaPEwLWvn3O+/PxDs/k68VmkVOXrXup4rxBef+ 37TwA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-36-ardb+git@google.com>
Subject: [PATCH v2 15/19] x86/efi: Use iterator API when mapping EFI regions
 for runtime
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Use the generic EFI memory map iterators to invoke efi_map_region() on
each entry in the map. x86_64 and i386 traverse the map in opposite
order, so the two cases are handled separately.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 90 +++++---------------
 1 file changed, 21 insertions(+), 69 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 44d106879120..8778ad441c42 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -498,73 +498,6 @@ void __init efi_init(void)
 		efi_print_memmap();
 }
 
-/*
- * Iterate the EFI memory map in reverse order because the regions
- * will be mapped top-down. The end result is the same as if we had
- * mapped things forward, but doesn't require us to change the
- * existing implementation of efi_map_region().
- */
-static inline void *efi_map_next_entry_reverse(void *entry)
-{
-	/* Initial call */
-	if (!entry)
-		return efi_memdesc_ptr(efi.memmap.map, efi.memmap.desc_size,
-				       efi.memmap.num_valid_entries - 1);
-
-	entry -= efi.memmap.desc_size;
-	if (entry < efi.memmap.map)
-		return NULL;
-
-	return entry;
-}
-
-/*
- * efi_map_next_entry - Return the next EFI memory map descriptor
- * @entry: Previous EFI memory map descriptor
- *
- * This is a helper function to iterate over the EFI memory map, which
- * we do in different orders depending on the current configuration.
- *
- * To begin traversing the memory map @entry must be %NULL.
- *
- * Returns %NULL when we reach the end of the memory map.
- */
-static void *efi_map_next_entry(void *entry)
-{
-	if (efi_enabled(EFI_64BIT)) {
-		/*
-		 * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
-		 * config table feature requires us to map all entries
-		 * in the same order as they appear in the EFI memory
-		 * map. That is to say, entry N must have a lower
-		 * virtual address than entry N+1. This is because the
-		 * firmware toolchain leaves relative references in
-		 * the code/data sections, which are split and become
-		 * separate EFI memory regions. Mapping things
-		 * out-of-order leads to the firmware accessing
-		 * unmapped addresses.
-		 *
-		 * Since we need to map things this way whether or not
-		 * the kernel actually makes use of
-		 * EFI_PROPERTIES_TABLE, let's just switch to this
-		 * scheme by default for 64-bit.
-		 */
-		return efi_map_next_entry_reverse(entry);
-	}
-
-	/* Initial call */
-	if (!entry)
-		return efi.memmap.map;
-
-	entry += efi.memmap.desc_size;
-	if (entry >= (void *)efi_memdesc_ptr(efi.memmap.map,
-					     efi.memmap.desc_size,
-					     efi.memmap.num_valid_entries))
-		return NULL;
-
-	return entry;
-}
-
 static bool should_map_region(const efi_memory_desc_t *md, int unused)
 {
 	/*
@@ -624,8 +557,27 @@ static void __init efi_map_regions(void)
 
 	efi_memmap_filter_entries(should_map_region);
 
-	while ((md = efi_map_next_entry(md)))
-		efi_map_region(md);
+	/*
+	 * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE config table feature
+	 * requires us to map all entries in the same order as they appear in
+	 * the EFI memory map. That is to say, entry N must have a lower
+	 * virtual address than entry N+1. This is because the firmware
+	 * toolchain leaves relative references in the code/data sections,
+	 * which are split and become separate EFI memory regions. Mapping
+	 * things out-of-order leads to the firmware accessing unmapped
+	 * addresses.
+	 *
+	 * Since we need to map things this way whether or not the kernel
+	 * actually makes use of EFI_PROPERTIES_TABLE, let's just switch to
+	 * this scheme by default for 64-bit.
+	 */
+	if (efi_enabled(EFI_64BIT)) {
+		for_each_efi_memory_desc_rev(md)
+			efi_map_region(md);
+	} else {
+		for_each_efi_memory_desc(md)
+			efi_map_region(md);
+	}
 }
 
 static void __init kexec_enter_virtual_mode(void)
-- 
2.53.0.851.ga537e3e6e9-goog

