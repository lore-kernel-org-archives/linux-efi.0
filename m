Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3297528643A
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680323; cv=none; b=fS6XFVlxw94hHJ87nd0hoCp8u6tqFbPpsj6suyrSc66ZY911XYkUZKhWUFzkJ5aTOP5l77ZUvjKwYZ23012EQPe720b6CJBUUWKvb4nIroQroVhcRdK8bB4wlZVq9R+zMA1TyKnvP3sy8dmRTwWolTDZgsqQBBYR5cv0WSuGP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680323; c=relaxed/simple;
	bh=qUVbE+TeHACIDYQtXvQZb/Jb/ZvYZJiXsNQli4gdvAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVlAIgMY5dNsi+YmXFI/D1F6pFabxFnItKakMMVoMJKZRJ3XgjaH9rFEzuMPIsEutV5Wjtm/n42sIbFcvy1yVdjv8BLGFJNpED6/PWFtMgQ8lITZw/JUKYeYz3fwmMV8VSiVbKVFK4w49fcX0ZFx+yHAxf2Wr5hkPdHtf7nH9/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=h3WHm6y4; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="h3WHm6y4"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 7D725C010B;
	Wed, 13 May 2026 16:52:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp) with ESMTPSA id ppLkjiGSViE0-cLRory1y;
	Wed, 13 May 2026 16:52:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1778680320; bh=TvbFunkv2EyimV0ymMZbjXhYDuTThqNebOOa38V8+rw=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=h3WHm6y4hVY4A7Z4I8afiDO0oMmC50VEqIlgqv5j8dJxz1CNWfYv5cRLXGXjBm0fY
	 fukp01/O7jvrC6FCfCAk4Pv1E0FaIlxcljkgZWLD+pkCKbidOKJBOF4t6WpK16Bx0S
	 VKgYuxsD2FcKLgvJvsYO4ogGuMb8Jyv/l1+lTZuA=
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
Subject: [PATCH v10 5/8] lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
Date: Wed, 13 May 2026 16:44:04 +0300
Message-ID: <20260513134407.884033-6-dmantipov@yandex.ru>
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

Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments
to match the commonly used style as suggested by kernel-doc -Wreturn.

Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2 and upwards: bump version to match the series
---
 lib/cmdline.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index f6e4b113ca9f..16cce6621cec 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -43,7 +43,7 @@ static int get_range(char **str, int *pint, int n)
  *	When @pint is NULL the function can be used as a validator of
  *	the current option in the string.
  *
- *	Return values:
+ *	Return:
  *	0 - no int in string
  *	1 - int found, no subsequent comma
  *	2 - int found including a subsequent comma
@@ -145,6 +145,9 @@ EXPORT_SYMBOL(get_options);
  *
  *	Parses a string into a number.  The number stored at @ptr is
  *	potentially suffixed with K, M, G, T, P, E.
+ *
+ *	Return: The value as recognized by simple_strtoull() multiplied
+ *	by the value as specified by suffix, if any.
  */
 
 unsigned long long memparse(const char *ptr, char **retptr)
@@ -205,7 +208,7 @@ EXPORT_SYMBOL(memparse);
  *	This function parses a string containing a comma-separated list of
  *	strings like a=b,c.
  *
- *	Return true if there's such option in the string, or return false.
+ *	Return: True if there's such option in the string or false otherwise.
  */
 bool parse_option_str(const char *str, const char *option)
 {
-- 
2.54.0

