Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B1C20D4FF
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789845867; cv=none; b=OxOWZloZjEHgR3GfMOD1KoYsH+PKcF31LNipDTxZ8bNTSD6VxQUhV7nmKWXLQPxbtc5HK30jdxhBbXaqCT1FaL8HEmPNvgK9kzkX9v90ZXWyaMsgyM3kQx9YJgboFQd6bJdskJ6ZbDkSCP3ewuFQJfbOmlL/rpDhOtibgD0vS2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789845867; c=relaxed/simple;
	bh=VVnhsfm3As+sMznpo73TbHUDuc6zMzaiuu2csJA8JAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KwwVTFYiNxkiH0QYuvojrM8kd2Cn1UnaVrQNeonCrugEeCfYrSpui8IoNHHa0wEBVTpfX3+5/Jhax7cgKETOItz4TScm+IuWbv9jR5xt2AGISgRycyzziASKkeQNCfybDThkwlELZmEZFaY4mriuUh2I3Ufwks/Pl95JGI+YovM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OoTH/dgy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoTH/dgy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso12537135e9.2
        for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 12:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789845863; x=1790450663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zCBYukoxlIjOQo0Rl4nFIpPvgCBBr+Fx+MuYyRfGWBg=;
        b=OoTH/dgyo4HBXuPL+vCIvony8Q0Y7KWL2bwFFWxSIxoW6Vkv5M0eodMXk3mKl123ht
         fGphbHxjBls36cnT7NSXgmSR8TxmJyFEik8+Nfr7zAvWhxSIiB33KSXZM13H5baeyvlR
         E1B9PCBlZYy6qv8qLUkI5brbYehV+zaOrxb0iX6iUTSm5YOTrhsKLGfi5FYJ1WbeE5m6
         nz5Dsbp9r7z9ZKNMFjZjJvio8Xds+SAHVznema/5+MJuY9SNofNeunmYl64TXmZHjt5u
         7r4uhDFQ8MXc0/GxQgSXEgz7La8xe/ZsZb4QEdOiSWu8Iz8/Vp9Z/qVvZLW9R6tzvfIQ
         5Cpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789845863; x=1790450663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zCBYukoxlIjOQo0Rl4nFIpPvgCBBr+Fx+MuYyRfGWBg=;
        b=tPW1GUggY5O16QWZHqOO2AAMRyMi+5vR31paeVjwkwwio02LP9nsfVf6FL4ENGTadY
         pINnBjoXMBhmtgcMJYE/oa1L77ZmL0f02r1EYHVDfQhUuev/R8ZUbNLdF3DFV8575TrJ
         DRKsrG356tedrTNimwpFjAjOKVjxJcrX3Do9emJwBTK2/jH3Gy7oP1M65vwjAk3ViHhB
         B0RWenGD6CHJ9mJVc7uu2A8spFRQi8XN5jUl/m5ST6jmP0LuwTJrg1SvDCFHgdcdj/4k
         jg1A1kyLOeJwKswoypBtx3Xf+am+pEjCMADsEOQzI8+fCMWMMGTWS2o8BOpVEQhUO0x0
         GFlA==
X-Forwarded-Encrypted: i=1; AKwUvBxBpUhw48YC38+OW6kJ3LbV3FlIIp+JCLQi6CYMnTzoKXGdoKJ+Qi9px3iaMcHdyrsTJ8ndxOtz4Lk=@vger.kernel.org
X-Gm-Message-State: AFuF++mAeNoNgpd3CriYVGeMWQYEj7/kHvMkAMfvrO+UCChdJvOnzHml
	juFqLi/zBo+v1wXfKkNF7dpocW+mthccckG2R2Cj/mDfbTUurcJAcyYs
X-Gm-Gg: AYBFou1hm95KKUCi5z8NN1T7fuaOehJRoMhavMmq0Gi8glbAHjL8HBwjsa5FrfkIazm
	WAEiBXTvxO574QBGCVQq/p4GoUz7MAOI/1OGAWp/ypPj/29dovZK8vw0uBN9cDc9nH5HXmsotVe
	gamyKesmQQbBElrywBjAQM5d/5BirgzMrpzOFFVbUFvzjUNv5xL4slfCUThB5EiNyaO7jqrKsHN
	DzuxbuLgweSXNaYknObQXjirXo75g9aRMlGBwPiekmjYCL4nt1Cu5fPRZ+1TFkkIMZcvc7ecjyr
	XFSpl91MGh9nAXI1l/6d8MmHzd/KEt5tpxsRbKeJYEkMWqmaRQC4/gnJ7F3X1L7zV4g1Cpq47SH
	zjzZclWVP4TuIuz4EHnIO5MH5m5y8SVB8lNNRXn+vtgWugycLEPWqK36Qf8xajfBgpFYijO9nOj
	wkKL0wHDjCy1O6UKKVf44g54NuQF/AmJT1GWkzRLA+GqfXNrOZtFvGQmlQEaI27AOH1jCboWe44
	/AoDHDRki0ZDsYrHWrOG0lSMirxledcBJ0zZQTaYF3LSuW2fnHT
X-Received: by 2002:a05:600c:3547:b0:49d:2562:d670 with SMTP id 5b1f17b1804b1-49fc56aef66mr88814505e9.14.1789845863475;
        Sat, 19 Sep 2026 12:24:23 -0700 (PDT)
Received: from fedora ([202.47.63.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc5748e56sm152023445e9.2.2026.09.19.12.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 12:24:23 -0700 (PDT)
From: Muhammad Bilal <meatuni001@gmail.com>
To: ardb@kernel.org
Cc: ivan.hu@canonical.com,
	ilias.apalodimas@linaro.org,
	mingo@kernel.org,
	matt@codeblueprint.co.uk,
	error27@gmail.com,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH] efi/efi_test: bound capsule_count to what the int loop index can hold
Date: Sun, 20 Sep 2026 00:24:10 +0500
Message-ID: <20260919192410.272516-1-meatuni001@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

efi_runtime_query_capsulecaps() only rejects capsule_count == ULONG_MAX
(to stop "capsule_count + 1" wrapping the kzalloc_objs() count to
zero), but then walks the array with
"for (i = 0; i < qcaps.capsule_count; i++)"
using a plain int i against an unsigned long bound. A capsule_count
between INT_MAX and ULONG_MAX - 1 lets i wrap through INT_MIN instead
of ever reaching the loop bound, and capsules[i] with a negative i
indexes before the allocation.

kzalloc_objs() would have to succeed at that size for the loop to be
reached at all, which bounds this in practice, but the check should
not rely on the allocator failing first. Reject any capsule_count
that would not fit in the int index up front.

Fixes: 092e72c9edab ("efi/efi_test: Prevent an Oops in efi_runtime_query_capsulecaps()")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
---
 drivers/firmware/efi/test/efi_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index d54d6a671326..683a0524dd31 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -611,7 +611,8 @@ static long efi_runtime_query_capsulecaps(unsigned long arg)
 	if (copy_from_user(&qcaps, qcaps_user, sizeof(qcaps)))
 		return -EFAULT;
 
-	if (qcaps.capsule_count == ULONG_MAX)
+	/* capsule_count is iterated over with a signed int index below */
+	if (qcaps.capsule_count >= INT_MAX)
 		return -EINVAL;
 
 	capsules = kzalloc_objs(efi_capsule_header_t, qcaps.capsule_count + 1);
-- 
2.55.0
