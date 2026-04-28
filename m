Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1F833F5B4
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 04:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777348951; cv=none; b=fzUAMRVuHpxL75jJMqKAOsod4RkzaLDDPGRfvxYITK2zz67qJWOrj6Izb2+tJato/kEMUtF/INs4IMehnstMnsHwbo083vckTeTdLMrMEwJi5EZygG5wb2gwrMpQg4bTHys3lcNz6TxWxSyWj+EBBNL8seVzDMFLQuFAUdnnaOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777348951; c=relaxed/simple;
	bh=BBDy81e7f+H5HTwVt9xBxcupTBb51CUnDJ6rTPApRes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkLC1VrNeSAgqK8YampUVC9L5q+993Be+gBBdNDpsTlCWXqY/X4Ud+seS0bjb1V2UQufvwt4JYP73TFJFwK+kfaWHTQPjoBxvf+3/eJQiSDRu3OtXikyz5NDHSDM75gnXw7KrPRjqaPvB1iSTcvblx809x1dFo8hRwydy9JVE+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=BH2YVVrp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="BH2YVVrp"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b24fdac394so104295975ad.3
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 21:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777348950; x=1777953750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+xcb2ORv56/m7G9kcRuXp28eD7jaH11XygDbCbx8JY=;
        b=BH2YVVrpEXR3v8Mazm3oOXPjq0L2ORzpZeVX8/E6hLlUZ0SR00N3b7FncH6YsbLSbx
         dnEBvHHkaNAUIUwSqzGYjlSrD32ZAygWSD0pIy5uj0UuWQ+z/gCm+e+ux/nI/SRfZpsK
         G6oUxMc/6V2/C/SQaodMNG6NWHdP05P3SHfH8WMlbUXGeW7fbppSb0/GDcBuSDDAvKh+
         2b56B9xdLDUXXUN0iiceH6QE/8GRWv8U6uGVM3+qwNORnCVsfH4bGUQx103Tq8wanvjB
         70eudLLlbw1sGMv7NqRtx9BW8dH4NdQvrqYKEPbAcC00iwJTc1u+D265q6vhIgMrDz/g
         DHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777348950; x=1777953750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6+xcb2ORv56/m7G9kcRuXp28eD7jaH11XygDbCbx8JY=;
        b=hORQb/RcHGoUob/qi0Rhwhfn/gEq2kIQXxQ4TKNv0QL/pL1EqXwn0hWqONbgN4U+Wh
         LVOopGXewsYJFVclIHJVPYtEsVWrO4ZqsucBrOXVT6totFnb8XqGrY3U9P6roiQvYQes
         eXLHRNYfgUcwXFnMeL7TrjrT6vU+KhOQkL5ltQSOG7Dp+SyLW7ki7yO1dkk2JVBZ6+I+
         s4Ld7CEtNDW05/mqZmAYz5j1yIBq9pQnoxdZOC2AVd8s60JjE3DTYf50z7oviJGEj3sg
         qCp+JIMXxXkj6YGBdqrzRIUnmVhzKWpCTarl5JYkVNMTWBkZTdTV9Nk/E7xH519WEZRI
         LHbA==
X-Forwarded-Encrypted: i=1; AFNElJ/HiNUTKk+ikj/FYYbelVX0q3NPqT/euc4b/fPp/Vvjfb9NrV/X20NiKaJNIxFmgKFXajnRFI/5q7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTU2xZI1BUsQT6f+mzSPfLetmr6RO82bbHPJjDwzn/Zi1846Lg
	7ttsPLPn6KHvR3i4/NBIGgRiSGTwmIHbwAsz4hUcRBNfxfVRsUlQ8LsYwvou3orHYqQ=
X-Gm-Gg: AeBDievx1Q/I3bXLJ4sLxVnT6p9Qlb7tL74OiOeklVP6Z4brt8W4M3pQI+WpMqH6lLP
	nD93GGmkux85lpZ1MNrA0xC45Vdeh+nLse4/xwiq0uU48BKSnO5IqhkbX8snIJvUCtyngZqzQ2j
	h6/lCJAcOANi0n9/zmJ0kjwA4IUcOnYjmzKeH9sQehOxMkskIWa+hguIAC1VCtxDz4BQ8cJXC2Q
	pvg5tIyxjjxYOtp4dbhWJRALthexX6gTB6if6B7GrYYHnmvG1SeA3i2TLCcm3JaNzH0E1cBwAei
	XA3m1fOw8vJMbB/WZ4HtkvscDAfSkCvKIUr2cNckzzwmaduCZwJhutEL1MET13Q9oHqoYVz7UsD
	BNDO/ZiO5BKaTNEzXkUnNRs8gUblDP2fJTiRyzTTvARbHuXzLEaXLQZ28ce3mtzwJuf1j8TyqS6
	Xp5cq0tenQijpzQ6ORsQ==
X-Received: by 2002:a17:903:1aa4:b0:2b9:7051:2c18 with SMTP id d9443c01a7336-2b97c039e5fmr13515095ad.0.1777348949793;
        Mon, 27 Apr 2026 21:02:29 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac8cd29sm10131365ad.61.2026.04.27.21.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 21:02:29 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Lisa Robinson <lisa@bytefly.space>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v2 1/2] efi/loongarch: Randomize kernel preferred address for KASLR
Date: Tue, 28 Apr 2026 12:01:58 +0800
Message-ID: <20260428040159.1065822-2-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428040159.1065822-1-r@hev.cc>
References: <20260428040159.1065822-1-r@hev.cc>
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
index 9825f5218137..c44be5d3dc04 100644
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

