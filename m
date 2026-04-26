Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AAF35AC13
	for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 12:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777204975; cv=none; b=ksOiDqgX0Govs3Db7u3u507Js7+awJZE3FAYKBk9wy8vOK45Qr7YzzHO6sFd0e0gRArIhxejwf1STU6lb0tMu//p984Ji8eRjTXP1izgvG67VjWpTephiOoKLeV+2TdidXOyW5zGJ3dvk6qgObBaqHMDAyrq8jzjZUhSsZ1bA+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777204975; c=relaxed/simple;
	bh=gZg1LZJ8U8You+Wkevxwu5gYhMLfjULVKE+O5oAK3N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBcxx8W7pXoj99FDnWSPffnNrsYLlVRexQnOtWcibBS0+UaKu22cEl5cslaUB8XhNU6Q8cx1i+ny/mTCcG2z+g026oCpkXDNGmK2iJMNhWaQHRrQ6UVsVdfYDYKEUdB2q8UhiHrmglM5tFfgFNyhvUjVv4sAliI8es3ukDCGj38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=JPhfCkr0; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="JPhfCkr0"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b788a98557so42139195ad.2
        for <linux-efi@vger.kernel.org>; Sun, 26 Apr 2026 05:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777204973; x=1777809773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhTH8c+vBFpvSOX6DMmifWKJbw9Gz0Bb3dH6yZMz4Qs=;
        b=JPhfCkr06MJFNDM3yrbd0UyZSrVbNnbislx0lXDBpt8BuBw3iyfq3/qsxxai6BaaAD
         F8m/EwBPalP8tBtb0FUu0GhcuziiGLdjERjQMv1yE8OlMzUnVSHudr96D6wwv5X+6NRy
         fh5KfhsoCHNo09mWDH2ayKlXn/GdW3om0iD0zPQFdJKJZTpruFKsdhO7u0aXlYy2W9JE
         hsQqpdsKCyI2GQvu95kHocSrKcJHmvJCP1LTZ2HBYJ+3XbhjYot7uUDCYM5UyHmM900O
         rhddvCm+I+aQwXy6x23ExUGvRUqN5+E1Kek9j5oX7twjubKbit9J+iIh2RT55YcOCjWV
         Ylfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777204973; x=1777809773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UhTH8c+vBFpvSOX6DMmifWKJbw9Gz0Bb3dH6yZMz4Qs=;
        b=AcTQDdBsG74ryxDel/x6LizeK5gR6W+e+QZrBxl0lnhenQzLi8+n4sZWkoE7s4OE0h
         qcZibEaSmkIiYU28feYndaE34kguFKry2Dv0+f+2+4aOkpfrmP/GUnsFzig1jzZ6eplG
         Lf/XOPvyeHV/+Z+HU6fds8LpA8mfO344gV5VXf6XzhqZHyyU7osOEhcAfBPHeYr+q+l/
         2ORN+Dhlu6JWG22ElD3CE+itxIHyqzWyYcqDkeMPM7FI72EdhtjfrqYgmcnhfI9DYRVB
         O6MhRO7bDWsmffj9gk8S/w/8rdUgZrStGZWSi8nOuZEQqm+lYBrjjocTxe1dEML7rkTL
         MXdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/y1D8rGplvwwfmCQ33lxK+iMKkbBC7LBJWZYsvIVmUjeSCwCb4zR1Y68vtTIV8DayexgU2cl28f1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq5n5rl3sB/82FvcTf5sKFBjxXACQYXQtFonFKKbqlV8rtTyVe
	pVC6Z58zSzQS05VHuBFUlPIqAgaHcoDibu3+XyKcWxP+aBrrAYSdkKA8FGSa1WApBGk=
X-Gm-Gg: AeBDieuDh7oI4L7vrtW1Wjd0Rh4KckAHWDgdoo7rblSyyBHWJJrY5hTRx3Evtm5yceJ
	Y7Q9B9/Zy7YZi2XSVNOFmNTELJUpG8VfkAzaRzV91SvqNmto/f2TzomykW3VTjg7U/sjzl3mYzk
	rhdovuypAWDoyQIGA67foEDnGVeHcMpQo4Ld9NFDCkBZCj85wn52vFD1Ya9uOHJIzQaK9AMj1om
	jyTD1iUVi1N30lLJnkCJ05wFPhdDGryOZ+03EnFDqaBrqdYXin894+EOIT01muXBqapch5kz4xP
	GDw9mxph/A+HbCfGjZinVzE5Ta5OnC/66ELv6agtqahd96jz9Gbe0ivk30y0Bmwi2wcX+0qT/th
	SMcXZ3osjU3d7Lg9AvgH8v0ypvCtmHtid7LxJxAsKE69gYTLUDTbJV0wNv8yMTyIQHpcw7kN48a
	q44SXDeMXT4Iw7LL+NXc8UakCQFpZ6qA==
X-Received: by 2002:a17:903:2ecc:b0:2b4:6022:bf8c with SMTP id d9443c01a7336-2b5f9f52984mr430205845ad.22.1777204973336;
        Sun, 26 Apr 2026 05:02:53 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de3c:3085:4d80:3614:2212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab297c8sm263413965ad.67.2026.04.26.05.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 05:02:53 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Huacai Chen <chenhuacai@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	loongarch@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [RFC PATCH 1/3] LoongArch: Allow rdtime_h and rdtime_l in 64-bit builds
Date: Sun, 26 Apr 2026 20:02:29 +0800
Message-ID: <20260426120231.532644-2-r@hev.cc>
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

