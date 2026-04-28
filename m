Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C72A340281
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 04:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777348954; cv=none; b=npFgQpfFvmyd0rJ60mqUbxxADXX3i7NU0tCfFKhEPjpivWO33VsfTeQ1Qb9soq+6m6gnVZdVAju++4PYJByY0NL6tBSGL8DMtBbIi2KKbfuBLxp9DYLfDRMO/GTK3AJSkAOmqYXgnZtxsLnDieH2Bjp7DxNNjHR7uRUbyfpHSgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777348954; c=relaxed/simple;
	bh=AFxDVPfqDD1fX+0U3m7t2OJUKJfWgyTTwFDtosrykxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl7/csL5F9V7GT6fsRQ7qnS6DYgy03WJDTCgDlbCdzkbtR7z77QeEQYpKWlWovIuSdH2lKR2dmS5PQ3xLRaoHW5EDTlBvUzO89nyYPv+1Y4vyPe2f7NjiPKtR0TGJkpe9P5ga+QXr5UQ1JaJaDU4X1OlFm7/wk1lWE1sU6tvkUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=V+G9sBYk; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="V+G9sBYk"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b7d3ecc10dso28569095ad.2
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 21:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777348952; x=1777953752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1M23bGh5Hxam/8XaoRaHHo8c9kozCZBAlQpB9hznRA=;
        b=V+G9sBYkThL/Ujc9Bg8avGHjYpCpLm4bopzwA2GLkQNkxZ47DIMLx+9qTxehk0ZQx9
         jSct3X8NCKUfmsRk/21tIaXO+3lRNXeqzAVKtxu8PKc7IX/AUN6z+JyS3Ox7ZYAzG0tY
         UFFg8gC71yvCTND1hiHTd2eaVlpypVBgOWjvZOW6b3dDKAz+d/i6sGWKBvO0e0VRah6S
         FhIV7NTGqYHb4X/+QkEqazZ8BCYXNqrY3Iqfr0aTEnnoQgJgEKP+fg7Waj9AO/TT3PFc
         jTO1ndcE/lxifqVbXC4Ao3WXfH3KE2le1FthAqHXsgAL0+XoV0yBRMcSuZFVjauD5lBh
         9wTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777348952; x=1777953752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s1M23bGh5Hxam/8XaoRaHHo8c9kozCZBAlQpB9hznRA=;
        b=VYDs65v1QjUI//K7r5tFMZerHMNEDI4kOC2Grh5EA4lH5KrPL61/uS+M12OVnKaZy7
         XMv+xNx5Hxs32LJEp/SGVO38HYLCpJyCsb475QhOW/2oYRjmAytis6x0UpvDx+qxCFDa
         DqAHL4hynYC2E2zuS3coLYQxMk7IEn7YO+5g1D1ykJalipGGni/OpfYmJtrpin6PIbZB
         9CuT4TVC0w/8j6b2EoeQt5iaGJaHoj2XVGUeApwfdm6EHQRd59j+tVJfB3JLOh/RWziD
         0QWgBf2/FzmsXUcvzRE6pcsRliAen6xJMKEebCTqkacKUXW/Wab1LSn1ZQIRiR4GXcZS
         bh8g==
X-Forwarded-Encrypted: i=1; AFNElJ+vSIFmFHDxz9I1462uvagUU/X5lnEQlZEN8OrbSWEBJfKK5iCPeWlYvxPaejpSoM1HJ7rQEjm9GDg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh9SOFArdjdyOBmctDDqby+xqY5bH5LZvl7yTYXZrnl7W1XKgp
	ueRfPPt1MPZCo+5XrgwpObBWCwbscnWI7MS0J08VbfPw8gyCwCGVCPIU+44oYxxfohQ=
X-Gm-Gg: AeBDieth7hxBzgmGgERmFMb6b8O5zyrbRqgBzkzUKtsmJwr7hjArvaF9ShnPTNes9cw
	NOrfqzKX/nDTFdh0kKkpRkzXvIajfOF9K1/UkYqvcCFjMMP2lhP1V3D4LyitHYFo6fU1vDewp9p
	tFo0tcvYK+2Lzn9aQyZdSnK62nHQgBKCyakb+VU/rogFW0eQJnqxhXAe6P2C4Ut0CPvyYVhUjUT
	X/sP5/D0/ajm4Ybf41VdNDs1zgsCn8bzLP+P6gdb9PDJdmulpBf66UlTrYs3ZP/cVPuyNGgVk/A
	7awoEHRDUgNQyMBvawxJTB9XN2NTjRuCv9KLOzQ2QZf747Qk9183zBpJgH2mODA3vFCoqI9Nk/F
	xPC+Vj+JUAPm+fYsZXcZR+VINcTd6xpXMhRSq7DHQgbnoLmlpMW6/gfekGlRnrIR++zQrCaZiT+
	Ve4gwKIdHsfC7wSW/0rA==
X-Received: by 2002:a17:903:2f43:b0:2b4:5cea:f618 with SMTP id d9443c01a7336-2b97c4064b5mr14219055ad.3.1777348952268;
        Mon, 27 Apr 2026 21:02:32 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac8cd29sm10131365ad.61.2026.04.27.21.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 21:02:31 -0700 (PDT)
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
Subject: [PATCH v2 2/2] LoongArch: Skip relocation-time KASLR if it has already been applied
Date: Tue, 28 Apr 2026 12:01:59 +0800
Message-ID: <20260428040159.1065822-3-r@hev.cc>
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

