Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541879;
	b=UA5QdgepIHQrhkFPa+f/93IaGRlssNhlnC8bzxQNA9BAFae6UVvWNU1P4SzOLTjKyc6N
	 0XTwnoNFFS03avnguyh/6IH2WB+e+ZW+wSPgwTKhB3b3xawKw5Oxlu6CkPvZk7YC9neDF
	 Kq6KhOy5eogTH5F8aRuZylpsH2HIcmArwqlLbwnAIxZdfxXjKdGYPJHgYPSmKhW3iD30A
	 2Zlv03kCLQui0gOSLczz8GJQCbzZ2oafMsPojJKDG8R7yWpC/rPWVgv1sGxQF3zfytORn
	 kLcaRiWqGsGXPslJsB46AVdKh7zinKoFJUZb0DcvxDNy2Dz4yQyvp6ajLa9TqfHsVXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541879;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=6v5NzjvwYZ58RiPzhXUDdpprJz49DpF/ElpGD4nTZsY=;
	b=I7zceREW92gwyf3YubbtaBTXUdzWCFVv5MZO6A0qTcppW+pTsSie3Xj/4umvCzHXSO4V
	 fBKF4os3kaqCp5yPc/X9s9G4IaDkh0aN43dLqnNlSy2y1Tt+cutGQXJRQXP/UgO7onV5p
	 RfuP74RDN0DeA7bup/SuRsli5OQllwQzUNDGDsjVKvvBO8+/vQh3U/tpaSvkWFlf5xgtw
	 h/SO4GTCpNUg5RUmxXorfk4ADIOxfbpudj1QKgBufb4ZTwYzX7Cg9o5XbpIos/240h6QR
	 4Y23tt1ge0u3/VrhxM8nipl9KHNj7fbYoKMThHHhKeogEBmI9FmINiatNQaUHuihEEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gqPEQPWO;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C98606A31E
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 17:37:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87C98606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gqPEQPWO
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a17741243eso25560645e9.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541878; x=1796146678; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6v5NzjvwYZ58RiPzhXUDdpprJz49DpF/ElpGD4nTZsY=;
        b=gqPEQPWOe+8X9D5o1Bd3c4LGk1N0ccVtOWD88alVtoBwlUAiUIyksktrWN0z/wKajR
         LCj7K7qJA71gFYoVwK2tMcdkS6P1T/+ZGPhCuGYK2TNhJ0q8DZEtdVHa0OuT85uj28P0
         rVVh2jxtuWGn4emKS29yiHqA/UHV8xH0AsGIWe6s0BTrvKf9y8nh/d9yZRe83z/GVVdN
         b9QWanuzTMKt+2EbVECnG9ys7HwgtP4tkfpk9QaxkF0YThbc0eFBkrWD8/zLU9vu5rZO
         n6ngZDyuKHWBqOVeKMfO5Tj+AGRndXOgwt5XvGI+1jg8oA2AlpFZiQ2HPbCSeC92IfZP
         tpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541878; x=1796146678;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6v5NzjvwYZ58RiPzhXUDdpprJz49DpF/ElpGD4nTZsY=;
        b=DZbF8mBSpOYuCFmzEUdKkpeFCQqSDX1xJOhijzwrtdq1sZ2MTuer/rmO11xWNHf6yE
         hbfkfNTO3OXrCPk/BXKkzJD57l34U4uMMO7Ou53w1DSt1/8HgDUvSj0+Fj4HN//Ei+Rl
         bP/iqD+CkhTspeOOYwXLkUxREjs5gFirlVa1Id0fLsVujKW2qmuSV+TzQ5LW6QrTBP3b
         u3i0U5cFPVZE/gu9Nfh5QTtUW/APUSB9aszQzA91sU/Vaana9TFWi6qUml5sa10Ck4IL
         EJlyzs8XaKFcm/O3zTabBMbrDBAUtIDGzoz4e1VI1GJtHtvFHllOeq4ELQnJ75yrBLCa
         2jQw==
X-Gm-Message-State: APuU4Z/5y0Uiktyk1V8QDe7M06vrnKg6eCuIOkXLJCBiyNXHbSSHosLX
	3/bIDmDn8H9q0u0C9lxnaBLYJbtH3xHbzcoW81mdYlPGVJmlF6+HGGUXrq6ve3HoMSk7BykLUIM
	gC/UcFO8QFq/IAbgKb+va6HIABSwiyViZ+KrThBTXR66FtHtp05pTd0s57XwTMK/SHORtbXBF9Z
	WLpyJMFwuSmEsPrPLT21SRB4rHCWZ8wA==
X-Received: from wmxt6-n1.prod.google.com ([2002:a05:600d:8646:10b0:4bb:6c3d:a4ef])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4514:b0:4bb:6823:3d3c
 with SMTP id 5b1f17b1804b1-4bb888169d0mr332015905e9.20.1795541877789; Tue, 24
 Nov 2026 09:37:57 -0800 (PST)
Date: Tue, 24 Nov 2026 18:28:13 +0100
In-Reply-To: <20261124172811.2580784-7-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261124172811.2580784-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1543; i=ardb@kernel.org;
 h=from:subject; bh=ShfLKpQXSx3+06xzSKjjmW5LXkkkn1/rWITPEdzisMg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZv1pIHhA+/bN0sXLNXXnnzz55Ho/9LPtsXKPfT/sOHzq
 dialCbbjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARjlZGht+5qlNdGDW9JfP8
 cl9cEZ2jVHnB595E1+dl708URDscYGJk6HnBPnN1if9a5yf1XVuOHZw2rbJj+8WpFz98mVZbPl1 lOysA
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124172811.2580784-10-ardb+git@google.com>
Subject: [PATCH v2 3/5] efi: Statically initialize efivar_ops_nh
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" <u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efisubsys_init() initializes the efivar_ops_nh notifier head at runtime,
but only after generic_ops_register() has already called
efivars_register(), which invokes blocking_notifier_call_chain() on it.

This is currently harmless: the head is zero-initialized, and
blocking_notifier_call_chain() returns early on an empty chain before
touching the rwsem. Still, it is fragile, and there is no reason to set
up the notifier head at runtime at all.

Use BLOCKING_NOTIFIER_HEAD() so it is valid from the start, and drop the
runtime initialization.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 40b423f85e06..98f6365c1a8c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -184,7 +184,7 @@ static const struct attribute_group efi_subsys_attr_group = {
 	.is_visible_const = efi_attr_is_visible,
 };
 
-struct blocking_notifier_head efivar_ops_nh;
+BLOCKING_NOTIFIER_HEAD(efivar_ops_nh);
 EXPORT_SYMBOL_GPL(efivar_ops_nh);
 
 static struct efivars generic_efivars;
@@ -485,8 +485,6 @@ static int __init efisubsys_init(void)
 		platform_device_register_simple("efivars", 0, NULL, 0);
 	}
 
-	BLOCKING_INIT_NOTIFIER_HEAD(&efivar_ops_nh);
-
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
 	if (error) {
 		pr_err("efi: Sysfs attribute export failed with error %d.\n",
-- 
2.56.1.831.g720f3f5937-goog

