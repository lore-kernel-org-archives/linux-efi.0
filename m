Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CDF406295
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 12:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046253; cv=none; b=G1mJJ4o5Ijh9BtoP8UOkhoq90uccHTlFlmLy/tZ/C8uqNEn/qmPZYfS2uB+L1+aLGPeU5ciqeDOBYK61W003c7xXqZCiEmdacPnUPLObs39ylUaFltVwru/SPF/Yxjjya/wtXuD29NGRxC4Lf3FCo8jZQBDU7Tk3t5nONBCZ1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046253; c=relaxed/simple;
	bh=YK+U8DngO2p2xHvfZLICzQ7p9q/5l2Pooo/tpmsxwDg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OVJW3AZsHj3JqE2/kKSA3uab+31IlDmnci12uQVKjub8RqEPIf8Cy0jJTrtiILspCWYM5WZQmOUcMJwBP1YSIc9NyVVA0w0++zMmbtrNMz2J1RBiRvggbqeAIUc99DC6iOzAZG/lpzLfpO6mz6e9VCl3BGwpQ8smIZ3n/g4G0pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m1ZTlN3K; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1ZTlN3K"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4871f6712ebso39890485e9.1
        for <linux-efi@vger.kernel.org>; Wed, 01 Apr 2026 05:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046249; x=1775651049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/aM4S1PduY4h/8bCx53tKfnLs3GrlzWIDVWJDUhE/+8=;
        b=m1ZTlN3Kh4W08rBQ8/ZFD5PJNkQQGoGzzgrUUp/VXN1g/oSfRkek6tRiGMXsGrd4rQ
         80HvFMkN3uUZn+RHIYhtC5oxuJYzsXFJI3WeaLnBq8tv8UgZYQ/AOgkhkXJ87yy/IszZ
         U4lTgUwE/18YiIL+kBeoJJJwfbzBUhqfFrUPLN9C1//0aPMRIpMGI8BlJXToqSbhFsL3
         PBRlT6RI3XkJRxkQIbzH+ErntD2a9F+/OPzeta5cK6wTe/IrWOhXbfLHI2JidZCztuP0
         c1mFM+sJw0tY6IzQ8L01gscMfn7jioixzNjQpe/dXfP7K/539Tzb+iMzbYZQToJjo40P
         AdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046249; x=1775651049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aM4S1PduY4h/8bCx53tKfnLs3GrlzWIDVWJDUhE/+8=;
        b=dE7Sp27eEMGPh42X7JEt73kRvR3SzIKzvCF9d6leNPAws/ZfT/ILY4MN4P8p/ua0s3
         +Ti3yktjl/gp7ehONPQeAyNlXp9ZyeO1euS/CAdVKwwxhJ+2FBGR7BcRKd6s4/0LQ5P/
         weOevqhpVgaddQZqDtqzQhvvEEH109SxcFz8N+X0NsA3bH7UBHTi0lbD+s9fA8KCTYVh
         w/RwopSHymTMSugDkn3bVx+4aX3nl8Kdn8CnmhRkcVtlS9XWV3feQtU5gumW5N2jkLlS
         ksPAgBTMcvVzN1qI3swlPBFuM3F6PoZmKm5lG4eflGRk/tZx9QLLnbI4LLPdM4KNr8X6
         Bclg==
X-Gm-Message-State: AOJu0YzGQOhvO/cQS+taye3EyfpWhaLVIf1kuB8qkSLfPRtH8LIr30/P
	dEt04qh7Feh7ye1+0XoiZKxdAVJuIUO+vFLY4sUq5mVY9rlRC8sbH2eq71KznkYW/q9Na42heRf
	YSoBarTT6Q0BVh/z3z18v/IbG7RUHw1er9YefWZfJCqzyjCTCRkOejMIkC9Esf4iQEcVofc3Qdm
	DKSsmPLxSJjIR56RhVlHxFX3YlQj1ZcQ==
X-Received: from wmf3.prod.google.com ([2002:a05:600c:2283:b0:485:6976:d608])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e1a:b0:488:7784:d06
 with SMTP id 5b1f17b1804b1-488835abf84mr53317615e9.31.1775046249386; Wed, 01
 Apr 2026 05:24:09 -0700 (PDT)
Date: Wed,  1 Apr 2026 14:23:56 +0200
In-Reply-To: <20260401122351.2058145-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260401122351.2058145-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=884; i=ardb@kernel.org;
 h=from:subject; bh=QYLi+A1pkK5JDmD/bJgyNt3bd0+6uqfnrlyZz6kzmFw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMsX9xpppBd5ubu19azZa9jUo2UTGIVN2uoWPDmSSJLw
 T1Lq/8dpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCK7nzH89+adVHhJIdqLe6Hh
 qcxT91VLWq8pFWd3iagoWCTJuj6rYGRYMKH5xqs3R/+4/jyWF15weP72eo49gRXP9d88ZFO+ssa bAwA=
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260401122351.2058145-11-ardb+git@google.com>
Subject: [PATCH v2 4/5] efi: Use efi_mem_reserve() to reserve the memory
 attribute table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Use efi_mem_reserve() rather than memblock_reserve() to reserve the EFI
memory attributes table. This is needed on x86, where memblock_reserve()
is not sufficient for assets that may be placed in EFI boot services
data memory.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/memattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index b83f1c5a9164..785b7fc687fe 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -75,7 +75,7 @@ void __init efi_memattr_init(void)
 	}
 
 	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
-	memblock_reserve(efi_mem_attr_table, tbl_size);
+	efi_mem_reserve(efi_mem_attr_table, tbl_size);
 	set_bit(EFI_MEM_ATTR, &efi.flags);
 
 unmap:
-- 
2.53.0.1118.gaef5881109-goog

