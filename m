Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1793B52FF
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 10:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286864; cv=none; b=MTP280IBTQNGtES0kSIkMnkABOvrEzRpfz/48wsQkHo00utvXbPnX8DDF4wBnAhWePT6x5y+RbejUCnPcVi16D5/r58LCypjZUiUq+lEtaR6OBV1ioZCzKTeFXhrRWn1cBYcrvhl3XvoD+LwQLQ4BPJut/8b1EtvbGjtpx/TkZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286864; c=relaxed/simple;
	bh=gZg1LZJ8U8You+Wkevxwu5gYhMLfjULVKE+O5oAK3N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsLLB6KGCAM2iY7y/dnZ5sAEExXaLpDvQhDXr9Usm55qly86EZ+7q9NIDrnYkSzpXnDBebQNFgn4R9KMMYTTojgkuGbgJLKN81z9Pef+iXCEEp+ejy0TLeoQsUVfEE0eXGOF2yjHSlflk6Wm2GhXxua6aU6TRmq4XW71xr6P1SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=gKNVwLmb; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="gKNVwLmb"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3614826eca4so8834352a91.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 03:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777286861; x=1777891661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhTH8c+vBFpvSOX6DMmifWKJbw9Gz0Bb3dH6yZMz4Qs=;
        b=gKNVwLmbkRXj3azfIqkXDR958PrnmAq7LrAkbOiOfJq9cuqFsB1d26Tlk035hO6xGt
         3o8JEuTOiSF9qwH/VuXeNf31TJfgMxCt2a1+XVvQlUeCCIuxdku2muAML+BhbH2JTLiJ
         /c05+hHhFh0zYwen3y6MOVXam5uOyrfZvMXCcn62quqTb7TP4AfYCP36iozFs/1WiqJA
         pIDzkMJiD2MazrRYzDnHpLGaFCzv7lyhG5OUAXbpLj1stPzKbnL/LBhGlIds+TnAzb16
         VFM72J0yjU9gr39AiD82k1lwPe4lw5LO14EFpmaMfKzEU5EamH3py3wZMKhkG934K46s
         jkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777286861; x=1777891661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UhTH8c+vBFpvSOX6DMmifWKJbw9Gz0Bb3dH6yZMz4Qs=;
        b=oiLABhPT7/A9jGS9QPvsOF5Mmvy1LN2yT4txVh0TEP5s+Dh6WF6IIBXeqCwuLwtl/3
         gc2kiuxjnHubiQY0Z//AzPDHIPwbFmj2LNrPngV3kE0VhKc6mAiIZCbAakvPpvO6UeNr
         BuQTAvS7j5Dsz9p8b5Nk45X3gUfc9wP1z1Bmm7oHyQhFivsj22jAziJddlxA6dODHvSO
         jx89FgO21gA5dMkBpfoQ0lLAA8S62lK3dpXM05oXKsljI36ZhG5AwG1hEc0agWnHIUNJ
         aclkrxRh99nkHj2MnOQ+qIHfDF+XH/KRE20bMWJ5GHo4v3/rb2p//ho8JTKxrzWn0g7q
         S90Q==
X-Forwarded-Encrypted: i=1; AFNElJ/AYulWsB0kOySElJOsYvra4WFP7WiFVoRPv/diUYI4P/n6paiG4KbFRzVXKetoU0nfI4P/5eiiKlc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4qGC4zwwGEVwK7gaW3G54ZrlVc6JFWS3GbM0D4nvAgW7pc4ov
	dXTmn5yzqq8OzYj2DcwVRDB+DBL9WgI0RF6qfL80Fw6JZZJUKmmiw6lI07z7UXwoAvc=
X-Gm-Gg: AeBDiesKizsPN7h6zS/l8CRsDXcpDCdoPTFYLY15PzhEqodFjdr83+zhDUhV3rKRUXu
	O+480QkM48q/UE+hnoJfoKte2DZrJugmx21mZB4RIkciML/d+kA99AB5t38GmJY1ADZZpn63Gwt
	0tTxZRZePJy0j8xt/9YzG4bERLHyirmDwD9vsZMzSsP7Y0izT4J4eWac0gzXUl+AU46HoHwGeAt
	qyU8DDWNe62LiZQNbUavEdWuneI1pDOGnLLxqcGQHmbKM6XswFKEjE8vG6VKpZ0rhkv1emJkPO8
	eFezOvh9/BGBoloDNEHul3XVWsZL0wSE+2v1k2/kWbUM1N9ASvFVSNCtlsT1ckXMwbZ2haN8gOK
	iwZwzbiGx9nRT/MuJXg4YgY76SkhOq71oroKipEJOsFFkjIFeuGf3aUeh4z7Mj9hvKr7UKmlRL2
	EwGeJWjNxDv2U=
X-Received: by 2002:a17:90b:562b:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-361403bdcfcmr43713580a91.4.1777286860831;
        Mon, 27 Apr 2026 03:47:40 -0700 (PDT)
Received: from xpc ([2400:8902:e002:def5:7882:53a7:6a48:4d11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362dde4ccbfsm16227029a91.1.2026.04.27.03.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 03:47:40 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH 1/3] LoongArch: Allow rdtime_h() and rdtime_l() in 64-bit builds
Date: Mon, 27 Apr 2026 18:47:19 +0800
Message-ID: <20260427104721.47724-2-r@hev.cc>
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

Remove the CONFIG_32BIT guard around rdtime_h() and rdtime_l()
so they can also be used in 64-bit builds.

Signed-off-by: WANG Rui <r@hev.cc>
---
 arch/loongarch/include/asm/loongarch.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 2a6bc99177d8..bb2da9c58411 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1248,8 +1248,6 @@
 
 #ifndef __ASSEMBLER__
 
-#ifdef CONFIG_32BIT
-
 static __always_inline u32 rdtime_h(void)
 {
 	u32 val = 0;
@@ -1274,8 +1272,6 @@ static __always_inline u32 rdtime_l(void)
 	return val;
 }
 
-#else
-
 static __always_inline u64 rdtime_d(void)
 {
 	u64 val = 0;
@@ -1288,8 +1284,6 @@ static __always_inline u64 rdtime_d(void)
 	return val;
 }
 
-#endif
-
 static inline unsigned int get_csr_cpuid(void)
 {
 	return csr_read32(LOONGARCH_CSR_CPUID);
-- 
2.54.0

