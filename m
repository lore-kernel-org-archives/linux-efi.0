Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27B93DA5AA
	for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 10:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496405; cv=none; b=uQVjqLH/sjoAXmTP/MLpG2ALEd6JOe0S4ZOcoSU3ZvmCWKY1TIT0e5xZ5vHvtNeYqgyqEFbukiN5Ecu9Nn5i3xaBbc6bLvyJxji4MoqLdnfqJ+T9TQoefF5M/rYbjqol5rMVa3TFPY+HaZmrhFTK4QYhFG7LHvN/R8U8akN6fGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496405; c=relaxed/simple;
	bh=M7SzPCM13HJKsqptckY7Oq9QwJZQzoJVaF+FfkouS7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVPUwLFb0es5/Fu2Y6N1uheNCjTEYbiSySLphSFABTbnfi4Aujf+WI7UxTYOegxSCEZc/m/5EPBBioM26/yOQoPZTIgjeiTfA9bueMahUbadV0c0YM+snVEERqmFHHfrVKsSHXVH7tchi0qFT5xPe5UDEMER1ukHeo5jdD8uglc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=Gf6+6qkG; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="Gf6+6qkG"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c80203b9d7bso1586780a12.0
        for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 03:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1778496403; x=1779101203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCD5tvLyAyFU8kzoBKm4CiGZmi4/Go8gChPflbMKPN8=;
        b=Gf6+6qkG+flz3le5dyK0qQCHxbhfiYetKTbgJ3ZvhYoGeZIPJTCa2h5DJ8YxZMybx1
         MJP7irTzujvfIXYOqxH975kjhYz/RVO1AQzp3oHyb07Hhej53OWoQ6CvN4R5qQQuL6kS
         PACfOG/3JPPVj176wEsvipCMQWxwtn7BvNQ+lcttt4w2QYQG3mu8AMvz9hSnH4zu+BEu
         XO44xzMwGZV/UDKXtf1tpzVisBSZssmi+twQEt1K+0jgJapc31y2pGq7ZklcnWhVrE6k
         lTVfiNh+1vsnQuu3PsH12ELTkNhUYilPQP3sCFLSH8mG11g1YHd8IlxsFgm3wKo/QNqB
         h6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496403; x=1779101203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SCD5tvLyAyFU8kzoBKm4CiGZmi4/Go8gChPflbMKPN8=;
        b=kjRItGOOD03UR34hBhvggKSM1TIV5xIxo5k1HMItTT63AV9+e8vJU4wCTY8sI8vrod
         aMGHSBhEC8QltlVQsbzfG4VsJrWvpR8k/4hc/I8dytLfdTBnCsoVsUm2Z22uQvIjb50v
         zXiZMF62HSYj7w6ZOpTUK7JmIV1q6CLIUr/9yv9oNUO8vUk8sok0NR0m8/KHBblG2w0P
         rCwNeJZNaI6w3K6iSpStKcro6O2f/H8yoDemJb4s8Y2EApZB7jVvHTuCVgypUlktc4BS
         kFGH5pYHM+yLesQV1oHxK9nTlMihtAXoR4rLYi9yUrBMFwJx3CBl8+Ds7NzRbzQMgHvg
         /qsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Y90i3vr1S3MgCH7sb3Jh/xd48aakgW1qdro+5o+Ww0rb4TRcCipvTOJyXG7yU0Mj613DwlSpXU/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLu6UMnv0R+4Vtas8TFqfkvrc0iRiKuLrb+XtrFlNwewp1a0mI
	z8/1dH8OUzyJ+bHYi45IO3of/+zB/5+BE+3qwE04Lb9m3idcWeWZtT7+r3kOyQdGWzrlbjOAB7y
	V7eW5kEItIA==
X-Gm-Gg: Acq92OE1MgpdQy9f9ijhQzl2fLCk/f9PAaqJZCTzBKPJZOnvDWT0iyE1sY4QAgJ69ij
	7RrF8RV4c3YFxqhQMFJVs0fKXfYeaT9MR+n3i1z06GiYwI/OQaBHkRvHbYGNkZdgbScPjGI+A68
	ZwjljQXKPYl033piUYZjYeE8KVG1XzjBXWmzimyHLs6O+fEZDYpLQotfzBZSDN/dQbCVvGX7hfl
	OS1qVlF7Mg4t2yaN5KobKeMY2mIk8aLCjDmQB2I3rwkd95ocifgG7d823pRod5l/1JLBK1LgBE7
	yJPBX4ZLtvbUXUerrBdN2o7g0j5tHE9sZcz55WL9NPiy85nsQklRVpEr54GiUPwT9M6+SNFkvtH
	BPZJ+eNabxvwjXyAh4iMvw+616t3arXmAR1gXhQ5vWj2mukXHkBWblCZuem0wKIjwM0QCOJzsS5
	bKaNpaR3hl
X-Received: by 2002:a05:6300:2189:b0:3ab:1680:c5d3 with SMTP id adf61e73a8af0-3ab1680c657mr3024235637.31.1778496402887;
        Mon, 11 May 2026 03:46:42 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3f:344e:4435:2c77:3920])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c861esm24927599b3a.30.2026.05.11.03.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 03:46:42 -0700 (PDT)
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
Subject: [PATCH v5 2/3] LoongArch: Skip relocation-time KASLR if already applied
Date: Mon, 11 May 2026 18:45:54 +0800
Message-ID: <20260511104555.196270-3-r@hev.cc>
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

When the kernel is relocated during early boot (efistub or kexec_file),
a randomized load address may has already been selected and applied. In
this case, performing KASLR again in relocate.c is unnecessary.

Note: strictly-defined KASLR means the kernel's final runtime address
has a random offset from the kernel's load address, which is implemented
in relocate.c; broadly-defined KALSR means the kernel's final runtime
address has a random offset from the kernel's link address (a.k.a.
VMLINUX_LOAD_ADDRESS), which also include the efistlub implementation,
kexec_file implementation and QEMU direct kernel boot. kaslr_disabled()
return true only means strictly-defined KASLR is disabled.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Co-authored-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: WANG Rui <r@hev.cc>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/loongarch/kernel/relocate.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index 16f6a9b39659..0a045964fad5 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -134,11 +134,23 @@ early_param("nokaslr", nokaslr);
 
 #define KASLR_DISABLED_MESSAGE "KASLR is disabled by %s in %s cmdline.\n"
 
+/*
+ * Note: strictly-defined KASLR means the kernel's final runtime address
+ * has a random offset from the kernel's load address, which is implemented
+ * in relocate.c; broadly-defined KALSR means the kernel's final runtime
+ * address has a random offset from the kernel's link address (a.k.a.
+ * VMLINUX_LOAD_ADDRESS), which also include the efistlub implementation,
+ * kexec_file implementation and QEMU direct kernel boot. kaslr_disabled()
+ * return true only means strictly-defined KASLR is disabled.
+ */
 static inline __init bool kaslr_disabled(void)
 {
 	char *str;
 	const char *builtin_cmdline = CONFIG_CMDLINE;
 
+	if (kaslr_offset())
+		return true; /* KASLR is performed during early boot. */
+
 	str = strstr(builtin_cmdline, "nokaslr");
 	if (str == builtin_cmdline || (str > builtin_cmdline && *(str - 1) == ' ')) {
 		pr_info(KASLR_DISABLED_MESSAGE, "\'nokaslr\'", "built-in");
-- 
2.54.0

