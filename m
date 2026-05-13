Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D46258CD0
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680327; cv=none; b=AvlDCogtivMgNIVxC8y6hbGTLZrmAM5KYhyAIb9/XbUeb9WFkEIoM2wyz92jBewO06s1O+1hgYKh4yXsmLWCJjXNv0F+vAagtj4UvVoMAyYdFlKoJRVVKdTuTVJgQgo8FT0DYRg/R0PXKDWuDxXXSQym/T9r1jl1KHWEu8YOhmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680327; c=relaxed/simple;
	bh=fEBy8PwiXNY8RhSQMbxjv/pfcxS3iIEOPQejxH/LpgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxQDbD7CPpHufim+hHqqOTzu2PfEUTsn5jYiSp1sEPNZHphkvAOBP4FFFjEpX+/gH7p9fPu7zSSFe+nQwAi1ORRZqLG1znhcrP73vUKe/HpAj3iiGoOnMa6/HySpmAkH0oAkGsdkgIKRmrZ0u/jMADgJ1GMxy78U0gvST8T0MjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=sFE5Byco; arc=none smtp.client-ip=178.154.239.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="sFE5Byco"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 83E74806B1;
	Wed, 13 May 2026 16:51:57 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp) with ESMTPSA id ppLkjiGSViE0-4ywCnrqc;
	Wed, 13 May 2026 16:51:56 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1778680316; bh=6V25NbAI3/rMJ9o0WKC5Hikn/U0EkOQjDi4xZKCFUJ8=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=sFE5Bycojkr64H7H/LMONHISrPgAPphPW74USzyw3KAWtFgR+OOlbFwWM7VSL5XXJ
	 XtD5qkr1lUdp4mWt9QZq7f448FcYRoyH39zJD1XNP7SP//TgiLQO4B907nlVzecxn7
	 +q7dKekoUwsSjdmX3OWsmxQ5urZuDiqk879Rn6A0=
Authentication-Results: mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v10 2/8] lib: fix memparse() to handle overflow
Date: Wed, 13 May 2026 16:44:01 +0300
Message-ID: <20260513134407.884033-3-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513134407.884033-1-dmantipov@yandex.ru>
References: <20260513134407.884033-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since '_parse_integer_limit()' (and so 'simple_strtoull()') is now
capable to handle overflow, adjust 'memparse()' to handle overflow
(denoted by ULLONG_MAX) returned from 'simple_strtoull()'. Also
use 'check_shl_overflow()' to catch an overflow possibly caused
by processing size suffix and denote it with ULLONG_MAX as well.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v9 and upwards: bump version to match the series
v8: do not use temporary in check_shl_overflow()
v7: do not double-adjust endptr and drop
    redundant check against ULLONG_MAX
v6: handle valid-suffix-only string like "k"
    as unrecognized, minor style adjustments
v5: initial version to join the series
---
 lib/cmdline.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index 90ed997d9570..f6e4b113ca9f 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -150,39 +150,46 @@ EXPORT_SYMBOL(get_options);
 unsigned long long memparse(const char *ptr, char **retptr)
 {
 	char *endptr;	/* local pointer to end of parsed string */
-
 	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
+	unsigned int shl = 0;
 
+	/* Consume valid suffix even in case of overflow. */
 	switch (*endptr) {
 	case 'E':
 	case 'e':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'P':
 	case 'p':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'T':
 	case 't':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'G':
 	case 'g':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'M':
 	case 'm':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'K':
 	case 'k':
-		ret <<= 10;
-		endptr++;
+		shl += 10;
 		fallthrough;
 	default:
 		break;
 	}
 
+	if (shl && likely(ptr != endptr)) {
+		/* Have valid suffix with preceding number. */
+		if (unlikely(check_shl_overflow(ret, shl, &ret)))
+			ret = ULLONG_MAX;
+		endptr++;
+	}
+
 	if (retptr)
 		*retptr = endptr;
 
-- 
2.54.0

