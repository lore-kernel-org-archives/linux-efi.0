Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB112F1FE4
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570051; cv=none; b=QRJ8Zdz1Z779p6PtR81idH0iK3jzY+b75LTTNkOyzftG5ksWt19a8koWtDp4kCqhlVT1hso/eY2F8ZMbiiNfPg3RbzsorDoqqLRYZdgRUOaubIP4OJhrPetyiGV0bDoIXXx7VMgQYn1u9FYSYAMaBEycII1+2op6AtGWnsX3HuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570051; c=relaxed/simple;
	bh=2xhGhsnM6cFg9XqwguWnmGOLniqfg3yffsSq814n3oY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N8hgecYWPc1gybv8oPc9mdEyrvOA5tmL9U2hrrZdzYJV8Xu7ULry/rIe0E0KPH19L0j1C60Qg5O49KwyagldLyiZbTRjm6QmxoR6ijfrhk3K+OI8dxYyE8cuLGEyv1TXaTpka8JGNXF2COubKNsPo6mBBPsEuoESU1sQS8wuGKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C2TpLZgK; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C2TpLZgK"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-472c330e555so2581591f8f.1
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570047; x=1790174847; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=adQpVVPYDSCv+/CQimrvUBYO3H49guv1JLukjJuQ+Nw=;
        b=C2TpLZgKvbqrLxGl3GBqP4xjqJWRtdNDpVU6FsPgBOhCcy0ftRcorh66sutaniGFFs
         ff3kAVI+0FcQSF6by6xZTVW4PVrxg4LUU7P0lNApyzhgvPpC6vYGj4eUFBxfly/NwgOy
         koLsOqZxNQIqeiC5/PhODkSkwJy777tOZJiL9zxZok98bUSmwsRu+wkdRn2MxOzqYrdt
         fRGuO8P/rAB9pkNkhl574P95e/h1oPOvmiEbQJm/x5sgZKbUN5WOoIksCpSg84lVA2LS
         swNsOOvZLwbUHuHUh8YJbqwZTQkLKtU7OmPeC8QHdmyCkuBLQRklpc7LVTbB1koKCgh8
         puWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570047; x=1790174847;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=adQpVVPYDSCv+/CQimrvUBYO3H49guv1JLukjJuQ+Nw=;
        b=ohEWabv3X/BJI4er73EbFz07DXgbed/hAqnoeiSL2DWu5HF95qzB/kfrCp6lBs+EYe
         VmkFNHu8eq+NrsVNeADjP9Wk8jewkhd8p8UwvjgVHBMoX0HLFK4E0oWH4dB39yfsdLT0
         RHrBrpJ+BcV5EzuXnD85gHbkEdtMhNIGMgPLZVRyqnIZRVpMcP086AKqdTmXDamTlJcm
         9bq691Htpvin8jmFomb68BWknPds3J7sxl9JqgP4wFlpniZgvCuLdxsY608LOhN1JBkd
         oGnIZKHixIJklmtMQDcsJ1S4YDIiWq9DnPJgubnoupzdiLNiN2ZmIP3dqIPIs4RgvcAJ
         ZK3w==
X-Gm-Message-State: AFuF++l3vT2oLjQSDCgpy3VKvC36krFbn5TLdMqJ+ivc2Suz++gpbuWp
	lf3mwN0Ei1BGx3UifGRSDgUo8caERNWU1Vv02HyCDoLFssOhgEl0CTeHw31yLNQoPGudyknVfRB
	jPyGlXisIrEyJr53VafYni1mhb3/ciQzDIU5G1w67P8oLNWmqz60p4STCw18bySMd7dcYbmx5Ni
	xl/2Eqxm38stpY6YfQBy4yXgjiwaFhKA==
X-Received: from wmwb6-n1.prod.google.com ([2002:a05:600d:4446:10b0:49e:6be1:415d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f8f:b0:49c:cee2:1697
 with SMTP id 5b1f17b1804b1-49eb7322d4fmr34446395e9.16.1789570047100; Wed, 16
 Sep 2026 07:47:27 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:49 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=873; i=ardb@kernel.org;
 h=from:subject; bh=YU1ElVLaCeA6lifqtbLFaABcpHCwQcZWRxgO278csYc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6psf7zU3fTJ3kP7pnrSCtW6/kUitm/SL1rUPVDbVy
 +XXSdzpKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPR+Mrwz+Cdr4KHy9zUVRpu
 vu8vTT1+wvVhfMHvcusCT/mZ978bX2P4X6+7Y4b+MxXun7N/zfOMFN3XvMcubJGCiKjnp7z921d 2MAIA
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-12-ardb+git@google.com>
Subject: [PATCH v3 1/9] lib/ucs2_string: Drop arbitrary input size limit and
 associated WARN()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
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
2.55.0.1032.g73a4cd73de-goog

