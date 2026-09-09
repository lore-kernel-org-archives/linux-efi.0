Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541015476DF
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954960; cv=none; b=A5R94ax9jFQkwdp2ek+B0/OJM3TqLojt05U1O+ILjDjoRYvbYpg7a9nYv/HZ76PnbmiZhHLadvx79CbjiWuITCD1tRuClhEVyBu0Rp4QK+8R0uH+VWaWvNj0pqAjeiY/0BvSMUBMzp0etXNvLr1QLLNJYuo7qW5nYIIU+iVH1SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954960; c=relaxed/simple;
	bh=IdKBvI7mqdasCvjDRpPew5rCar4w3KM52tqCqnCnNoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hqTitV6pm+nV9Oz8FfkuTX3tED3UcxEYvijM0gM2vVC9JLsgCKHjEXzwNaP+ikXkFUu+vFquqlMOkq9AAURKu4DRMLc1z3TubM3g9WeK3h/iN7sm0n48SS4Wi2JV5NPumDLzWgxkax3btj1PTeE1eZb01Ff+waOIo+LBeo6o7UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QUA2wCfa; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QUA2wCfa"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a677b003aaso1676806a12.1
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954957; x=1789559757; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DJhrVBAWrexjqr5iinpdHbX84bROtKiyiiaiXCWB80M=;
        b=QUA2wCfaTNa6lQGgdS53rxkqbZKPtAYPDTn4ij3pvkmsv10S6SW/p1PlFrF3JO02j7
         r+DGqTI6GGnLw5qp5YpoohilAgTZ6V0HUMX6bhjp1Mbd6/TEKKCOg3tk5CJEpWYafrjp
         euUopM/+nRYtalEWx0sE7gasZCM1dw+053gGiI9NcGMpiWJxvf3LlG102JR5aEEOhX9u
         fUEhFCAc7hDsi3HnSr83qiAmTVF8W78tta+fz450mI98H74yPCW5g8FUs4DetiHFFXas
         hYzBgDPHY6adVu9zNF9FOtwgOyKGz06bJ4y7gdH8EkKOToe5MGye6NC299yzx9Wp/g47
         r72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954957; x=1789559757;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DJhrVBAWrexjqr5iinpdHbX84bROtKiyiiaiXCWB80M=;
        b=SMxAgYyCvXBN0Qs+ttrZTvj4prprGYq2d+/8DjuVFTr/p2oW85eS8e5cdUpRgKSGdl
         ic9tvfSLfrl00z2mLNct1KqHO4bU9EgKgh8ZuRJiVvQgauS5Kw9WMNWktI5yh06LRydu
         pd1UDo+0PVJg307VjFXGX4sb5zo0Y85/JDc/Z2a/5TzGQX7TYNMwyAyvjhoJZuh7ExYG
         UizK/NRApmC/dk+TzdrvMwJmG0iNJyYBw96tT0hoWYaRnba4+WXLpa3+m5Dspi3fuxqE
         buxR+b0a1GYR+xfHMV9MwmW6iOapco+SqvW33SjAuU8lBAgq98ocXh8zpu0O45K8+FNx
         MigA==
X-Gm-Message-State: AFuF++ljld3iEgAiAdHI40+BRFwiyxioK05/7UH1JJHVCW/1ULdOEZVz
	v9XEdeeaFGiI7obR4iSu0wv1rrbPi1IiDzyHrae3rTvt5PNRSczzX10Iv0SgHoesr7jiZTEguRQ
	/I0etrMyqumqT6zwBaR/tRYnkzSe7F7XNiNALSPzBJu49kdxm/qRBUvbdgAeHiVQWHIR+rJVxHM
	8Jnn37AamguP/i99kPfxl8dJiFqSjSWQ==
X-Received: from edvj18.prod.google.com ([2002:aa7:de92:0:b0:6a8:5f9:b58f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3783:b0:6a6:92ca:40a4
 with SMTP id 4fb4d7f45d1cf-6a696aa6121mr14983854a12.11.1788954957196; Wed, 09
 Sep 2026 04:55:57 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:33 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=873; i=ardb@kernel.org;
 h=from:subject; bh=DCPAKHSt1MvEF3l2OCYFuyQlxzeVLTEHo6sm95Z+hIo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp+lUMQbN/zXyXlMZ8hNW/ZbrPxhsJv0xLfqpfZqW8
 EqJLqaOUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMBEXKUaGielucQauXj8Cfqqs
 5C85ZO5hrtlSVm6mJx1l/vuV9tEYhv/RO8/sTCq0itBw2awhH9wRHnOkabmeyAN2idRi0/2X2Bg B
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-14-ardb+git@google.com>
Subject: [PATCH v2 02/10] lib/ucs2_string: Drop arbitrary input size limit and
 associated WARN()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

It's not really the job of library code to WARN and potentially bring
down the system (with panic_on_warn=1) on a condition that is fairly
arbitrary to begin with.

So drop the WARN_ON_ONCE() as well as the condition from ucs2_strscpy().

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/ucs2_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index 1f7dd4eb640a..d66fef9c9b81 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -57,7 +57,7 @@ ssize_t ucs2_strscpy(ucs2_char_t *dst, const ucs2_char_t *src, size_t count)
 	 * Ensure that we have a valid amount of space. We need to store at
 	 * least one NUL-character.
 	 */
-	if (count == 0 || WARN_ON_ONCE(count > INT_MAX / sizeof(*dst)))
+	if (count == 0)
 		return -E2BIG;
 
 	/*
-- 
2.55.0.1003.g10538fe699-goog

