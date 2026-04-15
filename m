Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203742D780E
	for <linux-efi@vger.kernel.org>; Wed, 15 Apr 2026 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776256364; cv=none; b=DBun0+Xuj+ZVij00cpKbwflY/as1y/AQfl70f8rFbU33v1qOgCrZn1NrAMJMxM9H89heN9DmxAf49AbonRICPYhxzgKObL8oH22SS3mMF3G46wYwlPIwK/WZ5pPwqBhaoqoYOpGJO3TbwkKYxVIFBg3gVMgZHlW+MLWOAALrmTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776256364; c=relaxed/simple;
	bh=1m6vcCapcKyi0P1pIB84z0t1oziQft46ivQ0rYE4ncg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX+kuwH4hMTV1pk9j+52j/CuZl08TlN91obPtT9TEW1ZuKCavAD77Swb3CXFnH9hasEtBux8BlFj0o1KljXRgXVKfaCwt2Y0jHqn4dhyGhJb0DGnzxjsjI5u/krmjRL91iQURtD9/SJHkABq8TWmTJeAlcqlB67ZRRd4fmIBfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=TY0/4cS1; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="TY0/4cS1"
Received: from mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1c:2e1d:0:640:64e7:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 60397C012E;
	Wed, 15 Apr 2026 15:32:31 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id QWLFfkFSpa60-AZI4VFys;
	Wed, 15 Apr 2026 15:32:30 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1776256350; bh=okwG1kbdI0J7alL1vWZeIo32wOcltwq41sD23duLJzo=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=TY0/4cS1Ii8ao/dzuC3QO/QQJb+rIrubDH3NOzXbGGsfJVy0VRzVUG189Hap5ut6o
	 sFsoIz8hTHyqgLDKN09U3IrL5UZ/VmCQ16nUyXGe9yn/eYLWWUMXMMw4lT69o6i+NI
	 Y54HZXiGDupORDl3INEiFkvshBbnOUXqwnjnkPG4=
Authentication-Results: mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v5 2/3] lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
Date: Wed, 15 Apr 2026 15:32:03 +0300
Message-ID: <20260415123204.1467909-3-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415123204.1467909-1-dmantipov@yandex.ru>
References: <20260415123204.1467909-1-dmantipov@yandex.ru>
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
index aac60b6cfa4b..b43f6346940f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2950,6 +2950,16 @@ config BITS_TEST
 
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
index 05f74edbc62b..db678ccdd8b1 100644
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

