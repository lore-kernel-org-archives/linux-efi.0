Received: from forward204b.mail.yandex.net (forward204b.mail.yandex.net [178.154.239.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A643D5646
	for <linux-efi@vger.kernel.org>; Tue, 14 Apr 2026 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776162726; cv=none; b=CAhpynjuKwFmYZB3jLaM15bfyZeHkiSpwUcf4gBLVX14ETpwvAJ5vEDQa6Go2qAjcdA+n0xSUvy2YAkglo9iUBDQdCgze4ANhMCf7daIOLtWoAWKttiG6UlR/H6gXugA6qf38NrroFw7AOmIBEPb7TlDsJ0MN/CPzI4wW7rNzck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776162726; c=relaxed/simple;
	bh=nWLKDMkhhrvx43zgmOaZCL5Aclbva+t+YUgiWU2wXSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i92BJo31RUAyctua4BoauyZabfex/Sz+FH0rNkY7K0JTWygrp+8L4egO69y9EtRNHr6JBx5Sq/MpOqgTcRo3ZRspjrq/axQ4ESoBc7Fb+L4uc4gCjz8YDAAkeoeyTun4jKdfuVOHoED5gLZ5rXZ2Nc1aKldm9czA1i67Fr2xlFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=SdKlovDm; arc=none smtp.client-ip=178.154.239.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="SdKlovDm"
Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d103])
	by forward204b.mail.yandex.net (Yandex) with ESMTPS id C1F2180F00
	for <linux-efi@vger.kernel.org>; Tue, 14 Apr 2026 13:26:23 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:3d95:0:640:5c83:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id D41B3C009D;
	Tue, 14 Apr 2026 13:26:15 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id BQI23sTa1uQ0-YGZ1Ar9n;
	Tue, 14 Apr 2026 13:26:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1776162374; bh=Mr1hTPyQNlez2JlQ/uPi299mOYyEk6C+zkloCGhX058=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=SdKlovDmd8CdJfyM7WLceE2/vTm7AeMdEkMj1Doq0KLonHwrOwqw8N0jHAUV0JK/3
	 diisuT7wYBxmln0P4CUPvpGTMzKiLu/ivGpezSIOt2GEfP/MYNFtnD53S1qd3/WU3b
	 ytZd4O86S19C74qwnRfgK/FgNKicSN36o083pa4c=
Authentication-Results: mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v4 0/3] riscv32 library enhancements and build fixes
Date: Tue, 14 Apr 2026 13:26:05 +0300
Message-ID: <20260414102608.573555-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series should immediately follow v8 of lib and lib/cmdline enhancements,
see https://patchew.org/linux/20260212164413.889625-1-dmantipov@yandex.ru.
Started from riscv32 build quirk, now it aims to provide platform-specific
double-word shifts and corresponding KUnit test (tested on ARM as well).

Dmitry Antipov (3):
  riscv: add platform-specific double word shifts for riscv32
  lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
  riscv: fix building compressed EFI image

 arch/riscv/Kconfig                    |   3 -
 arch/riscv/kernel/image-vars.h        |   7 ++
 arch/riscv/lib/Makefile               |   1 +
 arch/riscv/lib/ashldi3.S              |  36 ++++++
 arch/riscv/lib/ashrdi3.S              |  37 ++++++
 arch/riscv/lib/lshrdi3.S              |  36 ++++++
 drivers/firmware/efi/Kconfig          |   4 +
 drivers/firmware/efi/libstub/Makefile |   3 +-
 lib/Kconfig.debug                     |  10 ++
 lib/tests/Makefile                    |   1 +
 lib/tests/shdi3_kunit.c               | 175 ++++++++++++++++++++++++++
 11 files changed, 309 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S
 create mode 100644 lib/tests/shdi3_kunit.c

-- 
2.53.0

