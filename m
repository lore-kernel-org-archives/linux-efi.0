Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F4A37882B
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570059; cv=none; b=GXPEGzm+yv3ytj6cK5nD2dMGGnCqSQZthKE35gm08mOWuf9W55dAHs5kCH5il0AIFmnAjgBMY3/hBZMPI3dN5nXWGvGP2t6yD/oVReysP30AvtZWK4tvpp6XBvkiIwTk0UkyXJ2v19ykubGqPeDSRTU8ANpHzj/0HoyBJqnDdfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570059; c=relaxed/simple;
	bh=bIJT8uMDZTPbPgXrXoz9RnHI2oQQ5zLTI3zimM37reo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YD8c+vCgv1mSd0f8OWClwPSe5pSVaAHSTvoJM5GBahdjCdr8w4OO1dLlLqp1/eiOaxViDsFpmfbWpfRWycDoSbUgQytScXYYQsd0Fs+xEz0Lfc045aqXUpUniNBY08b/VRuq5UJIhc0N7dHDWp4I4ZV6demCQCnP0LIXmibLGL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NsKcyqb4; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NsKcyqb4"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49b0e6638e3so51384575e9.2
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570055; x=1790174855; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3jhe110S+2cKvT84ngsYWk0WnYvffWOvM3X507E5BdI=;
        b=NsKcyqb45ucdRr+VxafTi5RmAMutKZHZHAkD1d4Pi9aIX0IzgXnQAem162CSiLmzw9
         /c1HL+RC8cn9hNomTFuleFwR8YsPVFZyR1MRbFOYqzcAr2YYY1KiQaZUf18XX1QkyuYG
         +vcZDuUcBmTurrMbFTeawTVsT15OyCWks/bQdYaYlDiXSw0+BcyNP9V8J7S3BD4LakJR
         //VH6tyW0g3i+NSa9IhNzYiZSxQLAeiA2gIvY4eWe/X9GdgnTnduuCyeX43pXNhimHs/
         X4cgvYUJOSSnPK9V69hzUYIBZTfLyW9vpuxREbkhnmVmgINXLXNvpFXPTfasLwBEPffn
         fAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570055; x=1790174855;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3jhe110S+2cKvT84ngsYWk0WnYvffWOvM3X507E5BdI=;
        b=qrOwuYwL1P0GI0m4h0itLYmpLGRUCKqUdjMPofK6cxZ1mmSBlwxr/MilLHkEAdXh33
         uHn0Z0iovRvT8jFIbGYcV7C1t0bm1tseFAnKgRvgGUUwRYUi+c4nmu/WItdKT/rGUsu9
         0M5mmzbb/krqCrI3urT8HI0SB9zdhTvEtKZgbcUbNyo9lGmkxgtwm91j799WWPqH1IA9
         xNCUS/N1mxMvn0gRTBnAm+n5tjAe0kQ1ig6aJuqqj6vtfafRyknmdf/Y+z1eXcSUXlH4
         DvAhCAImNW7Rk60BGAGHGPIBTNPbNR92vNEROopGIyGnD5oH0v1dYcfyCfObK0dOSB6U
         yKGw==
X-Gm-Message-State: AFuF++kIpi2kKJ2DJBSvz7uVc3q7MKz9mWSNxn1agGrvJ8mO3goORfae
	r233j9UCnX8PFH+7xATBCHYssK0FntOhYOic7YwDWE029kkisdgxSovwu2eAbii0Sl+85ofI/xY
	zpQ7KANYm2Fi45NTqWzM+QwgWmbVlFbM43TftzFqnoYroP5I/r6Klw9+525xaYYJ/iKaHpXYRsj
	3zsL6SyZ9/0rTFIMwUVdq/tG5zkP8oOQ==
X-Received: from wmsm42.prod.google.com ([2002:a05:600c:3b2a:b0:49e:6640:5820])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3547:b0:49c:f4e1:4c2d
 with SMTP id 5b1f17b1804b1-49eb732633bmr33661035e9.16.1789570055212; Wed, 16
 Sep 2026 07:47:35 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:56 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1793; i=ardb@kernel.org;
 h=from:subject; bh=otson7pfhqSkY1QgbBEJDWS7yLkDvmJ6XHiMyvjC6Nk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6keqHpt3XLg5//fp7Ed31t//tbBlenkyj6uSFs+2W
 45HAt84d5SyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJnFdlZNh35L792WdGd9d+
 qfz97KbQd7X2nedWxJhJnc7h0ytjuF/F8D81Kvrj8yNbDYy3zTqwXjvGdJugWUftgey7F/yYvKe 5L+MFAA==
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-19-ardb+git@google.com>
Subject: [PATCH v3 8/9] efi/libstub: Add efi_snprintf() to construct wide strings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The native EFI character set is UTF-16 (or in practice, UCS-2).
Implement efi_snprintf() to construct UTF-16 strings using printf style
templates. This will be used in a subsequent patch to set the
LoaderDevicePartUUID EFI variable.

Link: https://lore.kernel.org/all/20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h  |  1 +
 drivers/firmware/efi/libstub/vsprintf.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 36056c624782..880c1d0c464b 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1084,6 +1084,7 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 		  bool crlf);
 
 __printf(1, 2) int efi_printk(char const *fmt, ...);
+__printf(3, 4) int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...);
 
 void efi_free(unsigned long size, unsigned long addr);
 DEFINE_FREE(efi_pool, void *, if (_T) efi_bs_call(free_pool, _T));
diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 54b82ba798a2..071c8b245b68 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -508,3 +508,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 
 	return pos;
 }
+
+int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...)
+{
+       va_list args;
+       int i;
+
+       va_start(args, fmt);
+       i = efi_vsnprintf(buf, size, fmt, args, false);
+       va_end(args);
+       return i;
+}
-- 
2.55.0.1032.g73a4cd73de-goog

