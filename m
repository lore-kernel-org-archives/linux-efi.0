Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094232C3257
	for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 07:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297044; cv=none; b=LooqUAPWWhmHBvsDsIoqne7ggD8ODn7U8y7iKvX0YKj4kr2n9tu0zbqBFL+8CNlvThFj7C09kdZcA3mCMYsIGtY9Ajamc7hpINP6AxX8/i+U1xnI/Yj/SLp8L+onVmIXtYjUwu9g5hUeTm45Jce73Ebm9pLjFfSf/8IyuQpBby4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297044; c=relaxed/simple;
	bh=6aTwQdRfTlZr6KPYAsI1pZcxvvIIVjR7PqzfXOD8IOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E4mC+DTomu8iCD3mXB+8LiX4aHUYFCDmMAjHXt1fg3ngSmoCAWFX0xlB5XrT5EG27vwPQf7HdTwi5AucddzW7u9uuCxCsbePWQKb+pqw/4eXj1eDML0tDFA+FABZeSQiyBVjFlZkX3D6fFzodwa0+JkpGMCwtfjPzaO833Rv4ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AliSbaUy; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AliSbaUy"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e7109321dso415541a91.3
        for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 00:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787297042; x=1787901842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/dT/kH2RMkdhW0wPnYVez698rdnGbsfuneIzdJ0ufp4=;
        b=AliSbaUyJGjVUsqA9+Xzc6izr86lWxUpkqdmQzUKgEmrYlOn5TCflQeaGnSFlIddk6
         ya8dpZis/OU3L3YgpxCx49Aor6yxLIAUOHgD7bJRvK2czGtTKTiJJxc7dlPry99uCfwT
         iwwVXcniZJl6zTUFQXysEesK8OzphZjqRyqxx745jYrT2kvW6GH+4vsMGk/LFh1zeURp
         Av+dK3BqL9T//9KttZvl/2vSH5LA9RA7u5c6I02sDAC0tYIDPPm0vEBhaeyw3iGvq1X1
         XE070hn6IP1bpmUPOBTc1wkIdAONuyebl7WYkhL/1tOCDxl0cbp1AI8eXwKywLfSkUM8
         W3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787297042; x=1787901842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/dT/kH2RMkdhW0wPnYVez698rdnGbsfuneIzdJ0ufp4=;
        b=DzfQtztCjS+S+FA3OCGtXc9n/Qf+t789bJCp2xbRxNK0lOZBxPwnKhcIysKuMdOuL0
         S1V623CLHONPoB781t3plGlrVvzHOi3ekOgRge34jkbvRyvm8MXEgox/FCjTyX8t1PjG
         QyrXmgpTfzFTPGf7bJ+XIbh2k6DT0e938v/VHtvad8121+kiyGnNbxduKEqib1vzuKox
         PICWbn64f/X/xza5kpKKkSKmubjUdgPT0WqakRUvaJkONq5Xe2lbQrG+BGj5+ZZhnFAD
         lPMRDClu2SO049ipLpZpGLrtFFVb1ttKeoGK08FbFWy+0EXhh3T+abrrxF7EcTAfz0zf
         bRJw==
X-Forwarded-Encrypted: i=1; AHgh+RoD7/OP1D3cheYgeMznWX2ACWVIIJDlXjbPvqIgpHi8nzreWKKbTis3yUTuynZMLmP2M1qIH0BI170=@vger.kernel.org
X-Gm-Message-State: AFuF++n+refN+BTaYybtRa+cSd40/5rCZc/fKt4XNtKvmu9fwpt1hsTN
	xxnmG+YODKDe3BsMyyG+i43aFVHsBU2PcvG9q8aCH5pPJkv0VNtgLvab
X-Gm-Gg: AR+sD138edkiAu14K4hleSudIBaG65Fiz18KjEjCEBS6R3oc5tzj2roj+Xuf9GRbZgv
	ipCDwmP4yEymPBQTE1/a+t/7O20Uc8va/EWJ5uhRCsV5gwb6MU8sjKuQaawB4iFo3FvoRzb7Pvb
	oY3cmZmseiNCpm6xTP1Z5vP1fmvS3kgYEDI41IAoPQ7ZWti/jRkh8uwgrm/oZonF2UOCv2vyTJi
	0gtcwmBseowGIklPg163BDr2bgAJ4/SM8C6o2yeNflW7vkGWbIrc3SyJRAk06ptAH8u1TlhCZW9
	zO7pdCCbaDyCsQBFdbYxU8vWwRPGwfXAg3IqfsJcLvOrpZSudOmSl3GyruMB2NzRusssd+krbT5
	jzW/OZCCgnGbaLjFmZlXBN2kvcxHSPsY9SzgDbxVfoGXnnF1aLX1Up0Jfvb0IdNRl9pNrdN7ckh
	GGH8tn5/ZL9ObWezAD8Kn9MgE27L8so0WBqxdZuNq5yqjUzamd956D6acAiHxmbph1AsXkVC3F
X-Received: by 2002:a17:90b:1b0b:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-395c35ac458mr7309206a91.6.1787297042374;
        Fri, 21 Aug 2026 00:24:02 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c467d907sm2025485a91.7.2026.08.21.00.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 00:24:01 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jens Axboe <axboe@kernel.dk>,
	linux-efi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: [PATCH 1/2] block: partitions: efi: report the right relation for last_usable_lba
Date: Fri, 21 Aug 2026 15:23:54 +0800
Message-ID: <20260821072355.2006771-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

The check rejects a header whose last_usable_lba is below its
first_usable_lba, but the message prints the two with ">" between them,
carried over from the preceding test against lastlba.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 block/partitions/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 9865d59093fa..76994d3edd1a 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -406,7 +406,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
-		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
+		pr_debug("GPT: last_usable_lba incorrect: %lld < %lld\n",
 			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
 			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
 		goto fail;
-- 
2.43.0

