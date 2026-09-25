Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60D36E489;
	Fri, 25 Sep 2026 07:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322718; cv=none; b=HSIGKh0qr14nF+sx58KHjoMoSrjp7/vCkYtlsmUyYSa2S/HxmvRLlYU5QsH6U+tEZzM8uts+i0MVgsyOPVrp7WKkcGPEBGPvkWuZcOg1+OYs3XEt8AHaMJ6+EQIa8BHqalFxtMlImwShMAdFAHSSiUPz9F1ICINRD3oTab5uX98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322718; c=relaxed/simple;
	bh=kHVPFXbJ8EqkKfRf8xzGYsQcndBVosP2b9IUPfJiLdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hUFDOi7VTm8DrDs/AYWL5FqVRSRQ4YPF7g0cTXQ12u8eDiPOlsw+jQmBAPzrUy69XeRqcFfiI6ZzWagROKe0UmnVz3Jw2sRp4NdyOjbLdw0exUrDZjkTIzmN7Taf+c35yWQ53Z1HrqGtCr4fidihahiONrNbbCb7JEaySYdLASc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lpp3ptlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lpp3ptlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90A71F000FF;
	Fri, 25 Sep 2026 07:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322717;
	bh=kq3SqEusRgNdp0z9oySPm66wZTMWFLa2zSE1QTiVlbA=;
	h=From:To:Cc:Subject:Date;
	b=Lpp3ptlzyt4eBDfPN/C9Yjt6ic8WkJj7sXKTeu2jXx1vCtkDGNGCiBswOGzaqo1Jg
	 eVBgdR1CIoEQdH4XnIiyEpEg9Fy+fzCUKz19TKYo+d1jv4ZMBwpujUr2d59HALbJgY
	 NnYiXbUr30W3WbAzNf25Msztw9h9QSgbSswJEju9WH2nerlsJ4XGpbAzg2U9/yVTCI
	 ku7pp7gMVTWZabX4ugYDzTcgpSB5zAeDpXsbOE9oIkxpIecGKW9Ao47apnVOqq3nUu
	 uXN3ekgmTAHx4zS1vDHzLhw6hiLtJa+4JvBQ3Oh4n7/dKehGHj3HCxH6/zLIDmGqXg
	 zq5Id+8sYTRLg==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 0/3] Move memory acceptance x86 arch code into EFI stub
Date: Fri, 25 Sep 2026 09:51:38 +0200
Message-ID: <20260925075137.44298-5-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2033; i=ardb@kernel.org; h=from:subject; bh=kHVPFXbJ8EqkKfRf8xzGYsQcndBVosP2b9IUPfJiLdo=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGLK2aXDucPkt/fBlamik7rtA77obVuvvHQ9OeTNpdd6mf T9iHSvUO6ayMAhzMsiKKbLsVM7pfu0i+k5foTIHZg4rE8gQBi5OAZjI1wrGGo5vHVpXjxnu7Ekv 4NCUZHz3prp8ssuG0v3P2L4Gbvp0/rzovrkz/CZdP/zp6KGdp9eYnGKsD5uVvSJsV918FangTYr Nhy7vPbZ17yx25YgZv79dvFZy91rrr0QWHk3/I4wy+suCLb2UAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

This is a follow-up to [0].

Move arch_accept_memory(), which is only called by the EFI stub and
never by the decompressor on a non-EFI boot, into the EFI stub, and
avoid relying directly on decompressor APIs such as error().

Instead, call tdx_panic() on a failure to accept memory in a TDX guest.

This makes the decompressor's implementation of panic() obsolete, and
allows it to be removed. This is a prerequisite for dropping the
implementation of snprintf() from the EFI stub entirely, which is what
the series containing [0] implements.

Changes since v1 [1]:
- Add missing stub for early_is_sevsnp_guest() when SEV support is
  compiled out but TDX support is built in.
- Use native_cpuid() in EFI stub code so it does not get paravirtualized
- Set __NO_FORTIFY when including tdx-shared.c so the decompressor/stub
  version does not get instrumented. Needed for the memcpy() in
  tdx_panic().

[0] http://lore.kernel.org/r/20260909115530.1924665-13-ardb+git@google.com
[1] https://lore.kernel.org/all/20260914183745.37538-5-ardb@kernel.org/

Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Edgecombe, Rick P <rick.p.edgecombe@intel.com>

Ard Biesheuvel (3):
  x86/tdx: Share tdx_panic() with the EFI stub
  x86/boot: Move unaccepted memory handling out of the decompressor
  x86/boot: Drop unused implementation of panic()

 arch/x86/boot/compressed/error.c        | 19 ---------
 arch/x86/boot/compressed/error.h        |  1 -
 arch/x86/boot/compressed/mem.c          | 42 --------------------
 arch/x86/boot/compressed/sev.h          |  2 -
 arch/x86/boot/compressed/tdx-shared.c   |  2 +
 arch/x86/coco/tdx/tdx-shared.c          | 31 +++++++++++++++
 arch/x86/coco/tdx/tdx.c                 | 35 ----------------
 arch/x86/include/asm/sev.h              |  2 +
 arch/x86/include/asm/shared/tdx.h       |  1 +
 drivers/firmware/efi/libstub/x86-stub.c | 39 ++++++++++++++++++
 10 files changed, 75 insertions(+), 99 deletions(-)

-- 
2.53.0

