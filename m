Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541877;
	b=nxq3WqCyMy+tH05seYTo/x6KMU+HyyQlhbfwluwdq7WcNAMaNw3gadY7B4VpWyqxuPTW
	 KAiZbehUAzSF1kZIaRr7gWUdY6kQugjnJDvpupXibaXE1CDD3yfCEwf+3cgU058G1X7Q8
	 5UO2PAzxJJ4+7jCd0yt4in4HlGpQvvHtrz4oWOgRma060Fts5BA8A/LXsrIURiZ+Uijpd
	 vcwBzYfwg4gybdKh1CBAL+Ra+NwB3QqESnbkbw0l6QiqpejmiYpRueGyQwa/Ytr8BFEkQ
	 EWrcGHt1v9dF3Rk6O19L1hwI13aMoDxX/Kl7dYJWHqvDb+GuyqGYx3UTKnGB59Ipo8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541877;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=lr8eROeYqOwVYDYKaKs4dok8lqJtCln9w99IrPpRWrY=;
	b=uj5BYbo+9qB4IFFVz0SK0kLhkumP+Dcm3I33xcwBqfSExePN/m7oYIhovkmngsIk3kW3
	 OSFTaMEVStdGfRqlVp9RwGQwOC3LSWsAMaLJ4AgEH11mUElCTflwF1RV5NwcqU7bLizlA
	 KjPFzaLKLKe7TTsfkA0oeZw7Wzt1iKdvqUlbsjzVv10saU7oypmwDNnhDB2gS2yyUaL6S
	 KknG5oA5aZN1NJH2cKPcmOaWSeNHjB9FJNC1moNVrcLFUOl9ZxvawY3awnIYJwe3HP8GD
	 ICWt6qxfnwylGDPrzQpIKNcOGrhoiWttpOheTthNQ9/207kqjjHt34ttJraI7sJu2Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jKh8Gq+P;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDA6606A323
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 17:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DDA6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jKh8Gq+P
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso17335995e9.3
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541876; x=1796146676; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lr8eROeYqOwVYDYKaKs4dok8lqJtCln9w99IrPpRWrY=;
        b=jKh8Gq+P/AaKNhplNkIOvENYy5oA8gA6ZkVHBgI/hUhhooDfz58syc2fuVZRUOkVHW
         Z5hKCcZYsuxYfeewPKn/N79iPVqw6PZmM6fKib44ubvN/zHLUr/eNDOkW3ZQSh1SF+Ei
         4++gastOFZ4oYJnmqfqkIJsbZpW8QV+TK70EtUdngiiQ86o/rAYbDIq4f74xMWlypjd7
         PoN5L0EGT1p3s+uIJS5o1Gqcs9XLkZM47qRlVoj0g0xRgH7Lb9OBPgJg9MBYoSwcoY5K
         GPRvmjURJzTjcaZ6OIyzXFC3c2un/Fh2U1vMML7bW/w/PWzFMl31mXSioiObEBEnVKaN
         qN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541876; x=1796146676;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lr8eROeYqOwVYDYKaKs4dok8lqJtCln9w99IrPpRWrY=;
        b=eSAgx8Dp6KrWoE97ENyUKPG7kZHiWQdDTHbT+xKnO8jMWhXB4M/VIBJ+MsKHaxBs1T
         V2ISzOd1Jequ9B76Vf6NkEmenkyHnrybnT537zcussKPGhRsYGleMNBnKXtXeWXoMtKj
         ZtlinaD+LDIn1l6BJ0+8qK2rF1IyEBbszrw1Hcs8KJft/rq46sHthCGIbF8UbuttfSv7
         vrE3eOtWRaDATJyK/MewrYze1U4CJeW364DPUE04uWu+iONHXmee+h4QnB0AbISrDn7P
         RO/UDhNaLFe8pvo1W6s7s8FSyIhY2/V4yeiBxkdWCvbcB98fwN0qvTX5YA7n1dioTF0c
         Eg5w==
X-Gm-Message-State: APuU4Z+bY+7xGVZ/4Se06oKo5VruCwt0j3p+wWiCto8/47HggV4vk0D7
	FgUDrKe2CgcK2TeA6IKt4lGvUv+7URgaQYi0P4HnnKVwXXSnWHVd0gVZQetF31JvryDoTLig7PY
	3Oammk0FYPTDQIgkB+fpTPn7SsicjJhiJguLmiFertYE9fMEfIYpHp7rrsHgzQkQYpJWC5fU9W4
	A0TDHL+ZeYC/Xq39WPymLBt6qhMND3xA==
X-Received: from wmg25.prod.google.com ([2002:a05:600c:22d9:b0:4b6:4096:72ad])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f4a:b0:4bb:6752:8413
 with SMTP id 5b1f17b1804b1-4bb8880015bmr354089625e9.8.1795541875757; Tue, 24
 Nov 2026 09:37:55 -0800 (PST)
Date: Tue, 24 Nov 2026 18:28:11 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3707; i=ardb@kernel.org;
 h=from:subject; bh=WAeSq122zmRN6UBtMnHF67HzqKFqId87iOExF570bmk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZv1pF7ZsZUMFnbhvKsE7JdZ+Yt1ztwxpbvr+gLGUx0XM
 1aViHF1lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgImcW8XIsHDvvUObHv3xK/jO
 GZy5qexqyqyjy+J/sTguEFnk47dfroHhn1LC3gO93Omu9YEJNglTWaTYbaQsI/jTTPeIJjQzvuh jBQA=
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124172811.2580784-8-ardb+git@google.com>
Subject: [PATCH v2 1/5] efi: pstore: Make pstore_disable parameter read-only again
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" <u.kleine-koenig@baylibre.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Commit a28655c330ab ("efi: pstore: Allow dynamic initialization based on
module parameter") wired up a kernel_param_ops::set callback for
pstore_disable that invokes efivars_pstore_init() directly.

Because parse_args() runs before module initialization (and before
mm_core_init() during early boot when built-in), calling
efivars_pstore_init() from the parameter setter is fundamentally broken:

 - Loading efi-pstore as a module with pstore_disable=N initializes and
   registers efi_pstore_info during parse_args(), and then runs
   efivars_pstore_init() a second time from do_init_module(), leaking
   the first buffer, failing pstore_register() with -EBUSY, and zeroing
   efi_pstore_info.buf/bufsize while leaving efi_pstore_info registered
   with pstore.
 - If load_module() fails after parse_args() (e.g., due to a subsequent
   unknown parameter), the module is freed without calling module_exit,
   leaving pstore with a dangling backend pointer.
 - Passing pstore_disable=N before record_size=<N> initializes the
   buffer using the default record_size before record_size is parsed.

Module parameters are meant for boot/load-time configuration rather than
runtime driver state control via sysfs. Revert the dynamic parameter
callback changes and tighten the sysfs permissions of pstore_disable from
0644 to 0444 (matching record_size) so it is no longer misleadingly
writable at runtime.

Fixes: a28655c330ab ("efi: pstore: Allow dynamic initialization based on module parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi-pstore.c | 39 +++-----------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index a5db3534f0a6..19a7e4fe5b52 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -19,37 +19,10 @@ MODULE_PARM_DESC(record_size, "size of each pstore UEFI var (in bytes, min/defau
 	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
 	 EFI_VARIABLE_RUNTIME_ACCESS)
 
-static bool pstore_disable = IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+static bool efivars_pstore_disable =
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
-static int efivars_pstore_init(void);
-static void efivars_pstore_exit(void);
-
-static int efi_pstore_disable_set(const char *val, const struct kernel_param *kp)
-{
-	int err;
-	bool old_pstore_disable = pstore_disable;
-
-	err = param_set_bool(val, kp);
-	if (err)
-		return err;
-
-	if (old_pstore_disable != pstore_disable) {
-		if (pstore_disable)
-			efivars_pstore_exit();
-		else
-			efivars_pstore_init();
-	}
-
-	return 0;
-}
-
-static const struct kernel_param_ops pstore_disable_ops = {
-	.set	= efi_pstore_disable_set,
-	.get	= param_get_bool,
-};
-
-module_param_cb(pstore_disable, &pstore_disable_ops, &pstore_disable, 0644);
-__MODULE_PARM_TYPE(pstore_disable, "bool");
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0444);
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
@@ -255,12 +228,12 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
-static int efivars_pstore_init(void)
+static __init int efivars_pstore_init(void)
 {
 	if (!efivar_supports_writes())
 		return 0;
 
-	if (pstore_disable)
+	if (efivars_pstore_disable)
 		return 0;
 
 	/*
@@ -287,7 +260,7 @@ static int efivars_pstore_init(void)
 	return 0;
 }
 
-static void efivars_pstore_exit(void)
+static __exit void efivars_pstore_exit(void)
 {
 	if (!efi_pstore_info.bufsize)
 		return;
-- 
2.56.1.831.g720f3f5937-goog

