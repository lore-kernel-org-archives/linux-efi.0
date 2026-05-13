Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE568258CD0
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680321; cv=none; b=sm0Qsi8dY0w6bhFWrnIbu8yK7OBig9BK+jzhKqLvwIpCzPxb6fiUxDRmjHIv9M/tBbjkLPuWhHScF8fhxML7z2QW0GyTzP6mudua0GPB8JgMNcac7Nolq+wh7hzCkemDMjrE4CBDo/E/xLG7qTi+k/k+hRFxnsVVEouoBOGMJik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680321; c=relaxed/simple;
	bh=5unapVmx2VbqB5nn/Gbx4ZyoZw7Grw7YupbOT+ZcRTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV5a4C04lBLJSD/rUSwHeqZWjQLel0ZsykdHFzyWEDDPrKnfBg9cJzsLLKkk9Po9XqKvWxJOLa8IfEXRQBUXrDu5DjliEpgtNeumitPNmkmeJBZh8enhj5DgYKe7POeTgdlah5HHvD4kR+y5jpYDN7Qhv8Wr0Bq4yBKCXNHW/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=sfEceLET; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="sfEceLET"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 04BDDC0121;
	Wed, 13 May 2026 16:51:56 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp) with ESMTPSA id ppLkjiGSViE0-2mqjxlxE;
	Wed, 13 May 2026 16:51:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1778680315; bh=TBxNdS4HSxmdP1AXz5UGyX20Ie/mR2EERiHh7P+Kz6A=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=sfEceLETzv9FrWpzv6xaEpmFWz50RPvI1bs8kPtJrunRk8RKm4vcg/FOLq/LPGH04
	 +rYjDV4vd9nppAZRxMf9Y0tk2x+byM1OSSyBS29nSrE7FSUZHBS60/YV2j8FpARoRe
	 QXmzwEZiyvoJbM2tBbEXNUBIurieFd5gcTp5Ubd8=
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
Subject: [PATCH v10 1/8] lib: fix _parse_integer_limit() to handle overflow
Date: Wed, 13 May 2026 16:44:00 +0300
Message-ID: <20260513134407.884033-2-dmantipov@yandex.ru>
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

In '_parse_integer_limit()', adjust native integer arithmetic
with near-to-overflow branch where 'check_mul_overflow()' and
'check_add_overflow()' are used to check whether an intermediate
result goes out of range, and denote such a case with ULLONG_MAX,
thus making the function more similar to standard C library's
'strtoull()'. Adjust comment to kernel-doc style as well.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v9 and upwards: bump version to match the series
v8: do not use explicit temporary in check_xxx_overflow()
    calls and handle overflow flag using separate variable
v7: drop redundant check against ULLONG_MAX and restore
    original comment
v6: more compact for-loop and minor style adjustments again
v5: minor brace style adjustment
v4: restore plain integer arithmetic and use check_xxx_overflow()
    on near-to-overflow branch only
v3: adjust commit message and comments as suggested by Andy
v2: initial version to join the series
---
 lib/kstrtox.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 97be2a39f537..edc4eb7c1bca 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -39,25 +39,30 @@ const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
 	return s;
 }
 
-/*
- * Convert non-negative integer string representation in explicitly given radix
- * to an integer. A maximum of max_chars characters will be converted.
+/**
+ * _parse_integer_limit - Convert integer string representation to an integer
+ * @s: Integer string representation
+ * @base: Radix
+ * @p: Where to store result
+ * @max_chars: Maximum amount of characters to convert
+ *
+ * Convert non-negative integer string representation in explicitly given
+ * radix to an integer. If overflow occurs, value at @p is set to ULLONG_MAX.
  *
- * Return number of characters consumed maybe or-ed with overflow bit.
- * If overflow occurs, result integer (incorrect) is still returned.
+ * This function is the workhorse of other string conversion functions and it
+ * is discouraged to use it explicitly. Consider kstrto*() family instead.
  *
- * Don't you dare use this function.
+ * Return: Number of characters consumed, maybe ORed with overflow bit
  */
 noinline
 unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *p,
 				  size_t max_chars)
 {
+	unsigned int rv, overflow = 0;
 	unsigned long long res;
-	unsigned int rv;
 
 	res = 0;
-	rv = 0;
-	while (max_chars--) {
+	for (rv = 0; rv < max_chars; rv++, s++) {
 		unsigned int c = *s;
 		unsigned int lc = _tolower(c);
 		unsigned int val;
@@ -76,15 +81,17 @@ unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned lon
 		 * it in the max base we support (16)
 		 */
 		if (unlikely(res & (~0ull << 60))) {
-			if (res > div_u64(ULLONG_MAX - val, base))
-				rv |= KSTRTOX_OVERFLOW;
+			if (check_mul_overflow(res, base, &res) ||
+			    check_add_overflow(res, val, &res)) {
+				res = ULLONG_MAX;
+				overflow = KSTRTOX_OVERFLOW;
+			}
+		} else {
+			res = res * base + val;
 		}
-		res = res * base + val;
-		rv++;
-		s++;
 	}
 	*p = res;
-	return rv;
+	return rv | overflow;
 }
 
 noinline
-- 
2.54.0

