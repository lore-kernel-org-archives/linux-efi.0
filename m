Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF03495518
	for <linux-efi@vger.kernel.org>; Wed,  2 Sep 2026 20:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788380131; cv=none; b=Vh4lm38F1G1rWoo8fZZMpMSWr20q9GzQihZOPFyGDK8YZDcK6f/F2Lgw2Her3BV6qYUxW9B6QrCh8VaUB/ZZLLcTW5PBdhUiC9WjTfNE4K7CnWYGV717gP5dfZx9fkrmbpLbRquXNKn9+W0COwyqf3JAQoDgi0lv/MkIFBJBrDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788380131; c=relaxed/simple;
	bh=JwyZ01kuAk/qfl+mFKMw2jltAZAwwxU9OjstgPcmPv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pp5Vmjmo7IlhxMWVQZz4nH2ISeNgm08zfGVX8pevWhsOo7+00JAcXddNEXFsZ2kUuz9Nxf2iXVl5lyklTLaTosHospiqgiofjnkk7pS6HgWoFbJXxehCsSNC+cv3IeGvaZZ3bM1+RDPHD3D4EWefwHWeFj+GsoO31r3SM0+ERyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWtdPkAC; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWtdPkAC"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7f3f52143cdso1215612a34.2
        for <linux-efi@vger.kernel.org>; Wed, 02 Sep 2026 13:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788380124; x=1788984924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RwvNUiQuAitNr4jRa/k1l/qEywBvK5orh/+JwgBfAtc=;
        b=XWtdPkACBA/wZ901baYeRiajj0eaMeZT0HCszyTR9KYxxzi4lVEgvn5OyjbIKlp2sq
         YO8HGGcTnUipFrDadS7CRNiOjkIaODQIvV7JuljzIqPIU/bHD2dm7PzEG4u5sKJ3evPI
         OeFNIy/Trpo4n09hFZugdbofAQ60ueTk8KRobDl5lcV5XKqJwq+3IcwnNnRW3bePnOiC
         /45MTllt47kA7qLClXNTSm6FqERK1hyzXVDDn/UsJKI5IKKFNkLde42m8nggOCBeU3S0
         N+Ht5cRW6kvNntqnRyXTrFDSUqbzKCekpavSxrdZl33zy4A1R2uqcfHnbAyaGYJmNfE7
         cXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788380124; x=1788984924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RwvNUiQuAitNr4jRa/k1l/qEywBvK5orh/+JwgBfAtc=;
        b=lz/t0ElTC6C6GPFkFW17/x0RbwaR59wPNcceiY4+34buefMLmogcvJLaQMJxn3wnMX
         sle9H/CcLy1H274smyCupX6LQh4N7jeU2IGHO/XoGMTQG0FZe/iqqUpv878/OoyoiM3+
         Il9rB8QlDUrBBBjII31hIBg0X419XC7dgIqxGW4OR+8HrCGYKDR2m4+0R4XA4DL8rZxk
         dL539h4faVvvDWEBNqR41pqI+S4AJ50vKIzPZ6T19+VnAy1vAuSOX+xtxT3IpgJz9Y0/
         CW3Gmyh2qpNUBtUDfqUCWSPdqZo8n4I12apSq9f6F99EnLjpVYben2gFP5Nip+wLJ2Ar
         p4CQ==
X-Forwarded-Encrypted: i=1; AHgh+RobPQh3yR+sR6LXiQE5Wj9BaBjOuvKZhKYF4a+WcVaoVY/hXDSdJrhCscieD5lTyhjSh+Q7bT18Ogc=@vger.kernel.org
X-Gm-Message-State: AFuF++nzqIcVEa9jE8Uz2bZt2p2I4FUb6DPA5OTbzHCFv2TCfh/3WpQk
	2ifBcN13HOQSlGjFAAfJcZ68+G3M8vRLixrva4gHvisOUh2m5fVlMkVm
X-Gm-Gg: AR+sD11GlmV4CLheXQZ7GV3Z3L0z0eUGiYF2ZT6uL1so+dOJY1zf7NRsecu+gawDhHW
	fYVKf9ooCN0eoczEhWMlIrPFqYlvBtCivFqJMDTJHmS+oi7uz8Pw6Y9hb4DLFBiHuwXAqkabvW1
	dxx8i9kCaktD98mYvMeN51H9fUe2BMxT4gq4G82oBSVZEE7eZK7Yg2cXXoSXhculCdLER6xmmrK
	xuCbL9vnyAY9wWVth5NLN3J1guxsSkMttvcJtmbSHirSF5Yau8et5Bvhp1izhybVBazZE9UW5eH
	vSeluegtqtt7vCcZtQNhdu8fQTSbhAHToI0tz4w5w4sk/P/qwCJnMnyB+yD7KcsuxRdBdkUjnnt
	2PYYaMHzVba7Rmett/G17dGYF2eKOguIWgVP5NZOiEqLbCylfXCC0Tf30AWhXqPN6qOuiSm1rix
	74HSQCocHGLcPF3FbHOAlrykRzzVOMb6J+ii/ZatbsCy/s9mKB38pq5NXxNC7xtXvnF8wv5DCuI
	9N332UpQrNub5pssiBoOIIW+D91yOo=
X-Received: by 2002:a05:6830:6317:b0:7f8:9fba:2cd8 with SMTP id 46e09a7af769-7f89fc97821mr2058368a34.9.1788380124278;
        Wed, 02 Sep 2026 13:15:24 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f74f8f7fbcsm3172554a34.23.2026.09.02.13.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 13:15:23 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH] efi/capsule: Replace kmap_atomic() with kmap_local_page()
Date: Wed,  2 Sep 2026 15:13:40 -0500
Message-ID: <20260902201340.70189-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmap_atomic() is deprecated in favour of kmap_local_page(), as described
in Documentation/mm/highmem.rst.

The conversion is safe here: the mapping is created and torn down within a
single iteration of the sg_count loop, preserving the strict stack-based
ordering that kmap_local_page() requires, and the mapped region is only
written to, so neither pagefault_disable() nor preempt_disable() is needed.
The surrounding code already sleeps (it allocates the pages with
alloc_page(GFP_KERNEL) and later takes capsule_mutex), so there is no
atomic context to preserve.

Build-tested only.

Assisted-by: LLM sparse
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---
 drivers/firmware/efi/capsule.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index dd6252638..417e8f13a 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -245,7 +245,7 @@ int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
 	for (i = 0; i < sg_count; i++) {
 		efi_capsule_block_desc_t *sglist;
 
-		sglist = kmap_atomic(sg_pages[i]);
+		sglist = kmap_local_page(sg_pages[i]);
 
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
 			u64 sz = min_t(u64, imagesize,
@@ -277,7 +277,7 @@ int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
 		 */
 		efi_capsule_flush_cache_range(sglist, PAGE_SIZE);
 #endif
-		kunmap_atomic(sglist);
+		kunmap_local(sglist);
 	}
 
 	mutex_lock(&capsule_mutex);
-- 
2.55.0

