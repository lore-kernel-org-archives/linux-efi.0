Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2040E2DE70D
	for <linux-efi@vger.kernel.org>; Wed, 15 Apr 2026 12:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776256366; cv=none; b=O0DqCiwxXzG8pEVgKvCW39c77Haef04SLcIZMfMECxT4tQHlZcuhjHHFM5dz6BdBZ6QLsgxyYn0R8E+eA98kBNQECJXie/SiQQ03U9K6LdJljPX33EvUBB0SD4LBs4K3/uESOx02OAjrxaQQ8POjMpGUZzs6/c9MltJkcFer2ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776256366; c=relaxed/simple;
	bh=nWLKDMkhhrvx43zgmOaZCL5Aclbva+t+YUgiWU2wXSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sR19fe5K/0FDTjCqUL4cU+YjLlIIei8yo3KGUUMbqJuMeweJ+gvupf+BoCQo45ZXweTB5GiiGdARAbBqCZAIFNGdBgxIRE5aBrRvbu4uVQzg8GxE738NmaiAHRig/ydbR25C/fuG1WceLq1omefJVs8S2Ty38x6NFnmzBaRsf4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=GrbJHAv4; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="GrbJHAv4"
Received: from mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1c:2e1d:0:640:64e7:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 5C078C00C9;
	Wed, 15 Apr 2026 15:32:29 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id QWLFfkFSpa60-UuExOsOG;
	Wed, 15 Apr 2026 15:32:28 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1776256348; bh=Mr1hTPyQNlez2JlQ/uPi299mOYyEk6C+zkloCGhX058=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=GrbJHAv4KAiKkZ+uwNLwWQR6soxjZ9fDddbtyWcxj/ZUzGlbXpN49xyfDvaBFk08A
	 YGNZjepdI3Jm+lOaLbJKVccwmmTy5RL8d1ThOsQoQiaFXK3LN0vEuJw2oeBaDPsMZz
	 1+e2NQXCKAZ8yNthrMyhjnat6TN4QGj0i87c7HsM=
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
Subject: [PATCH v5 0/3] riscv32 library enhancements and build fixes
Date: Wed, 15 Apr 2026 15:32:01 +0300
Message-ID: <20260415123204.1467909-1-dmantipov@yandex.ru>
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

