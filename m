Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5172D3F54C9
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464227; cv=none; b=WfshGq4O45HSq71M2A6877E7A/VXEfEBRV+pdFe8vkpz6TgwVVP5l5MFPy878Wc0M+d5TV6V4Ieo7ZAi806MGxmSCcfj722wYxllAr832Gd2HSbNPBKx5TZot7OIgwsnuPKXCBwFAZCK9MjLXr/3fOo2fDJ2VU/udHH8LT007KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464227; c=relaxed/simple;
	bh=a34ACn1Sgal11ZBxSg+Hb4pRuQubJyFhjmNMgVieRzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQqTSqT/06ksWeoNA0x9UI4hA5WrNMbds0Y21YuAn1LTPbDCk2I56DEA+qwyDZsnmI6tEmnLqGb8JpKnkaQUGD3j0P8t/OAMHCio+Y8mrvqBR3iAPUAovtsVRyfU3kca8DQO7J9WGyy4r3PG032pskGvLmdqV5cpi/e+WJMKuy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=wK92ALMv; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="wK92ALMv"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82f8bf96b46so5979995b3a.2
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777464226; x=1778069026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUMOs2k5LZ6uSx/H9Ms2dy+Y0TfQtSGfCzkhnixfHJw=;
        b=wK92ALMvpZJ7Eod0hSLs57IWZPcK8pCf1I2z2on5ieKP1hn6iVREzbwNgQCtmDised
         OA2ZDLxkP56JOOLzqjIFiPhMPsLM9r6sxKwzJVOa4LXfHe1n10r+JsVIvHfQGuB4r3t/
         kugn+WIReUkP1TvsxUsz3ILpxokhlB8hk7jXWMCD/aMXhnflhcVVTCmXlU1GAxsdaCXW
         gAEVojFj3Lij+nxYNBHZNw69rB9ssGej6k6IE2lVTX0XT9x9fz6C1sluH89t1RuFbXdT
         VvYj/xkfmuCMr5Bpu3Gye3utPExNpl1/BNkha14drzSJc2gN5Baa3/dCpdzpIGyu61Tj
         /Etg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777464226; x=1778069026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gUMOs2k5LZ6uSx/H9Ms2dy+Y0TfQtSGfCzkhnixfHJw=;
        b=QkB/FDIfzmGlqZaWfrIrBgyY1cdlB4yrNQtkb/9sqDYw3/Pe/G+NHhFJ2vfKir03TA
         vNBE1w+IKE8asL3sYpGFViQl1cg/W8WqkgDJbnWRBTI+lIs56PIG0V5hDAIHJzIGzE81
         EoMb5JU+0y3rvcyGJpJIfbaSQTGefyQ2Css9mU0q+rNGTpEJst8MsyXK7yQvHW0JvbPO
         cDwnzTBMHozN5E4p3PlRFUevEdCaUHpGvNY+jlUY7rjsXsfmz5sVIfU6P6bjLI/Ks2jb
         ZYTIMj12YIlFgHu//GBJcGYZ4849u1J4sYQtxRdpKHa3NsGMeZmtV+C7r17o7uPZkpGQ
         alEA==
X-Forwarded-Encrypted: i=1; AFNElJ+fQrDKiWoflifmV3YQXXPcQnRtvnCuL2thEwIZDnrtJfC7ByFHx9EMOaSoAG8HlJSLVEHOm/YIHqc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgH3e2TsrVN4wI+3mXo0J1oCzX5UH3oXE6eeFmUksLi693Nx75
	oh1Wa+PZ2YkqlbkeIpVULH1Tb/nE40+5XcXHKp+XPr/YYEhdqKUqNdgf4KHt5CcxCT4=
X-Gm-Gg: AeBDieu1mT4D1Cm/wQdKsTAnKguItWNAS9CW3xIkVEG10C7/UZEpnnSHAgvRT+Nro+P
	AIY+15rqcIqT5uU5x4jz+0uVWE8BMST9pCmNuaKcMSJfzTofQIJ33ybVH0JV0px+zTYDgQ0w4y/
	iTDzk9LpV9jLvYpl8XradZlSkz5zfmiiaPf1YlDHYABj3axEdRzalZJ2+ep1YT6fCBCbFXRwmtx
	/s2knc5kFpfB7c2SByy6FlFHaGRl28M5BbvoLvHcTegZCcHn6bIIu4AxqghpFZUmx2nMAdfJA5D
	kUQz/pYRmEXPWaEzxT/L3Bb7NW7cijNuK+YBFLlFteMlXj3KvsHu0c5bpX8ZGFJc27g5cnACwLY
	JMHfdZmBD8aGIQAxY0rkw50sTKQSgDco74ORcSE0ufuSibkRFvRH5CLtR4xZ9npYP3fanRGbq4x
	3WAdrq3hCN+/qH7lDgfQ==
X-Received: by 2002:a05:6a00:2999:b0:834:e15a:19f7 with SMTP id d2e1a72fcca58-834ea68c89amr3427366b3a.44.1777464225343;
        Wed, 29 Apr 2026 05:03:45 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5efaaasm2016493b3a.27.2026.04.29.05.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:03:44 -0700 (PDT)
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
	WANG Rui <r@hev.cc>
Subject: [PATCH v4 3/3] LoongArch: Avoid initrd overlap during kernel relocation
Date: Wed, 29 Apr 2026 20:03:00 +0800
Message-ID: <20260429120300.1786210-4-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260429120300.1786210-1-r@hev.cc>
References: <20260429120300.1786210-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate the relocation address against the initrd region specified
via "initrd=" or "initrdmem=" on the command line. Reject relocation
targets that overlap the initrd to prevent memory corruption during
early boot.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: WANG Rui <r@hev.cc>
---
 arch/loongarch/kernel/relocate.c | 45 ++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index c36604a81d08..721b982f194b 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -214,14 +214,59 @@ static inline void __init *determine_relocation_address(void)
 	return RELOCATED_KASLR(destination);
 }
 
+static unsigned long __init determine_initrd_address(unsigned long *size)
+{
+	unsigned long start = 0;
+	unsigned long key_length;
+	const char *key;
+	char *p;
+
+	key = "initrd=";
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
+		char *endp;
+
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
+	unsigned long initrd_start;
+	unsigned long initrd_size = 0;
+
 	if ((unsigned long)location_new & 0x00000ffff)
 		return 0; /* Inappropriately aligned new location */
 
 	if ((unsigned long)location_new < (unsigned long)_end)
 		return 0; /* New location overlaps original kernel */
 
+	initrd_start = determine_initrd_address(&initrd_size);
+	if (initrd_start && initrd_size) {
+		unsigned long kernel_start;
+		unsigned long kernel_size;
+
+		kernel_start = PHYSADDR(location_new);
+		kernel_size = (unsigned long)_end - (unsigned long)_text;
+
+		if (kernel_start < (initrd_start + initrd_size) &&
+			initrd_start < (kernel_start + kernel_size))
+			return 0; /* Initrd overlaps kernel */
+	}
+
 	return 1;
 }
 #endif
-- 
2.54.0

