Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541879;
	b=kVv2K0Ghov7HWMezIaimcmT4tD5faXyxXQUqd81uRaVPiGnVwB6Kn7nRCVnp2w/1e5Xw
	 zKmphTc8igm5c1JltyZNQoOLESv4c+b/0CSycIzSDeUv0xRXDyzPTfOukycynduv6lAtg
	 uSy1NXhS8/T3755pWP7poOiqviObBfZnpcgJ0w9iqAg73Um6pMbYI4ZJSGAm0EcVaC2Vk
	 fdHwgWbEvjYT/P85W3duYGDBR8dTZw8z4hDbCQKbY4CH+ABe0U8RpqJdVsVsHwNoGNVzi
	 fMi0k4NuVoEeyeLXXFbHANCAQ8afl3uO37cWQM4N2PeM/e5vR3/8s8y4366XS0V4W7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541879;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=wlJLIbvVcosGzM9lxx3HqjKGxylleodTsPDn21EHK6Q=;
	b=FaqwHTTEkIRKjE+WL3sdDDlIV6h67xOTiaKuOaI/Anlpv1cy2WPhcXhZc41RqwkQssHu
	 qB4FxSrFDTsYWl/J/1ctxjcAnhV6O1aTUym2LQkNrK2I7+FxrTctpSxYHjXpuYbCRtFlh
	 JFUekTjmoSk1C+HH3wN6pUm0WCunZhk/J47JTim7zwngy26ziPfPfrbzFve01EELHtSK3
	 WdHfE43LdJyiUDAKW8TPMCwtgYfys8GtIQtDTrtlrntlATYq4zzbsRNoCPGRdvDTqwtUo
	 2OdQ+1O86GBi07ZFhTwHJgOMCxLSi7mLJhM7UE9W5bv7UBpelver2nOAPlJA6/tYklw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SKwWPlAo;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E0A606A321
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 17:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2E0A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SKwWPlAo
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4ba078f26f4so34740975e9.2
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541877; x=1796146677; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wlJLIbvVcosGzM9lxx3HqjKGxylleodTsPDn21EHK6Q=;
        b=SKwWPlAoPfyaRWQhlsYxiQwhYXjsCHN2RGs2pweae6d827b9sz/rBsu56DRsTKpz+h
         p3LjjrV0Vtl0kzgBoRMaZQ8M0wqw1JujdhLSGEkULa5WaCSIt4PJJnvSfUIWoLaP04CT
         lA6XQmnZPGLzE4rsLlxNpqW+cTSOsbGQLCDuht00oyWmXm3S6AJcDYRo4QI7p5HaeJBC
         f7R0mGVdDZ+WgsKprmGORgrzXL3ep4wo7iqc2LWYsr8zARhxSrNpCCupCyfrZF5cYkwv
         9rF2/aY67eGo0JI1sqWT78hD1+XpQyeZlARC1vOsVXpl0YBUu1m4tld7d3A7So2ainTz
         CQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541877; x=1796146677;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wlJLIbvVcosGzM9lxx3HqjKGxylleodTsPDn21EHK6Q=;
        b=dlH7WDyHldsDCa3gxKg5S7+AZAHUkY+BcWbCEDPFs2cAw2eewl7jAUWgApqcLGfx0m
         xqxThe0iGqgLmjMPiZC54p6Se2tAIJiKr+lBLm+QPZHjYh3OgsJx1t2PKq2E1A0/7Dlw
         +vgFcj5q+nWg/janWwsPzdJzbXnck2qsT7m10zcOecZ4Mf6nBAN1xNJO7L/+jy0oQNBD
         D8oZAc1YdBS5BYlpclbJPFH9e2rKJqqY2wfM5bpvlNGZpExtBdVzo9f82QZTMgk2OXNZ
         ylzVZAFebjS2gmLThLtsQR2ml8H6UmWq1uZdqRkGAWLZmgUXobS8Di8Iuyj2hUitgNg4
         cj2g==
X-Gm-Message-State: APuU4Z8eFjWdJG+4gtb07xvGPywORTJxuzyfJ+y3ZhsfsXH5fvhnuIex
	3ebUMbIZLvTXOISGYTIv+gnUEPNGngKW4gChU2LDPfuuM4MUPoaNMoXFJb0Hh7OOJFKDgxbBP42
	Xv35E8jHJ9SQDydWm0qt1cCs8IECQlvbrTqEpBUMoa1O5GaEyrhM6CyteG72hzEw73o2wz4pZKL
	+/VCRhtlTt2xDE1EVc2AXpFPQtsSE1WA==
X-Received: from wmbjj10.prod.google.com ([2002:a05:600c:6a0a:b0:4a1:8915:6ed2])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1911:b0:4ba:38a9:85e3
 with SMTP id 5b1f17b1804b1-4bb8880eecbmr345896045e9.12.1795541876987; Tue, 24
 Nov 2026 09:37:56 -0800 (PST)
Date: Tue, 24 Nov 2026 18:28:12 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1552; i=ardb@kernel.org;
 h=from:subject; bh=D+Jviff9cT9FNqN1EwWc3W/lQSGks8VjCMt8OB9ThaI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZv1pL5iZ63SQ/3ODwHf5pZnNtT7uyYxu8Z9rr1rsbv7D
 ddT94COUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJEPfAz/AyXYPhrmsXwLSefa
 fy6decIcgRimlMLDam9+JRsw19yIZfhnavpo08PqxZOuPVE4uq23apMGr/SO799XKGi21Zb2619 mBQA=
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124172811.2580784-9-ardb+git@google.com>
Subject: [PATCH v2 2/5] efi: efivars: Don't dereference NULL __efivars in efivar_lock()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" <u.kleine-koenig@baylibre.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efivar_lock() and efivar_trylock() check __efivars->ops after taking
efivars_lock, but __efivars itself is NULL whenever no efivars
implementation is registered.

That happens at runtime, not only before efivars is set up. For example,
tee_stmm_efi_probe() unregisters the generic efivars ops before
registering its own, and qcom_uefisecapp_remove() and gsmi_exit()
unregister efivars outright. A concurrent or subsequent efivarfs
access, or a write from a pstore backend that is still registered, then
dereferences a NULL pointer instead of failing with -ENODEV.

Check __efivars itself as well as __efivars->ops.

Fixes: 472831d4c4b2 ("efi: vars: Add thin wrapper around EFI get/set variable interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/vars.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 3700e9869767..f9c28fbdb26d 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -143,7 +143,7 @@ int efivar_lock(void)
 {
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
-	if (!__efivars->ops) {
+	if (!__efivars || !__efivars->ops) {
 		up(&efivars_lock);
 		return -ENODEV;
 	}
@@ -159,7 +159,7 @@ int efivar_trylock(void)
 {
 	if (down_trylock(&efivars_lock))
 		 return -EBUSY;
-	if (!__efivars->ops) {
+	if (!__efivars || !__efivars->ops) {
 		up(&efivars_lock);
 		return -ENODEV;
 	}
-- 
2.56.1.831.g720f3f5937-goog

