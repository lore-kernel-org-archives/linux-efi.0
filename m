Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F654405ACD
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 12:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046251; cv=none; b=jZ0YMvB2iJqFczBV8idel+ydrgRR2DbCQUy+wDGOZ1xwWceKvGBbWGKnafM5npaz5DceN+ZnZ09IOBMJX5sDYWyKnDI/GjbG0Fkcynfb7DCauFHHuAGgKwUSATrZPAHFcHkv6zNCddm07i61e0ooSnOLuFRUjd7HAJTxFS16Nd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046251; c=relaxed/simple;
	bh=mb6d7rW0CVAuRgITj2ljHrU5md0zBfVw8rbd/vwnu+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OlxVpshyrzsUhWP/6BG5LeX/3TiekIRpyk6ul46FK/WujE6aTSuI9NLSateIMUg48C2+nprqILz76K+OHaM3bjCENKwCcSUs/10qIJ0tG9wXiSgsjnvl5cffKMg2V6YJF8ZWeC1mo708rp1C2k0fl6z2BUgwQPL7yDVNbMua6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YzNyyGg2; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YzNyyGg2"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4888873abc4so3283355e9.2
        for <linux-efi@vger.kernel.org>; Wed, 01 Apr 2026 05:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046248; x=1775651048; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M4wbaKY21hgpMlmdrFHV95hFJUSsWb/tqabG7mAIAC8=;
        b=YzNyyGg2/eh8uE2X7OJ+ssefhYi2y55qVvg42aCv1b12nkOZgWKLFUdZyYOD2j+aRP
         sjUvHJVFq30QLmizaqiDygVkuYtea1F5L4iZLOHHGAYW6uijbYQUlLzNZJUNz9lrPZEu
         HCOUNvdajbbnTvk24WWLYBFgzDaNBtrC3ihBE454Lo1dwTcLkafP3LivhUsJGXhLPD8w
         N2VrOgkh3iib2QZxOfpX0VZPr3AKwYDyBxH7/F8vHdFeKc5JbHzJHiuG/HUmck8TIRYy
         JuEHdBNI4ycx0fGaNV9UUe0HxxLmTA56XfgVcYKzDecCpfWuCTzyryWtEkBIkt1wd6Hd
         3nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046248; x=1775651048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4wbaKY21hgpMlmdrFHV95hFJUSsWb/tqabG7mAIAC8=;
        b=HwwfZvXQ3pX0n4lViDs3Bqk9+Mr7yLJoIcM2lyQiz5dU7ulXJO4c3+/tYR2uXHdUeI
         1WCiDwRpfZ38lfLy6AOCSwd9Od1e5V4Dz5jPTtPsqwol+0hIz+WJTSSQABeBCGEs5Un0
         DprXwMJA+zF7L2KHubNf8O0KfhHouh7UyJn3EJ1EzPOdOpJI39TAoPN0aYjQvCScL3Bu
         dEKp9xk2CK12qBXVF6hwryKVXZT8VFFGtrjI+KWPYWuLtz7y03tfOR5t/BbMgZ4vkZo0
         0luowDJWscDqu8wnBAzPhHZryGu3N0gX90lt8jEPWs2kYM4azpDzNz673hgw56q3mIAz
         pUjg==
X-Gm-Message-State: AOJu0Yy6JDE9mSvyEfvk1yTVvdmAJpeqHouJ+fQzfvnuXS0Tlfj8ph3m
	rRfzc6JQ+FawNIzcAHVap3jDOxm7zb0OqbBv7miwixbiyypfJkEEyKoywbiFGct0/7M5p3izV6r
	xit5H+CvJ80fnRW53JHvcxMqZCrLC3ibIKwlL2pnZFjWJ53qdp+nTw+Fn9V1LcwLb1WwqR4chZc
	Zrvbe4rXGOJ8uHZC3sgVmD4quJRkvqqw==
X-Received: from wmbe18.prod.google.com ([2002:a05:600c:5912:b0:488:7f73:f59f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4b23:b0:488:869c:edaa
 with SMTP id 5b1f17b1804b1-488869cf045mr20210045e9.7.1775046248089; Wed, 01
 Apr 2026 05:24:08 -0700 (PDT)
Date: Wed,  1 Apr 2026 14:23:55 +0200
In-Reply-To: <20260401122351.2058145-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260401122351.2058145-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1578; i=ardb@kernel.org;
 h=from:subject; bh=2pqrLVJXUdSwkxLG1HfUHc8dGGkHych9XZigLHERKdI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMsX8zO7P3nlkzR7fayjbdV556ttE6vz1TiyhW+/K+CQ
 sms7mkdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCKKKxn+B9Yq2HWJhc2J+/Po
 c1fGJdYlQYvKL7pcLbXMN5eU2rN3KcP/qjQHEVuexAOrW+r/rGK1i7qde3KxzOsfNr1h+4UcGeq YAA==
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260401122351.2058145-10-ardb+git@google.com>
Subject: [PATCH v2 3/5] x86/efi: Defer the call to efi_memattr_init()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_memattr_init() should call efi_mem_reserve() rather than
memblock_reserve() to preserve the memory contents of the region when
the EFI memory attributes table is loaded by the firmware.

However, efi_mem_reserve() can only be called later during the boot on
x86, due to the fact that it may need to memblock_alloc() memory for the
EFI memory map.

So move the call to efi_memattr_init() to a later stage when building
for x86_64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 2 ++
 drivers/firmware/efi/efi.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f32276bd8d4e..107dcdf354ba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -167,6 +167,8 @@ static void __init do_add_efi_memmap(void)
 
 void __init efi_init_reservations(void)
 {
+	if (IS_ENABLED(CONFIG_X86_64) && efi_enabled(EFI_MEMMAP))
+		efi_memattr_init();
 	efi_find_mirror();
 	efi_esrt_init();
 	efi_mokvar_table_init();
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b2fb92a4bbd1..d28ed1ce9a33 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -761,7 +761,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		}
 	}
 
-	if (!IS_ENABLED(CONFIG_X86_32) && efi_enabled(EFI_MEMMAP))
+	if (!IS_ENABLED(CONFIG_X86) && efi_enabled(EFI_MEMMAP))
 		efi_memattr_init();
 
 	efi_tpm_eventlog_init();
-- 
2.53.0.1118.gaef5881109-goog

