Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208BD302146
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570051; cv=none; b=R6L8uzEU2HRb2+gQL8YShsOMKlL8yzl+O8ujrt0kCxoqIcgSkSAtvfuIsQQ5eikDrb5loGJcNzg39FAhJjnxppeJLTcznF2gAvD2SFxZK//hiY6VKuwgFpbczRBMSMb07Ua9KGp7EWZchu5ocH87+dY43E9cn28h7X/Ct7V7TkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570051; c=relaxed/simple;
	bh=C1oNciHcEscYHEFiBPOAp/Z1rml/FIlWarmSgscZ6yc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=muzozJjeL3H2pwNhyUebGaxnH1zjzV/1KSzVScPErEri91z/wCmaXiPZjNDkKRj19dUcib0i33WebXnb9Xga9dSgG7/N64G4mSxCirAtimROgAnGbOIO/JqIArTkFMzaoadEYk3N34iKM1PJzqL6+ULzn6tnSuZoKTSZP/Mg/fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ram7WL1U; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ram7WL1U"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e661c6440so34686175e9.3
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570048; x=1790174848; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SChD6gZN6HYF8sdEF4kgrqs3H/vnYWBrVFLBfW4Uqts=;
        b=ram7WL1UkFun17DGGjfsO6e/gXDih8BVBZPFc6KbHc+b7rw+7UxT/tQ2XAvTuXTaqB
         5oNh2oFIRZpK3VjWZpC0kSqSA5iIDhTIbO5Sds/bruL8eR+WkhjBiZj86N4sSaB3z7Aa
         GmMy8M6ACk/70uM/tMNBkwRgGAWC6dInIXAAtCCSrQBYPBeSFEar/674vTThJZseCqY/
         aB5t7kbNvAtUy9s6DYPdcvU8Fz0eIpyEYFZU3ZP+2562G88s/ASIzheutpWiFffoUgdo
         emC4bPyNhYhoJuqFgIVLlyXEPATiFEvCzN8LBYzHSN1TjkddQal/bcw/eTKqHdpRPNIV
         orrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570048; x=1790174848;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SChD6gZN6HYF8sdEF4kgrqs3H/vnYWBrVFLBfW4Uqts=;
        b=DN6ai7P3ZXcWtWpSPHmPFgq9tWTbueH6YtNXa+fHWJMriq6odnYreTqE6egI5FYn/1
         k6sBw2kKJbHdT25f+MhRvBHoVoOt1c48c9cS/Dgbk1hn8t9g6La4XESf2fcKMzELEE5D
         EW/n1hKc7B/DVTO2hqEfElMPuxpbQQe5Mi6Xm7KvOPn4fBwY5XJdNBva4mLo9eVWwphD
         R53rFrmtibeMlD9DshWcFsjjJt21kzfKT8b8E7EVRGNLd3uR6AD93sH/P7bYkSAuJvc8
         DlpfvYy+95Df1j6/s08I7PwVTyTFddYeK4LddaZVJpSzZA5qF1qFkoLALvp0XSLOUS0e
         0aWg==
X-Gm-Message-State: AFuF++mpD23kcwG5TGNwmFto2Yz7xuKhNyFoCs1OwjcXfVn6QQ4Eb4XD
	IAqLPyCT0KfQ+M7aQgjtiKkZ4cfQvXP5RccBl0bQTX0xJWBTc9YE8xn/UJfV5jScieX4nOPoSKW
	JVhJ9Jl+9wWOBydJtSp5Ww0aZodaiSAEnewug8WR3BIXCCll/05Sk6eo/Gy2Bgz9JNv4OZDb7Tv
	ALi3oZk5OpMysKXK5W3CaQcHeWpQxSww==
X-Received: from wmbgx11.prod.google.com ([2002:a05:600c:858b:b0:49f:646f:58cf])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b29:b0:49c:fa21:e74a
 with SMTP id 5b1f17b1804b1-49eb733e4camr32594375e9.32.1789570048115; Wed, 16
 Sep 2026 07:47:28 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:50 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=705; i=ardb@kernel.org;
 h=from:subject; bh=qgkzqtEAKN071Ee9/bQchBV2SIPhg66nmHFUwJgGBhA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6tt+qv/5vh6efeW1WvZCDaON99Uy1h/fbsCW8PJ8U
 GG1rLNYRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiIRRDDP8XLBYaKknVxKc+1
 dk897rVIyeXJI9vLkQG8B6x2Gj2pWsLIcGRGY0P9vA/Vou/Zp88LmcNlc31RyXOTjwttfZTsIw4 U8wIA
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-13-ardb+git@google.com>
Subject: [PATCH v3 2/9] lib/ucs2_string: Suppress modinfo when
 __DISABLE_EXPORTS is set
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Allow the UCS-2 string library to be reused in the EFI stub, by
suppressing the modinfo data that is usually emitted so that the library
can be built as a module.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/ucs2_string.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index d66fef9c9b81..f75fb4f7961a 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -165,5 +165,7 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
 }
 EXPORT_SYMBOL(ucs2_as_utf8);
 
+#ifndef __DISABLE_EXPORTS
 MODULE_DESCRIPTION("UCS2 string handling");
 MODULE_LICENSE("GPL v2");
+#endif
-- 
2.55.0.1032.g73a4cd73de-goog

