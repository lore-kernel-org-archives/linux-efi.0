Received: from mail-vs2-f42.google.com (mail-vs2-f42.google.com [74.125.227.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71808125A0
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789783090; cv=none; b=DY7Ez3jGVoNxXENDOklXw5oGrw+oSy1qqouVgXIBHxenxAodNBjGz0iLU6RTqmJfVvOvqpaMLhwWcfhr288TmJwoV3hYEgWyMnG1TUFUFwxFH2/3Xc+l5WKT3i+lAF7yM6FQGExG8hwp+jPzEEaFXF75OYr8WhVc35E92ERW+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789783090; c=relaxed/simple;
	bh=hOgrTSzDHUXv8LSGsvtvmeAzYC/FIwUfTSU+XSPwXq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZGMgqT5xoj0823DDUO9k1SRIIS4pk2fmWfLM8n4FwiyIdEFpUFPG3Bs08ieXzH+oRbvv7wg3ZgQ0wLUjOShDGT5sfYSXv3uPv7gVUhWzfzSyURkUlm+dS2bm0dc6u7sSYKVkkh6U8adMOBlW9zKRo3QzKjJD6ThB9aPhh0ElD2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xn6BjCE0; arc=none smtp.client-ip=74.125.227.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xn6BjCE0"
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c963a787c9so497728e0c.2
        for <linux-efi@vger.kernel.org>; Fri, 18 Sep 2026 18:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789783088; x=1790387888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I6B0uMAA6o66TC8E1zzz+beTnTfyc+FYj8+MQ7ymYgI=;
        b=Xn6BjCE0OOuWonDCc3f6RlPKkIq87TmiAMwWodYur+BNlazuodbMbWBvX/ib8YGsrb
         QnYf3QJm6LXEqWtRjFkcjLsFgqHWK9uWkDM4YOShSF9HzzEEjaQYCNH3sEVsQwhwvfTU
         jJAsaqkDdV/Qdlen6VtAg9Yo9wu/cQH+INp7aXV3j9hnHB8ILFt8oDGDwjMbMAxmsRoj
         QvxhxicmYLgqFx/UXNI+r9psB4oTF+yIUIQ8a6hhhJgnlCjTMcdAqhjAlj3l7yBiI0ur
         tflxQh/1Ey/zKtqjVL+7d+VQOTRluLj7UurzhHWkVIjJYjIT2ybn6DWNj+2o2TE8pVSj
         fPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789783088; x=1790387888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I6B0uMAA6o66TC8E1zzz+beTnTfyc+FYj8+MQ7ymYgI=;
        b=pD9PgMgit4D1vY5gz4qEML9JlqBTebbSR9FZ5C3XWtBPOqGQROgTGMtr52MtrLuvyS
         TsX6fXVD5JJ7FHkbUSqwcM27XGC2Ld8lqq8zyKqyLclYKJB17LUXo7s9bFba0U17KkPm
         7FJ+zrGpzkS2jXPi16k9w+JNV0cPlEmmoUM7wlTGM5YHN6QcTpgp5k0XkEk8SBxE+Zga
         Nkf5mosicxncFIXzgDQb6xyrytbqOUAqYiOes7XJh271nYZzXInLUCJV+8R/z/gQyKcP
         xR4ve4XTpNQu0m8cU6Wi7fBXElyfbO8H2L0JFJyGV/7Ntoiwv6zJGLbm7KVU3vKnju2U
         MvYQ==
X-Gm-Message-State: AFuF++n81EP8JVWUw2A+D9rEkZQbdpPrrmdNVy98rIC0widMkWSMAeTI
	8rwph7JvSdPpFVu2GRMlwgzRwAAbrugJUf+LjMx2KDYB4rXwsMiOAnGR9/W/eg==
X-Gm-Gg: AYBFou1QGHP6jyILuspxHhlQiLcQ84UC9aDC3LEcoA1zF07mcEQueghlFoOHFv2mDji
	BjnmPFTO0C18lB3f7qQ6M+oj5n0KQY7mNxS6whgVLn87riK7q6LIVk47Kiei33N0tXfw5LgwUEU
	GGHxZeQVz09PwFL6p1qyo1o+A778S1HNsDAy9uglKch0nTLpvVKlXJkA71hN5lqkTeF/ByKILzE
	qG3ELCGx25ppf+n0TfqF3QHz/qHvbmvNXlOL4DQ8w/JVw5pnhlcGLyTV3jlK7VYIMe67X/hiB2H
	9apWJf8GbjLh+Rv4xlfmUWKs8US2WLKN9voB3fKM+vx/5s2Zd3cslP5L52NIsxSVYOHYZAfvFAi
	8/3vI1yYnttfOu8/BxivHU+AWheoI5nv+iXul8VmO6+4WWcf8j3sfOscOrQjh8mobw31I9LOvCV
	GUfskQuQTlQapibPtge2SWc4Eig4exvOQZHbZE5o3quT677Ylmflq4a2k2ZmoqYZQsG9PwWxw2j
	IdTnsfuyKpAOBPEPz+r9A9KJHX7JN4qsg==
X-Received: by 2002:a05:6122:d21:b0:5c9:a60b:e5c8 with SMTP id 71dfb90a1353d-5c9b59c5db9mr2550652e0c.11.1789783088260;
        Fri, 18 Sep 2026 18:58:08 -0700 (PDT)
Received: from DESKTOP-7QP7L26 ([191.181.70.182])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9c195a6desm1180864e0c.14.2026.09.18.18.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 18:58:07 -0700 (PDT)
From: dev12124 <joaoanandalima@gmail.com>
To: linux-efi@vger.kernel.org
Cc: dev12124 <joaoanandalima@gmail.com>
Subject: [PATCH] efi: Fix a typo in efi.c comment
Date: Fri, 18 Sep 2026 22:55:58 -0300
Message-ID: <20260919015558.1005-1-joaoanandalima@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d3..846179b23 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -8,7 +8,7 @@
  *
  * This code registers /sys/firmware/efi{,/efivars} when EFI is supported,
  * allowing the efivarfs to be mounted or the efivars module to be loaded.
- * The existance of /sys/firmware/efi may also be used by userspace to
+ * The existence of /sys/firmware/efi may also be used by userspace to
  * determine that the system supports EFI.
  */
 
-- 
2.55.0.windows.3

