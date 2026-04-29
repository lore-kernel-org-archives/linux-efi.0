Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987463822BE
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439643; cv=none; b=R4dOFAmdV6rbvdEHmi/aTnCrmw9je0Lvw5J/37h87Uv5qaI1MVhmjwcV8XI3ovnitMnkE9j6bypuVplJz5UV8+MvNtnYJ1oSw8jFcsoyvCLV/5aEB3ZEayL/rM6WRk/ap9pHGTwJJ9o6Bse85k2uH1lzVpNRYYzUy3EHg05AWvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439643; c=relaxed/simple;
	bh=ZtZZjU14tH4CI7Qi3EwJbsIUSfhgGfNFvjX3BbzBTUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJHTRn80MmVTUXS0siUOVQZ1u2oQG8quIoLCB8oe+vK3DDMOhOoGDwaOc2PkG8AdRv+CZsv3jb5VlqFoadImavkyaVzC5jeQ+9yLafuo3wLiYMHlxNEah8Rh21F5mRRqsMSQSAW7R0Ot2jDY+9mgVUwI+OFHNoxtqe3gotE+MnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=Y97wC5uI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="Y97wC5uI"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b2429f98d0so72346145ad.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 22:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777439642; x=1778044442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c434K46vhUUFgUVT8fa10pxpFGP8ckGFIv5A6TmNO0w=;
        b=Y97wC5uIhmG5oCBhUhz428YGmU/XTcGeeYgcS0RHzkkSNIYX125fCaSL5VZUxUJUoJ
         WFBNLI0sTVLA0klBWOCjFnj6GoOJ5a/frLxDykPiHZFDOKkxRGNG3M2773241uExoNqp
         e853KCPO/cDEErtvxoqIK+rRDRk5vW4LY0iA0P9I712Hb7vomdXirIbUPPkq7m9G+MLR
         S+9Yxiddw0GjPWIxJH2xhzOD6Kascb1RtR5LjgLF9caTjgwZdvihlAbGM+5vPH7wy6J6
         t+dnxOK1VHBJVKnYfErlVr8wo/BPs67lGZ+jMwkjLikA/ItT8Gtnf2sM4xNMY03E59yj
         tx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777439642; x=1778044442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c434K46vhUUFgUVT8fa10pxpFGP8ckGFIv5A6TmNO0w=;
        b=hTVgBONwN2jup+97G4oyVEJoWrzzxhazDxqxtuidts6Yz0mbEzxH7QlFW0tSyA2TFD
         v5mzz/HV2d6pbhzSK/4OYxn+CphY5N4T3JZ5z/z5rq9QOP7qlyI5nx1LAMcHtLSmB2nO
         pTA30wANzjJtGq7B42G4LiDRC7wOS4Coi6YVTJnNseTjlVQAdaDjHsE/uDbvsdZ52RJE
         jsk8t/qa6mxIisCha3/umx46TLECFDTyq4xKzNQ8jCnBnZ74LZ43ZliCY661get4TsBE
         BsA2yR3yLKdUcrcSGwq0hOmW0ZWU5Fpa0+zm8Lt2+U2qipl5RQTHikYUNpj8iEfWggni
         rOlg==
X-Forwarded-Encrypted: i=1; AFNElJ+8c8JXvK2eujSMV+RhPvl4ANKw4AGIhmwe4vjW02ORHOag/5/wVYkpIyxx1eFfWOetXHAfQ5NEffo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Ne46CEnLDUEn31fyIwG52YHmSsv9a2QE5IwEBXvfNFeElkFM
	9Xgw4se9cJ6oJ/mFJT39WfacsJemU4GW7Q6uGGsKegF/nTjyvhsvFA6sH/VjTsMUyaw=
X-Gm-Gg: AeBDievVYbHw9ALHSKvrzjDzSEYn8clcwFrl6C1SsWw6URMTgzNOZft7G+vABRohswx
	F/DIJRrQniJuKaT11d9SETDrfQATCWy/Q1r1if7n98FmzZHsKYoFY26Dw9JdHgm7RLHaPNCoEHY
	U0te4bCeEnzlNdcRZoERCXjvh5VuTkGD6Mry28I8cW+EaTlcVPyRRgZWqTwa7q2aBE3niHbybqs
	ldvrrfyl6Q1fSsTVr3f4+JbgyT39wqN4TbP8mwQP7BuwTQWRV2yBgp5IjvTYH9TUS+SJ3WxZynl
	xXQO6j1LLTnWnbAzMM24/KpJXVCnuoxLkpt72aYbVlgckZnGdcOrcXahwsHgWCAS5f4GT8n8F4o
	w8yedbkxBzXdVwoReruy2D/i6jCBqszdzq3rX2bktHprGMx2HAT2LGh/e7QnnUJP5mr3RDCkj1X
	3eZIJMXkRi9CArFiwf9ZVvnZpleaAA
X-Received: by 2002:a17:902:d591:b0:2b4:460e:6fa8 with SMTP id d9443c01a7336-2b97c4dd4b6mr55225105ad.34.1777439641576;
        Tue, 28 Apr 2026 22:14:01 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988787360sm8846935ad.20.2026.04.28.22.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 22:14:01 -0700 (PDT)
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
Subject: [PATCH v3 1/3] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Wed, 29 Apr 2026 13:13:16 +0800
Message-ID: <20260429051318.1581350-2-r@hev.cc>
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

Introduce efi_get_kimg_kaslr_address() to compute the preferred
kernel image address dynamically when CONFIG_RANDOMIZE_BASE is
enabled. The function derives a random offset using EFI-provided
randomness combined with the timer value, and constrains it within
CONFIG_RANDOMIZE_BASE_MAX_OFFSET.

Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the
EFI stub can select a randomized load address when KASLR is active,
while preserving the original base address behavior when KASLR is
disabled or nokaslr is specified.

Signed-off-by: WANG Rui <r@hev.cc>
---
 arch/loongarch/include/asm/efi.h         |  4 +++-
 drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/asm/efi.h
index eddc8e79b3fa..f831320efd41 100644
--- a/arch/loongarch/include/asm/efi.h
+++ b/arch/loongarch/include/asm/efi.h
@@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(void)
 	return SZ_2M;
 }
 
-#define EFI_KIMG_PREFERRED_ADDRESS	PHYSADDR(VMLINUX_LOAD_ADDRESS)
+unsigned long efi_get_kimg_kaslr_address(void);
+
+#define EFI_KIMG_PREFERRED_ADDRESS	efi_get_kimg_kaslr_address()
 
 #endif /* _ASM_LOONGARCH_EFI_H */
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 9825f5218137..51997a0e83bd 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
 	return EFI_SUCCESS;
 }
 
+unsigned long efi_get_kimg_kaslr_address(void)
+{
+	unsigned int random_offset = 0;
+
+#ifdef CONFIG_RANDOMIZE_BASE
+	if (!efi_nokaslr) {
+		efi_get_random_bytes(sizeof(random_offset), (u8 *)&random_offset);
+		random_offset ^= (random_get_entropy() << 16);
+		random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
+		random_offset = ALIGN(random_offset + SZ_64K, SZ_64K);
+	}
+#endif
+
+	return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
+}
+
 unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
 		efi_loaded_image_t *image)
 {
-- 
2.54.0

