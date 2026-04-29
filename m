Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005A3F65EE
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464224; cv=none; b=ciR1cBAe81XYc4GznabQWj8HtXBl5SAVymSo1o9zeYcT1/8l/RVSAv9n0ZdTpn5fNAhGMiN1O+YJ9Ub3O/+JeQeh5BsfOy97OOn/BQPHvIkxIeTMJJQVyehU9aZ7dVbanHd5nkZqdHnS+x288y3PtyzhqxFyH1fHdxoDNJRZPxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464224; c=relaxed/simple;
	bh=0HbWEFap/x2oXNG2YyKXf3ucWF6UibURcORpeo/4CBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CowTRvTL0sSfNwU6PtHW+QaxhukBW6MfKiBjf629UQldXTng7bwxv+5Fo8pVCkHZno2xFOGEzzhFQ1zIu++YS45Q+7ZzvV356Sfq5xlhS6+xqFbeht7aiLoBVgYnb7YPysAUEcARpijs57QMNlcqLHc7ebajXGPyy0ECPCMRSkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=MWaHbiCo; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="MWaHbiCo"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-824c9da9928so6060134b3a.3
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777464223; x=1778069023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZSqUPVvVHrJHdl2goTYBViyTH/4ppdxe03roQ8yBtI=;
        b=MWaHbiCo9GvWce/x9FS2h4kFLwJ08rc5w02ewLCG98WTRLwAdDMoU30QgAzpE3CpSR
         SJzbfJJKoJEVeN+QrNpvQzT5l9lcs3+Rmd9U4IjR7lms2dIlfrGcufCm1XDmXIiEbGRh
         TqigoOowWmJYn8HfJvAZ1G/xlysh6nMyDGlxJcMXqWUpLvqZsUMt74Lv11r9qZ20yZws
         DpIhJxImvLi7oaxONjOcvvN8Joa6twGXnqUV4JE5xB3eVfdgafP8kLW7nhcVAthy43GK
         jIP+gNHoCXPPbs6fHDyWOPWH9lls5kvr9GsCJe9Q+xxO90yHpd7xV6OMTLuwPBPFlE2O
         8pkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777464223; x=1778069023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZSqUPVvVHrJHdl2goTYBViyTH/4ppdxe03roQ8yBtI=;
        b=J9KCMuqlvUYxMIYL/ls4EFFV1TC6ydAQdF/L+r1a645tybct/3ggmwd2WvWbwnYChU
         kCZR/LCygEeXN25lq/zdYW5d2zbErWaAdj52RkG2xUojRM9kEC0JXyefav73hEgVWJNE
         Hn6KlXdAz7mDU/L7JsUfQVfFNOldi0dfmzB/LvcsRjX+M/dJ3pn/GckFyEz8j68X+SWq
         edrSbp2/d1rsmRXHmOnTlk3up3ZnG6j2G3grEvIgV86J15yJSUpW6ofEXwlmL+buUUeN
         kbXlOAFkpG++tEGzG+6YqjQ5nM9otloTSLMZSceOr08TM33LaFx7A62+SUt3ewp59dcL
         WuiA==
X-Forwarded-Encrypted: i=1; AFNElJ/epbrKZ/DBfhhb2WnJfNtQSPcmtuFrNa0hINGT9xhEltdDtBgI/1upTFfEBz1V25kk7GirqYRhWIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4sGY9lvmwzrt7NrW4UG0nEu7SWGbi6aTaIpNEPcfyrel/vIgM
	VTkCCc173UXwhyo8xK/ZdKknRZ1aH13dP1vNN165GeElvu8YuKf8fOkcSrYB8FOdWG8=
X-Gm-Gg: AeBDieuFW54YokIMGHcXtvfy6C7pAovIIEjzmFEF5zkP0U5rZ6iWwgHKqZtx8hHpcer
	3hi9OIByVpy0v4uBkZZr2U2a0DIW0kMqjR53OEbpx4TfPURZIT3XSxdRbZYJuCPtZMnMml2uhMc
	Fl+gPpug4DatX5vJ9VA9RAh3atQD6JvBGiuxdvrebji5ag/5onzUwqM79gsbkQJyW20FfUF6TpI
	8Z6jPaaVYd16b5ZryX0cCqgiY+5VxZ+CbKsKOVGn50q+X0LD7tHi+X3aaGhfKUqlLEoD6LtFH0R
	Ge/v5/H9FZ4qaI4lWWQUdnNr/Rm/lEog3sNYxPJv2q7kFDeLm/+jSFYL86TLX8wTq9UtKyE+GaX
	c0gcxDPA6ry1+YMGJvVVJ5lPb/x0Jg7h8l14A1GFTB1p5WffFsRQTS0dY5elCle5pZ4Ct8sGFP5
	9QVHO58NaZVjRqXgy+OIeeGt1nPm7w
X-Received: by 2002:a05:6a00:9092:b0:82d:556b:7a01 with SMTP id d2e1a72fcca58-834ddb05a5dmr7285440b3a.16.1777464222678;
        Wed, 29 Apr 2026 05:03:42 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5efaaasm2016493b3a.27.2026.04.29.05.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:03:42 -0700 (PDT)
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
Subject: [PATCH v4 2/3] LoongArch: Skip relocation-time KASLR if it has already been applied
Date: Wed, 29 Apr 2026 20:02:59 +0800
Message-ID: <20260429120300.1786210-3-r@hev.cc>
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

When the kernel is relocated during early boot, a randomized load
address may already have been selected and applied. In this case,
performing KASLR again in relocate.c is unnecessary.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
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

