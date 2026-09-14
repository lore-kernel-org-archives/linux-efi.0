Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602739E9AC;
	Mon, 14 Sep 2026 18:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411084; cv=none; b=cxs+vuEuF6eQjx8Wi5biN6wmHxbRQliq1GRNyAP0F4D+ZecHGrvnLF1ZUp6GZE0p4QEyxaeb0EWoNSx6JabFHKoiuS4SdInpmq14dTJ8cXI5u1Br579ZLfud5qv4j10Qk79hzaDTbPdQBA4GQ9oilzX6asSAFuAsU4HtrCyGNRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411084; c=relaxed/simple;
	bh=V8oHB9tepYvRR+hXK96/ICwrRJ5Uev1MWGdSHDB6FDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RMWHZCZwwsLez8YM5GkYEgzT1iTuIBS5ad0a2b03dCwyGaiONZw7UZiBw+zS1P3DkyEapnOij5vxNSk9XTsGnQq+HuMF4eL6cGRyEJbvANj4JzezUtU0fcdUiMmxGz5eXlnIpI7w0v2TyMnFKsbo6i2sRnJlf8umaBUIIihkmz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZITNpScO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZITNpScO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1821F00898;
	Mon, 14 Sep 2026 18:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411077;
	bh=kp8eN6LJj4BgTRlawhDSrzGb5ffXtOcY9dGTmwun7+E=;
	h=From:To:Cc:Subject:Date;
	b=ZITNpScOFJxB9F5Dkx0tVhgy+RMy3uu/f8m6unamHoPQIGGo3WdShKCSLqu4EiBtS
	 Slsy8B22HIGJdyYMuzI6uIOLyJ+l9ciL1RHKETkCP0CWZAdLiADLmH0todT2raSyZQ
	 bhMCFf12ZyuQuH9wZWDm0Kz+KwmZTPxnEKepqnjVZ8eSrvVg5o5fkARCUB38M8jX8K
	 WiVn0LnpwqAtxv5oYgRC5PmFr43/deG9szWYNRoxLd4mNqHodziKLhr9r1IYPU61qO
	 yao14654s7zdVwuXGNbDb3zCSC/svEJiElCPgrD+D+YHIS8Orc5TeVIGNlcfgzZSbj
	 qSIaZN5ONgssw==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Date: Mon, 14 Sep 2026 20:37:46 +0200
Message-ID: <20260914183745.37538-5-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1551; i=ardb@kernel.org; h=from:subject; bh=V8oHB9tepYvRR+hXK96/ICwrRJ5Uev1MWGdSHDB6FDs=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuF3c/+Amahy3Jv3hjXiJ7c6XF6h8YD3wv/i3jtm9zFM x7c/ujRUcLCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYyZQPD/2INI6eyu377nlwp b1U8lRiwvahfVqvN/mjHqz4tlzesvgw/Hu/PfxntcGT11kOrdvzYEZezljH7ncg05ytt13Ubtau 4AQ==
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

[0] http://lore.kernel.org/r/20260909115530.1924665-13-ardb+git@google.com

Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>

Ard Biesheuvel (3):
  x86/tdx: Share tdx_panic() with the EFI stub
  x86/boot: Move unaccepted memory handling out of the decompressor
  x86/boot: Drop unused implementation of panic()

 arch/x86/boot/compressed/error.c        | 19 ---------
 arch/x86/boot/compressed/error.h        |  1 -
 arch/x86/boot/compressed/mem.c          | 42 --------------------
 arch/x86/boot/compressed/sev.h          |  2 -
 arch/x86/coco/tdx/tdx-shared.c          | 35 ++++++++++++++++
 arch/x86/coco/tdx/tdx.c                 | 35 ----------------
 arch/x86/include/asm/sev.h              |  2 +
 arch/x86/include/asm/shared/tdx.h       |  1 +
 drivers/firmware/efi/libstub/x86-stub.c | 40 +++++++++++++++++++
 9 files changed, 78 insertions(+), 99 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.47.3

