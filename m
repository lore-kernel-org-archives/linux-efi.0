Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915503BB678;
	Sun,  6 Sep 2026 13:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700119; cv=none; b=Ky/JqG2S0lGL4VOO86onpkuY0idiupsnn9jHEx/NmDz/1Wf5OCkWa+T6WYSSWntQRQhuR84P9ZPgjFfRADA0+/MUJAPHfmowwW8IEMLQDE9Bn9vLwLtBQ6m7vW6J4CWZA1+m8LaeQVyiR8KQWr063vwp0CaJDS259aLny3Dzmxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700119; c=relaxed/simple;
	bh=ATZaAijNF9Jdao4pDDL276SxxKkOSuWrO9bXjfY0MAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IWfL6m3HS1uWPijqhLYuFIj9cjR8CAfxkdlhdkEQktDVVqMkb0A8VGr0tP2JyAw8YW1kbxtzz/xUOG0zZ/hpSq/+RvwKWypCFT5kmABh2ibthQrvWVIZSvqM6rk37YGcKrSJM6pF7ph6A2sIyHIF7ZFz4GR15/3+mTfS2M5w3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMpFJuoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMpFJuoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109A41F00A3D;
	Sun,  6 Sep 2026 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700118;
	bh=ZG0tbsIHw1yykpiDlA+t3Q2aPDHUy0gQYAmmwNrtizI=;
	h=From:To:Cc:Subject:Date;
	b=OMpFJuoJO6VZ8xLIEXwQu+U9ejrXZz/20fTwBi1dufJf5e276AMbxC90MjhA2/+Yn
	 Tqb8N21H2soKltyrOC36ucTG9kplBDhFWQcFsIOXw/91EucokhgqiNEhPeGyxuOQr1
	 8YkkybuVQZ1B62s+/xLrE6m1i2iTVD8sJFmyLJjLfeqb9Nw0IDA7M6uEk5Y/jf+MYV
	 5Gd/UKm8vBxCzV27LtPMotCRjwel6KOVzCu6ng4Vqe8YdQlt0AKuFau7CdJB5UOe/e
	 ZL9Oli4IYne+nXpwmEicch+TCawf2eyeSczOTsrVDiXLTkI838tgrHZvB3EPoajYbm
	 V/9JEoAb+B9zQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 0/7] efi/libstub: Avoid UTF-16 conversion busywork
Date: Sun,  6 Sep 2026 15:08:18 +0200
Message-ID: <20260906130817.1151961-9-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1695; i=ardb@kernel.org; h=from:subject; bh=ATZaAijNF9Jdao4pDDL276SxxKkOSuWrO9bXjfY0MAM=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6iHF8JVBpflBl/ZPOMh53Fe6Or6gRTv9VcTfJdH/V 0cJe6R2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIncNmT4K3lr0UyDukjWG+8c Qts9OXgrhVWzZ8+O3GkaYC8/bZXXLYa/8hFM6o+uznVm6j5xRki/9ZT+MZfLtTc8at988JDJ0xV kBAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The EFI libstub performs some redundant conversions between UTF-16 and
UTF-8 and back again, which includes dealing with surrogate pairs, which
UEFI implementations themselves simply ignore.

So drop all the homegrown code, and use the existing UCS-2 (== UTF-16
without surrogate pairs) library code where conversion to UTF-8 is
actually needed (the kernel command line).

The remaining handling involves the EFI console, which supports wide
characters natively, so just use those directly.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: x86@kernel.org

Ard Biesheuvel (7):
  x86/boot: Drop pointless re-implementation of panic()
  lib/ucs2_string: Avoid WARN in library code
  efi/libstub: Use ucs2_string library for UTF-16 to UTF-8 conversion
  efi/libstub: Avoid efi_puts() for compile time constant strings
  efi/libstub: Output UTF-16 directly from vsnprintf()
  efi/libstub: Add support for printing human readable GUIDs
  efi/libstub: Add efi_snprintf() to construct wide strings

 arch/x86/boot/compressed/error.c               |  19 ---
 arch/x86/boot/compressed/error.h               |   1 -
 arch/x86/boot/compressed/mem.c                 |   2 +-
 drivers/firmware/efi/libstub/Makefile          |   3 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  59 +++-----
 drivers/firmware/efi/libstub/efistub.h         |   6 +-
 drivers/firmware/efi/libstub/gop.c             |   6 +-
 drivers/firmware/efi/libstub/printk.c          |  93 ++----------
 drivers/firmware/efi/libstub/vsprintf.c        | 148 +++++++-------------
 lib/ucs2_string.c                              |   2 +-
 10 files changed, 87 insertions(+), 252 deletions(-)

-- 
2.47.3

