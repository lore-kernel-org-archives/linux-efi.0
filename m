Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5406A33D4E2
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957668; cv=none; b=sRw+qW6z7fcbvCgRLPNNvnWJCui5B5g/wy3F/wXKHcCG8pnKzvmPpBe8nVNMxl7s+HM495PF7IKrwQPDbrJ4SuVNveQO0dw04rDvyOXiRcoOl9W3Wx14sKV+x+tTqO2z9Q5BUnE0TTaQBWOYmqJ4Cya2h+XsvBXZOx1w5beMo6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957668; c=relaxed/simple;
	bh=csMz6OTWa744MWvUvvooa2OQVxqluJ1t6vQj1ZvJETY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AMuJDSrchCHjq5cHfaV1HBVn4QsLZ+JsbeT3uCAEmMmKE+SK68GG2ADFTTvGfaif01BHdwzZAN/IAhLkoZ6QeaVkiT7Oy+mO24ZcwMO6pYfNaTl59lI32NUKm9HjxRYo89Yjl5GI4k6KcE6s1E/ABaKcBJmAps2YVDY4GePi8yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uWZGUpcC; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uWZGUpcC"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d721a4858so4714197f8f.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957666; x=1777562466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X1BgsYQQEh+WL/GlE+9+D3uI3VKv2eWJ1o6ED2se/NE=;
        b=uWZGUpcCxmJwbp6SkGxbhtOljKFS6pfwsDKig0jMTU774Vh6byCBDO0bO51rzNICte
         vupL3LenytKmTBqW9l+MGp5TEJ/CVvz70ls+mo2cpbXM+kgk0b1iV9BBtevKb/hElySm
         +Bl2HKnGn8qSVTABua48SPm2hN8+vaJXQdFknQ56KTpPPKRSRiAlEaUAi8COgZsHzQNZ
         +eRekxhAe+LQA9N2ug5VuDxbge2C7n5Adtvz5HkO9Oqy/RpGP1k1rkFQjVt/5E4u9tMX
         MW1tRkuA6wFMd5TYL4uWYDxbrvl+xLENKm3+SbgoTp4VFREhG2WNirx3f1yj23eLw8a4
         5GWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957666; x=1777562466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X1BgsYQQEh+WL/GlE+9+D3uI3VKv2eWJ1o6ED2se/NE=;
        b=PBAXGWz1+UthUo2OUEKL13rPjYEH1KnWtioxD0dQQyu/9zD61ubdrIJ2TAD5q4VY7v
         iWk3qIqSTi2setA5BfL8NVU+12/iunPF0TpHcjsiH2ty7Dsgy7bXQOvkRHFVSQmOBbpR
         UMCfuVUSu5+9tmaY29y5X6YQlvQtm4TN4JUn/hUHXJ8xlOztla7WYLKNwqKD3P86bPKx
         iA41xVr2lKT04KoGpJ3HmY8OS/fzcK2YpW13YEkg7LZ3Y7tI7DgO2xpt2i/SB8UZQMnC
         nsFzaonsJtBbQOPk7IF8rKP2YQS52J3jdFjz4X7ZeaqeRqmw5JArDZRdJlgabexY8CNF
         SLSw==
X-Gm-Message-State: AOJu0YxEkNO4tD0piz5gE1ZoTE9dVBjDmFsBQpoeW5T4iMNNKxPpvuSi
	/Uy1NSc438dkxCcSbYi1NCD7sprv1W9B3lDSHbueIIGb5mO3HEXBAZ9zQwlU7cNS6mxZcKhB0A=
	=
X-Received: from wrrx13.prod.google.com ([2002:a5d:444d:0:b0:43c:f9db:4c36])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2303:b0:43d:73d4:b34
 with SMTP id ffacd0b85a97d-43fe3dcb1e9mr43538482f8f.16.1776957665004; Thu, 23
 Apr 2026 08:21:05 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:30 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4315; i=ardb@kernel.org;
 h=from:subject; bh=mtKZ0aXjRN4p0VVWJRqKtVcFXFyhdtP/RFJ1WrypNIQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxYEVbD1Ntl4urAk1+p93f9h9NErl98KPuUmpP1/FT
 5nyUWRRRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIul6Gf9rrYvIDd+343sD1
 +1fFs22Z515qbD9wf77YibBfxw/+zzjEyPDATtTz/MPUPiXX14dOX/hmxNVwepL6i+p51rLeX1/ vuMMFAA==
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-24-ardb+git@google.com>
Subject: [PATCH v3 05/17] x86/efi: Simplify real mode trampoline allocation quirk
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
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
 arch/x86/platform/efi/quirks.c | 34 ++++----------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index e2e57e9201a9..e79fb94c1bf6 100644
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
@@ -340,11 +344,6 @@ void __init efi_reserve_boot_services(void)
 		 * efi_free_boot_services(), we must be extremely
 		 * careful not to reserve, and subsequently free, critical
 		 * regions of memory that somebody else has already reserved.
-		 *
-		 * A good example of a critical region that must not be
-		 * freed is page zero (first 4Kb of memory), which may
-		 * contain boot services code/data but is marked
-		 * E820_TYPE_RESERVED by trim_bios_range().
 		 */
 		if (!already_reserved) {
 			memblock_reserve(start, size);
@@ -427,7 +426,6 @@ void __init efi_unmap_boot_services(void)
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-		size_t rm_size;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA) {
@@ -448,26 +446,6 @@ void __init efi_unmap_boot_services(void)
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
2.54.0.rc2.544.gc7ae2d5bb8-goog

