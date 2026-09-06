Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891BA3CF673;
	Sun,  6 Sep 2026 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700122; cv=none; b=edx384d9VZ4PGFV2ikzNQAWYPU3jvK11hpJF/bP/d1pNHNNdrBGhUILWyAUOR6ak6Yntq0PDdA2rFyyvQ0txFWIDzm+3ubVUo/nqVLD7C/9C8sfdaHco6kGhjoJmSgL6q9+vITEGZ9pZ74pO3qPIiH+96fN0oJpUhDofjZNLW9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700122; c=relaxed/simple;
	bh=l4TB+2TeCuTlY0OJCVLsunoaHu72Xx1EIrdqOvisbI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktpQow6tc5xF6EteMWn8TdnCsou2Pcxf63uebOssONmrG04iJnZf0vYYjm+BgG9shmtmHRCGMjVuWBMEBjthHm9rtcIOtVglGnylFFqC+eeQj4gP7xpwuCabZGt8qMS7eitiUPSVl55kD6YX4dn2O2r060pBeQBPCjcTAuSlcLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPjAsSUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPjAsSUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163881F00A3D;
	Sun,  6 Sep 2026 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700121;
	bh=fyc8LQ/Z+NjkucxXu1s7ry/SopNvj9pgZ/5QwdnIHAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPjAsSUOu4gQwC6Zov7asFzpOt9/5sayUJxodHyx3h5yN9iwS/WwEvhCZhMqwt8cV
	 snndP4OiabbTq5AUZHC8dINOBg7jHmr196GpDgnee9m8KWEH9ti90szAJY/pjU6JpY
	 KohLFxzg+x7C/a+pSiYwpFpim5ZGUovw9AEqg0yP7IvJ3Jl3UAgdNcvgQ4MbVhhnrn
	 yPD2dayoGd2ZCiDDKgJNrDTNsK9wnq9z69nim7sPrPuSzKtSQ04K3suwAPQtVBuYlq
	 BVSHPg0D2OnW5g3vbJEPphPedyYQI8u5wwQHcnFcysq19amS5Y+/LY27grayCQe66L
	 6pd8CyOsPGDIA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 2/7] lib/ucs2_string: Avoid WARN in library code
Date: Sun,  6 Sep 2026 15:08:20 +0200
Message-ID: <20260906130817.1151961-11-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=865; i=ardb@kernel.org; h=from:subject; bh=l4TB+2TeCuTlY0OJCVLsunoaHu72Xx1EIrdqOvisbI4=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6vFPC3xfFvst4Q2Wj/krGGwV6348aO6Jc91T3f/+v tBQ8/BwRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIoakM/6zrPr2aI52ZseLU kWXfWEX/nuP9PkvGWonxuTvzgiUTZ/1j+Ct6Nc/lrq1U0hvJ5q3cf2xcW5f47kpkMzAIneq/anv FAw4A
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

It's not really the job of library code to WARN and potentially bring
down the system (with panic_on_warn=1) on a condition that is really
not something to obsess over.

So drop the WARN_ON_ONCE() from ucs2_strscpy().

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/ucs2_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index 1f7dd4eb640a..d391c9d8eba5 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -57,7 +57,7 @@ ssize_t ucs2_strscpy(ucs2_char_t *dst, const ucs2_char_t *src, size_t count)
 	 * Ensure that we have a valid amount of space. We need to store at
 	 * least one NUL-character.
 	 */
-	if (count == 0 || WARN_ON_ONCE(count > INT_MAX / sizeof(*dst)))
+	if (count == 0 || count > INT_MAX / sizeof(*dst))
 		return -E2BIG;
 
 	/*
-- 
2.47.3

