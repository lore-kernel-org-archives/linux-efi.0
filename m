Received: from forward202d.mail.yandex.net (forward202d.mail.yandex.net [178.154.239.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD8A3AF64D;
	Mon, 27 Apr 2026 09:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280998; cv=none; b=Ezpxd7xrau9I3CqY1yRus+NkIlMf9eq2/i0wLoBP4xSt7KCO9xrDDkGCRCwywnF2g85X+BiHYCYv8tsEzFeBOCFP9VQNqnuGEJgo7wA+2GCwzkxntq3y975ji7eja1C2WuFKdkowaCnOa0SE6qxlPGj8a44nu+V7ngDpNpp/z4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280998; c=relaxed/simple;
	bh=YLXj5AmJ/++5CzxtvSLMRJMWqiR/5JVn6r6MI/gWdxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajfWNhD3kfndTd0e3GwX5mcCQgxuhNOiFRwBu7LtDy7sj8HbnFcgbb/bg5Fw3860Ufq6jFbRnshC+tKEM60wi8H+H++7FW7g6EIRgfoNqJMqVd4X2HWd6QDkdRLhk9xmN27+CneQyLuD2V+4l//kngUe643kAwmBcXdjXlsT6ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=UKkGAP0f; arc=none smtp.client-ip=178.154.239.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="UKkGAP0f"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward202d.mail.yandex.net (Yandex) with ESMTPS id C95D6854E8;
	Mon, 27 Apr 2026 12:01:47 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:ea2:0:640:ef77:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 6118DC0081;
	Mon, 27 Apr 2026 12:01:40 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (smtp) with ESMTPSA id X1UMu7lR5a60-Xb9gGYSr;
	Mon, 27 Apr 2026 12:01:39 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777280499; bh=Ff9SdFCbk25ZtmQGhp1frc27zJiUuk0lebZaoptedLo=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=UKkGAP0fCWCVBGHrvOWdDvj4Yjc1QQ9vPO+PzzayQEI4EuTz8WfZbAp4U0hZlycHt
	 xTmfrZCxlJcpus3bZ+CKkSmiznOZ4N2c5GJby7nZS42WD3dnO+4c73y2I9oRE/ZPF8
	 R0qLFHbjZ71gB644M+cWVNJsQJc/8A9PuufW+jQw=
Authentication-Results: mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
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
Subject: [PATCH v7 3/3] riscv: fix building compressed EFI image
Date: Mon, 27 Apr 2026 12:01:05 +0300
Message-ID: <20260427090105.705529-4-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427090105.705529-1-dmantipov@yandex.ru>
References: <20260427090105.705529-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled,
'__lshrdi3()' is also needed to fix yet another link error:

riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need
these library routines, rely on CONFIG_32BIT to manage linking
of lib-ashldi3.o and lib-lshrdi3.o on riscv32 only.

Reported-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/20260409050018.GA371560@inky.localdomain
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Assisted-by: gemini/gemini-3.1-pro-preview sashiko
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v7: use lib-clz_ctz.o exactly once (Sashiko)
v6: adjust to match recent upstream changes
v5: rely on CONFIG_32BIT rather than dedicated Kconfig symbol (Ard)
v4: use more meaningful CONFIG_EFI_ZBOOT_USE_LIBGCC and adjust tags (Andy)
v3: initial version to join the series
---
 drivers/firmware/efi/libstub/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 983a438e35f3..7fc654e99305 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -95,7 +95,8 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-riscv-obj-$(CONFIG_32BIT)	+= lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
 zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o lib-ashldi3.o
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
-- 
2.53.0

