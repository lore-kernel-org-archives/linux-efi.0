Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA16263F34;
	Sat, 25 Apr 2026 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777143133; cv=none; b=fn1dM8qUxP6w3j7kKFht6dbTbwYTqK38SnhiTa7OLSP9EeN1ngYWgzhVnN7PJkDULtJN7sIUp2tMgZn/kwBtrjfCWOXo0hD036fmMq1yq4ydMDbty8J4mwYyoAQL9mvEXZ4HtgEFHZ5T2xbC9J+Yk7vqKhKC6K7BR+aZThk75fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777143133; c=relaxed/simple;
	bh=09l3YPjhSwUTMzvWUFfu8oB1Z6UzYECjFr5+YfERXDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfONOvjip0162prQ1rxyATO0NkLVD1LvyassiemJQinwSRC9hep4JdnkkMhgIkJ0kSNBmjFB3npssGrHKxB1EONzqTHXorEg5mUZZP3Z1wfJQaG/gi+NhPiNszX2+i6tnbf6xN8xYXIVPDa9hV2Bg0xhvCPaB8oJuHbWGXf8FS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=YY6xFbMq; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="YY6xFbMq"
Received: from mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:143b:0:640:90e9:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id 31BD8C003C;
	Sat, 25 Apr 2026 21:52:04 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (smtp) with ESMTPSA id upbkSmRSGOs0-gvCSvSwd;
	Sat, 25 Apr 2026 21:52:03 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777143123; bh=nK4CS/JIFT4EM932PuliLxB7i1yt949Y+0UAOs05EfI=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=YY6xFbMqyNIOqq9XrVsv4yl480/btviIm6YJRA3p3PaahVGcgP07vqixpKhsJmaIb
	 cghnKc+EsPKC9VjMKOi1k9qRtMTd8wePqcjzgQFTS5yfRppfVktWCC5Bn2A9Catwh1
	 Aq/0T8ZVX2U4OfQqsE20MtMDozOGiyyHbuTheMjQ=
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
Subject: [PATCH v6 3/3] riscv: fix building compressed EFI image
Date: Sat, 25 Apr 2026 21:51:50 +0300
Message-ID: <20260425185151.477442-4-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260425185151.477442-1-dmantipov@yandex.ru>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
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
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v6: adjust to match recent upstream changes
v5: rely on CONFIG_32BIT rather than dedicated Kconfig symbol (Ard)
v4: use more meaningful CONFIG_EFI_ZBOOT_USE_LIBGCC and adjust tags (Andy)
v3: initial version to join the series
---
 drivers/firmware/efi/libstub/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 983a438e35f3..e1c11d02a5cb 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -95,7 +95,9 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o
+zboot-riscv-obj-$(CONFIG_32BIT)	+= lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
 zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o lib-ashldi3.o
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
-- 
2.53.0

