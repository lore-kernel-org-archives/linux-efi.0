Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5047C3537EB;
	Sat, 25 Apr 2026 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777143133; cv=none; b=H8Ly/FJR+D2Q+9fvitNfB3gvC2qUEapO1eiIWwhIcxDUY5qR+39YWXj6Tq6JmOgw2HwCnYiWg7Y38hxMMl2/9RI2RYGfxWCp5BFjO9ajHpAXAoZU4fjmzhhMGe5O9ESuE/g7GoBQXq0C9Wnlj0XMAihDk1YqKmdK3pIielvRpvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777143133; c=relaxed/simple;
	bh=E8uR5fBtRkJ5lHvZKJaCATB0yUtZEWG9Z+Xe6pSmo9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nbC4DtvN5xUaNPy1Y6Zad0eSvEeea/DQDr+Psx9jXgN2Ksha6ww0qRdBKVB7oz1blQXZ6/FLD8kjriG1A++zKvMr7k2zo/EV6V+eMjJAtq2H5vskU7FSXloyjn8ILdyscXiqlmw6L+JffQmyxFGr+gme05meFJNuqhSMxXCM+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=RmzV3NK/; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="RmzV3NK/"
Received: from mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:143b:0:640:90e9:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id E0C72C0038;
	Sat, 25 Apr 2026 21:52:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (smtp) with ESMTPSA id upbkSmRSGOs0-meWgy57M;
	Sat, 25 Apr 2026 21:52:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777143120; bh=Z32NmT5CVy7Z7bGrRY4+g5I67jzTqY1eawuxieoIPEM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=RmzV3NK/HX+OHzuwqZn+2Wjc0UHB/TUEM5YlFyoCCxfU/2R32PWrgVfDWEuQB0UZg
	 SRme54zGqbKeVgiiMdzkD271AUdd7bO3xkMIL616D19AFXx0DfkaYkW/ax2F/Xc1sh
	 CNsXAd0fx9MzCr00pzg5aLKxxufb73jq+JFu4AJM=
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
Subject: [PATCH v6 0/3] riscv32 library enhancements and build fixes
Date: Sat, 25 Apr 2026 21:51:47 +0300
Message-ID: <20260425185151.477442-1-dmantipov@yandex.ru>
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
 drivers/firmware/efi/libstub/Makefile |   4 +-
 lib/Kconfig.debug                     |  10 ++
 lib/tests/Makefile                    |   1 +
 lib/tests/shdi3_kunit.c               | 175 ++++++++++++++++++++++++++
 10 files changed, 306 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S
 create mode 100644 lib/tests/shdi3_kunit.c

-- 
2.53.0

