Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272A838B140
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 05:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439646; cv=none; b=BVnHarsBON9De/Ybn5m5pm7GmfiwkQHoVbzN3xxw1QaNwWq+iaW9qgaSITqoyg4yy9GmAW152AFTiJcpyJg8T8VII9ksWD+3pW1+TrkV6ZYtb4iVZPq4iPF81Rp9gLxKIYFApb5iKxTZuQdG5ne5kN2uuDl+VpGlb2/ai71GRVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439646; c=relaxed/simple;
	bh=AFxDVPfqDD1fX+0U3m7t2OJUKJfWgyTTwFDtosrykxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWLo2BJRa8Cs4PtpBuFBoHBE1rhlmwHLAjiaP8qNSWcBEg6h2wbPu1z4FFm9WX/KX3MtWybZhystJHjxqpDwwn+k/BvMpRK4+DK6z9KF+oJX6EyaME06JiJpra4yugezTX7v5RONRPjajA0C/+mpOPCGvhmgeC5iV3Y7Gs7bkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=WVKtCJ/j; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="WVKtCJ/j"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b7adb38d65so58260755ad.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 22:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777439644; x=1778044444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1M23bGh5Hxam/8XaoRaHHo8c9kozCZBAlQpB9hznRA=;
        b=WVKtCJ/jXip4lCFUgLcr8SGqOY2Hd4vjk5C+fjAvRy28GR9slBnqcnbtMiwuz3d1NB
         u5mvu8RkzEDyP78Ui9Pt5TIs1SqD8eCQA0EizLzV4eou0qfj+HxxqeZsPqD8G8m2pldg
         QDW+kGtzQpC6FEw73dXFmbckNYmigqyzGrRXWQAkMqh7oLKvj1dd+16EmBoEK4CrADhY
         07lHupqY/f1ye2Lx+RIsdqx/aBW+QUmGtgP1NHiSHrPi6zVoDycTZOgDr5UwC5ExwbGv
         uZTyuEEeBEWq3WdHEWvn8hZwv0pte4gM12Ng6/1k5AiGbIi/KaUQ+nOgO1B09DeTv7ir
         XPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777439644; x=1778044444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s1M23bGh5Hxam/8XaoRaHHo8c9kozCZBAlQpB9hznRA=;
        b=MeXjP66YREwcolDMmURrxTLiQJDN5lh94oGxXzlQeK8OHtBOaWS7yvvI/EDqJXViKi
         YBqyEP0TiFzaMMmUX3/hWsaBolWsD8o/hRKZuJX0GjJwTcYq6stRQ8TrxKsvn5PFsxwt
         h6MRRHqcEr4wruX0PiJcBtpCKykOWi1yFQCYVZpVTrVNwIW12p42NXofpzxhHb7PjhLP
         ZP8E/TTOYeeXNmQqwzk7/IZDr4oDRg3LnHuJgdMHCUvINOe1Ns84KU+u+HDeynGkAHmv
         f7h4g760n8+gFeQUu6VlO2Lvjw8lX4gvthS2uK/RhbHss8KsGhJdsku6pQhD7Eo3/5El
         Bt2A==
X-Forwarded-Encrypted: i=1; AFNElJ854hdw0Ig2a6/HMy5MPN3eSR6DlL7uUAFhQ5ZvChqJPKn8uJlxB6meO/Kx1/mw9y1imKNa7wZmSzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKORabEroYsLZDD0YZJ+n6SFm1LfzwAUq3gejJN39/I8DOinho
	Ejz4cFMmM3hACnui9C//62jPuXkD6HFhmXD4XJoZkQKz3nT2d04Fsc4nuF9d7F3S+QZpjELacvd
	+PjhIZ7g=
X-Gm-Gg: AeBDiesQWfEFsgleNeHi2opCzhMiL2IwyH/biFVPddyvUTu4GG7yT4VqlCwIHvUee6U
	nbIlBiAoUTjoLZloAyKeRrqemDAcAamwqZtBr0th/wwGzrDfPS0p3pn9WzYOr49Rhg+IBZ9DKcD
	cqmXn7Oj8Q/+CbfEmHQTyqLacBNYutYIriEoAziTefYbezXUAzc4XgP+0revnUKhUJ4m+k9ClAj
	cCLayDZZVhEeQrPuYNdfjSJipDLJ2BSEkSxtfrjvTqcuCev4+9ytpoj+TrDDJ4DdK/lKj2Cs4+k
	gg/4qRUQrTxjbyh/5jsbWbWwOX84AYZx358E+D3eCMCETrH9UdjO7vaQ/YbPB5er4Dt3c6+2Fcp
	9KGsp7t0VIwMT3E6aIns7y8KMTCdEFPVaJ9sgGllZQceXjnmZxI8o6Mw1kVE9hELi67rZ9AQfaq
	et4ai5Y+Q95azFHkLDntUDxXy3qdUL
X-Received: by 2002:a17:903:2acc:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2b97c48d869mr58904515ad.34.1777439644464;
        Tue, 28 Apr 2026 22:14:04 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de33:3dbd:69cf:4a22:309])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988787360sm8846935ad.20.2026.04.28.22.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 22:14:04 -0700 (PDT)
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
Subject: [PATCH v3 2/3] LoongArch: Skip relocation-time KASLR if it has already been applied
Date: Wed, 29 Apr 2026 13:13:17 +0800
Message-ID: <20260429051318.1581350-3-r@hev.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260429051318.1581350-1-r@hev.cc>
References: <20260429051318.1581350-1-r@hev.cc>
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

