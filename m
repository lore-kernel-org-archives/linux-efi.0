Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47413B5302
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 10:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286868; cv=none; b=Re7QC1Tv5cGbMdrTiljVoco50B9EvEx/shYOvjhydHrDqfX3QoqdlymSE10w7UvR/62P6ewkOy4kIBYQVNPNzivLMHgWFQeyf4kcvlNKcN5IcwDecOUD7uVprzpMTYWssFS1H9z/nQd7bYpdha202bZ1+bH5JprkOdE1I7xUiA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286868; c=relaxed/simple;
	bh=AFxDVPfqDD1fX+0U3m7t2OJUKJfWgyTTwFDtosrykxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vF2Hlv7nQmJN+f1N7jAXurWPHTeEUHv+46OPyldznlusDLPet/Uf+9yDGHyb/5r++p7dnnl6F2gWCW3lfRa5MKg9rx5YsXO4bJfsibvGNetNEk0iAKRkSaIJDmxtR2u+k1FGps5wM1l4wpIgQno0buk96gYHGA5p80vvFG/DwF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=tS93o6KD; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="tS93o6KD"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so4704248a91.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777286865; x=1777891665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1M23bGh5Hxam/8XaoRaHHo8c9kozCZBAlQpB9hznRA=;
        b=tS93o6KDEYVOUtMDWnfVwMOXoCuQGs7UcyUTBuP/j3bjP7BO1BzDRUT7k5/hJRAGpj
         ZXfdbYm8v41TMOGcnzNIAp6kd5BRE30wZzJCFh22apQrpE/kvm/ZL/5t6ktVEaynpVGh
         tZUT/o5h7OFUL+T+VjpndJgxRV8U0MVAilM6yS8sockjdoFdLs9hEEvXayqVr+LLTqaq
         U+4S6x74dazVHzMAwRYEwg3KaH1HRsXtcY1SZk3g7AFEbH91Oj4NWK4C7Gwj4643GCl7
         p3e1YyIdbbsS27ZpMp2yyuI8NW2h+k7yogSztLQ9+MIkXeyg6Juld3Fl+nouMLhJ6YJq
         5gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777286865; x=1777891665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s1M23bGh5Hxam/8XaoRaHHo8c9kozCZBAlQpB9hznRA=;
        b=Yuoy9pnz/NRvhlwrMk+D6YyimUD0gqAmqm/hJqQwWlPkAgQtt/Ki7RP8z7RfnLJeSD
         HT7diggXBOVms5B8C/eRl+30XcR81wMfgjswpn3uHM94I0JQMugBm58Atqa4A+ks4W9R
         abJ3CUXeGBBk1ewWlo0upfCADkVFqy9tuQtihtGLvWx8+EKyMzgjKXTY2jQVCUDotRJZ
         whHPrYx+pOgZHRS7CWexQswkv6qaLxaFPZwLVlY6uzpzlQpuTAToWrjLQ7v5Pr2w+LXr
         6Hhf+4qK7FinZoot/ed44aUyaxTvTFNWIspjyveKp82fihjP7d4OHu2adOy+0/vHlcth
         /2BA==
X-Forwarded-Encrypted: i=1; AFNElJ//9qElYYJNuryHEffG1GsykrC2XwD22kjsM7XEw9rTnu8NLgdnyl/vEtGAbVGwZpgdotaXkRNBhsU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+IOzAH1Un2Gsru2/eXYqMkg+v+tyTvKxLmvqt9NP9zC6gQWpy
	z3lA4H1/4fEsP7Pt8Juo2LW8StsUVaUqtCpP4+WLsiiXvdRY+5OhgWBZXQrS4LHSuvA=
X-Gm-Gg: AeBDievA9zMLOEm1/qkK7ocG+dshYqlU3rKvVZAwmnmwlf1qsaPqHgmc+m8fUH0E9na
	xI7X0+ZrPffMOvkZZoBbfcLdxPveDKD3k+jdT7abH/9eQNM3rz57XiSgUWyws4rW45N6LaDjbfL
	XG1KG95HZaf1m02gfLP1Z6b+1ZBZe51YLrqccmAezoC+mDm9D0XQeqb0Dk9HPJHbYrmgPVgVsBa
	07jJ8YGwidK/20D2imnNK/JQNpXEwbdAuPFz2KgGIy4fIXj8qvhaMMeZgDvDbXboZ0DYU/sHNvT
	IBRGS1x8/8FwQXDhMWy7ZxV8k8XpyQO1NbphTuMBAA6Ui38WD3Cqk8N1Rj+kFbk1I89E0+s8W0X
	vS1Y9hJGEroFresYP5deP+0G3X9oDTbpnu2RquXFaHpmZn9qsYCQ2RppnjPo5zkGJNyEplMwFhu
	Vogtr3i4DA7vcowcSRZeis8g==
X-Received: by 2002:a17:90b:38c9:b0:35b:97ba:acee with SMTP id 98e67ed59e1d1-36140465451mr42503043a91.17.1777286865144;
        Mon, 27 Apr 2026 03:47:45 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362dde4ccbfsm16227029a91.1.2026.04.27.03.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 03:47:44 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH 3/3] LoongArch: Skip relocation-time KASLR if it has already been applied
Date: Mon, 27 Apr 2026 18:47:21 +0800
Message-ID: <20260427104721.47724-4-r@hev.cc>
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

When the kernel is relocated during early boot, a randomized load
address may already have been selected and applied. In this case,
performing KASLR again in relocate.c is unnecessary.

Signed-off-by: WANG Rui <r@hev.cc>
---
 arch/loongarch/kernel/relocate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index 16f6a9b39659..c36604a81d08 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -139,6 +139,10 @@ static inline __init bool kaslr_disabled(void)
 	char *str;
 	const char *builtin_cmdline = CONFIG_CMDLINE;
 
+	/* KASLR is performed during early boot. */
+	if (kaslr_offset())
+		return true;
+
 	str = strstr(builtin_cmdline, "nokaslr");
 	if (str == builtin_cmdline || (str > builtin_cmdline && *(str - 1) == ' ')) {
 		pr_info(KASLR_DISABLED_MESSAGE, "\'nokaslr\'", "built-in");
-- 
2.54.0

