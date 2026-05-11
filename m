Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489730E0ED
	for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 10:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496407; cv=none; b=Cu0NcEcnky/uqbOtuC60WCLseicEfB6ZicSMfUfrHCNAJWNAr+FfDsUqX5tU/oLR0FqBX0QJQ4+Ov6t+N4i9m4/WCyKtvE6lenABw1jP8bXyV2gPvMQlpCForVcth/CtW3Rgqv+e8ZrcQ0mNERxpUTC6nG5CDXri9IKO8JxPMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496407; c=relaxed/simple;
	bh=4SXmfcgX9Xc7X+ECU2pGHF0IxLYkgbYx4JOLZXPQsjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwqzsqaH81dRIV5Iwsbkv8fQcIIqgjDjr5Bfl0LO+GzbeB50PHrqEngVQedeKJ2k6X5deXXeezIaSU7O7K6ShZIARO2QuDrYtrwu8tpnJWac5nRfmka4YiahDmL+NUbIpMq9WOoe0PDyH1GKP0dfFwy+uC+9hNR7yymUsHlyih0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=LSnTkGc1; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="LSnTkGc1"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c80148ae949so1731438a12.2
        for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 03:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1778496406; x=1779101206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGeGGvDHlwPJP9DOo96cEsEK7mSKv8XkYQ47F+mLwRA=;
        b=LSnTkGc1PkP43z/TY+94DNORbjhdx0ORrS9UBbmNOSWq6+MeT3OMYak42UlTHT50Gc
         MHSeOHrhZSLyjm4W3eDlqdCyr9us/AHw7dJjj3nImoihDHmMNznQ1B1QIaG2/N8jBKVj
         tjrrZkcqO8FGIZZN3GuPIetO3fu04WcuoDVIZTCYa9N0qn1k3oQ/K/rs16S0shKoUOde
         O8UP/Qv/P5F4Cq5b0I0VpbeB0Y8JiNOK7HTb1cB28luRsiJ/xJEAri/TrQnPevj2vWnv
         6vS5QbgMsHjX7XCO4zRhD+9mNzLUh2SozoKpW0inRpVyRGnm65VMhQWsXdq4bZ/ib6LO
         jTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496406; x=1779101206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KGeGGvDHlwPJP9DOo96cEsEK7mSKv8XkYQ47F+mLwRA=;
        b=KKuwdcNresizvI5q50mRxLo7gVUliyWElSLZIpl3OJyGdHLCQbzTM1oghERnLk/xaD
         Q5m7ojezK8+y9pOodjQwhZhe90dj0JuC0WzBTu7HQNrW5SjgF4dQYGeFqjCiYhZi1fk7
         ofKICthR1V7Sl2TU26rsIgFKu8YsP/zprjgwXCrnUO4WKCSVAdTBY79050tR7PhdGvbA
         jPXNeiUH3wOOzX3Kfg3i/aXZHuFxj4W0ZkirDRmi2XmgpQ7D2ZqYDb7w4sdoNftWFqlr
         Ee9mVKIn4gDMIy+lPh/mNxjVp2SWmKxQDBGddCw94qs6dPtoE8+P7NI5NBpusLB2Gl1p
         OZ0w==
X-Forwarded-Encrypted: i=1; AFNElJ/ojoY/XtERP9XZpCe035FH+glyTYTUa2h1VJutkFOHQ6FEjhz0CaRZjKO68esCCW0Xr83C8E/MolY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaZPPaHrm6PA4rq2laO0UhnPqBFQ6Vwjdq/LsG+CpUVi8fL+9a
	5flvWUuEdbMVdUsgL7CK1PgSgkW7JY3vH+I7/c7kkaxNc/raD9RlSh0igF7LxEzyyDY=
X-Gm-Gg: Acq92OE93j8LopCHD2WXCMrrZXNsz/ZLg5BKsXQRvJz0w0M0DGx5Bo4YXw0Zd7hZACz
	y9FZPdXds5AOHgK8SC/rF+jW2g1tyXojlU1RIIhMOW4ETokjkRmSpNatCi34s72dUUA9HWdPqov
	YroNqT5Czatou/9ORuqDRvp3v/qeaSSivEXTblwa+heU1zaV/AyxG8faKAay1dLoecRpP0odNZT
	pZb6Je2VYKYZqEPGssg4yrStqWCi5HbgW9Rh74wM+so4SinvuMJx4HHeaunlYk9JSewHaeowsLQ
	au1rduWF2luTSM/o6um4aznLJcZA6TMXdZ/fy+Q/Cl6yaXci/A9jb1ige9WuyCmRH93GVfLUVpz
	sp25G8yizZrLNgfVjWdtog8DVAFIUZFD99zJkMy/Ta2sZjzkmA3WHgKS3ns/iAC1RXBrjAQr8v1
	jqopTg+B5u
X-Received: by 2002:a05:6a21:3390:b0:39f:94cb:1bc with SMTP id adf61e73a8af0-3aa5a901f0amr27108324637.1.1778496406048;
        Mon, 11 May 2026 03:46:46 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3f:344e:4435:2c77:3920])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c861esm24927599b3a.30.2026.05.11.03.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 03:46:45 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Lisa Robinson <lisa@bytefly.space>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v5 3/3] LoongArch: Avoid initrd overlap during kernel relocation
Date: Mon, 11 May 2026 18:45:55 +0800
Message-ID: <20260511104555.196270-4-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511104555.196270-1-r@hev.cc>
References: <20260511104555.196270-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate the relocation address against the initrd region specified via
"initrd=" or "initrdmem=" on the command line. Reject relocation targets
that overlap the initrd to prevent memory corruption during early boot.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Co-authored-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: WANG Rui <r@hev.cc>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/loongarch/kernel/relocate.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index 0a045964fad5..4b61a9632a98 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -222,14 +222,52 @@ static inline void __init *determine_relocation_address(void)
 	return RELOCATED_KASLR(destination);
 }
 
+static unsigned long __init determine_initrd_address(unsigned long *size)
+{
+	unsigned long start = 0;
+	unsigned long key_length;
+	char *p, *endp, *key = "initrd=";
+
+	key_length = strlen(key);
+	p = strstr(boot_command_line, key);
+
+	if (!p) {
+		key = "initrdmem=";
+		key_length = strlen(key);
+		p = strstr(boot_command_line, key);
+	}
+
+	if (p == boot_command_line || (p > boot_command_line && *(p - 1) == ' ')) {
+		p += key_length;
+		start = memparse(p, &endp);
+		if (*endp == ',')
+			*size = memparse(endp + 1, NULL);
+	}
+
+	return start;
+}
+
 static inline int __init relocation_addr_valid(void *location_new)
 {
+	unsigned long kernel_start, kernel_size;
+	unsigned long initrd_start, initrd_size = 0;
+
 	if ((unsigned long)location_new & 0x00000ffff)
 		return 0; /* Inappropriately aligned new location */
 
 	if ((unsigned long)location_new < (unsigned long)_end)
 		return 0; /* New location overlaps original kernel */
 
+	initrd_start = determine_initrd_address(&initrd_size);
+	if (initrd_start && initrd_size) {
+		kernel_start = PHYSADDR(location_new);
+		kernel_size = (unsigned long)_end - (unsigned long)_text;
+
+		if (kernel_start < (initrd_start + initrd_size) &&
+			initrd_start < (kernel_start + kernel_size))
+			return 0; /* initrd/initramfs overlaps kernel */
+	}
+
 	return 1;
 }
 #endif
-- 
2.54.0

