Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BC33D564B
	for <linux-efi@vger.kernel.org>; Tue, 14 Apr 2026 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776162397; cv=none; b=taPT4KH8h6t9FSCetKOmlPVwls17Z7kdNMC/VHJC/ict582ptxOUFBAA/p/fjCcgxr5Zj2q4ae00ExA/MhA7RdEbSHyzQ8QVUVdWfJ2p1YPpWU0ePtu1GipN+Amjl5sJoTbpFKis/vSWCExisErN694A5qHkNz0Y+j7H/W0S2IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776162397; c=relaxed/simple;
	bh=o7IJYKevoHuwsACRVBy1iHiwEkLBvsn7XUT8fd9Tgwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXNOzb1q9hmTdKbIVcHoCIIzWoYPX9FVhyTfi7PtczwnCbEVxXtei2eX9TGM/LgUMBkSXRIqPSgmhlDJSz/bdEqxIZg8UkJAoL1SbkPupc5scxGnq4xywqRJLqznDeQiSU7YLZPXhxlcijDXh54EjFtq9HcpP2zU9BmOw7GYGwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=B459aHMF; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="B459aHMF"
Received: from mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:3d95:0:640:5c83:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id EC819C007E;
	Tue, 14 Apr 2026 13:26:19 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id BQI23sTa1uQ0-JVJ8hnRq;
	Tue, 14 Apr 2026 13:26:19 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1776162379; bh=by7gI4ivVLUjkjadIHQ968y39O7n15nk8RwOcZ1UyVI=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=B459aHMFv3k6/Z8NYgFEFKecrxO22MOglnBpP9okQoaJm8zbfSnzuOz1I1DLUlwF1
	 8gQxArwc6JLNBx41vOqHU0zyMHNz9Ksbi/b3JbCnmAnE1fkRIorUpHVkPMR15NlTJi
	 33WJP5kxrWg/eDdvVQpfD9TkmYvxBw7J8OsNhu/8=
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
Subject: [PATCH v4 3/3] riscv: fix building compressed EFI image
Date: Tue, 14 Apr 2026 13:26:08 +0300
Message-ID: <20260414102608.573555-4-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414102608.573555-1-dmantipov@yandex.ru>
References: <20260414102608.573555-1-dmantipov@yandex.ru>
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

And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need these
library routines, introduce CONFIG_EFI_ZBOOT_USE_LIBGCC to manage
linking of lib-ashldi3.o and lib-lshrdi3.o on riscv32 only.

Reported-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/20260409050018.GA371560@inky.localdomain
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v4: use more meaningful CONFIG_EFI_ZBOOT_USE_LIBGCC and adjust tags (Andy)
v3: initial version to join the series
---
 drivers/firmware/efi/Kconfig          | 4 ++++
 drivers/firmware/efi/libstub/Makefile | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5b..e1483e20c69b9 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -85,6 +85,10 @@ config EFI_ZBOOT
 	  provided that the loader implements the decompression algorithm.
 	  (The compression algorithm used is described in the zboot header)
 
+config EFI_ZBOOT_USE_LIBGCC
+	bool
+	default y if RISCV && 32BIT
+
 config EFI_ARMSTUB_DTB_LOADER
 	bool "Enable the DTB loader"
 	depends on EFI_GENERIC_STUB && !RISCV && !LOONGARCH
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index e386ffd009b7e..91cefa80c158f 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -96,7 +96,8 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-libgcc-obj-$(CONFIG_EFI_ZBOOT_USE_LIBGCC) += lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-libgcc-obj-y)
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
-- 
2.53.0

