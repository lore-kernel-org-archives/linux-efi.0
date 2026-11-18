Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026141;
	b=wBmEK+3tLYwbVUKJQJu/UAthWa3oIKnG60ESkv7IY9v9KD6JkccAZL2+PqjhfNw8qtxD
	 d1fOB2X9lWrgSMv2jEa292OCk84kBpY+YR4Sj3gS+p0oNsM39T1xDRx1ElwJRt1BBCwCc
	 E3nft/Ondo88lmZwrLU1YwLjIoUNSnH4AOqpfQ2LCGsH1oFqvd5ygoy8IMSIoSWTsNhi1
	 jaG+0oR9RRCkovr3qkwKB/Vr7JZC8Wh89Qu2ZLsamWwFXhJU4xpNYzV6z2xfIaSIXk30j
	 szURzh6ECi+k+QDqDIQbU9El7nq8qg0iyg7e2ZRgEv68W16IfgxBa4JMRddb9Z004Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=/uw6eSasL1b/vj1BX3jiErELTDd2rhnZAcbAAr5FXR4=;
	b=ZNAwsvTdY5ok5Z2xPvLSwwagaArjvDjKjcIFdcEs85kW0s8O//n/bTfQAh80imAi+8a4
	 LZE15gxjgL+XAbIx5PUdZGSGpMhGL7C2hZfuRb4yUQ/E4b0c16hFhhbxRMg06/mpgzXyM
	 FJtib3SgbdDKEqAJMdX03NNskaq7a6FzCiSChB+70/OOilXq0EtTPwRpR3m9lBU/qpF/0
	 ea45moEiUV7vPGnMD52rwmLkVdA6a1dWyVqLC/07SUHtKWV6/uDK2TDBvD5FKvuihpn4D
	 9j7T9nf5S4zN38us2AVXWM/i86jZ+cal9XTuNyI+Wo056s7ZfPfwWJ59iUgpfrPIVpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YiDhwWzf;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601CE606A330
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 601CE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YiDhwWzf
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4925ef75fc4so1017815f8f.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026140; x=1795630940; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/uw6eSasL1b/vj1BX3jiErELTDd2rhnZAcbAAr5FXR4=;
        b=YiDhwWzfzzC5wqF0JClr74wlzSWO1tYSuMnUh2sBmEfA7MCR/e7PX+uuEOihJ8wkbn
         DaCtFLHbgdjuG3EPFfXB3CZH9PZrfTJceJ+GezmCw6gIWPazfCyMEi0EfhK00C3lR+Cg
         wyFLUms86pm8YryXtkCOc9h9kXDWGBKQkjhJdAfpseC5/ldvXDhasuKT6qKKgRCGjHwu
         DIf3upDzjtOO8UpMb24fWDe4iut/YtSCNIPqX+hxZIWCQ1deDghWSRQfuKl2nO8QvLMb
         OkBAaMY0IiDbUbZKyOTxTNTcNrXnST1lRCdZ8nKEGXdwb/Fv+NviHY4V085m9QL0OZ8C
         K7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026140; x=1795630940;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/uw6eSasL1b/vj1BX3jiErELTDd2rhnZAcbAAr5FXR4=;
        b=puH74YBYj9cOxU7JIi3AS73lNuzFX7/d/jXvITrivYOcOjxM/Qhc7uEpgbxX/W6lSh
         cyv4coRsYARsjEQK2GtqjOSEewhWTUsph3ZCFT5ocSpj0xhdNJi1ULMoam8CbBZoErFz
         ELgGMqfqSFu87+c+qyqA4SkbsZ0YtIdDfIuDULVwWXKa6kRlNn3SPoYFpm7GOQCJI5FV
         sECSE280zHoszT0nJ8Zk6zTKRq0LeDIBL8cGwM2brmoVMuo5X97JfPWw1AdFAfHb5v0a
         OuF0SlK+E/kg/7sEN6lWk3GLoNiQx15BGyA75lpI7c7UXzyNiIncEeEnWkyZMrc4Vr5X
         bM5w==
X-Gm-Message-State: APuU4Z+SYn+Alfx4W0BWAWlrplq3lFFpyMtMPbos6GmEvw30ct1Lbq56
	ctxJeE4EFX4DLtH3MGQOX7fOvLTKcGJkDKWv7slNXm01VjgUm2NLt7dW1ZYgG/y+MzrPMr/G0/I
	s0STgJAs5MNBDOmoBrfvXbGLkcKJDLq6IfdaTvCjJIz+j1UZ3doee7CoTNH9ZkhJMH6CXXGcg0c
	HNSwYblDWAmpISmsdWaIXUxs/xqDEwYw==
X-Received: from wmdn7.prod.google.com ([2002:a05:600c:2947:b0:4a2:8ef:a5af])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a4b:b0:4a2:59:f568
 with SMTP id 5b1f17b1804b1-4bb7da12963mr69266665e9.14.1795026139303; Wed, 18
 Nov 2026 10:22:19 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:25 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2331; i=ardb@kernel.org;
 h=from:subject; bh=iMPCb+Keab2MgLv3M4zpVvDMgTGioYSkOer/TnS5abo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm7XCHZeeHX8f+DPD6s/EiYutrt4v2FF5+G3G5ovFp
 gkTt/vzd5SyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJrGViZNj06n4gj8DV5D38
 0+a2fkhoXPTgWswsFkENBVf2sAsbVv5j+CunwqFvkPC1JSbr9sY1t0SfFbxp3j7/ep6t8usHajm MT3gA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-40-ardb+git@google.com>
Subject: [PATCH v4 19/19] Revert "efi: earlycon: Reprobe after parsing config tables"
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
2.56.1.708.g77570a6a1d-goog

