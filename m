Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785E040961E;
	Tue, 19 May 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779211887; cv=none; b=lUNnlKfpksstYJMtjENrfhe47O77wasaKod4IZzu5Vz/9lZvF2D+HK9re/J202Gwu8jfY4LQR0Nz4yDnG3EtKmvC+Fz14zoz9JQoUS7H9FQnU1iRdo2Bw2zTHpKWuZEASMUjuoCHKndoe2ZV9zrLGuztR6Emva2pumL/73/tWbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779211887; c=relaxed/simple;
	bh=48e/NtcfrEecoxDCuEjuVsQCDDgGwjBQKc6n0WNja+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsqEcef06Y96WCL7DksXh6oOJ2VbI/iVH/HDIxmYDgGujQDt4YpGZRq1yJhXEFXLtGNF+Kdpe6tf/vO/L4ufOROGFbLO/l71hl+p5RkZhAZE3mc25elA+gHb6zxbxa6i9Heujwoe9kcTp9pz89cb/mZ9/r9NfW2clnXLGsnn0EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=w2+JShxA; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="w2+JShxA"
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward205a.mail.yandex.net (Yandex) with ESMTPS id EA7E5C5277;
	Tue, 19 May 2026 20:23:18 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:190d:0:640:bab5:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id 6DE4BC0188;
	Tue, 19 May 2026 20:23:11 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (smtp) with ESMTPSA id 0NVul40SU0U0-yH0wfFvb;
	Tue, 19 May 2026 20:23:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1779211390; bh=5sQTk16iTwRjsA7opO3KVlv5gR/NRWgPvIqwzzepJnA=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=w2+JShxAAgcXPB9AFl3ER7QVJRUTXPQasbyRsbFu/ThwFYRbj8f7TbU4PeY0xZZWN
	 3pflaEWzDWYlXtaM84auXB89Y2Ha7SjV942e278SARaIVubMV6O3dfguWjRy4TAcrL
	 hSpS9PocpF2LOaNdG62cVQ4Ck2z/9taUbJ3iUVtc=
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
Subject: [PATCH v11 4/8] lib/cmdline_kunit: add test case for memparse()
Date: Tue, 19 May 2026 20:22:55 +0300
Message-ID: <20260519172259.908980-5-dmantipov@yandex.ru>
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

Better late than never, now there is a long-awaited basic
test for 'memparse()' which is provided by cmdline.c.

Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v7 and upwards: bump version to match the series
v6: tests to check whether valid-suffix-only string is handled as unrecognized
v5: even more tests to trigger overflow with size suffix
v4: move actual overflow tests to test-kstrtox.c
v3: adjust style as suggested by Andy
v2: few more test cases to trigger overflows
---
 lib/tests/cmdline_kunit.c | 56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/lib/tests/cmdline_kunit.c b/lib/tests/cmdline_kunit.c
index c1602f797637..18b19c85baef 100644
--- a/lib/tests/cmdline_kunit.c
+++ b/lib/tests/cmdline_kunit.c
@@ -6,6 +6,7 @@
 #include <kunit/test.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
+#include <linux/sizes.h>
 #include <linux/string.h>
 
 static const char *cmdline_test_strings[] = {
@@ -139,11 +140,66 @@ static void cmdline_test_range(struct kunit *test)
 	} while (++i < ARRAY_SIZE(cmdline_test_range_strings));
 }
 
+struct cmdline_test_memparse_entry {
+	const char *input;
+	const char *unrecognized;
+	unsigned long long result;
+};
+
+static const struct cmdline_test_memparse_entry testdata[] = {
+	{ "0",				"",	0ULL },
+	{ "1",				"",	1ULL },
+	{ "a",				"a",	0ULL },
+	{ "k",				"k",	0ULL },
+	{ "E",				"E",	0ULL },
+	{ "0xb",			"",	11ULL },
+	{ "0xz",			"x",	0ULL },
+	{ "1234",			"",	1234ULL },
+	{ "04567",			"",	2423ULL },
+	{ "0x9876",			"",	39030LL },
+	{ "05678",			"8",	375ULL },
+	{ "0xabcdefz",			"z",	11259375ULL },
+	{ "0cdba",			"c",	0ULL },
+	{ "4K",				"",	SZ_4K },
+	{ "0x10k@0xaaaabbbb",		"@",	SZ_16K },
+	{ "32M",			"",	SZ_32M },
+	{ "067m:foo",			":",	55 * SZ_1M },
+	{ "2G;bar=baz",			";",	SZ_2G },
+	{ "07gz",			"z",	7ULL * SZ_1G },
+	{ "3T+data",			"+",	3 * SZ_1T },
+	{ "04t,ro",			",",	SZ_4T },
+	{ "012p",			"",	11258999068426240ULL },
+	{ "7P,sync",			",",	7881299347898368ULL },
+	{ "0x2e",			"",	46ULL },
+	{ "2E and more",		" ",	2305843009213693952ULL },
+	{ "18446744073709551615",	"",	ULLONG_MAX },
+	{ "0xffffffffffffffff0",	"",	ULLONG_MAX },
+	{ "1111111111111111111T",	"",	ULLONG_MAX },
+	{ "222222222222222222222G",	"",	ULLONG_MAX },
+	{ "3333333333333333333333M",	"",	ULLONG_MAX },
+};
+
+static void cmdline_test_memparse(struct kunit *test)
+{
+	const struct cmdline_test_memparse_entry *e;
+	unsigned long long ret;
+	char *retptr;
+
+	for (e = testdata; e < testdata + ARRAY_SIZE(testdata); e++) {
+		ret = memparse(e->input, &retptr);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when parsing '%s'", e->input);
+		KUNIT_EXPECT_EQ_MSG(test, *retptr, *e->unrecognized,
+				    "    when parsing '%s'", e->input);
+	}
+}
+
 static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_noint),
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_memparse),
 	{}
 };
 
-- 
2.54.0

