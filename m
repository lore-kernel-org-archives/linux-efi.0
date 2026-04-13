Received: from forward200b.mail.yandex.net (forward200b.mail.yandex.net [178.154.239.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5779A47A66
	for <linux-efi@vger.kernel.org>; Mon, 13 Apr 2026 09:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776072476; cv=none; b=aifxr1GSuu9/Lz0WSaElZDHinRGB9fiTAI9Ga5puBuNFXZpKPpA4Pq1oK5Nj/k4ZtHLtlKCTNx6sSnNVd5TR4YNVIRUWiLhhtkwGBngOl0h3Osh07x6AmgWw51chKlgzP22KoR2C95KkEAWT6YtR7IhgwCIHVZ+nrTaB7AuuM5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776072476; c=relaxed/simple;
	bh=gNvRE0b6EzTZhuIUAyp9wPLao8jjM1UfkRsYvjNOB8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqCkS2yT8MaRUjaqhsMplZqsqqe6xGaY5IgX6DfxoCyoDCt10sfSXfigPWHxYKxtcCbRHelvAbmbLnjfB8u6wTKGPSgFsyu67me0pjiMWlfiaXqNKopaso+VtFNR1Sfjufm33Qh0M3bone+k4r32WkMNv7Je2/ZriX9Y3lKDnJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=okjIe9Az; arc=none smtp.client-ip=178.154.239.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="okjIe9Az"
Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d102])
	by forward200b.mail.yandex.net (Yandex) with ESMTPS id BBBA88157C
	for <linux-efi@vger.kernel.org>; Mon, 13 Apr 2026 12:22:26 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:2409:0:640:85e8:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id CE528C007C;
	Mon, 13 Apr 2026 12:22:18 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id BMGbUY0QrqM0-gAjYUuKm;
	Mon, 13 Apr 2026 12:22:17 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1776072137; bh=voMqeQVH9FqU6nEefapBn9esCXQr+JucD1jehyO2FL0=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=okjIe9AzjK33lJekYuNY+zuXRUGE0QaPIi+O8NniuZn2gsBn6oFE+OSssJVZPF2De
	 UkQyjk28rVhh2khU8mnjIwkWdvc8Jf68Rue0FEQ7MR8qU9Vr+pB+MUYrVSl0yRsBAG
	 PLH+vWzjfaVuy3x7GlXU2UAsY9Whhipdf1hDoXIg=
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
Subject: [PATCH v3 3/3] riscv: fix building compressed EFI image
Date: Mon, 13 Apr 2026 12:22:02 +0300
Message-ID: <20260413092202.174394-4-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413092202.174394-1-dmantipov@yandex.ru>
References: <20260413092202.174394-1-dmantipov@yandex.ru>
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
these library routines, introduce CONFIG_EFI_ZBOOT_EXTRAS to
manage linking of lib-ashldi3.o lib-lshrdi3.o on riscv32 only.

Reviewed-and-tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v3: initial version to join the series
---
 drivers/firmware/efi/Kconfig          | 4 ++++
 drivers/firmware/efi/libstub/Makefile | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5..55fb5a20aa25 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -85,6 +85,10 @@ config EFI_ZBOOT
 	  provided that the loader implements the decompression algorithm.
 	  (The compression algorithm used is described in the zboot header)
 
+config EFI_ZBOOT_EXTRAS
+	bool
+	default y if RISCV && 32BIT
+
 config EFI_ARMSTUB_DTB_LOADER
 	bool "Enable the DTB loader"
 	depends on EFI_GENERIC_STUB && !RISCV && !LOONGARCH
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index e386ffd009b7..8f199b99d0f6 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -96,7 +96,8 @@ CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o lib-ashldi3.o
+zboot-obj-extras-$(CONFIG_EFI_ZBOOT_EXTRAS) += lib-ashldi3.o lib-lshrdi3.o
+zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-obj-extras-y)
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
-- 
2.53.0

