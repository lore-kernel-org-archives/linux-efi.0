Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D04A34FF79
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 18:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634639; cv=none; b=TAAzxaugdGgmZWmiCl3vtMGNElU+BJ2vudnIDM1Kd89P/Hi4IcmOu1Jh4toOZd/uzKf5OgRuoUnnTmU4nflHfmsArwDdVKp6LJZxfvUcL7HploJXZCvSDIzw1fgKvuae9yEV2vR+Puv4ulcjMJGJH20d2WAz5x6RiWuH78SdTMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634639; c=relaxed/simple;
	bh=BTI/aAntiQ9xcx69tlVTSh2gnfDkXs2rdrTFgedaEpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYeOdfjbATUGwzn4ivmKuHXwcYKE/H1T/4KvSNuYi4aer2WACU6pG23vnwR/6u9sYxWkUBfngTX2E575JxoICPOuPxt4oaDC9StFHOlFTYncoZa6jmruwOs8SNHrrX7dKwn4s1Vy7iyVOL0h6P1Xwxf6g2fp1KQuDCPz7S3s8e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mh9kBf+a; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mh9kBf+a"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf22d29dabso30737935ad.2
        for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 11:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781634637; x=1782239437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
        b=Mh9kBf+aEFUsMYrEnzOMysyyjK75Jx+vadehy61blzF+5L8atugjdQo6R+5G/u3PQW
         plZjWiVjWzPIHbKD0PdqSgeNlp8HS9zrGXi4HlIHy7v0e9qW1hZDVifkQNnPx6S7XsBt
         r+OY/eOXdNnmUphxXRE7tTdTFJzpZjbsQ6FFMoJkK7s2z+BL/EI8tTM2jTGhDpyQmpLw
         UWfE090yOdgQ+UQwldnAv4ciAItcqJ5qD3WwAvD4GpRxXEePQEjYDcqNrPwmU4XUVo0L
         PaO7ESeLjZdiWK34RZxm15vB1gik59KB4zVN2HNQIvMAfIIty7hygv6MbKWoYt2bnRTP
         9mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781634637; x=1782239437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
        b=l+ZS2Eyjs5ZX7/V1HDoPT0FFnALavB0qmgWvZCxomf8Z6Vh2uGHY5UZTYtB9cBF1f0
         8S3A95ci0mlNZUb2vAF2UWTV0LpJXjXtt86XYfHSzpcFFxZ4qEgZU2L2beOjPllVCLf6
         xP/qHxmHpDMzdl2iVCIpVwoUmJsM5MyKuvhk8E1lD9Gry8nsIFaYYFXxmMm/5ZJH+JAg
         usYIBuz0NyGlkFLmHLF+caY/pgtREIVv9MKa/TQwMR7HrUDFQzU51NV3Tjbqmf271Kom
         kO4ArItHtXeLmaiJy4jmfawjBDbLnp2EKW/R+/O0SK/BPg3JPTVijSF1gMPX9OSk4aSM
         ai0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+DnD7Jtw74s9kXQSH3+xdpQLAJJ8arOHyX0mpKXM/S1DSXpB216ETvKpuFJqSgI4c8SC/TAJzH7Sc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg0yHebVmL8EvfAT+ztTwDbSauQ7O30cH39RTqbOTHWOADhAVh
	v1ElNNczfnEjvGbqcbOtD0Rg+uX+5fAeiaBY2z5Lnm9pa77GEiU2C/MD
X-Gm-Gg: AfdE7cnaEDbimXxv0HmCG+iAJXW8TD5sKwbDCkhLS+pOOybfJXSk3hSciUMD+1VJgFZ
	pck2Su4yRMcVExzLvbbV8+lHW5Xq0kL8u45ttZqpqBxxldPI8SqHmiouyxfqwE/ZJN+LGfWzG+c
	La4oFQCy8Y6UT8hXKKObJIiLmzGyAu2dV6EHKx6BPwtl3BmFsGItiS/vIW7bhIxt7VMvNRWRski
	yKQYIUB8itfSb1qrEexyc5FAYdQnXpEPeuRhERcGL5xHCiVSoP3EcA1V3WzrkBN/DUd9PeV+vUN
	/0572yImqJDMvl8Hkwh8AsPD5IZvHrOmAtugbbTQjNA0wPcRnRv1jDqrCXxNDdNT0potc965QG/
	Ohem885ncgBwTCGc3SY3Fu/HCGZsFWyE6NzbU2O3u2Dc/OpdkAyBKCHYfXrK0hvkIW8v0wYlFs1
	fjtDju4xhFw1FtzHbY3A==
X-Received: by 2002:a17:903:2f86:b0:2c0:c2c7:58ad with SMTP id d9443c01a7336-2c6bc0ab9a2mr1960395ad.13.1781634636941;
        Tue, 16 Jun 2026 11:30:36 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c43345e3ffsm141092685ad.71.2026.06.16.11.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 11:30:36 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Revert "tpm: do not ignore memblock_reserve return value"
Date: Wed, 17 Jun 2026 03:29:56 +0900
Message-ID: <20260616182959.2429774-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616182959.2429774-1-ekffu200098@gmail.com>
References: <20260616182959.2429774-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit c33c28f9f6e017702374e1ab907dfa5a63db5301.

efi_tpm_eventlog_init() runs from efi_config_parse_tables() during early
EFI initialization, before memblock_allow_resize(). At that point
memblock_reserve() either succeeds or panics, never returning an error.

Therefore the return value check is unreachable, so restore the original
unconditional memblock_reserve().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/firmware/efi/tpm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index cdd431027065..288bcf7a5b99 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -61,12 +61,7 @@ int __init efi_tpm_eventlog_init(void)
 	}
 
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
-	if (memblock_reserve(efi.tpm_log, tbl_size)) {
-		pr_err("TPM Event Log memblock reserve fails (0x%lx, 0x%x)\n",
-		       efi.tpm_log, tbl_size);
-		ret = -ENOMEM;
-		goto out;
-	}
+	memblock_reserve(efi.tpm_log, tbl_size);
 
 	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR) {
 		pr_info("TPM Final Events table not present\n");
-- 
2.43.0

