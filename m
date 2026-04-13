Received: from forward202b.mail.yandex.net (forward202b.mail.yandex.net [178.154.239.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF347A66
	for <linux-efi@vger.kernel.org>; Mon, 13 Apr 2026 09:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776072484; cv=none; b=Sc8WIojpvodVWCpV13/OQXQMbf80eGPwUGoj4JO7xahx6m6XCFDtgwmRrAWvWurCrXHof/UB+WB9GTqvZYXRF7RtjCfkENs8IpEyrYfDmbQazhLIVjyyX0d1U69MY7X/Sl9dSKGhppHhFL4p8x/txOMYiLhuNY/pe5TgdHKzwDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776072484; c=relaxed/simple;
	bh=Y+XI7upongy9jMWyGxA7gwEhDXYV2ebUb23wXhASqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HAYvrOCA6iFIf3fg/f24lS3PSbjLKO5uIZi50WY/CX2sghzYCVHlmjzQnfDg7AtPSFGum10i9WOXxivaKoZ/N3IO93HSx9SFJzahDOTVKEQsmJsfV6ZgJYbOviVUw1M6+abUM5nN0c1+eopRNmNhodYwzBJs+qZIXW/rhXEGR2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=puQxK6SZ; arc=none smtp.client-ip=178.154.239.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="puQxK6SZ"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward202b.mail.yandex.net (Yandex) with ESMTPS id BBFE4C2A82
	for <linux-efi@vger.kernel.org>; Mon, 13 Apr 2026 12:22:22 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:2409:0:640:85e8:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 4007B807AF;
	Mon, 13 Apr 2026 12:22:15 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id BMGbUY0QrqM0-7oRxIfng;
	Mon, 13 Apr 2026 12:22:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1776072134; bh=jh2fsWgly8lktcsE9k5a728Oe8/wRVoehO0PJo50uyc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=puQxK6SZxnnw1nAeiLFF0S4r+EcaEgKXujtjQ8qX4sM7IwsDWh79l+OPHQTbokarF
	 DFDlhX7FH4BG0V0V5z4sP6HwOl0RPXHCCLsdiAaFc1WZzWltj65N6uT06kvQHB/lZl
	 GOvG23qU3ADKQL2KpVUGZ2JDyw2lOlAu8jmYblZ0=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
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
Subject: [PATCH v3 0/3] riscv32 library enhancements and build fixes
Date: Mon, 13 Apr 2026 12:21:59 +0300
Message-ID: <20260413092202.174394-1-dmantipov@yandex.ru>
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
 drivers/firmware/efi/libstub/Makefile |   2 +-
 lib/Kconfig.debug                     |  10 ++
 lib/tests/Makefile                    |   1 +
 lib/tests/shdi3_kunit.c               | 175 ++++++++++++++++++++++++++
 10 files changed, 304 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S
 create mode 100644 lib/tests/shdi3_kunit.c

-- 
2.53.0

