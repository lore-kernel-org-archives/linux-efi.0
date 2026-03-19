Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6E33B27E9
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911181; cv=none; b=ow7D82kT5FQY6C8K3kXR4MyOTo2LZOWBICh8GibWVUgy3R21IBpiJrdhhWLb/Kia9gEH6v2mysvkhMQRJX8Z01UOqqGoF088ZYabVIQ1MN6WG1Tac/wYx/z7g5LSeY847x7eIDpVGc6ug3Y7+H6n7bqNq89a4XfF4DdiWJtA1jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911181; c=relaxed/simple;
	bh=9OprONxDWnCOJYX+FgMjLUb77QLi2ZEk9RUwqdxBQHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K9GaNRPOvbMTNlq+s3xVJrNNxGD5eXzbu67vKJIbjzHyz7BvXKfFlQz9eDNMglx2aoc2epRBew0ECB+ynl0lTL5XHqidc/QV3IfGqYJLaZPxPN3tPQUV5Ouu1cxLHU6le9iDE6U73COlPdMW5/s2kUvxtfspZwxM49cMkhUwIfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r7/I/yvB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r7/I/yvB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485397788b3so3470085e9.2
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911177; x=1774515977; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRYZyyQvMVeRrU4Yx4WOuIvt5z1Qake/UrKB6R2VYpU=;
        b=r7/I/yvBljtkOiS281eBbyBFV5D/yWZryy939l+pB33384Go7fo5lmEYNU3uDhR4yV
         5GvX/tNZKqY5eYzFGUSeMDYpuyvwioswYj+kPUza36XAIcuieepsAkx+gVTvgIH95qmA
         rw9vVsvSd/L6C0Zv3qnfMWVGViftAbmopwAgaMJdLQTSea2fr4PGE2N85osQYI3JKU5/
         ltLryX3v3vz37vf2XV2BYrUBPT/9W2tx8r/DIUneL2QRpc1vhnkHbRd3/I9GcguK1IaP
         /4GtfOC84E4cOFmvTPsF4gU6xDUPsTGeZHvv5vVHnLPUO+OT4vijn6yHO5ZjudJ8PFBa
         soBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911177; x=1774515977;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PRYZyyQvMVeRrU4Yx4WOuIvt5z1Qake/UrKB6R2VYpU=;
        b=S3fSFD8cO38H1NSE06LTkfhJVC+jfitHJ5NjBoYVy1LDCw83heSAWSCmgjS9KltguK
         i1VQ3q7s/HoWDSH03biGeDFkasOr3WqIWK4RSSqHh57AGLS1QX0qeMQD9LM2RbdC/paN
         X6OHzcVx+Ui7+JduZsO3MLr5qBpyLYV/zSfs4s6q+ddyHLi/pRwq+TaFOXeGfMyHBD6G
         HapiqoxgOd4Pc1PEW7NnroknWpIBzRHUphwfGvbmO3JDHjEjZtMRWwoKbt4jDGdM/hoa
         rd7fDnnrpTBOdQNSBpZXRi3OsPC+fWa+G6lYjQl0Cc66WBU7xeEAkGgzAg3g/iz7kWZ/
         /ODQ==
X-Gm-Message-State: AOJu0YwDnp3j1CkPLe82Pw8+rN4gVMp8WfXnK44srD73LsFeVehKOURZ
	As0BAW61ciqLgtgfhSS3rs2nLBgTaLf7EHeVknUoyqNrfmt4nCWWKDGjFPlFNadgRHBAOr9PJQ=
	=
X-Received: from wmqn21.prod.google.com ([2002:a05:600c:4f95:b0:480:4be7:3f3a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4703:b0:485:ae14:8187
 with SMTP id 5b1f17b1804b1-486f441fc66mr106760255e9.2.1773911177432; Thu, 19
 Mar 2026 02:06:17 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:44 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5125; i=ardb@kernel.org;
 h=from:subject; bh=+Cbk1AaYHmwQCKK7zA0yoqZBDfzZ+oWlWRJYofF/tdY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nmyFSc/z12bPeCOdY1pXu7RBJpIzdZNLnID7uY/TN
 8eW18/oKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMJmMjIcE9w9asjf/nSF2z9
 3V25bHmhw+dLCptvzXg7Z+P5HR32604y/Pcrfvhl6zPjrLhp200dxRbamt782nmcpfCl0TxPQ0G vCAYA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-35-ardb+git@google.com>
Subject: [PATCH v2 14/19] x86/efi: Update the runtime map in place
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
 arch/x86/platform/efi/efi.c | 89 +++++---------------
 1 file changed, 19 insertions(+), 70 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e9b84ecc859b..44d106879120 100644
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
@@ -586,7 +565,7 @@ static void *efi_map_next_entry(void *entry)
 	return entry;
 }
 
-static bool should_map_region(efi_memory_desc_t *md)
+static bool should_map_region(const efi_memory_desc_t *md, int unused)
 {
 	/*
 	 * Runtime regions always require runtime mappings (obviously).
@@ -639,40 +618,14 @@ static bool should_map_region(efi_memory_desc_t *md)
  * Map the efi memory ranges of the runtime services and update new_mmap with
  * virtual addresses.
  */
-static void * __init efi_map_regions(int *count, int *pg_shift)
+static void __init efi_map_regions(void)
 {
-	void *p, *new_memmap = NULL;
-	unsigned long left = 0;
-	unsigned long desc_size;
 	efi_memory_desc_t *md;
 
-	desc_size = efi.memmap.desc_size;
-
-	p = NULL;
-	while ((p = efi_map_next_entry(p))) {
-		md = p;
-
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
@@ -749,25 +702,10 @@ static void __init kexec_enter_virtual_mode(void)
  */
 static void __init __efi_enter_virtual_mode(void)
 {
-	int count = 0, pg_shift = 0;
-	void *new_memmap = NULL;
 	efi_status_t status;
+	unsigned long size;
 	unsigned long pa;
 
-	if (efi_alloc_page_tables()) {
-		pr_err("Failed to allocate EFI page tables\n");
-		goto err;
-	}
-
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
@@ -775,22 +713,33 @@ static void __init __efi_enter_virtual_mode(void)
 	 */
 	efi_memmap_unmap();
 
-	if (efi_memmap_init_late(pa, efi.memmap.desc_size * count)) {
+	if (efi_alloc_page_tables()) {
+		pr_err("Failed to allocate EFI page tables\n");
+		goto err;
+	}
+
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
2.53.0.851.ga537e3e6e9-goog

