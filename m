Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C353B2FF7
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911173; cv=none; b=rpwQktYvrczEcxChEDE+cWemysxwGxgZG0er9gjrBlJYgR4aD1a8SQDprQi8lPxIdN962/x1OhBfGCNVw4bB18QFj6Vjwj3YiaTDXZJT1ApcJV+qXtdYkmsMxxu3mtbdANEZPc7OVCumlt/hKGbrIkHLCjpvLXAB23iqP5zEu7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911173; c=relaxed/simple;
	bh=pU9XzhtWF/juNTzf+Kd9/yslgyVQiqAiygT2kcnBFrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CWj6RPlnksAnl4o6jaD83brV6bqBNq5bDhTwM1laf7yXHGOy68ugh1Hz8OqB8+LTcvwSOSM+gd7YOKxE8xeFeQwBiKFchISGzTq3aeY2+jYa1cm2Rf2ctRYaxcR3iZnMgUUFhCy+Xxjn7KSXh2iOO1Jd1285sfOtGtZUexk3Jds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DCBDzp3J; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DCBDzp3J"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b53023d60so365053f8f.2
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911168; x=1774515968; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YGawXAqaadB5xFeamVCn/5S0jZogRGa3Ig3UqDmOVOM=;
        b=DCBDzp3JfKNW1kpC9lj9cE0vDuD9qIgZVJfAPFnlm6bnJWPNGoqv60KuLlud0v9Gq7
         jDusbsgaX4oSGyMC73XZHn4OTfvkzVFSOD4xdkhJa+q78rYN5W3VOvNksC5jyX2nNbh3
         vTLxZV7WnqMDUre3cD9s15ghr8sY8evDDt4ypvojJT1ExeSJxlRF986xoGrDPNPojh7X
         UsC26/CNc/StVIjkxQ5YLZtAT+bdJMDd2Oce6g0WZ/87daWKehNTuCTa6NjpfcKUOJik
         OUJDngT1FzKgis28VfXVzIKJBVZ9SjxUFM6KYZxMUXTOhs1hbzfBPTHS1R9JyJfUCIcr
         KGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911168; x=1774515968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGawXAqaadB5xFeamVCn/5S0jZogRGa3Ig3UqDmOVOM=;
        b=Pela5AFc3iE9wI9W6CVHrL8LAN7BaLfsL6FYCaNaPrQY8NiKb0zIZo40KCaaBVAvAe
         jpoJlJV4/zokizqjUjWm0iEegJCXd8MAeOVYlb9FQXsPhrS3+jrkWze4x4vWQ6Y5vy2H
         reRpM7C6aBuj8usFkTpPcrbe7ow3IzzsNSp6my12FSdsF8oDN0EO0U9qP3vO+YNKAYV9
         HmFRKJcFpDIObrKt09A6PyjEDAkVAuusXRsRlKyXxqpAyRJ70P/WNasEEX7e6PzLtulu
         wtxr1krNeopdWioeW0E2Zn1J6PII8gNj8/fOBIDk77fDO7XSpygbP7Gfmf0uDbiYsh/M
         i/1A==
X-Gm-Message-State: AOJu0YzbWKVToB624APlR4WbWqjjRroVjpsMZTfVc8LlcphXp7v3QV8X
	8FgognI2JEaEwwaF+0CaVpsnoU50XMjz9ngRAQEllsSa/TqRdpFPoT2/mKzhxA8y0wl0HrzSaQ=
	=
X-Received: from wrxa13.prod.google.com ([2002:a05:6000:100d:b0:439:b6b2:283c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2512:b0:43b:47ee:4586
 with SMTP id ffacd0b85a97d-43b527c2008mr10897294f8f.29.1773911168156; Thu, 19
 Mar 2026 02:06:08 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:36 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ardb@kernel.org;
 h=from:subject; bh=NdkNKC4V8OlXuyY5MZEVWounQEXYEBvCLAYHi0Q+s/Q=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3nsQ7cS/Kf2Qda1M9qaxzN5yrUvW45bwardb5q34uv
 ptutPtNRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIDzvD/8ozkkLNiwqUNt8N
 aT4Tcm3Z18Sd93dXKKXyTpDIP//x62tGhueC7xz+CqwPbFZae+rL/wPfJ52Qn1TEqrDYpuLn3Y+ KExgA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-27-ardb+git@google.com>
Subject: [PATCH v2 06/19] x86/efi: Defer sub-1M check from unmap to free stage
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

As a first step towards moving the free logic to a later stage
altogether, and only keeping the unmap and the realmode trampoline hack
during the early stage of freeing the boot service code and data
regions, move the logic that avoids freeing memory below 1M to the later
stage.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 24 +++++++++-----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 906e29754026..25f51d673ad6 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -475,18 +475,6 @@ void __init efi_unmap_boot_services(void)
 			size -= rm_size;
 		}
 
-		/*
-		 * Don't free memory under 1M for two reasons:
-		 * - BIOS might clobber it
-		 * - Crash kernel needs it to be reserved
-		 */
-		if (start + size < SZ_1M)
-			continue;
-		if (start < SZ_1M) {
-			size -= (SZ_1M - start);
-			start = SZ_1M;
-		}
-
 		/*
 		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
 		 * map are still not initialized and we can't reliably free
@@ -579,7 +567,17 @@ static int __init efi_free_boot_services(void)
 		return 0;
 
 	while (range->start) {
-		freed += efi_free_unreserved_subregions(range->start, range->end);
+		/*
+		 * Don't free memory under 1M for two reasons:
+		 * - BIOS might clobber it
+		 * - Crash kernel needs it to be reserved
+		 */
+		u64 start = max(range->start, SZ_1M);
+
+		if (start >= range->end)
+			continue;
+
+		freed += efi_free_unreserved_subregions(start, range->end);
 		range++;
 	}
 	kfree(ranges_to_free);
-- 
2.53.0.851.ga537e3e6e9-goog

