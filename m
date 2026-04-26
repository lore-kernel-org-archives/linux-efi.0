Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99993344DAA
	for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777204978; cv=none; b=DHGuydKUxgPeE5946HKKqgV71I82K5DwtA6lDjnocs5CK/wiYwHnYv4+nbuoUdsKLemueM7qb7QOABXXfhmEMesDCHh3CbUba7ekhl4DeYQc4Es4SvRCJFqOSydGRHbFOeDPAp2AjG4hb7I2R2UEXoM6zlYy14P0BEFXIdLDjmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777204978; c=relaxed/simple;
	bh=qQCPWEhONCN/TKigEaYuGrNcB33stTCwU1/MF1UQ6tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5LNWc4DgUv68Iyb75oi9dt6G04RMMvSQhZHnfC2jp3i+4PuiAsT5+pxjpHqgdC6nYq400+VHjOG28nj6+1yLs4Jg/i1EcljCvBb7zK77ShzxMzsvmuy8U1U12EbzOVIcz0f26LZV1Ygvmyio3K7WNp7HhaeKXtiufrWPiNQPXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=WOKiuyl3; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="WOKiuyl3"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b23fcf90b2so88729955ad.3
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 05:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777204976; x=1777809776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YymJ79SCPZTf+NPdeESDccb+VxFojDPK0l67eRMH4Fg=;
        b=WOKiuyl3GFRj8GkTYGKAnR40iMv81zlM2f+aDKgveIVxmsBbyxX9fWV6cLKzuBZ55T
         b9sV3nORqTfkdK78mslxW9bKm628nCO9YJxLF5H1EIuKejAOzq/tUI9Gum5G5exaTfnG
         wzFjVQ8HRSFjHtu335ki+KtieKPr+W1nwJrzI5iUK4lR/P2eIonL7raPpOcCjR80oSKz
         /MrLmklscBShP2k6YmB5Q186ImeTLDe8xyOuuDik3hmReyUqMQv5nsrLFxqMCqtWwUY0
         2EEkQBjmMpB/l9tmJ5Pt/q+ub7wiKJoSi36onXIVDPYdtFh9Cr/QyJgCtwb6FXn0y0FI
         YOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777204976; x=1777809776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YymJ79SCPZTf+NPdeESDccb+VxFojDPK0l67eRMH4Fg=;
        b=dUHMbSY/EDDLMNaqigx09DZJsVQJskBF1vSjuhPrMg8Fo4N7bvEdxY0hBD/RrF7r3j
         V4W+aojOYiFVDMnuBQGF4TNfIhK0Dao5yUNfx7Eb2egcuJ6wn7ORnudF4nGJP8G5Rm7t
         3ndpe7qunRbwJZm1lbWej72J0FuDr00wNsNS/UmFvmsjMD6xGvJYs4wl6UzLzJLUNA2t
         imdLXVn5yfIFI05rApg3m0SO7K+igkNwLKUXAidT5TGI0Bxm9kswv/OjSVuJl6wUwJsb
         JeTIoXr4xHi4TxEyxOL8bCacQslQ5n2i7sSzz7D8lf13+bDpxgURe6Tfma29gZZRjvdh
         aCxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9K1Qez8H4IVT/Msa8Az8M6/DLwppwqmlWi3oZahVLyPP8C25sPA2xTAXOU0nUCra2NRoTiE/19QcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI/UJK7ORkuM34WRiG9p34KE1NXw5/rIkSCnL86y3NtH+iBl3V
	Dkfjad6xqUjionz63iqtAchUrkkdaAyF4ZYmxTHN3kFjjs3QPTsetgNJUvkgTglUQcE=
X-Gm-Gg: AeBDiesCAKj89V77ef+C1ntQEsT9dsgpsgwUR+6fMEPRQPxM9sHyLQHVX6fmJZzdWTs
	7GcUKzY7S7JRSqHAgOBxIvusArSRq1W8Sm8/Mf3AkboxIEi+faBK0ik04GKdGNF6XdT+Pz9+PWu
	TiweRAeZDvBW1c5FZfsT8bz4VDem5ew/XshmvZbSUDImy6cacOKwFgCzH/yhhhCGqZZ5kvlh8PB
	VVQlUKIB5rMRZEHyZJvkGt/PTqAfVrS4GwK7S8ECgGWk78vfXc+l6E539+7eyweZyTxawUxnI35
	ubChIdGaxQYq8DonCzNzUB3dFZOY2YgQsQgxGkFa4BE7ygtL3b6ufhuo8s1jNmJIethXcECri4D
	JZrVmNKr2wXsVeDXNW+xCxMQbysom3Imh+SAwYNZk509KAb/rjmTH8SVQI/ddXO4zd6i1ecPCB/
	Qaa4NelnFPhkuIKFVk+iVJq8Ku/esseA==
X-Received: by 2002:a17:902:d58e:b0:2b2:5c31:24bf with SMTP id d9443c01a7336-2b5f9f1b8d7mr389958585ad.19.1777204975949;
        Sun, 26 Apr 2026 05:02:55 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3c:3085:4d80:3614:2212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab297c8sm263413965ad.67.2026.04.26.05.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 05:02:55 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [RFC PATCH 2/3] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Sun, 26 Apr 2026 20:02:30 +0800
Message-ID: <20260426120231.532644-3-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260426120231.532644-1-r@hev.cc>
References: <20260426120231.532644-1-r@hev.cc>
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
 drivers/firmware/efi/libstub/loongarch.c | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

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
index 9825f5218137..80ba7d69e1b3 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -38,6 +38,21 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
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
+		random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
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

