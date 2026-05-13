Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB9218EB1
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680327; cv=none; b=dC7u7865vkBEjpn45dQndmE47ayzMpW84e1fS5L6wnl7Jmi95vpsJE7S1dS5ki4/s1EEUpU9JBT4Rzf0Op0mie9JTxfl+VYLgScOTiWdaK9E84qWPT/aPw6+CIgA1wf2hFq5KN1dwecJAbS+y5jvCfmhaExIoQ6ZN+ujFEIr4WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680327; c=relaxed/simple;
	bh=kGuXQHzw7Hr1W8r190Ke14n8eUlyPeK8TPV8eeL61MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9FXHtZjDYj0HGdEDjDR0km7jj600wJYO3wOdYauoPmQwR0swchXQOceCsiAOAIScNzK7mA7LR5cFND7a+iTe14TIvCSDhcMq8MAr0EXpPg+Au+MloBhQ60S9tkcfGHBsWrWiHGja0W51n4tmw8xhI1fdi8h67XNF4yCW30AGvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=AeE6w073; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="AeE6w073"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 32191C0085;
	Wed, 13 May 2026 16:52:04 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp) with ESMTPSA id ppLkjiGSViE0-kSOR4TFA;
	Wed, 13 May 2026 16:52:03 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1778680323; bh=ScnUJ/DMl9nMAbNk6bCYoIR+gfYLnW91eJ/WU0axDv0=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=AeE6w073SpnHvaZuza/DmWhzIiFSsqFFLDCASthihlJw0HomspG7BX0w6VzC6w/iQ
	 +4OULP8eLbZWS6P+dfCUdAKtKiu+2PzEOUa5E/3AhgUPwxFun7HXjy3I+GGx/paQ29
	 1HVR3Nq19KqKtrUI3tbws2eTKsBUdy1EIQtMw59Q=
Authentication-Results: mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v10 8/8] riscv: fix building compressed EFI image
Date: Wed, 13 May 2026 16:44:07 +0300
Message-ID: <20260513134407.884033-9-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513134407.884033-1-dmantipov@yandex.ru>
References: <20260513134407.884033-1-dmantipov@yandex.ru>
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
Assisted-by: Gemini:gemini-3.1-pro-preview sashiko
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v10: bump version to match merged series
v7: use lib-clz_ctz.o exactly once (Sashiko)
v6: adjust to match recent upstream changes
v5: rely on CONFIG_32BIT rather than dedicated Kconfig symbol (Ard)
v4: use more meaningful CONFIG_EFI_ZBOOT_USE_LIBGCC and adjust tags (Andy)
v3: initial version to join the series
---
 drivers/firmware/efi/libstub/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index cfedb3025c26..251571d293c3 100644
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
2.54.0

