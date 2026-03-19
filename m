Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559693B38BC
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911174; cv=none; b=CDjaeT1PrZzoRwh4KeMjyNJTWBGETIdeqr9PC8rdQZIsuVjFObT3+L8ma4VOJDvLScDMYAUfTQW+zK/Ot6AzVlaSy/9yqhArOnZLKVloWcZED/vOS108lWw5ngDg/3RdSRxiE4W5fpAJ318SdmgQE8kARfK87egcoPZh/TMeu14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911174; c=relaxed/simple;
	bh=KgBhK+TEZgstaXzTuRCtDnUCXmvs4UoSUv4TGHBNHUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fZgP+UsX+9n++ZCzfHq7EwIO2xSskfyw/GHxEaz6tsUAXwj2ecm9QdkntllRDpgzd+KaSsqvG39hCQR1TvK1AI4rMAjKg/zPaknTBoIub42OpLM9xFNN1em/8h2P4f2TOo8y8pmbGlv47aOgImB1yaeNaq6v4mN9vEvcsOkztlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X5UiTZJ0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X5UiTZJ0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485345e2fdfso4623455e9.2
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911169; x=1774515969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TjNiMrLy4tEOouEU93qnu1juEIPlINFhm86Rn+zMuwM=;
        b=X5UiTZJ0vnrJtqveqWnQtNKcY7RuBsZrLUKhrzyrog/H3mq1WEh3fWaSXi5XEX2+et
         UIyK9BDjAYOZmrthRgzJltcW1GUGvtsCrda7RHChmaAClGSGhuAKTsX3EDpBjr9klLk8
         2dz56i8iXbH105h/TLo13uRMRMQtk+JCOWACZo/2vVhQuAbRNa7fQ58O8Q7dyctO8m2o
         trqYhbYBsc9zR33A1BDCc7ufNOcW0TnPPJi5Ah6BeDeAwMlZAPi56XHGpmPWX0bDl+B1
         H1G693db4+bxS3zbwFPxmAhs0MiPWEfoK2o2JOwXYztzrZiRf0MwdzDtkm2z0DXFV7VZ
         0+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911169; x=1774515969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TjNiMrLy4tEOouEU93qnu1juEIPlINFhm86Rn+zMuwM=;
        b=KDDwG/ojxJhtkI9yOQ36Mzhlr2S/CUJ9FF55+eSFEKTflv11LatRLjpfywA5/UUVAI
         mD/3VCUufhkLvhxPJxRzxPuRq9zZsICiCL5hf9BJ9Hr6nberQg+YLz1Pr7Hg9RJXNXxJ
         Dftpn0HkkSmzeDX5rAP+WHV6H1lYKl98EjGYAy0WUla4kuh+s+DfcdpO27JJO8FGUZoF
         fFYP9IsWwo5KZXPYdPn54BL/PAKZM9p4IAYhIZE4SLLhJ8iO96YjRTHEfVyKVaiUoToV
         KydSgxck+EP5Esc6+q6KSHsa9UBWghbvAx5xb+i71M7x92uRwL2qLB73VOv2D2Z1lZWI
         3iiQ==
X-Gm-Message-State: AOJu0YxyKrZJdJe+1dLZtrYfmxMfhtUdfN1sIOhZnYDCfCCvD/q7gr9a
	z4J5z7RjeuWZQwnwqM9HkoNfeVyqzwVOREhsYjQX6mFYVADbcrLV1ukJHe88GE7+U9W0oC3J+w=
	=
X-Received: from wmdd11.prod.google.com ([2002:a05:600c:a20b:b0:485:4f26:fe69])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:470f:b0:485:3baa:af14
 with SMTP id 5b1f17b1804b1-486f44410acmr105060685e9.18.1773911169118; Thu, 19
 Mar 2026 02:06:09 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:37 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3749; i=ardb@kernel.org;
 h=from:subject; bh=gWD7ppoTqNzON1lfITM1AwwqfOFv6YDKqkDVs5WiapY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nmSxE7ZHrgXsmOXV77/IrFvpHu/7/X+U2sWYrqs4i
 nIzlC7uKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPRn8zwT0tU+cKqWb7vpi2/
 0PRU8rv7ub22s7sbnnXMjTjjYFX70ZXhf2H21ojw7OD0uyWXdcXZD6+v14wwaF94Uvz1KT2/47N W8gMA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-28-ardb+git@google.com>
Subject: [PATCH v2 07/19] x86/efi: Simplify real mode trampoline allocation quirk
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
index 25f51d673ad6..c867153eab8a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -329,10 +329,14 @@ void __init efi_reserve_boot_services(void)
 		return;
 
 	for_each_efi_memory_desc(md) {
-		u64 start = md->phys_addr;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 start = max(md->phys_addr, SZ_1M);
+		u64 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		u64 size = end - start;
 		bool already_reserved;
 
+		if (end < start)
+			continue;
+
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
@@ -434,7 +438,6 @@ void __init efi_unmap_boot_services(void)
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-		size_t rm_size;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
@@ -455,26 +458,6 @@ void __init efi_unmap_boot_services(void)
 			continue;
 		}
 
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
2.53.0.851.ga537e3e6e9-goog

