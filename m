Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43383A1683
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279663; cv=none; b=bQBrarfIkX1GSHOHXrXWWWcOPfc14ah0APVqhNy1SzkBNv95rYsXIVzCL8b4Tq4RRN6rT3jQ28a4go6DutG1cp74OQRB57k5wUy46pCaxPw+Da0hUMy/bTDxoQQXBF+uxoOIVWKnge7hgegsP0/LxoArZ3827OjB8B43fEra3Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279663; c=relaxed/simple;
	bh=UFnN0s+RsvkTALfr/a8OQyrxAQCThTQXJhV/kjv+G6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McmmBmIOdmTzPaKwTJAPEekIBXO/3pccoDU67x5Qr4rA4fAPPbNIJKU0RmM6CGjrTeyZ05uEHAkdKkgrMJACEE7LR/Ey3ioUGVfJ20Od18Eddko3xfIpmCqZPLtHdB44TGCkGWGeTJj9gapfSA1TaHpOcG76tVl+xh44fFXhZTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=Xt4Rm6I8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="Xt4Rm6I8"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b24fede2acso64587695ad.3
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777279662; x=1777884462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKHydH/fhv4hYoRFTuRlPVbogNTqYgaWcyoMFBpB6F8=;
        b=Xt4Rm6I8c5zKJ5QOLjGPT9Svkw8JSMaDdfNUG90rL1Bk2F967x5MofKoOUOnMOK9EX
         hdfvq9a0X//3Ns2JFBehusWLP7R48yTftH5EPqVce0zHfYcxKwbsVYbLozaysfi64u53
         fNKKOGBhejfaXqfKEhMjgsLLRLPmuchrUHr/bTERkv44Hnwr3i7nHUu6t/Wntv4YRVH8
         /lK1BbeZ8dv6L6Z4Acpxd3QDK8n/E7nThUVERyvsQlm81nrslqjdlSLN071qoOTXaL/l
         oXb0GIQQn9prMOXDr13oqhTDnbREFG/9JFfnZkZ0tSGb/Kog1dGpqQ6zjvu8jk97m3KI
         OqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279662; x=1777884462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oKHydH/fhv4hYoRFTuRlPVbogNTqYgaWcyoMFBpB6F8=;
        b=aFvE9HPUd1FcL0geFsJ25HzpoHCYpx91Fqs7ua3BXoGniIxiBlf10aNBF2IeUklNJk
         svUkTQ2HyqayTV8Ly3W507wI7mdT3Tb8Tq0Kf/jessTsuo1pi7oyDNGqUBqJ3w62l8Ur
         y6oyHIT/yu7L/XxVwJaJmqDWL4Vs/RK7VIe5GJ3bHl35Dr2/NYJ86Nz4HcsFCOK14+aJ
         fT2EJ6VvNvu93bKSZO9co+8PXLBlp7Jl+V+KzQ/Zppr6zHLrDQxp8gvB246e3sykqST/
         YVORUJ/Eb5JSIHjSUdXu1LkBkNA007vu99eDRBFzqCEGK1BMc3LVpOVkad0RONq+vK6S
         3ZoA==
X-Forwarded-Encrypted: i=1; AFNElJ/InMvMyNWbKniKzMCSeZPxXm0LdHNGBhagmOJvo1q3RDJXcj1pJijfCVspLB++UHjr4EZ2rzIx2pc=@vger.kernel.org
X-Gm-Message-State: AOJu0YysZhc20UFlw2ep+g8lMY2tMaW8TX7Qz2WVtQ4/pUJgL7uC+9AT
	JOAej6pHScLVSajp39lM+1/x6kC/q3O7G3/BFXLn1mjZTxSj+kSfXL1BbkpA1Om45vM=
X-Gm-Gg: AeBDieuyugya9JFETToIEDwxx0lMKhGFyl7mJipIoDbKKVv+FW4MBZcjRpuKpQVb7XW
	Jr7I2D5w17LtNzOuJf7WsRN4E62KBe9AuP5ZtidzJhvS78525WC2c+V1JNw0WwO7u3FgbI8wtkD
	F1n8XnpHrhtLo2OomQCO+4ULdMIQAZMwBnPncJ+QrXPnjw+aiIW6T4huq7WTbk6xYWW5xXoPMqp
	toO557VE9aIFnVcer5Q6+6gJ8p7rCHyfIRb+R/fuo+rPzeRniOc+1YH3KAgYicqz3c/5ZUGMcLV
	8dKm7lWzQF8udmLglRKHOX+SrUrMRPNbCGT85W7ulHzq4EvnXwDVzueM+t0yiwSSyGniT43Qi8t
	UFYUvGdQQQzJIy+batEv4KQSJVtNWZ7I0+o98Y5k3P9SEkLOGw80FWeI9qFteLJwKz1uweOR4Yi
	GCvKbHqEZG5FXJ6L9FvX8HZQ==
X-Received: by 2002:a17:902:cec6:b0:2b0:917c:bc4 with SMTP id d9443c01a7336-2b5f9e8e3c0mr473300875ad.4.1777279662059;
        Mon, 27 Apr 2026 01:47:42 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm291703215ad.72.2026.04.27.01.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:47:41 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Rui <r@hev.cc>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [RESEND PATCH v2 1/2] efi/loongarch: Implement efi_cache_sync_image()
Date: Mon, 27 Apr 2026 16:47:20 +0800
Message-ID: <20260427084721.40535-2-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427084721.40535-1-r@hev.cc>
References: <20260427084721.40535-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a LoongArch implementation of efi_cache_sync_image() to ensure
instruction cache coherency after the kernel image is relocated.

Signed-off-by: WANG Rui <r@hev.cc>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/firmware/efi/libstub/loongarch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 9825f5218137..f7938d5c196a 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -18,6 +18,11 @@ efi_status_t check_platform_features(void)
 	return EFI_SUCCESS;
 }
 
+void efi_cache_sync_image(unsigned long image_base, unsigned long alloc_size)
+{
+	asm volatile ("ibar 0" ::: "memory");
+}
+
 struct exit_boot_struct {
 	efi_memory_desc_t	*runtime_map;
 	int			runtime_entry_count;
-- 
2.54.0

