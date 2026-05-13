Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A642218EB1
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680321; cv=none; b=a/6AYEaT267TBNz1Zfv7ZRvN/QH+Vb6RLeAkTP+46uJLVDE9rAh7FcKl+oPaweO1G/JNWxqq83ppcjONzoKLFMt/OQhStTQ9JsLNqqSdFRacd0EWdu9j+JENWNUxIqNk6UtuBw+wbtwIyNJCC6iIBZPkz7CRVAjsaYDETjOcWe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680321; c=relaxed/simple;
	bh=MBTIkQr2MEcBs67zT7lTt4IEZDPapqs2+YcvLVtmWa4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TuvDsxVdKqbhk4B8nDSUkP/LW1Nwm3n70xMiZHqmNoxKSCWnJ0yhIW2AMZbQKvxkqiPwpQDq8zmxi5N0a38wxj1scXzYaUVx5QgdOLRvl3BiE2651jmJkCzduDOgZBVUZ7FwokkU1MWC4AhQ+Nv6gJwiyIQ+sZIDccpAngrqYqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=dCfD1Zv9; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="dCfD1Zv9"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id B70ACC0109;
	Wed, 13 May 2026 16:51:54 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp) with ESMTPSA id ppLkjiGSViE0-Mzh5yw02;
	Wed, 13 May 2026 16:51:53 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1778680314; bh=sgqPZBhmLj4CjzmFgb1iK96kcHfpdHHB/4dRlyF8re0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=dCfD1Zv9ttQtvFyIJ9d86qEn4UqLYMHwHRDFEJlDcx38PQgd27NkoOBpDJC37t0us
	 TZsvodkrQAz06Kuag5Uh2xFc0gvU5Mr1wF/DDVAqZeznQTcCsT2uvTw89Kf/QbpMDp
	 ZhKMBQm/auLpmzDgB+FBWQUC1qelhSd9xgQMQEW4=
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
Subject: [PATCH v10 0/8] lib and lib/cmdline enhancements
Date: Wed, 13 May 2026 16:43:59 +0300
Message-ID: <20260513134407.884033-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is a merge of the recently posted [1] and [2]. The first
one is intended to adjust '_parse_integer_limit()' and 'memparse()' to
not ignore overflows, extend string to 64-bit integer conversion tests,
add KUnit-based test for 'memparse()' and fix kernel-doc glitches found
in lib/cmdline.c. The second one was originated from RISCV-specific
build fixes needed to integrate the former and now aims to provide
platform-specific double-word shifts and corresponding KUnit test.

This series was briefly tested on X86, RISCV32, ARM, and MIPS using QEMU.

Getting feedback from RISC-V core maintainers would be very helpful.

Special thanks to Andy Shevchenko, Charlie Jenkins, and Andrew Morton.

[1] https://lore.kernel.org/linux-riscv/20260403103338.1122415-1-dmantipov@yandex.ru
[2] https://lore.kernel.org/linux-riscv/20260427090105.705529-1-dmantipov@yandex.ru

Dmitry Antipov (8):
  lib: fix _parse_integer_limit() to handle overflow
  lib: fix memparse() to handle overflow
  lib: add more string to 64-bit integer conversion overflow tests
  lib/cmdline_kunit: add test case for memparse()
  lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
  riscv: add platform-specific double word shifts for riscv32
  lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
  riscv: fix building compressed EFI image

 arch/riscv/Kconfig                    |   3 -
 arch/riscv/kernel/image-vars.h        |   9 ++
 arch/riscv/lib/Makefile               |   1 +
 arch/riscv/lib/ashldi3.S              |  36 ++++++
 arch/riscv/lib/ashrdi3.S              |  36 ++++++
 arch/riscv/lib/lshrdi3.S              |  36 ++++++
 drivers/firmware/efi/libstub/Makefile |   3 +-
 lib/Kconfig.debug                     |  10 ++
 lib/cmdline.c                         |  30 +++--
 lib/kstrtox.c                         |  37 +++---
 lib/test-kstrtox.c                    |   6 +
 lib/tests/Makefile                    |   1 +
 lib/tests/cmdline_kunit.c             |  56 +++++++++
 lib/tests/shdi3_kunit.c               | 175 ++++++++++++++++++++++++++
 14 files changed, 410 insertions(+), 29 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S
 create mode 100644 lib/tests/shdi3_kunit.c

-- 
2.54.0

