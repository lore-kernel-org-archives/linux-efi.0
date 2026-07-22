Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103CB428472;
	Wed, 22 Jul 2026 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784755396; cv=none; b=dLAP9T9did0O/roUlwr+gIMuUGtGrr6utl4VQhopPaGoFnXcfoHABn/5qeD5Ff77AM2VSmETS9hzkzkwO/CXU6nlKBT4dR1TOgOsTNyaBQE7iHPAUgmQ20YD4jTEdUIVM4zYtA+MUtJzkDDsv+blev6KPZuU1pVT2+UHQoXBA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784755396; c=relaxed/simple;
	bh=6aUkzZWqKB7RPXYLcc+B5urwMB0PBLszWPwPbYm3wS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FWCph+zRnUEPYS5tAQ66IZN4t0Y5d7+B3zGGpUD01vaNe2cEMz/ICaZA2j2ww+RaybdoPWx8NpZk82eff2fTVzW9Yeid/EH8nQsUwCbGSUhV8qFoFZPCEczr8LZ8mCUW3BCBTWRYO8sEsqeNUmImb86V/2/fI51N4pI0gPPbYNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfyAotCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfyAotCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F99E1F000E9;
	Wed, 22 Jul 2026 21:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784755394;
	bh=+JO/EUa2o5LgJpUDtIMigDJYcjFDyXup/bOSrVnI4V4=;
	h=From:Date:Subject:To:Cc;
	b=GfyAotClHAz2kSRTnvqrYMkX6qfDxxWO+F2MZo0ITsKpS6GMge08RaBB2tPphhcUt
	 5IVttZyYK+OKidYYkbLzZQI74qdPb+6zHjVSN371gwUMitiQUgnt+Ij1VzVPufmIBm
	 N+VjFg8gt3VPmxCStLBBkeQGaTUwBDTOe5z/jAL+/4VF1fZAijznX4k8tzFH7a+Op1
	 BSfX5zjQxtssKGHsYcBRVVq0IEMT6p7Zc5IB8RcsRO9HfiB86agEsRUyosqIEDU8V7
	 IviiXJog0MVAbZHPwwlxkWXt8vEjsTafbDIbSYDoIbcKuLRcuu1tYK/QdNEEAljpeD
	 6ZnuTk+2apWcg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Wed, 22 Jul 2026 23:22:25 +0200
Subject: [PATCH] efi: make efi_guid_to_str() take a const GUID pointer
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-efi_guid_to_str-const-guid-v1-1-c12a105da2ee@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqEMAwAvyI5G+gGVsGvyFJqjJpLuzRdEcS/b
 /U4wzAnmGQVg6E5IcuupilWeLUN8BbiKqhzZSBHneuJUBb1609nX5K3kpFTtIK3wfCeKDBzv7g
 AdfDNNT6e+fi5rj++cbAtbAAAAA==
X-Change-ID: 20260722-efi_guid_to_str-const-guid-a5b2accc7f0a
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=968; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=6aUkzZWqKB7RPXYLcc+B5urwMB0PBLszWPwPbYm3wS8=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFmJJnsv21Ykqksa/X0RmJV9OjjuyX+GtGy17+0KyZKOf
 z3Ntrl2TGRhEONisBRTZFlWzsmt0FHoHXboryXMHFYmkCHSIg0MQMDCwJebmFdqpGOkZ6ptqGcI
 ZOgYMXBxCsBUG6gw/LMIN1sfN6M357u4u2k/u10Yd0qRWunuHi+2n6vuXUxbsZXhn5Lt5KgWy9s
 HZJV5Xzr/slxlculw3sGlfz17DkXNeRTYwQcA
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

efi_guid_to_str() only formats the GUID through the byte array passed to
the UUID printf formatter. It does not modify the GUID contents.

Make the input pointer const so callers can stringify GUIDs from const
data without a cast.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479684..cf5cc85e3fc8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -705,7 +705,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t right)
 }
 
 static inline char *
-efi_guid_to_str(efi_guid_t *guid, char *out)
+efi_guid_to_str(const efi_guid_t *guid, char *out)
 {
 	sprintf(out, "%pUl", guid->b);
         return out;

---
base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
change-id: 20260722-efi_guid_to_str-const-guid-a5b2accc7f0a

Best regards,
-- 
Vincent Mailhol <mailhol@kernel.org>

