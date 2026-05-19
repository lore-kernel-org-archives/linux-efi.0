Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [178.154.239.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD825226CF6;
	Tue, 19 May 2026 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779211401; cv=none; b=e/JJ9zh1SnqZWxzHcHkwmE++Mg9lOI37pUkGa54UrmpAgHTuJGq/IcKXPbqtHswtibY3Jj6SaFq+REF0kDg7jmLkPxUNegC7TrqnQ5pcs+NZYNgpka+JaoVNk93yc74cgBoN6qOhTA/xzK7hugt8XoBeJCYsvQyxHiArvhx8Pu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779211401; c=relaxed/simple;
	bh=fEBy8PwiXNY8RhSQMbxjv/pfcxS3iIEOPQejxH/LpgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNivNlYuL6XoDs6iau0yyjAritGeBbGr4V4ReYZGFp5Tt1hJl7G6VyMBJUmPzoefMytG7m8B+e1yEL6uk89ie/+qjKGM/wmX/4K0yDCV273yzBnJ5CoNEDY1qTKtLGL+x5YRa+j9ZT7F3gzsZ21/rbefMPJdwqucnu1eMQU0NRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=wM4ir5Wg; arc=none smtp.client-ip=178.154.239.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="wM4ir5Wg"
Received: from mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:190d:0:640:bab5:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 01273C0051;
	Tue, 19 May 2026 20:23:09 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (smtp) with ESMTPSA id 0NVul40SU0U0-h1uA6rsG;
	Tue, 19 May 2026 20:23:08 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1779211388; bh=6V25NbAI3/rMJ9o0WKC5Hikn/U0EkOQjDi4xZKCFUJ8=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=wM4ir5WgqIXnjYDbIyTg9dAD0zEBOQtMGJz5TaHG1TXnN65QbqlWTWHyaZObz0Mpt
	 QjgQiiV2gjDDLTPKG/8k/+zr2/AxW91nyxIuFGkZLRS777skPEjId5yHX1BBU94Si3
	 BEudjJf64ax3eLeRhYSKfswPGMyXn0On+U2hscZM=
Authentication-Results: mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
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
	linux-kernel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v11 2/8] lib: fix memparse() to handle overflow
Date: Tue, 19 May 2026 20:22:53 +0300
Message-ID: <20260519172259.908980-3-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519172259.908980-1-dmantipov@yandex.ru>
References: <20260519172259.908980-1-dmantipov@yandex.ru>
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

