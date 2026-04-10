Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451613A9D9C
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808031; cv=none; b=HXX6H7D1zCMT6gKOTRay8E3puoEvTVcPBsMq4YOvYR1bjCeMkHmV7UpELCFiT+B8NYy14OMMYRH7GjXQ2X/kJ6nkCiYXTdeEm/4XX7rSwSchS4Bs0W/zewL5afntBj4k7gKDCMQtwx7a5WaaggxdokLgj+waNRhlMGgcMcK1tL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808031; c=relaxed/simple;
	bh=gwk2O0HVrHyQzJmAAiYDk1JsQjiaoBO/6mdfGTIyv60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jDBip3AoyfNI7BS5RROC/3kOLpkm36uBlRf3zTCQI1MpTO8WspCF6pqWt7ks7NZPMqK1xuhTZ9AxUmWmleRd9I2jGWDmydIF/5lYr1jjqcLcVlZzBIhIgRYs44BiKie1qaZ83cWUOLEMSjdmtDIaYGzeQ8Jwmefp5+0p43RnTLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HvDutz3q; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HvDutz3q"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488c2a4e257so12495175e9.3
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808029; x=1776412829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aZuVlxjjLoHFeIUm8jVkTp0g1A6kMbh8Qq6SqnHOAQI=;
        b=HvDutz3qpDv60cbo/ZM3VxcDVFT4lN7TyJpKBXDuRGpCDUFhR4ok73d2NLhN8bDRFO
         SqYPb4rMNCn9aiyyb7uIrcWQl7QPrSewPkq3REVqYu1R4zjqN0sSIKREo/5QYgJhhwh+
         Q/LG5A+bqoLOyxEK8/qm3oV20AKQ96xFCDfErrIxuD4osVjDFvq24gI6X+YWCFrBSYmT
         gWctGV1mabE4Mo5VbWOyzOy2Dkg67btLvR/IC33IUHvh72/IHlRH3PqAbYe1ocaRkgIn
         wk9FcMtEo5vEzzCGjKr4gsaEMT/MbZIDADQ0FyIghjs7a90T9n8qlw+QyWiHESn+7GG/
         H2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808029; x=1776412829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZuVlxjjLoHFeIUm8jVkTp0g1A6kMbh8Qq6SqnHOAQI=;
        b=UEKAdmTdveEcdK8Z2JPhJa5WUH1gHWfu6thuXqBUtTJJahHmwQXAd42/bV/TuaaCAi
         9OkJgmSDWUoAJqlpATvYF603TU574HHH3ktxS3XSi3BCBKaBKG+yqTViKhHbuNYDhQdW
         VuywvbHgBmdXCRWXei8A4UV6/qHG76Z0WOe6lFJ4ngwv7Mrsse8F5qd0AGz1nAAzjagt
         0Goyz4VkMwjXIGm+gTUOtAkDUOa8o66x03LBU9kJhY+9VVhsjIMmL9cGeSGOixZmi+Fp
         65/5QUiJSon9l/uWduKIXHpftHajDlZDwLgUc3acqZZo5zs/6MBrnmH9dIsLRtMHo17j
         1iwQ==
X-Gm-Message-State: AOJu0YybLD4Hxm1RbIups9WuGVIDnsGKoqGp6uk9EHlYx+vJ1fCFKJce
	zfTITBjmia2JNxrLV0dUeEJIGVLdmhhkw9eFkybR6bBfSarEkrg0QoghcoDHHeUHYGyJ05D2MaX
	5bhEcyxPY+Rzd53OJVqmYcT8R2WBVQW2F2CGZ5N0zIoAzLyh0ovaVUz0dlfxCrN9YEpBjSCM2sW
	xdElSepUgUuuunRPxIZVP0O1QEs+rkVQ==
X-Received: from wroz6.prod.google.com ([2002:adf:f1c6:0:b0:43c:facf:6d8a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:474c:b0:488:a2ac:a340
 with SMTP id 5b1f17b1804b1-488d67e7212mr21451815e9.12.1775808028469; Fri, 10
 Apr 2026 01:00:28 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:51 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2085; i=ardb@kernel.org;
 h=from:subject; bh=i+mFqLKqfPIlD2XAFQO4ErxCcgxefQreWpA5tkYfbQk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPG2p9ml2v/Wa/f3BN/cqeayoUpgZNbK95Lz+h/xJZ76
 Z7DQ46UjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRP/MZ/tdxn+hw/dZ1zO7n
 2rb0OqX9EiG37BdVbo2K/CX6v3fD70MMf6U37Q10fSaYUcL5S7x3z4PSHcsmxV/9ZNs0ReB7wYs tMhwA
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-10-ardb+git@google.com>
Subject: [PATCH 1/7] x86/efi: Omit redundant kernel image overlap check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The physical region covering the kernel's executable image is
memblock_reserve()'d in early_mem_reserve(), and so it is guaranteed not
to intersect with the regions passed to can_free_region(). So remove the
pointless overlap check.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 35caa5746115..05ef1b06c25d 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -305,16 +305,11 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
  * can free regions in efi_free_boot_services().
  *
  * Use this function to ensure we do not free regions owned by somebody
- * else. We must only reserve (and then free) regions:
- *
- * - Not within any part of the kernel
- * - Not the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
+ * else. We must only reserve (and then free) regions that do not intersect
+ * with the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
  */
 static __init bool can_free_region(u64 start, u64 size)
 {
-	if (start + size > __pa_symbol(_text) && start <= __pa_symbol(_end))
-		return false;
-
 	if (!e820__mapped_all(start, start+size, E820_TYPE_RAM))
 		return false;
 
@@ -343,10 +338,8 @@ void __init efi_reserve_boot_services(void)
 		 * Because the following memblock_reserve() is paired
 		 * with free_reserved_area() for this region in
 		 * efi_free_boot_services(), we must be extremely
-		 * careful not to reserve, and subsequently free,
-		 * critical regions of memory (like the kernel image) or
-		 * those regions that somebody else has already
-		 * reserved.
+		 * careful not to reserve, and subsequently free, critical
+		 * regions of memory that somebody else has already reserved.
 		 *
 		 * A good example of a critical region that must not be
 		 * freed is page zero (first 4Kb of memory), which may
-- 
2.53.0.1213.gd9a14994de-goog

