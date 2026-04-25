Received: from forward202b.mail.yandex.net (forward202b.mail.yandex.net [178.154.239.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2CA352C34;
	Sat, 25 Apr 2026 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777143551; cv=none; b=vFPU5KIOi7HzBrqXRvxJoXjY2DRbNpG5lQG6/7DO+aaS2IEmVPJ9G0nMLgzifHjAb2Cm6GlQDXHUm3YyaTkFsq5gK1sJV8iwKvKmYkL9ZXQ+z8CIqnKEUOw6Bt76uiJs9cEp2G8v11gdzq0/KCQIFEleuAu1x3jKFxnc2VEN6+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777143551; c=relaxed/simple;
	bh=t+JcRm5NR2mybg/9h3cRQ8HtuNpS0l6wbFDxbMeOwHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIKz7cFP1ryZoXSfAxyJGpd8IN74OXy1p+Z1XctexGfmXoa9HcbeT+77u1K0M9Prpj64k4Pfpwzf3HwM3JhuMlu3s6AHCFXb06MoK+r4+gkHW0HcUFIBFGMkmZphJ5N36P1fqTnxjjITedZU1UJ1YCJ3xNoqIylL2lmq7uwiwls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=re8qZyEr; arc=none smtp.client-ip=178.154.239.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="re8qZyEr"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward202b.mail.yandex.net (Yandex) with ESMTPS id 0E246C33B6;
	Sat, 25 Apr 2026 21:52:11 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:143b:0:640:90e9:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 034CE80609;
	Sat, 25 Apr 2026 21:52:03 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (smtp) with ESMTPSA id upbkSmRSGOs0-0FmCQ9Rz;
	Sat, 25 Apr 2026 21:52:02 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777143122; bh=kgGSD4RFaRxsPKilZr3yCajnw4z8e4iF7+oPlH/eW88=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=re8qZyEr2P/QE1Gk17WJ4/UkUMbZewWqg6gea4Gi//IDiT9qC4M2LUz/lB0J5kgRw
	 /zjswcy+d+hyQkl0kySyvTw3Mm58m4h7QLgfSmiCfxOp2a/D96W5cE7deB2eExpDWV
	 QQ7e04ja5TO1434sSSCXHv4Mu3EL6fe3QT7lrpGg=
Authentication-Results: mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v6 2/3] lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
Date: Sat, 25 Apr 2026 21:51:49 +0300
Message-ID: <20260425185151.477442-3-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260425185151.477442-1-dmantipov@yandex.ru>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add KUnit tests for '__ashldi3()', '__ashrdi3()', and '__lshrdi3()'
helper functions used to implement 64-bit arithmetic shift left,
arithmetic shift right and logical shift right, respectively,
on a 32-bit CPUs.

Tested with 'qemu-system-riscv32 -M virt' and 'qemu-system-arm -M virt'.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v4 and upwards: bump version to match the series
v3: more tests by Charlie Jenkins
v2: include test-specific headers rather than generic linux/kernel.h
---
 lib/Kconfig.debug       |  10 +++
 lib/tests/Makefile      |   1 +
 lib/tests/shdi3_kunit.c | 175 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 lib/tests/shdi3_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8ff5adcfe1e0..ea036ebce64f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2971,6 +2971,16 @@ config BITS_TEST
 
 	  If unsure, say N.
 
+config SHDI3_KUNIT_TEST
+	tristate "KUnit test for __ashldi3(), __ashrdi3(), and __lshrdi3()"
+	depends on KUNIT
+	depends on (32BIT || ARM)
+	help
+	  This builds the unit test for __ashldi3(), __ashrdi3(), and
+	  __lshrdi3() helper functions used to implement 64-bit arithmetic
+	  shift left, arithmetic shift right and logical shift right,
+	  respectively, on a 32-bit CPUs.
+
 config SLUB_KUNIT_TEST
 	tristate "KUnit test for SLUB cache error detection" if !KUNIT_ALL_TESTS
 	depends on SLUB_DEBUG && KUNIT
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 7e9c2fa52e35..4ead57602eac 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_BASE64_KUNIT) += base64_kunit.o
 obj-$(CONFIG_BITOPS_KUNIT) += bitops_kunit.o
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
+obj-$(CONFIG_SHDI3_KUNIT_TEST) += shdi3_kunit.o
 obj-$(CONFIG_BLACKHOLE_DEV_KUNIT_TEST) += blackhole_dev_kunit.o
 obj-$(CONFIG_CHECKSUM_KUNIT) += checksum_kunit.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
diff --git a/lib/tests/shdi3_kunit.c b/lib/tests/shdi3_kunit.c
new file mode 100644
index 000000000000..44f65e66512b
--- /dev/null
+++ b/lib/tests/shdi3_kunit.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR Apache-2.0
+/*
+ * Test cases for __ashldi3(), __ashrdi3(), and __lshrdi3().
+ */
+
+#include <linux/array_size.h>
+#include <linux/module.h>
+#include <linux/libgcc.h>
+#include <kunit/test.h>
+
+struct shdi3_test_entry {
+	long long input;
+	int shift;
+	long long result;
+};
+
+static const struct shdi3_test_entry ashldi3_testdata[] = {
+	/* https://github.com/llvm/llvm-project/compiler-rt/test/builtins/Unit/ashldi3_test.c */
+	{ 0x0123456789ABCDEFLL, 0, 0x123456789ABCDEFLL },
+	{ 0x0123456789ABCDEFLL, 1, 0x2468ACF13579BDELL },
+	{ 0x0123456789ABCDEFLL, 2, 0x48D159E26AF37BCLL },
+	{ 0x0123456789ABCDEFLL, 3, 0x91A2B3C4D5E6F78LL },
+	{ 0x0123456789ABCDEFLL, 4, 0x123456789ABCDEF0LL },
+	{ 0x0123456789ABCDEFLL, 28, 0x789ABCDEF0000000LL },
+	{ 0x0123456789ABCDEFLL, 29, 0xF13579BDE0000000LL },
+	{ 0x0123456789ABCDEFLL, 30, 0xE26AF37BC0000000LL },
+	{ 0x0123456789ABCDEFLL, 31, 0xC4D5E6F780000000LL },
+	{ 0x0123456789ABCDEFLL, 32, 0x89ABCDEF00000000LL },
+	{ 0x0123456789ABCDEFLL, 33, 0x13579BDE00000000LL },
+	{ 0x0123456789ABCDEFLL, 34, 0x26AF37BC00000000LL },
+	{ 0x0123456789ABCDEFLL, 35, 0x4D5E6F7800000000LL },
+	{ 0x0123456789ABCDEFLL, 36, 0x9ABCDEF000000000LL },
+	{ 0x0123456789ABCDEFLL, 60, 0xF000000000000000LL },
+	{ 0x0123456789ABCDEFLL, 61, 0xE000000000000000LL },
+	{ 0x0123456789ABCDEFLL, 62, 0xC000000000000000LL },
+	{ 0x0123456789ABCDEFLL, 63, 0x8000000000000000LL },
+};
+
+static void shdi3_test_ashldi3(struct kunit *test)
+{
+	const struct shdi3_test_entry *e;
+	long long ret;
+
+	for (e = ashldi3_testdata;
+	     e < ashldi3_testdata + ARRAY_SIZE(ashldi3_testdata); e++) {
+		ret = __ashldi3(e->input, e->shift);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when evaluating __ashldi3(%lld, %d)",
+				    e->input, e->shift);
+	}
+}
+
+static const struct shdi3_test_entry ashrdi3_testdata[] = {
+	/* https://github.com/llvm/llvm-project/compiler-rt/test/builtins/Unit/ashrdi3_test.c */
+	{ 0x0123456789ABCDEFLL, 0, 0x123456789ABCDEFLL },
+	{ 0x0123456789ABCDEFLL, 1, 0x91A2B3C4D5E6F7LL },
+	{ 0x0123456789ABCDEFLL, 2, 0x48D159E26AF37BLL },
+	{ 0x0123456789ABCDEFLL, 3, 0x2468ACF13579BDLL },
+	{ 0x0123456789ABCDEFLL, 4, 0x123456789ABCDELL },
+	{ 0x0123456789ABCDEFLL, 28, 0x12345678LL },
+	{ 0x0123456789ABCDEFLL, 29, 0x91A2B3CLL },
+	{ 0x0123456789ABCDEFLL, 30, 0x48D159ELL },
+	{ 0x0123456789ABCDEFLL, 31, 0x2468ACFLL },
+	{ 0x0123456789ABCDEFLL, 32, 0x1234567LL },
+	{ 0x0123456789ABCDEFLL, 33, 0x91A2B3LL },
+	{ 0x0123456789ABCDEFLL, 34, 0x48D159LL },
+	{ 0x0123456789ABCDEFLL, 35, 0x2468ACLL },
+	{ 0x0123456789ABCDEFLL, 36, 0x123456LL },
+	{ 0x0123456789ABCDEFLL, 60, 0 },
+	{ 0x0123456789ABCDEFLL, 61, 0 },
+	{ 0x0123456789ABCDEFLL, 62, 0 },
+	{ 0x0123456789ABCDEFLL, 63, 0 },
+	{ 0xFEDCBA9876543210LL, 0, 0xFEDCBA9876543210LL },
+	{ 0xFEDCBA9876543210LL, 1, 0xFF6E5D4C3B2A1908LL },
+	{ 0xFEDCBA9876543210LL, 2, 0xFFB72EA61D950C84LL },
+	{ 0xFEDCBA9876543210LL, 3, 0xFFDB97530ECA8642LL },
+	{ 0xFEDCBA9876543210LL, 4, 0xFFEDCBA987654321LL },
+	{ 0xFEDCBA9876543210LL, 28, 0xFFFFFFFFEDCBA987LL },
+	{ 0xFEDCBA9876543210LL, 29, 0xFFFFFFFFF6E5D4C3LL },
+	{ 0xFEDCBA9876543210LL, 30, 0xFFFFFFFFFB72EA61LL },
+	{ 0xFEDCBA9876543210LL, 31, 0xFFFFFFFFFDB97530LL },
+	{ 0xFEDCBA9876543210LL, 32, 0xFFFFFFFFFEDCBA98LL },
+	{ 0xFEDCBA9876543210LL, 33, 0xFFFFFFFFFF6E5D4CLL },
+	{ 0xFEDCBA9876543210LL, 34, 0xFFFFFFFFFFB72EA6LL },
+	{ 0xFEDCBA9876543210LL, 35, 0xFFFFFFFFFFDB9753LL },
+	{ 0xFEDCBA9876543210LL, 36, 0xFFFFFFFFFFEDCBA9LL },
+	{ 0xAEDCBA9876543210LL, 60, 0xFFFFFFFFFFFFFFFALL },
+	{ 0xAEDCBA9876543210LL, 61, 0xFFFFFFFFFFFFFFFDLL },
+	{ 0xAEDCBA9876543210LL, 62, 0xFFFFFFFFFFFFFFFELL },
+	{ 0xAEDCBA9876543210LL, 63, 0xFFFFFFFFFFFFFFFFLL },
+};
+
+static void shdi3_test_ashrdi3(struct kunit *test)
+{
+	const struct shdi3_test_entry *e;
+	long long ret;
+
+	for (e = ashrdi3_testdata;
+	     e < ashrdi3_testdata + ARRAY_SIZE(ashrdi3_testdata); e++) {
+		ret = __ashrdi3(e->input, e->shift);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when evaluating __ashrdi3(%lld, %d)",
+				    e->input, e->shift);
+	}
+}
+
+static const struct shdi3_test_entry lshrdi3_testdata[] = {
+	/* https://github.com/llvm/llvm-project/compiler-rt/test/builtins/Unit/lshrdi3_test.c */
+	{ 0x0123456789ABCDEFLL, 0, 0x123456789ABCDEFLL },
+	{ 0x0123456789ABCDEFLL, 1, 0x91A2B3C4D5E6F7LL },
+	{ 0x0123456789ABCDEFLL, 2, 0x48D159E26AF37BLL },
+	{ 0x0123456789ABCDEFLL, 3, 0x2468ACF13579BDLL },
+	{ 0x0123456789ABCDEFLL, 4, 0x123456789ABCDELL },
+	{ 0x0123456789ABCDEFLL, 28, 0x12345678LL },
+	{ 0x0123456789ABCDEFLL, 29, 0x91A2B3CLL },
+	{ 0x0123456789ABCDEFLL, 30, 0x48D159ELL },
+	{ 0x0123456789ABCDEFLL, 31, 0x2468ACFLL },
+	{ 0x0123456789ABCDEFLL, 32, 0x1234567LL },
+	{ 0x0123456789ABCDEFLL, 33, 0x91A2B3LL },
+	{ 0x0123456789ABCDEFLL, 34, 0x48D159LL },
+	{ 0x0123456789ABCDEFLL, 35, 0x2468ACLL },
+	{ 0x0123456789ABCDEFLL, 36, 0x123456LL },
+	{ 0x0123456789ABCDEFLL, 60, 0 },
+	{ 0x0123456789ABCDEFLL, 61, 0 },
+	{ 0x0123456789ABCDEFLL, 62, 0 },
+	{ 0x0123456789ABCDEFLL, 63, 0 },
+	{ 0xFEDCBA9876543210LL, 0, 0xFEDCBA9876543210LL },
+	{ 0xFEDCBA9876543210LL, 1, 0x7F6E5D4C3B2A1908LL },
+	{ 0xFEDCBA9876543210LL, 2, 0x3FB72EA61D950C84LL },
+	{ 0xFEDCBA9876543210LL, 3, 0x1FDB97530ECA8642LL },
+	{ 0xFEDCBA9876543210LL, 4, 0xFEDCBA987654321LL },
+	{ 0xFEDCBA9876543210LL, 28, 0xFEDCBA987LL },
+	{ 0xFEDCBA9876543210LL, 29, 0x7F6E5D4C3LL },
+	{ 0xFEDCBA9876543210LL, 30, 0x3FB72EA61LL },
+	{ 0xFEDCBA9876543210LL, 31, 0x1FDB97530LL },
+	{ 0xFEDCBA9876543210LL, 32, 0xFEDCBA98LL },
+	{ 0xFEDCBA9876543210LL, 33, 0x7F6E5D4CLL },
+	{ 0xFEDCBA9876543210LL, 34, 0x3FB72EA6LL },
+	{ 0xFEDCBA9876543210LL, 35, 0x1FDB9753LL },
+	{ 0xFEDCBA9876543210LL, 36, 0xFEDCBA9LL },
+	{ 0xAEDCBA9876543210LL, 60, 0xALL },
+	{ 0xAEDCBA9876543210LL, 61, 0x5LL },
+	{ 0xAEDCBA9876543210LL, 62, 0x2LL },
+	{ 0xAEDCBA9876543210LL, 63, 0x1LL },
+};
+
+static void shdi3_test_lshrdi3(struct kunit *test)
+{
+	const struct shdi3_test_entry *e;
+	long long ret;
+
+	for (e = lshrdi3_testdata;
+	     e < lshrdi3_testdata + ARRAY_SIZE(lshrdi3_testdata); e++) {
+		ret = __lshrdi3(e->input, e->shift);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when evaluating __lshrdi3(%lld, %d)",
+				    e->input, e->shift);
+	}
+}
+
+static struct kunit_case shdi3_test_cases[] = {
+	KUNIT_CASE(shdi3_test_ashldi3),
+	KUNIT_CASE(shdi3_test_ashrdi3),
+	KUNIT_CASE(shdi3_test_lshrdi3),
+	{}
+};
+
+static struct kunit_suite shdi3_test_suite = {
+	.name = "shdi3",
+	.test_cases = shdi3_test_cases,
+};
+kunit_test_suite(shdi3_test_suite);
+
+MODULE_DESCRIPTION("Test cases for __ashldi3(), __ashrdi3(), and __lshrdi3()");
+MODULE_LICENSE("GPL");
-- 
2.53.0

