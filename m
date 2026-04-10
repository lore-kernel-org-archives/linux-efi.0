Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA52B3AA4FB
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808039; cv=none; b=cUFHJ8R+7h7wQ9LMPdpJLKB0V8H7QqmBDRpCWFTLl8ocpcqzDsqPJyzbkdITLDutriAjwn7y0Dm4/zkWDwLBgzaZOckrfrYFN5MWmnunY0nrlEJ9ES0ym5IkbVHmJRHy0fC3A6BDGW9+ALCDaEXSdE/RyC9k92m+yuOlj7CZ49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808039; c=relaxed/simple;
	bh=4W4CxxD5Dxlp7I+ADPSq/Vuyb33eiXHyxz8fUdtuBfo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BYDS/N1X/unPsqMOXWUe9Hh8dm6u/OYNkroOm/Mcg6PNCgGFgihPKIGfuJT9Sp+ypEP5CgvyIXmnZNo02hhc2GVLw6eFz556ERyT+Q8IMVX4n6immmcKDcHQPJqkCVjRu4Pn4x4BAZkNxF0mdNGcU7qAxYZpCKXxWR3TJLyhyW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GNv/8Tu+; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GNv/8Tu+"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488c16958e9so10785525e9.1
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808035; x=1776412835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=64Gsuc+pgbKxgzVx0XspSJLmGpBqh32jTkSHxGYvit0=;
        b=GNv/8Tu+p7/KZhsRUaSsPsrXj+UbfQC6giKOJaqKU22IFYg/+lTgG3wUC5epxkgKi1
         uX68KcgVUIJKEUrOd1n/eRqWXXgCVBxfeYwtB+B+PxFy5/STXP8FRfIlOvKlx3ALw8QT
         bb/U7p53MsTVxJfTZUVwmwBNSALyc+OF7LG4yLJSjFAy26ywZ0+FlPavacDI8bH0MTKX
         oxr//kB+bTcsM7epN/varIIN6H0RcgHhEpCNucsUXTmHS/ZIR4j386/XZSHe5aK13gVR
         GF6csDg4DuOrVdwU8p3NPj6Ex8SuExYfn1rMsuWA7duW59hAltUTvWPlszGdfZ/6xFn7
         Gq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808035; x=1776412835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64Gsuc+pgbKxgzVx0XspSJLmGpBqh32jTkSHxGYvit0=;
        b=INUX2SZs4hwvmE4XcW1I0W/hYK9FxjyjveAlTlLjymydzfLhkaY36EpQUSLn7J9mi6
         nxUyasCbXPEFPTCcwkm4Tpqw3QP5rrr3ZGiMuWPHvQmPdhsdDvA+KvRI491pAO+E9JWi
         TdUXcAr7b0rPCuTZL2AGnzG52KLyy+D5PYJ/kOt7E0kxX9aDQNkwJ6u2ixz21Nvy4oq/
         BBrpAqnU38N7sZI2lHj+AtycKwOD1d8FsqthhrtHmHA2AJjWAZXq1TiUnu9P8lCB7Qs7
         VQd3ujrP9n6PPiSSDKkQaf1Iu/Xnp92HT7XLHf4gu7D+cYuQOJ5WQUVcGgVRB7j3KoVf
         jBGA==
X-Gm-Message-State: AOJu0Yy4z7jWuUJLN7PWeN6nS+z41C+kXfyeVNJHI/slp+rRGRxjIgZP
	NrrY3I6dVmyWL+oX2wO7cDC7N7POV2dU7L4H420bNzLLq7HfrhZG6Yko8znjwPihrdTjqMBmNkA
	TJwpJy62ZaINdMZ/1yWinkztb/VkdhNXYj86lfQcrYG5f7aV6AO7fP2ALhLv51gdNK0GWGT/54q
	h/Jk89x+2YzpGfUCPUFVYhqhE57EZ15Q==
X-Received: from wmbz1.prod.google.com ([2002:a05:600c:c081:b0:488:888b:cf6b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8907:b0:488:80b6:873a
 with SMTP id 5b1f17b1804b1-488d6860bc3mr15809595e9.21.1775808033196; Fri, 10
 Apr 2026 01:00:33 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:55 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3763; i=ardb@kernel.org;
 h=from:subject; bh=0dtpy6UFjr/qVlazrgUyoaxEm1jrc76faJUnaSEwhU8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPG2v+9TNaW1mcyLtx/oL1Iz0XN5Xm1ON/GI2+Oh/jKP
 9uxdn90RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIXjOG/3G3i6sOaqR8an0Y
 ZLCttDHDYVvOze7Hl5ytFr+O7U/luMLIcIj5Ce/8+8wN7FVZdVWZUSK1EtaTWuyilOJa7xXrHxV kAQA=
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-14-ardb+git@google.com>
Subject: [PATCH 5/7] x86/efi: Simplify real mode trampoline allocation quirk
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

To work around a common bug in EFI firmware for x86 systems, Linux
reserves all EFI boot services code and data regions until after it has
invoked the SetVirtualAddressMap() EFI runtime service. This is needed
because those regions may still be accessed by the firmware during that
call, even though the EFI spec says that they shouldn't.

This includes any boot services data regions below 1M, which might mean
that by the time the real mode trampoline is being allocated, all memory
below 1M is already exhausted.

Commit

  5bc653b73182 ("x86/efi: Allocate a trampoline if needed in efi_free_boot_services()")

added a quirk to detect this condition, and to make another attempt at
allocating the real mode trampoline when freeing those boot services
regions again. This is a rather crude hack, which gets in the way of
cleanup work on the EFI/x86 memory map handling code.

Given that

- the real mode trampoline is normally allocated soon after all EFI boot
  services regions are reserved temporarily,
- this allocation logic marks all memory below 1M as reserved,
- the trampoline memory is not actually populated until an early
  initcall,

there is actually no need to reserve any boot services regions below 1M,
even if they are mapped into the EFI page tables during the call to
SetVirtualAddressMap(). So cap the lower bound of the reserved regions
to 1M, and fix up the size accordingly when making the reservation. This
allows the additional quirk to be dropped entirely.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 29 ++++----------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 999c9277c49c..ee906c0c46c1 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -324,10 +324,14 @@ void __init efi_reserve_boot_services(void)
 		return;
 
 	for_each_efi_memory_desc(md) {
-		u64 start = md->phys_addr;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 start = max(md->phys_addr, SZ_1M);
+		u64 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		u64 size = end - start;
 		bool already_reserved;
 
+		if (end <= start)
+			continue;
+
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
@@ -427,7 +431,6 @@ void __init efi_unmap_boot_services(void)
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-		size_t rm_size;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
@@ -448,26 +451,6 @@ void __init efi_unmap_boot_services(void)
 		 */
 		efi_unmap_pages(md);
 
-		/*
-		 * Nasty quirk: if all sub-1MB memory is used for boot
-		 * services, we can get here without having allocated the
-		 * real mode trampoline.  It's too late to hand boot services
-		 * memory back to the memblock allocator, so instead
-		 * try to manually allocate the trampoline if needed.
-		 *
-		 * I've seen this on a Dell XPS 13 9350 with firmware
-		 * 1.4.4 with SGX enabled booting Linux via Fedora 24's
-		 * grub2-efi on a hard disk.  (And no, I don't know why
-		 * this happened, but Linux should still try to boot rather
-		 * panicking early.)
-		 */
-		rm_size = real_mode_size_needed();
-		if (rm_size && (start + rm_size) < (1<<20) && size >= rm_size) {
-			set_real_mode_mem(start);
-			start += rm_size;
-			size -= rm_size;
-		}
-
 		/*
 		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
 		 * map are still not initialized and we can't reliably free
-- 
2.53.0.1213.gd9a14994de-goog

