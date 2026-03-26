Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7468A2750ED
	for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774531639; cv=none; b=PnaNKCHkkDS/CLONj1IzjZFXFsLTPPHbLzKg7ZN9eS/9GrgxW4wWOWcesbgQpA+CCkF9YDq7kJ5pRvz8niJnFXA5jmcBmChMzKFw4+NElkl3ydvZCuDdcyJrwtmMhunHHXf77xHycrpsyQrC4qrAWsRqzCQEy5x/orKyXuHgoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774531639; c=relaxed/simple;
	bh=Ltu5dllgYY1cuqPgkjM5/wEJ2ajA64aLJs75CRZCcHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W8XJ0UiRaS+7xPddi/bu9YgStngBNQ90at0H3n8xVyR3HZlhEfmGtwh2IJFJSWKT+z+N3M5FSKtTiQbRccr4Of/CEbhf/EwtYv9nb4DUB5mPyB56XqbTIkeK+GYFDlmeuutJAuICMV9riiLtUodZ/uv9sUkZ7aVW8L7+JeIcE98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SYKR+77a; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SYKR+77a"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso7853275e9.0
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 06:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774531637; x=1775136437; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HebH0xpfWNwDmcW1JGUvYyRNOr2RM6l+mn3fM1JaysA=;
        b=SYKR+77asuNPso0ArLllOV3PI6PwEkr6zm4Mi+bh/b1Psm2dbHiJACSljQ8NokBCJo
         t+iglOSZS2c/fqJmAjaRrZJxQYFMHo58Tm7m1ViJOab/16W7fH/kYl0EJfhCwmOZO90b
         D2CqrMtEUH0+lbh6uNB4TYoSpyG/jg+5zvAE3+vsArLwxrqmijGKkpAjt34B+Bjq5MIy
         ttVNegrhGJQDF7ijfXpemN586Fb4DHjowRK2HpDHZKzEKKGLqAytcQzSIavDYz4KMPxS
         CK0hltNJKWGVnFIySjGDTbpFCeDsszeY3Q3Eas1mEDoJc4ywi92lyr7dqGBG7ZdjDPYo
         jpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531637; x=1775136437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HebH0xpfWNwDmcW1JGUvYyRNOr2RM6l+mn3fM1JaysA=;
        b=nUiSLe2vpUi9fk8OhqyOz9FeDuQYudGvhFp0K+YiSuQNDXGPP4bKEt4Whuv37x4zSm
         oFSAkXD9BVHguXzew9yvOw0XODVyUrk0TNlzBgJpoftRNr+lKccMbbF74lPfK60BxaF2
         9UmmYSaCUCsH6pB8i2MYd5v4S9gMp0/T3HzQ17IDJQmVsn3F5uHUdFFdTQurvlaEoIw+
         8yGXYBGYW+KR8LGW/H70OaTOKDD69w9MHPwerm7V57wxT0EkGubs2LVuoZarWu/Khb47
         hNojo18NqU8/MfdN4l/uDjcehKcMlkklOPOCyb4EqDhrah4fd0XAaVXaktetmiesycF8
         01Mg==
X-Gm-Message-State: AOJu0YxIoKPv+assktifOJcRM5+YFS0za98rNc5i6tYhGmchkTf72nI/
	2oulyWsOQjh5dTVfteLQWyA6o5WukcF0U2eLRMi4q0Lvj0w1Co0oy3vjArVlvpg2jO/sGvABHZ2
	T1IJdfTSsqTqUAPyiWaTDUxgj+d6eONLXNQwN0/puQd+Wq/vWb+qjW+o4kf6PX72hxPsucISPOj
	1F9Z0I33ra6u9EeKXoCjQEXISvw+FjHQ==
X-Received: from wmf24.prod.google.com ([2002:a05:600c:2298:b0:483:80e5:6e03])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d15:b0:485:3abe:ab86
 with SMTP id 5b1f17b1804b1-48715fc3d1dmr116751625e9.4.1774531636677; Thu, 26
 Mar 2026 06:27:16 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:26:57 +0100
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326132655.1733873-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2566; i=ardb@kernel.org;
 h=from:subject; bh=n5SOS6vCrP5KScsEzb2KWxQ7rouEvOe8/AT4QMZ5FDU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOoiaIAX8kdNqGDH21NL9YJp8asn/ChtUFnqv69vSveK
 s0RvbG9o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExkCyvDH+6joZuezl+tFn+h
 Unaqa6jegi8Xp+3Wus77WGXJTCnHoNUM/5Pec/3lWZMyPVSrUj9rpmMq+/WK6RvcjhR1CVc0eLJ 9YAYA
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326132655.1733873-8-ardb+git@google.com>
Subject: [PATCH 1/5] efi/memattr: Fix thinko in table size sanity check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

While it is true that each PE/COFF runtime driver in memory can
generally be split into 3 different regions (the header, the code/rodata
region and the data/bss region), each with different permissions, it
does not mean that 3x the size of the memory map is a suitable upper
bound. This is due to the fact that all runtime drivers could be
coalesced into a single EFI runtime code region by the firmware, and if
the firmware does a good job of keeping the fragmentation down, it is
conceivable that the memory attributes table has more entries than the
EFI memory map itself.

So instead, base the sanity check on whether the descriptor size matches
the EFI memory map's descriptor size (which is not mandated by the spec
but extremely unlikely to differ in practice), and whether the size of
the whole table does not exceed 2 MiB.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/memattr.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index e727cc5909cb..8d4004149297 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -42,14 +42,17 @@ void __init efi_memattr_init(void)
 
 
 	/*
-	 * Sanity check: the Memory Attributes Table contains up to 3 entries
-	 * for each entry of type EfiRuntimeServicesCode in the EFI memory map.
-	 * So if the size of the table exceeds 3x the size of the entire EFI
-	 * memory map, there is clearly something wrong, and the table should
-	 * just be ignored altogether.
+	 * Sanity check: the Memory Attributes Table contains multiple entries
+	 * for each EFI runtime services code or data region in the EFI memory
+	 * map, each with the permission attributes that may be applied when
+	 * mapping the region.  There is no upper bound for the number of
+	 * entries, as it could conceivably contain more entries than the EFI
+	 * memory map itself. So pick an arbitrary limit of 2M for the size,
+	 * which translates to ~50k entries of 40 bytes in size. This prevents
+	 * a corrupted table from eating all system RAM.
 	 */
 	size = tbl->num_entries * tbl->desc_size;
-	if (size > 3 * efi.memmap.nr_map * efi.memmap.desc_size) {
+	if (tbl->desc_size != efi.memmap.desc_size || size > SZ_2M) {
 		pr_warn(FW_BUG "Corrupted EFI Memory Attributes Table detected! (version == %u, desc_size == %u, num_entries == %u)\n",
 			tbl->version, tbl->desc_size, tbl->num_entries);
 		goto unmap;
-- 
2.53.0.1018.g2bb0e51243-goog

