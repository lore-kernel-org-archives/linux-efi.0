Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D05037CD33
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957675; cv=none; b=Ae6/4Exesw/+b5yhYcgEOX4Y/AjsuAWzU/xSwk0p9tcX+lmFpZrTmRUMgIEa8rAYc9IM0W/IKn67G/auFQhOjnD3+GrcgtwIugM/ujPwYt5tHQHCUKnkQgtAwsyhNXA+qsH+H5uOgIwlCmpWlRcddxdalRCCWCzqEYwwHcUtlJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957675; c=relaxed/simple;
	bh=NFY6SCRdR50/UvbbI0XJ8aRN7kaq2SSzEgofs7VmHPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iyQyIHX9E5uFAwsnTpqE4iEmOHpOJlrl1qZ3l6hP0BW+xveGc+DrnLXaP9l3KVMPvHlME/xedgDNcohClyy8Kab+V2ewPvg4s6veQj7//kOpjkaPrKtqrqOVbvuE7/3lJN4uN+trxnxO1nHyiLXOSByaeVsSr71MU1PEUqJSUvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FDDtE7sj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FDDtE7sj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488e097a270so48719735e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957673; x=1777562473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9wk+GPNJ0EjdJDEaWn+TxDE0CUn7/Zc7fS8GRI/B9Ic=;
        b=FDDtE7sjoS4dkWxutsWDmCZYQ3DZcEVoqPFdQdaTeO46pVK4jGINW3axSsmaoClH6+
         vJ2Aj2D0SZjfNMWhTDYwkkmLlwr4HWGGCE6SsOTx9QjRfLaJdMbKuIQ0Ybt4dQk/DE3E
         ZEBJy5omI00rQ/bGAnHQTV04JfC9OOTXytoS1U6/qNnommAQ0KOYIn5BUgzZKl+6+mmq
         Psj2VBRmrbWXGw/jBfQYezjrDpk1wm4EV62edIF7WuipsIH8EqtGXHWKziw+0T9TxqZc
         BCoI6Gy16no+mgke1d+cgjzs70zOradh7JHcgVQj0vhK2xNwphLz8EwU5aNV2dOYhku5
         JSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957673; x=1777562473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wk+GPNJ0EjdJDEaWn+TxDE0CUn7/Zc7fS8GRI/B9Ic=;
        b=PPQOn/Mdx3aXEK4FYFQDqaGCZqoNRnqc1diZ+i4sTYxOK55BGWBO+/RiSxjLmDhuUY
         De2hL2H1oKJrG5DUWjHdiMjj2b6lW8y90SXi0gQzG2dU2Tqdsi7Lh3tisg496FiXomXv
         G9teSbGjVkwFCyVPmEk104SV/kNRtmrIF5P3VF81Lm9W0IqQ6CxCn3Z7mqAXfXJ/rqi1
         H6ivwAWVU8c39fwVNXNnmRPxdx7dVyi71gSURi4wr85HzxQpkdD/m+OWDy7tCIswpzQd
         IS3GpjOtBikoQVkKvaKT0KOWNfx0LjYVGlQI0dZOLBEmmulO5FrIpIeGEqRtvS5FielA
         qYuQ==
X-Gm-Message-State: AOJu0YyveQBg+yn3LV5QAEBzGHCdlTAm6m0q2cWB2YFoZAEte2EdTH9j
	UAM33LnZVJ0PJ995UsAZbGVevhoH+bXm+UkL4B32bKriy1dAJ2mj0yDpw7ZYFswdLHFOP2lIEw=
	=
X-Received: from wmbes10.prod.google.com ([2002:a05:600c:810a:b0:488:b96e:9939])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a30b:b0:487:2671:fb8f
 with SMTP id 5b1f17b1804b1-488fb74dfe5mr270391755e9.8.1776957672489; Thu, 23
 Apr 2026 08:21:12 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:37 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2415; i=ardb@kernel.org;
 h=from:subject; bh=UgW0djVOr4KqgQMmxvoDDuu3bEWRtuv/b3T+lF82Vmg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxal1rFs7XVhd14qndS0+KBw3Va722Y7AM19yKpp0n
 R+duSTVUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACay4AYjw1lONyY7g28cCZen
 LyyNSJ/utd9eavN/ywWv11veNXEJ7GNkmFptoMe+Wb9BKEDwfTn7HM2Ob8YHl585zOJzvZ+//n4 lCwA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-31-ardb+git@google.com>
Subject: [PATCH v3 12/17] x86/efi: Clean the memory map using iterator and
 filter API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of open coding the iteration logic, use the existing iterator
API to iterate over all valid entries in the EFI memory map.

In addition, break out the logic that iterates over and conditionally
suppresses memory map entries so it can be reused later, as something
similar is happening two more times during boot.

Note that actually reinstalling the EFI memory map, which involves
unmapping and remapping it, is no longer needed, given that the number
of valid entries can only go down. So omit efi_memmap_install() and just
update the number of valid entries.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 30 +++++++++-----------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index edbf6efe3947..459b5c13167a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -266,36 +266,32 @@ static bool __init efi_memmap_entry_valid(const efi_memory_desc_t *md, int i)
 	return false;
 }
 
-static void __init efi_clean_memmap(void)
+static int __init
+efi_memmap_filter_entries(bool (*callback)(const efi_memory_desc_t *, int))
 {
 	efi_memory_desc_t *out = efi.memmap.map;
 	const efi_memory_desc_t *in = out;
-	const efi_memory_desc_t *end = efi.memmap.map_end;
-	int i, n_removal;
+	int i = 0, filtered = 0;
 
-	for (i = n_removal = 0; in < end; i++) {
-		if (efi_memmap_entry_valid(in, i)) {
+	for_each_efi_memory_desc(in) {
+		if (callback(in, i++)) {
 			if (out != in)
 				memcpy(out, in, efi.memmap.desc_size);
 			out = (void *)out + efi.memmap.desc_size;
 		} else {
-			n_removal++;
+			filtered++;
 		}
-		in = (void *)in + efi.memmap.desc_size;
 	}
+	efi.memmap.num_valid_entries -= filtered;
+	return filtered;
+}
 
-	if (n_removal > 0) {
-		struct efi_memory_map_data data = {
-			.phys_map	= efi.memmap.phys_map,
-			.desc_version	= efi.memmap.desc_version,
-			.desc_size	= efi.memmap.desc_size,
-			.size		= efi.memmap.desc_size * (efi.memmap.num_valid_entries - n_removal),
-			.flags		= 0,
-		};
+static void __init efi_clean_memmap(void)
+{
+	int n_removal = efi_memmap_filter_entries(efi_memmap_entry_valid);
 
+	if (n_removal > 0)
 		pr_warn("Removing %d invalid memory map entries.\n", n_removal);
-		efi_memmap_install(&data);
-	}
 }
 
 /*
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

