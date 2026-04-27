Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1F03B5832
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286865; cv=none; b=XIuO+GmZ2Nmpfl0YCNC0bArlZu4HGp5mJQpoU7WUy6Ag2ODn8P8VG1zjpMXGdgIbt7Aqxt0cckKRMcX7luZzXSnrK8c4jf9FMAtYRUW7zwfPmsGM6sEtFY8OZRzcRhJ3NZb102oC0PyJqUbQ6hNGXd6NGz+FX7FcvEvu3lT5J6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286865; c=relaxed/simple;
	bh=MK9MxhznQ/DE9fRBF+ryEug0t7fwbSkm35OOxaXAc7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0AkSH4uSgjxpTRMTOve4OmxZgIte5mMHERS3FGUzPQ3VlRwmr8j2g9fSHGc10eWdOCDJCyZ/WIz6mc7p7jl4cNutGTHZtwO3T8HGxN0ILmr6umGanT+DfN3KufQx5MSAjrqOSsLY180cyqU6Yr+mykadCAtu7i9IjWSWPl3qfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=gAMnEAAX; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="gAMnEAAX"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-362e30526f8so1531291a91.3
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777286863; x=1777891663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PIBge1O7GywppeH3FxYzvTz5haKfwUyb1lL4zzJi9B4=;
        b=gAMnEAAX1OdDdpm68rbgotfb5OYSp8JbVpK+mHThmGyCYfq4OalfZiDkzOK6w9vP4h
         15qgyOaVXOiEOg7y6zOyc+9t9kLWZm9PfUDKGXqIHm+Z1cbci7rQuCQUzsZTlYcV76xK
         qtobmJA1IcwYKO+KUwsk95dW6OwAsAJCPKdh+xx8leBYFGaKnLix2numQgYPFRk7aUWP
         M1Qhtb/gLY0irbkS0/UrrLrYuS8NwfRaivATWLdqBC2obDZdmtnEMdM1aICmcLjyiLn2
         OvWx1U7BOVpNyqPIgX7i2DJdx366bGemExOZbhlc+uUB/SD369/EsDfYkgkyUD9ix/AB
         50Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777286863; x=1777891663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PIBge1O7GywppeH3FxYzvTz5haKfwUyb1lL4zzJi9B4=;
        b=O4LR9D6fZ/62Cl0WCYM2NM/xiBq25ej4I48d+kBov6LuLiHVghL/LiPgczrHYFWekt
         lQCVTrOoVTcFQHHDKG74jx7UvmnfQh2BZC87EIEBjwZm6cnTDcx8b66VkTDq3h99Fxo1
         KLQDqZpfz9bFCaQRQ3UgkGRsjNOoKupaUvOuw6ejxWBY9Rg79GqTURPKAhd35Ax5MSPG
         3j+IO7NSfurExzJIMNdoNcSf6HZyOnesj6S41m1NVD5wzt0ISPgtn+qWRocmUFovP1UW
         jzcN81iDN5GyGltHeC3yG9DcYmx3GH9fW4Ej0iUBQ6cBhlAhoMT9Zmc3TdyfzjIglbhW
         pXSA==
X-Forwarded-Encrypted: i=1; AFNElJ8T4w0qthdqyc16dxR4DoCJRQ91NOqLFEtlswfwyM73P+3VOLOtD+4i5meKuu4ujojLtRAU/txyu7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWTebLQ4vdQFOZEdIkesbxJ2l1iJTTeHq7KC1S8JWVig+oOdZc
	KD9joaTVDSHZZLDcLr/ZzWJ3zM3sHmzHWLfdjR4aZ24M8PE7FZHhq7xUzRldHiGDb58=
X-Gm-Gg: AeBDievWtg0x1mb0A+tbPcnpdu2qKJ7aQi/R8QZIZqeAnkkwh5S5rJ4e+UQQA0T3yEe
	QziEC285kpk0HqqUnqUM+lNeZpzHaRd9e0HZhHXXf1f4hTnlQYfRbYx299w0aSJkf+aAyI5LZL5
	VDuzWGvNmS+G/Gh2zmWi7vY/qWYS0/lt7erdm08uZxLqMbL7Y5yC/eD7GcgHXuFdXeu2mIaNckJ
	TfMyNatPG/fPjW23jh3rLs8AvQ0Ei17k+vh/ToJxHUAsL1Ue2n4NLYMfdsLbSGeMyxAO9p23zkc
	eOHycX2OWgDBe8Xy4euZwO5+7zUgY7RBg1UCi7CGe8C4G+qeroUMxPP7F3iAfgPx8ci9PGZR/Fc
	EWjXP2KN9qF5BacGQOv6awtXnUdV0y3sTAkkqB5WGbea7EmsSuGdnHnOYUMHHgwduTsgYPeuYE4
	XOCtzJFNNGHZQ=
X-Received: by 2002:a17:90b:2e46:b0:359:8dfd:64c8 with SMTP id 98e67ed59e1d1-361404a81e0mr41584514a91.24.1777286863074;
        Mon, 27 Apr 2026 03:47:43 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362dde4ccbfsm16227029a91.1.2026.04.27.03.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 03:47:42 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH 2/3] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Mon, 27 Apr 2026 18:47:20 +0800
Message-ID: <20260427104721.47724-3-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427104721.47724-1-r@hev.cc>
References: <20260427104721.47724-1-r@hev.cc>
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
 arch/loongarch/Kconfig                   |  2 +-
 arch/loongarch/include/asm/efi.h         |  4 +++-
 drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 3b042dbb2c41..a5afb70f73d9 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -730,7 +730,7 @@ config RANDOMIZE_BASE
 config RANDOMIZE_BASE_MAX_OFFSET
 	hex "Maximum KASLR offset" if EXPERT
 	depends on RANDOMIZE_BASE
-	range 0x0 0x10000000
+	range 0x20000 0x10000000
 	default "0x01000000"
 	help
 	  When KASLR is active, this provides the maximum offset that will
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
index 9825f5218137..df67ef8c68ab 100644
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
+		random_offset ^= (rdtime_l() << 16);
+		random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - SZ_64K - 1);
+		random_offset = ALIGN(random_offset, SZ_64K) + SZ_64K;
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

