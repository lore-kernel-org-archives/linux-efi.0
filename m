Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1E3822BE
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439649; cv=none; b=r2/KNhA1V84UO40nY+OlscNx8pR/bekGsfa7lD5Es1I3pNXMnocSQ52EyUE6JeYTb2sTPv1gcGAKpWb+pQvUSalI5O1qan6eL3Gc6VeVp1W/QbYPx0v9bEhd/J1tHwMMnnruMeLLTdxhGY8Kpbm0LkG5xbGij+1s+j+4krNWGaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439649; c=relaxed/simple;
	bh=dItIsPbk/j3Cl3D6WqOm0NerVIalkv5nzvBY3Zn3xvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HteBbV8KgBjAcA+Q1tb9SOYwycs1q7DhR2Y3aVXkshpnT2lIsdfhS5bbSM/s0+O/KgUopfqjWj/Atg0bRFThYvzx/+IpTK8oJaCActn8+DyhEvdfAY1Whd7QCFQSbfv7NTIDAEdTPHEuaZ8aJznQeI88yXnzdx6vdL+oU5bA438=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=RaP71bfk; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="RaP71bfk"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ab077e3f32so53103265ad.3
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 22:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777439647; x=1778044447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99tLjWOK/mLpAv9uxA8Gv2R+vi67znNvjWmjayf7030=;
        b=RaP71bfkiykOFpSz7etZdREtpyULq/YII+YILILuAhshL2M6GOcXWXdrogLgFm1JFL
         K1uP0Al4udjorWRiAVLOi82M4d0LzqM2Gy1BAw2D+3qq1p8bzddRdC7hyZkn5wLUUNRm
         16ccIEYshP15EJg7b29StaAAOuCA95z8pkcqwKKUgRmWRvTno9nKLDEl8Na77tdhzCLY
         YYYOi7osZb74FB0sjxCebDD1UyiJBuN9ObGCuQaefoRywJG/QTKY3qsVROrJNi/vokRo
         5LGxP1KQatZeVvJBCS+O7VXKbQWYhOnHinnwn9fmAL0NeXxAAsLMmrOxsdKMTDBhXXz9
         EqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777439647; x=1778044447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=99tLjWOK/mLpAv9uxA8Gv2R+vi67znNvjWmjayf7030=;
        b=Zj3K1KhDFEgb6LZHkqR2Jftl52dnFPVTyRQxFA/e306Yl5agS2SMQft6jKygDw2r1w
         JtyRygDGdlQFhB0zq5Wyb9mVMbNjQD+QZNeppQnGWXD+PW7pLFgGNn9hVuw280uVjmJZ
         pDq2zdX7YLVuSYpues2WG10iAL3DGZikHy3aAB1ZK+s6jJBzbXN52eN/TogfkUkgwGez
         bsBt4KTUV/uQIoq0UVj+IqUEct9ikHoLi6DD3vJygYQ2LfgW3iudGwdrTAjB3j3eNoEh
         wK1r6dirdAq6OtSgIrC+qST6XNeK2OWU8brteMlzooQ5OXZW/SedIp5aagSXfIckiqQH
         WM9A==
X-Forwarded-Encrypted: i=1; AFNElJ+6BakBLLNkScTqJC5BMMkQ5/Kk3DjUBieqakIEFn+J+7IMxGgmdBC74buE8oXDoUp5U9XyU9HkzHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTrhiHqUi4lACI3gnDuTymXCfS2Gnocu31nq3YwS9LRl8WgTYZ
	FwIRvd5SDA9DLIoL/BeeGD9BRbt4UTGbpBXh/KX2np98aZeV+rnf+vf6D6eAqbVWAsQzOaVsnr4
	JWYe6Jyc=
X-Gm-Gg: AeBDieuSRqJKxYuZQdmZAG7toOB6tCyQVN6tNUFKl6jACgPEbF/LN1Bg/DbOUEzZbYR
	BH0VAem7SFDMgYtLvAyx9PcAoBOoxn7GTMNUSqkhqug//p5CZgwHXlNG0zxgA3fEukmCWwncTAU
	qEZw+ktMLvZMxoxU9mFN5y6+QLjN9Z1EKjryDsilFHWNjP+XO7s2QL7rHGSxm9Hg6BVpkbXals3
	ulnnobAHvRzo+3jMJfVX6pNFv+3WiiTHjDkAuJaT3m0kP3k0Z7Tru6KgXHtcQjhU5kPc6Ccz2Bp
	VNLonUinBQGLN0Yg6Zibe711gTA652aeBENPus+9fDaaOlJS/eAj7eeYvws/AVTbQJxk8XwoCFd
	yjJHQBGSr/wm5AwTxCzTXsBercRIzYrSEZqQV8QhWl/E24YRCKikeeeWUPIvWLvpvAC8OnicB0d
	0xTZmMCKFbnSBhPpEQZJy97jYTL3xV
X-Received: by 2002:a17:902:f907:b0:2b2:42b1:adac with SMTP id d9443c01a7336-2b97c412257mr40027755ad.3.1777439647157;
        Tue, 28 Apr 2026 22:14:07 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988787360sm8846935ad.20.2026.04.28.22.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 22:14:06 -0700 (PDT)
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
Subject: [PATCH v3 3/3] LoongArch: Avoid initrd overlap during kernel relocation
Date: Wed, 29 Apr 2026 13:13:18 +0800
Message-ID: <20260429051318.1581350-4-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260429051318.1581350-1-r@hev.cc>
References: <20260429051318.1581350-1-r@hev.cc>
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

Signed-off-by: WANG Rui <r@hev.cc>
---
 arch/loongarch/kernel/relocate.c | 45 ++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index c36604a81d08..c303c0be8f06 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -214,14 +214,59 @@ static inline void __init *determine_relocation_address(void)
 	return RELOCATED_KASLR(destination);
 }
 
+static unsigned long __init try_get_initrd(unsigned long *size)
+{
+	unsigned long start = 0;
+	unsigned int key_length;
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
 
+	initrd_start = try_get_initrd(&initrd_size);
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

