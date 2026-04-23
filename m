Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA2F327C08
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957663; cv=none; b=SKUEAmqnLNGu8P7b2PhULkFiVC3mjtDmOzIyE+q/Cegq+DdTAaXV0qRmuaaKTZ2+bzXYDlH0KetnkRd0TdQPYd5Cn9ot5up0yyDQ0+3gRNzSMnTmw1QU8QMrziLlpntWOPc7cdlxl0k0qaVsASvQVeFXe/kB0SOlKaeCOXKg9sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957663; c=relaxed/simple;
	bh=rDCZLCXVdfhYaKY8LVOXFIF/6b3Fy0ov0xYCP0dCALs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o0mgExQQ1adXFo0Ih1P2BnQ23t+yztMMLipaoPaOeSlW4munVSrc5i/iaDqzIZd9LWCiKudVKEMayRhjtYTD9ANM9ewvBOypO8QnNI1RVSod+Yz33YcyT/iZsFcNl0tAA55ce0ZyZcLuZlAQ1TKpyZD1I1kHnpnk9N5kOhF8sdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZSQQFBdl; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZSQQFBdl"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso55402155e9.0
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957660; x=1777562460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4mSa+7vyhBL8YFiiwNvF07aeMvbJQOJ+ZSj43s2ayiM=;
        b=ZSQQFBdlG2mmBfYm1RV8vyz5JyOZ2ATNHEhJkqiAcQKfcGyYYIzcQCv8j4eY/hnh4C
         L2NbR5ngJ0uGRe6JbjJCe8pv35mGkWWaSCKgMCT3DVLNLogrTqKVSjx5089XoqLEYrkl
         RKtABHbp49SNPgtrlLTaMzLP9J2trhRVj7hxjoI+qjk8tcz4Sj1x+ZhZpPJidr8+LHof
         pPCZMKS9s7Vs96guZ2LHsixDidMT+kyQNWmrWIvyvFhb35ffiqAEiBQDASH7Cgl0g4TO
         idta5nMtCWLCT9FQMjVXPKzABqQx11uTXSMFJUVWkt0yh8Xo6TO59DuBDof1vaTQ74Yo
         Dilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957660; x=1777562460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mSa+7vyhBL8YFiiwNvF07aeMvbJQOJ+ZSj43s2ayiM=;
        b=aOgOzz676qhpeoUp8wtYwlCnM8zU55gzJ30p95gKRrJnbRDTyrjFPVeHoLKl/BJbMh
         0/QHBBa7ZVBiiGysr2vf6Cf1gmUNAkUdrb9POIHaKya+gKAejMXA6o9emk9UH1sc8qJG
         iaHBLEhg5YN10isTVuHNh0+JrQDD65lLZN2YW+ViCjU6VNhxGdm4hv8eV91y9iDU+dXi
         XnLD13vGnEr/pfnFK4Yl1caKo5DL2IaL0Dd8obRDa3mIgEAFaVYRfTYa9kwNJ++ncjSl
         CgujbvJWqLDyXHRGhkgkKxnykZGfowq1F2sEU15w4YpOwfzPkvHXXUxt9JE/GfA95Q+Q
         LMBg==
X-Gm-Message-State: AOJu0YwHB9irxwLjBDBSHlUqBSCPB6YuB+K5pTRwJzAMQMBQLjKzVilx
	zY09nU+TDL0E3H9q58Fpl5WCw9BDv3bXORmuJ3SEGG9jK0t5cPYcN9cUR8ZUxuUA9oEg7RFBrA=
	=
X-Received: from wmbz21.prod.google.com ([2002:a05:600c:c095:b0:488:7ca9:439c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e4f:b0:488:d6eb:e63c
 with SMTP id 5b1f17b1804b1-488fb778703mr395298005e9.15.1776957660235; Thu, 23
 Apr 2026 08:21:00 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:26 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2088; i=ardb@kernel.org;
 h=from:subject; bh=F9s4TuifOtslvPyT1K7byiUAjZGW0HaWaUoXOgAp+vY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxa66dP0X1VxWvcv/LdjrtKPXNtzmx9yivcdiMha6v
 r5oeeN+RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiIxUmG/+FsKz61C5z6yzNz
 a4n302Va4hGaO1zc4l97crffv7WCsY+Roc3wV1dBuHr3ZPtO03e1B04ya70zyjOtkZA4e3KG+Sk jfgA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-20-ardb+git@google.com>
Subject: [PATCH v3 01/17] x86/efi: Omit redundant kernel image overlap check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
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
index df24ffc6105d..4d8de7c6ce59 100644
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
2.54.0.rc2.544.gc7ae2d5bb8-goog

