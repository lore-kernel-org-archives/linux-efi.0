Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A563AEF20
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911176; cv=none; b=TAOPHaPw7U+VuxRyMEucDo7lvhHxHfpn1oCJMm7mMBkWSqxWQBv/DsH0TIJugted0T6tAVcAkwVjXHENGFlOQjh1uDNzQR1AmvAMemV8rpWv0D9ZyXT0hnagrh6AF5vKk0ya3gvZuJxMt5FndhcwNoUvId/79KcI3gM9Hz0/WBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911176; c=relaxed/simple;
	bh=HOt4tgF+H86w/ifeMUACxXFqRdDJ2s7lGOmb3GciFEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VQkMuilZ86sWhYxleQrRE1SXRrUhnYB6kDYVj2hH7AntzszDn8rF1PJ2O67Vzw2hbkf8IasP9lOoHAL3xs88K9DXbz8HLf8Q4nyvNpLbg2+RC8pF5DWy8BfVabDfwral0FLIkVW7kvdCsYvssz62sXJjpfbSfrVgoZ1eiE5R/Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S2Gl9e5+; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S2Gl9e5+"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439ca4b3d0bso1143367f8f.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911171; x=1774515971; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEs3mmx0viyT5mPQ14qRORhKgCypSb/SW/teub5WiMg=;
        b=S2Gl9e5+UKiuBR/q08cJ4i0sl2GN1ulSf/5/WZRY/wKkUwnEnE4IHrPosF6KvbTi6q
         qdK2cFgG5/YWYENoacArCECUISVk9u1tev2Pv3y2C7jdvgnM9LsB6E+Fi9YaowSvJfbi
         RkHxY+SfapsbxYMFVl81yI/kkFrLsKxlnoSyJbKYp4rLg3hQQuqVlasSKoMmBCHNf/C7
         NR4dXLCzMnG/yq+WR1OYABy+kGNaCZHK952tPTNbvinE3hNfuRBPPaJE3hVVtfw8ipCj
         u0C9W0o79vU6+DlRre/fqdqfOEHAmg2I4mHwdRpj/h9f0YEeSEIQgoeV2nwCOCiH51DY
         kmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911171; x=1774515971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lEs3mmx0viyT5mPQ14qRORhKgCypSb/SW/teub5WiMg=;
        b=LjpLyyp4bfftn3rToO5OjD+DtwaxsOIhFFtcTIbjrsTVlJCQ+oSIvEeu9ojnA7km3B
         038kmfttcb2YpwZvXK/aY7FSWtR+VKRFuIcHUSNI6x6k0TM4noHl9rkH0zDpXclt1Ljb
         9mtIE0S7SNFljb/90k2YebOt0pYbmc4LavhBX4neij6eAIHK6IP5CzHcTHCo7ObfLZN2
         sEKwjm3ECJQ9M2AYHDZwDTIKsrlHcns1HeEBsk8NEPsycGus81jmZrSGx08QFwCcDy9/
         hDSAfYmkyfhxmz0dkS90TheC8hniQm0B2e8TT463aJ9y38dcRtyEO9WiWCKqCYJixyun
         PDRQ==
X-Gm-Message-State: AOJu0Yz7fmH4htJIwJLEbrTfouUBjLzrskhlH7RE06Ev3tHtKCGVez2i
	ou20iP1p2j/u9Yf8e1bhAI+WurbMf5M1twXe864m59ihtFHoybAFMWM6FCL6+ZSLWe5IMhcw3Q=
	=
X-Received: from wmnk10.prod.google.com ([2002:a05:600c:168a:b0:486:fb09:30b1])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e0f:b0:486:fb5c:3b20
 with SMTP id 5b1f17b1804b1-486fb5c3c68mr21321045e9.13.1773911171394; Thu, 19
 Mar 2026 02:06:11 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:39 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=914; i=ardb@kernel.org;
 h=from:subject; bh=iWpHiCO4bmybSs4v9cDyeXiFivmsE9/7Y/5o33bpjDQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3ntSmgny5l9pxCbvl07dfOPJm5Y6kndsOiYr6cmQ0L
 vuz+ZFsRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIwWZGhkmKBx+HB7JuZ3C5
 vd0mzenE4jq1uNLte7YuO1jV9aPi30SG/z4/LG8ZyUunbut7tYArZvWsrVHcEqbdNZdUPGbEdmp YswIA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-30-ardb+git@google.com>
Subject: [PATCH v2 09/19] x86/efi: Drop redundant EFI_PARAVIRT check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_memblock_x86_reserve_range() exits early if EFI_PARAVIRT is set, so
there is no point in checking it a second time further down.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d84c6020dda1..b60f8454a1ec 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -211,11 +211,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	data.desc_size		= e->efi_memdesc_size;
 	data.desc_version	= e->efi_memdesc_version;
 
-	if (!efi_enabled(EFI_PARAVIRT)) {
-		rv = efi_memmap_init_early(&data);
-		if (rv)
-			return rv;
-	}
+	rv = efi_memmap_init_early(&data);
+	if (rv)
+		return rv;
 
 	if (add_efi_memmap || do_efi_soft_reserve())
 		do_add_efi_memmap();
-- 
2.53.0.851.ga537e3e6e9-goog

