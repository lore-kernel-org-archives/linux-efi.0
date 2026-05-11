Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FD93DA5D3
	for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496401; cv=none; b=OxydRsr7iY8pwrbl6Y7egUk3x6UU6O/FIZ5w9q2bm/gun+Tpw1M70OtSC7bzbOaETVJQqAfcy2kbC/QLL8CXAHaxTdfevmb62zxlOb1C8qtutKO0hwP0abwBt3E8xsbTnHM/ckFHrJi5gfabLMkp+E8NqUwXU3BgDQ5htuCzfis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496401; c=relaxed/simple;
	bh=lYLyGpAeXXin55IC09xdRLP7QiJRBHgecdSl2/SXufI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSHTzL91jnwdjPGBf1t3stgwZScRTyf3PvnL33H0tZlLDP9Hk5N7IAaX2UE2U6/m0XfYgj2AMWKqkCqGtYKpI+Dx1eZGMEHB+28mxQUCIM1Wd3TBTin4FZ6TkqGBzbT7mt2m9Gw3MxbXfnOOELk6FDOv6M2UHheB4k58QdGMBmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=JdnnpLTF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="JdnnpLTF"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-837dfccd950so1886216b3a.0
        for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 03:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1778496400; x=1779101200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hS+655jFZPiMsN9BL5hVT9EfmcJYrhGbTVgUqy03Zy8=;
        b=JdnnpLTFmErECkAYD8Ze47ZnQ8P6pw8aUaL9eE95yJTxEjHuDD5rj7S6Sobo9Cgbkg
         i6AXem/JIn57LUao5dNURUKoPQSdc69NsqI4exNBClAjSF96RAlRLXj7pc5YR6y5L5XR
         TtTKabEG8WdxP3Zg8aaXL9Z8gNx5L7QCwHM+0r4kGjj+7S7wewgy7Y1FAOmBnS2s4xdq
         Zzu6iSD0hYx57vUDWHLVf1YF1KqoFSbHGtl+zVnnPVtPROzrODa+7gL8f28OywNm9veJ
         UPNlbEjaAaldi9iOLyo+Ct8Nj/CvHH3c1RahtnkQAJrcM6tzsSINWvF8dPazYiVhwOSD
         Tkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496400; x=1779101200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hS+655jFZPiMsN9BL5hVT9EfmcJYrhGbTVgUqy03Zy8=;
        b=cxSwrpQWUYzgx8xnds5fcnt+RaOSziSQBymgtPtCDujddIspGf/HDk9Htg6f+Wrlqh
         XbhWWkzITh0w/Hkwqr+61ETdZPZk08yhGKSnBKkCBTPIc67A2Otrmny6rOiivacK2xAt
         0EAzzECKq0bDiK8B2M+Yd42h3BuPH+QoJI0d9UHyM6+DeW0QY4o4fbGBYW7iEYsZew1P
         ry/b2NXS9GpU/DeoPzrFoggrj4rzfipWvieQuc8EUR7VmusBWnn4CenQ6zEdKbXdytVK
         aEcKzLMxCI0j7Xl09Z8E2HCNbULWbW2cDLJ1rmCoscvXdlki8V+3TxLUlgMzBVGI7d4B
         8pSg==
X-Forwarded-Encrypted: i=1; AFNElJ9QEOGZuxtGorJG0G4i9W/JGA6NPVlnPPLkDKFb6JaiSHuXj47GjxmBGANEnLv2LEbpZ7HQeYmw2Fs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3RWR0nwXcGToKqPruRZW290ee/Uftr7q128p3RfwnXvpXdlbc
	whoxcio7eprGm34fYkxvNSeRlN/2rIlpltOTux9U9DdfG2OvvtCF3aNh8sWK2yRkuUo=
X-Gm-Gg: Acq92OFr5FepsX/qO5uCsfc1yL8F2zim3lewFxJFBU2yZTVyZTd6KThp50QtNf+70od
	7EcJf04s6dcLF2fp2QYW636OuIZUbT27EFThCIZMYu/k+f7rthImYL0pBEWKUrMGWuPG5tHFUxN
	h3uXb4C9MMZktYeT0XaAGkq5lQwtjl7E9KX769bwiUefy+k7Vzh3xECKIYnIRYyL0GTkX1vTN+m
	YQMT+0slT5bHux4cXeG5Fx68GoTKQDUKAtUeYTzrf7ubi52d0ZBxO/BCJwpwP6MBy1Yt4EPrOa9
	fZyQ74xlFNkrpLd3H2wn+BuT1h5Gibco6Wq1KAtgSGxB+g4m3whvYNpoCF58sLI0G2kBe2ulths
	iRryzFt6aUZJLUutuI4K1dLQe6gIxq3tkJL0bObgXp7Y/DbCNogT1pbvkK6rgsPcr3kdTR7Pzjk
	9RkDlmCvS83AQ3F+bRshY=
X-Received: by 2002:a05:6a00:368f:b0:82f:6e7:1527 with SMTP id d2e1a72fcca58-83a5d09a84bmr23434499b3a.23.1778496399633;
        Mon, 11 May 2026 03:46:39 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3f:344e:4435:2c77:3920])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c861esm24927599b3a.30.2026.05.11.03.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 03:46:39 -0700 (PDT)
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
Subject: [PATCH v5 1/3] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Mon, 11 May 2026 18:45:53 +0800
Message-ID: <20260511104555.196270-2-r@hev.cc>
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

Introduce efi_get_kimg_kaslr_address() helper to compute the preferred
kernel image load address dynamically when CONFIG_RANDOMIZE_BASE is
enabled. The function derives a random offset by using the EFI-provided
randomness combined with the timer tick value, and constrains it within
CONFIG_RANDOMIZE_BASE_MAX_OFFSET.

Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the EFI
stub can select a randomized load address when KASLR is active, while
preserving the original base address behavior when KASLR is disabled or
"nokaslr" is specified.

Note: LoongArch can't KASLR for hibernation, so set efi_nokaslr to true
if "resume=<devname>" is explicitly specified in cmdline.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Co-authored-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: WANG Rui <r@hev.cc>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/loongarch/include/asm/efi.h               |  4 +++-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  4 ++++
 drivers/firmware/efi/libstub/loongarch.c       | 16 ++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/asm/efi.h
index eddc8e79b3fa..1ad764b18c3e 100644
--- a/arch/loongarch/include/asm/efi.h
+++ b/arch/loongarch/include/asm/efi.h
@@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(void)
 	return SZ_2M;
 }
 
-#define EFI_KIMG_PREFERRED_ADDRESS	PHYSADDR(VMLINUX_LOAD_ADDRESS)
+unsigned long efi_get_kimg_kaslr_address(void);
+
+#define EFI_KIMG_PREFERRED_ADDRESS efi_get_kimg_kaslr_address()
 
 #endif /* _ASM_LOONGARCH_EFI_H */
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 7aa2f9ad2935..f27f2e1f0019 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -79,6 +79,10 @@ efi_status_t efi_parse_options(char const *cmdline)
 			efi_noinitrd = true;
 		} else if (IS_ENABLED(CONFIG_X86_64) && !strcmp(param, "no5lvl")) {
 			efi_no5lvl = true;
+		} else if (IS_ENABLED(CONFIG_LOONGARCH) &&
+			   IS_ENABLED(CONFIG_HIBERNATION) &&
+			   !strcmp(param, "resume") && val) {
+			efi_nokaslr = true; /* LoongArch can't KASLR for hibernation */
 		} else if (IS_ENABLED(CONFIG_ARCH_HAS_MEM_ENCRYPT) &&
 			   !strcmp(param, "mem_encrypt") && val) {
 			if (parse_option_str(val, "on"))
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index f7938d5c196a..2b0c87dc9908 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -23,6 +23,22 @@ void efi_cache_sync_image(unsigned long image_base, unsigned long alloc_size)
 	asm volatile ("ibar 0" ::: "memory");
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
 struct exit_boot_struct {
 	efi_memory_desc_t	*runtime_map;
 	int			runtime_entry_count;
-- 
2.54.0

