Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977D03F65F8
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 12:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464221; cv=none; b=gugBumnjPvcjnGVeH7mmMKJ8WL+c3wxEJ8Csno4It4fqa64u9gksQ5uXqJFKpe2lTo7bfaipGOQq/YHcJsI243XLZ3D5K1HibAlm4stsqS020nxH3WUgIFRnAUpBn9CgQtXqrKo27+hJa1Hlag8NwOOYgCThYYKVK1KW7IUryGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464221; c=relaxed/simple;
	bh=B2X2RPQv8ZrL3d489WU0ngl6i9tgLyFWZKtm0iXeYVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL2blLls73w3CyKfcIYj1JYHR6XkTpOiWojFbNEyUSvpW1RE6E7tSBLmcuMkOcixYvq47XfF5i/+9HqElJL5p6rtf1vQR5rIi7mtj0Npv+5e3jcDet5kYlV/NRPK7aLMQ08jVURo60ANmQdLSksnsHdQ92j/ieMoc20DE/B5EBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=ab7Dr4zI; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="ab7Dr4zI"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82735a41920so5027196b3a.2
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777464220; x=1778069020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yj3F3gFjpGG2RrkSlaKuTLLorI2CDb5ydvcn8Xu7mtk=;
        b=ab7Dr4zIgShNyPOuYbhVbqaFAzUbKjUQvXQAQa0qejmFK9ETJqPpU/SFQMU31HILz8
         lbcQ+ViPSDlPk54TbJquyekCkWNDciuH7KW9Wqu3lGSMo3W/XOwGxKlOazrrXS9paaT1
         x/5GgFwA08i0awu5olozGB9lCtubdKCxGkgW7p+NSNHW2E7Ic3V0rYwbXYz5GaxJJ7jL
         nEIOolXFVjLscj0kUD5g1lVYPRCf0BPifuvYpLgn4FOvtoHg9plpcOct6Zwcy6y90GVP
         aGjCY3UbYnd2AJBAT1FG9cyzPTaeXb/uDpkfi/JSL7P78YyrGs3I2Wv/gnD0oSjl0lOM
         IRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777464220; x=1778069020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yj3F3gFjpGG2RrkSlaKuTLLorI2CDb5ydvcn8Xu7mtk=;
        b=DgcVAz3OFDrGHjqGD89esTmiLXVaP89u+pnUPo/5Gjafxnu3SaEru+5ALPj8SUAUCI
         iBG9n34cgQNuzEL0VFMxQWHb2t6u2ZUMbnYLKSku40zKcx6fKJpR/HjSaXp68i61Z554
         wIKVKK5YW/9egBsWwJg2eANMuyEB+1Y86J3qBDE61yGmOlMBo4WE0p4yEzcgC+ko9Iw3
         dYNms2DLA3tysTwh7AdMxbyNgmcZK+qBtKxzu3Yrtl3F870MS8t8nzvGXXq4SaydDwbE
         3c3QHVnATamhjCrCPt9Si+oGHhFo4V3d5DmhU0LK2wSRgaD/ZM9eJkIgSQyqe1dLjEpi
         2EcQ==
X-Forwarded-Encrypted: i=1; AFNElJ9yPYsgVjJmKbopdNUas0+8thgN2Kx36XsFX/IotQ+jDN/SpIwm+xag13k8/j7WkkuU+MTdGsWkxQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQfve9g0a3G53bK0OoYnPIs+RP/ctIEqYT9PC8xF4IgySS1hVn
	/68d5pLRPOWF2X5QLp9nnlSqmEw562uldCtELnnaDaPs1oSyrPPWYvNWGE/Cvw4ebtk=
X-Gm-Gg: AeBDieseY3RMDmZ3mm7VWOl8DaRfCsdy7e5SQpVsTPAFIzTiGNS1L/5Nzizk2XwFPhq
	vChu6ZoUaGgZi09wqVDkQKv+I6jrJReowNkPShlNu+H9n/XpXtn03b2oBadZo9w2T0YZqOxstyu
	4J52yPug2Z5S1wdwJRzljM8Ip8m7bRLvhiUm/mHDNguSHZzlH5xM/5+Z0W7i8bRLvEqB/V4kEW/
	h6GPvyD1qYFJqum7PBANKP8iY5dCjkx6nHpufvisWtbifOwwqWEdhW6FVJ0ZBfk8afRa2y9rqHO
	4La5sQS2YKk5Vw4wXVVBDw05oVORKlgv6i5rwQKZWJ59nMCdKXxOpVQbQ7+Ejq5XhXh9qd9zeXn
	o49fqOUjpx6mJ221eaDyqDCmIvtd7YsESx89d8QlRT1TIlW8ZFhmpJkwlAlbFG/VQV9H7CPdpz9
	trlSIo44uekt9mCjvbrQ==
X-Received: by 2002:a05:6a00:408d:b0:829:8942:2c93 with SMTP id d2e1a72fcca58-834ea5688acmr3462864b3a.9.1777464219832;
        Wed, 29 Apr 2026 05:03:39 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5efaaasm2016493b3a.27.2026.04.29.05.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:03:39 -0700 (PDT)
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
Subject: [PATCH v4 1/3] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Wed, 29 Apr 2026 20:02:58 +0800
Message-ID: <20260429120300.1786210-2-r@hev.cc>
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

Introduce efi_get_kimg_kaslr_address() to compute the preferred
kernel image address dynamically when CONFIG_RANDOMIZE_BASE is
enabled. The function derives a random offset using EFI-provided
randomness combined with the timer value, and constrains it within
CONFIG_RANDOMIZE_BASE_MAX_OFFSET.

Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the
EFI stub can select a randomized load address when KASLR is active,
while preserving the original base address behavior when KASLR is
disabled or nokaslr is specified.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
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

