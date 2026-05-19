Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0763DB306;
	Tue, 19 May 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779211852; cv=none; b=l+V2F5pm0nps93aUvKNbfKiFr7CJasRVR0AvJPgG8sJcRV21KENC/u5P+SEF5iExfDusuwcsOVBtNxBhLVMk64SN18hqcqTFuA6YnS6aMVTCw2z7NuWFEAOcJH93YESPIyWbsMLt2P1hJXGj23i+BDVr1wvWo63Xi0i/rA3AVbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779211852; c=relaxed/simple;
	bh=ChjV+RX21wsTHhXk41HxPe1AgJy7mUy5Sua/9oHCIB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHROjZScnFWP22sanfj4VCXAUS11wpq78IEvp+p/zplYrKFWPM9tL1m2mYoHNSDt7i28J/iYVkmh7uLRIDtDmW1DP21+8rkvx1M4yXz21Ih1UT+kL4RiGTAiVrDzLM8kzr+9wzMT0tqUv2RLjlPpxemvdWSDb6ghZCEW96JGz38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Eb1W3Qdo; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Eb1W3Qdo"
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward205a.mail.yandex.net (Yandex) with ESMTPS id 09CE4C507D;
	Tue, 19 May 2026 20:23:13 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:190d:0:640:bab5:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id AEC44C0169;
	Tue, 19 May 2026 20:23:04 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (smtp) with ESMTPSA id 0NVul40SU0U0-fzsC5bFj;
	Tue, 19 May 2026 20:23:03 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1779211383; bh=7c+9bkOD0NfFHWVEjJO5bWET/2NkPh9vtXTbM/GJVa0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Eb1W3Qdo5DuQUgcIIMYkjGapyo9UIgOGw6gYQY4cQm0/1krvxkzC8K2Qx3gJNaN2g
	 thGnc3BY7nmen/bFnS2hs71Y+X6fdCjc7MYyVVs6wXbedziBrL2ysQSJ5o8QpBzA0b
	 374teJ9aYYojzcLf/R/w/0wbRMeB6iFB3mtDhDlA=
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
Subject: [PATCH v11 0/8] lib and lib/cmdline enhancements
Date: Tue, 19 May 2026 20:22:51 +0300
Message-ID: <20260519172259.908980-1-dmantipov@yandex.ru>
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

This series was briefly tested on X86, RISCV32, ARM, and MIPS using QEMU,
and compile-tested for LoongArch32 as well.

Getting feedback from RISCV core maintainers would be very helpful.

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

 arch/riscv/Kconfig                      |   3 -
 arch/riscv/include/asm/asm-prototypes.h |   4 +
 arch/riscv/kernel/image-vars.h          |   9 ++
 arch/riscv/lib/Makefile                 |   1 +
 arch/riscv/lib/ashldi3.S                |  36 +++++
 arch/riscv/lib/ashrdi3.S                |  36 +++++
 arch/riscv/lib/lshrdi3.S                |  36 +++++
 drivers/firmware/efi/libstub/Makefile   |   3 +-
 lib/Kconfig.debug                       |  10 ++
 lib/cmdline.c                           |  30 ++--
 lib/kstrtox.c                           |  37 +++--
 lib/test-kstrtox.c                      |   6 +
 lib/tests/Makefile                      |   1 +
 lib/tests/cmdline_kunit.c               |  56 ++++++++
 lib/tests/shdi3_kunit.c                 | 175 ++++++++++++++++++++++++
 15 files changed, 414 insertions(+), 29 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S
 create mode 100644 lib/tests/shdi3_kunit.c

-- 
2.54.0

