Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795184488;
	b=upoc7VTKrgjgJC3A79rKfRahFo8C70q37g+IEZqkZWSKavbX9Z3XHkcVCosQpckWvWto
	 hgBC94Js9pT17pO1cL1YmAPv7Y1Mp/h7lBT4wzLT68eKxVpOiCd/M5DbBU1B4DZV1u6pE
	 rxoQpltJU37BHSNG2YGur+rS2wuUyWwPxCofANRsBB6zhVJrPXfkgBtZSJMpj/8eFpCZR
	 XWwU2OdbDXAPSwAjF49RoANO/gnv1LXDqBhJ5b5wUe/LkJ8tBdkdwSRI+2Uj5ukZtXk5F
	 pu0XDqgKq04LlUt1uVuUK+YqkBwWTSiLxzKiF43YnNe2DGeVURP5YP7EiuUAFeExBCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795184488;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ITiUSrkcHo3/vrwpGUwRiKCqGxMl4l0M0GrgljGxK/4=;
	b=h94OhWHu0SBlYmGUQ8cmAP6ffAa+Hm7RVKROdg3p6MWx2xP3XaRvj9V9AIwwlaqK2IM+
	 rc0WHnGrGMterGPRgTAl1m46ZsC+Hq2nLGSvCUbvDWYfC3dk/wx/3cwWPxN6jOks9Xlhe
	 MIbIVKBvnfYjQwgEw2ylEhDHxUmbGOHvdOL9UPOmV6xn7pfyWx+Fud/4nWSfVxu41gIRF
	 iUrt85Hlbl9vvggfliVknhITt8PjA9UOoOvKX4VfKdoNadXrrhS0c0vWHbK1CWDV/hCFh
	 lkS/DG5Xfl0KGNDvDzpfTa1w61h55JEZ6vh7zNMYvAWhOkCDGziCatRIfR3SeN9nC4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gg02twkJ;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C80E606A32A
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 14:21:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C80E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gg02twkJ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4b9fde3044dso6798855e9.0
        for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 06:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795184487; x=1795789287; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ITiUSrkcHo3/vrwpGUwRiKCqGxMl4l0M0GrgljGxK/4=;
        b=gg02twkJEF7vnUZTtQcPdhpL0gvAH5oU800rqFvya0mb2K56/lW3eWvV+stZGMgGmU
         fUfdgYTWvAVdGEm1j+NEYiVj7jIsj3fdKKhaTLQUSXzpap6J8LqDXNtu227xO60ORLPo
         hgmuUdS9KEZJZ4sQoKWOFzDf305pKqtET5JBk6EcDXTqQhuuqyJZrq8ccI1c2UO1VJMu
         vTA8yU+8Thhy2nX9iJPtU6t14tf7l6wgDYtLH6RM9BUGFDSdvAoaNIulkgRlGXFpPfsy
         FXbjsKiIA7//aRxGI8DB8Co+c10HlQAkLk0+pdNZYf7mSqFCmcsIOGHNpeQDxeeZNvYh
         dinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795184487; x=1795789287;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ITiUSrkcHo3/vrwpGUwRiKCqGxMl4l0M0GrgljGxK/4=;
        b=cWlc1bcPxuO5mTtlKFPO476rgGa5/S7U9MupN5oPs5b32kzgI7AvvcWM1Nwuu5GNEr
         1HzR4wVWk5fesTLZUSOVdQlYonAYuFluUPRMTn5UaXgrbq4yd4HO7eK6YuaxQjUJwgME
         z+MiHJRIuzxoO153WRy9hx+bDfh43ky9zYEKroXkk+d9psG1g3lYrHIn6l4RnMVBne70
         fj2TyzndHmQUKVUo83LlgB6sx/3qqeWb3lGll1hRsF5uAj5V5ZqxXsZy+BpK37rl5l7E
         6oLXGxaxMyqW/rfezGC5jFFAYbpTlaBOl4agpsMRILZGHNOCs/okFk9fftsGUNWY4mYQ
         zMVA==
X-Gm-Message-State: APuU4Z8567uGQ4mc3qBtAZ+7FH1leJ/wyP9SJRG5YRUo4Cdf6gvJFKyf
	WEPpPGKsW/DDvtKcnwWltcrpnE/8bmHYThLym2jbW7J//NYNjLi6NLZrtSiMIAFQHvBQR8c2Upo
	htx7rvhHb3+KwSin6KEQj/lOO5y1C1kp6xVsrP4EJy6DYTeAravJGEaBFC+hAF1GjtOemLPQfdF
	5xs1upSEAgIEpBJcg2jarUrGxOPjqIlw==
X-Received: from wmol4.prod.google.com ([2002:a05:600c:47c4:b0:4a2:655:296e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6708:b0:4ba:7e6:53d6
 with SMTP id 5b1f17b1804b1-4bb88940848mr62322595e9.33.1795184486289; Fri, 20
 Nov 2026 06:21:26 -0800 (PST)
Date: Fri, 20 Nov 2026 15:21:24 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1872; i=ardb@kernel.org;
 h=from:subject; bh=X3o9Rmm7jx01kMITf0sPisYNfYMNsUTwItzuQQ7OsyU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZshPPlBlfXFQ9kW09YuOKl2dvuLpIz2Bfx5jAVLbl86F
 Bxy70NGRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIJBsjw85VT855FniemFxQ
 f6STSe3HinPZPe92Z9xc5fR35kqVCVcZfrMmftN6W3k+9LHuJ4UDv1PusBnHS16u4fTd1BAb7/P zEBMA
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120142123.1125683-2-ardb+git@google.com>
Subject: [PATCH] efi: Don't destroy runtime workqueue on efisubsys_init() failure
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Commit 98086df8b70c ("efi: add missed destroy_workqueue when
efisubsys_init fails") added a destroy_workqueue(efi_rts_wq) call to the
error cleanup path of efisubsys_init() without clearing
EFI_RUNTIME_SERVICES in efi.flags, leaving __efi_queue_work() passing a
freed workqueue pointer to queue_work() on any subsequent runtime
service call (for instance via the rtc-efi device registered right
before efi_kobj is created).

Furthermore, since commit 13c6da02e767 ("efi: Allocate runtime workqueue
before ACPI init"), efi_rts_wq is no longer allocated by
efisubsys_init() at all, as efipostcore_init() allocates it earlier for
consumers such as ACPI PRM that do not depend on /sys/firmware/efi.

Drop the bogus destroy_workqueue() cleanup from efisubsys_init().

Fixes: 98086df8b70c ("efi: add missed destroy_workqueue when efisubsys_init fails")
Fixes: 13c6da02e767 ("efi: Allocate runtime workqueue before ACPI init")
Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9bc22de0d67e..40b423f85e06 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -466,8 +466,7 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
-		error = -ENOMEM;
-		goto err_destroy_wq;
+		return -ENOMEM;
 	}
 
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && efi.runtime_supported_mask) {
@@ -525,9 +524,6 @@ static int __init efisubsys_init(void)
 err_put:
 	kobject_put(efi_kobj);
 	efi_kobj = NULL;
-err_destroy_wq:
-	if (efi_rts_wq)
-		destroy_workqueue(efi_rts_wq);
 
 	return error;
 }
-- 
2.56.1.750.gf70dc682cf-goog

