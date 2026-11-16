Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839253;
	b=iIDkfI+xF7z+EVGxgWS7tt+PKBmJTefOjNwHlbK8Gs1yqKdvlpeG/FMr4lhlTrlGV2WJ
	 W7xARSfkXBK9+L8QWPXqRke9T0N9+3Q+SGKnJczHRMjhEk5yYYSi5CUlkYOwBQA2zD9IP
	 ej4hX7JuopkZo8jhcXR+yx26Iybg9W9DJ51bGL3JIDJ90u4DN32GaMVm5sXLSw0/AH7Ot
	 zdWKAB/+7v0rJHTAFLZZwlowVrDikb/diDEE2HZ0scmObR/jcek/5jWtMH/B9UmX2QV3S
	 oXOpIWgR+Jabp5wfRUh/HURn6KsdCuBOBoEgWHPvQoSAWBlKsIPyD6uYDVZDkvQq97Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=GDmEcRmMyOcax5mKICmpAsSQPFvmFrhuIcwUrIgFdio=;
	b=BzLRczBYcRSOpAELJhfhp+3X0uzqtJoLcPculgBAZKAVNFg8r3EKKE9ywx4EjmDTzvOr
	 P/+5bPOkF5Z2ZBirgvsYtmaNBcKw1z9ySESepgKJWDxpa63FhY1kbNoPY3Y/sk2u0W24T
	 9NyQUVL/O72wCN7L3f7F40RlZWFGTl+PLqahJwS9bHTpEKfKtwR5EA1fxn3FCkC8cQGDS
	 /wqG0rL07Z9v7EkwvcVCGVMlpU5IAZcFrsnXJm6iG8FDMB9mdI6l4TaO+cvd5+C9y+08R
	 nDKzynuje3nyFGgoeVdtemUE9GtcQcLOGkIs3fJ7xB5SAQ7KIwA/rXmJvPUR/4A+slA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HTEVF6FW;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5F1606A32A
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA5F1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HTEVF6FW
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-492e3189fc9so2237396f8f.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839251; x=1795444051; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GDmEcRmMyOcax5mKICmpAsSQPFvmFrhuIcwUrIgFdio=;
        b=HTEVF6FWLkJfgD7byZXmZ++9tSegDcAj7AMvq9YNEsTqrZ1cPiwn+rm/rSl/dm4b8D
         VQJAXFj0CYnYy7wBnlNZz3LqEUHQbjs7g19aeFDK2p3gCaYeNl0qWBRUG0osCfO+8N4D
         hzmGOTugxMw8LRu6gbGx3RqTOjeI9AYcGuH9bZyz5HOfXxfoI2C5ruFvxGkQQ3li2gZm
         adK4rrrBd3zpZO92puvRfTwQy5CqiBsgUgwvL2SBEpeJwOf8k++hwhYpJNYdrrrVBqYL
         tQaXfeFcqOm7gC1dnbMjjyiHOxVmwH53uZExGtR5NTqNuraoWWFCvgAiTioWskkTyfcm
         G7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839251; x=1795444051;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDmEcRmMyOcax5mKICmpAsSQPFvmFrhuIcwUrIgFdio=;
        b=0xUBO/G/rAPY5pTcrsxv5o9Q1GDjS+UKuI/FQyeXVWHWu3LF9hZpK6CWiLHfQF2OXL
         g0c2Hap8LT4BcKnL2C5VvLzQgANuPHE664fHVXt/tBiox5qq9ppPJHLlhfkd1MzNaJ34
         ocGamguQjLDn1o4BIbBdvYooA4HjVPUa+DhXOKoh6JAQO/cn1DjuIJJB+fpFejDdQr06
         TbUb4uMyH1sRnwnkbNYUJc0EuYJUXwED6u/vLqhO1Ep4citMrkPdZQHaMgxO5gwOMjIS
         nEE3Jokcw+sKkzgKug42Y12yp8DVwJmTJVOjboEc20Zro4zuvLPSQtFNUvDdltJc4cDX
         Z4vw==
X-Gm-Message-State: APuU4Z9oQDGVjHwMWjjEj5dw1j7IdaLvL/8w0Yh0iLJSewOr9bHDLDlG
	MNbvQZJC5WXuuT2E06tFiZxqG0VaPCTtrnpbXETOTkYyR4753tGRFmrCq6vSMEUVmh5kvh8Ycl4
	SBwNV6Qjr+yesby0thE3UdJKpJUW//jlRL1PWsb/V2qhxLH6nNNp4gZMiLIq6RDoVE6EeO+wDUz
	E3rkIYQYtoPpoiPhfWyFCUrrrgNYBCTA==
X-Received: from wrbdj11.prod.google.com ([2002:a05:6000:b0b:b0:493:1d71:a33b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:608:b0:488:7dc6:4e9
 with SMTP id ffacd0b85a97d-49c70ed8e94mr25114870f8f.10.1794839250838; Mon, 16
 Nov 2026 06:27:30 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:34 +0100
In-Reply-To: <20261116142618.1687025-17-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261116142618.1687025-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2284; i=ardb@kernel.org;
 h=from:subject; bh=pQuS5NqxIFj4wbVklTtBdnUPtGLjNWkfYhwihjrAl7M=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30IKV0rIFvb3+jhJvjwtvPt+/VykrMM5e7MOqiDD5J
 z4biho6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwETuWzL8d11y4WaaBftmeZMD
 53wZtqg9KLJ+1VZUrtITZ9u4o7zpACPD8ueZbzxnF72pm3I965OyuWpdZ0F03u3v0v87Z+lIPG7 lBQA=
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-32-ardb+git@google.com>
Subject: [PATCH v3 15/15] Revert "efi: earlycon: Reprobe after parsing config tables"
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This reverts commit 8b3a149db461d3286d1e211112de3b44ccaeaf71.

That commit added logic to probe the EFI framebuffer earlycon again after
the EFI configuration tables have been parsed, as the primary display
information may not have been available yet when the earlycon= early
parameter was processed.

Now that only ARM uses a configuration table to pass the primary display
information to the core kernel, and the EFI framebuffer earlycon is not
supported on ARM, the reprobe logic no longer has any callers. So revert
it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/earlycon.c | 16 +++-------------
 include/linux/efi.h             |  1 -
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index 3d060d59968c..997f69ce46cb 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -216,14 +216,6 @@ efi_earlycon_write(struct console *con, const char *str, unsigned int num)
 	}
 }
 
-static bool __initdata fb_probed;
-
-void __init efi_earlycon_reprobe(void)
-{
-	if (fb_probed)
-		setup_earlycon("efifb");
-}
-
 static int __init efi_earlycon_setup(struct earlycon_device *device,
 				     const char *opt)
 {
@@ -231,17 +223,15 @@ static int __init efi_earlycon_setup(struct earlycon_device *device,
 	u16 xres, yres;
 	u32 i;
 
-	fb_wb = opt && !strcmp(opt, "ram");
-
-	if (si->orig_video_isVGA != VIDEO_TYPE_EFI) {
-		fb_probed = true;
+	if (si->orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
-	}
 
 	fb_base = si->lfb_base;
 	if (si->capabilities & VIDEO_CAPABILITY_64BIT_BASE)
 		fb_base |= (u64)si->ext_lfb_base << 32;
 
+	fb_wb = opt && !strcmp(opt, "ram");
+
 	xres = si->lfb_width;
 	yres = si->lfb_height;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc1df1577d5f..4a809c6ae724 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -719,7 +719,6 @@ efi_guid_to_str(const efi_guid_t *guid, char *out)
 }
 
 extern void efi_init (void);
-extern void efi_earlycon_reprobe(void);
 #ifdef CONFIG_EFI
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #else
-- 
2.56.0.611.g1030f0b940-goog

