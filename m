Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.60.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696924;
	b=dpTNBlo5Msa8MXZMjG4/teK21KeHFp6mrosdFK12xe535W9ex0CK2v0NNdTcO0yMT7eP
	 K8vSPyVwfIJFIU81HdyVCUkRFz0ig73nG6kYBGWo7kovjMUSjw7EAYlDDlUV0fxsnTpFZ
	 MsfS16qDbIbz+3OMhNGnpTJDtDrgNYfgggRSq33jiRdkW5iogvNu+6iUVjBTddrykFbYR
	 jd0ITl2E6rSDEZ+Qvspx4Ct3d3+hdObGBLHB3GKeANBWqwxRgm4TG7Q45RIX/VS0hH9aG
	 1MtaUxf7jqHTYQse4zCN3sGA2JWiV4BDT+c9jvgkBNXdeYu1R6X0LQXyfNfy9IEfhTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696924;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JneyGuy1qh+xtE++6pF4sbi6Wsm8hasIC9ikeIhpHCU=;
	b=ZOOw9i5SIPkRjNvfUx+af05Sv8OiWHV+10aWFsuFhgazAputJ7/b8w4hGbkegEdYJI8v
	 NVn5KPGLEmH44SrDjbIErr2RtZ4wmjBkDfQU6+ZWdmPhXe9ElVitYFNT3Nw+OBsQkKd0b
	 rlvyu/MezKSoWINUV7+wtjAPA0D7fi9i/TqLeF5fHXh3sFXxqwSu8hPnB7MJEfgBEhABP
	 +DTj0RgUVPpn1RnsLF0Ptu5MDupUBhedBXDNN1cp5+wXRylhFKvt9xV5XfEf+qx9pQfb8
	 6p9/gnO5VBOqg8/zeVkFrt5HiFWC30derI5q3xT2er8Cd5aDx4Z7L08+ilDPRNQs68w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=CH6+PKjZ;
	arc=none smtp.remote-ip=51.250.60.162
Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [51.250.60.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2016606A326
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 12:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2016606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=CH6+PKjZ
Received: from mail-nwsmtp-smtp-production-main-58 (mail-nwsmtp-smtp-production-main-58.yp-c.yandex.net)
	by forward102d.mail.yandex.net (postfix) with ESMTPS id F05BCC03AD;
	Thu, 26 Nov 2026 15:41:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-58 with ESMTPSA id lfhVEFQXeCg0-BoDN5UTt;
	Thu, 26 Nov 2026 15:41:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1795696912; bh=JneyGuy1qh+xtE++6pF4sbi6Wsm8hasIC9ikeIhpHCU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=CH6+PKjZQzevZN+sT1po4LCM4WeGWy9GVETvf1uN1vvwewh+sfrRF5ehqeITcaM8A
	 i+bQzHZjiIBf44Hebnr43VoiX3iQOE8+p45UGouX6JGhJRNDz43SWbLs2iaFl7QqyE
	 NMZSUr4ZQPNZc+JkS42EmYB+jxb6X08RBWOmrMRw=
Authentication-Results: mail-nwsmtp-smtp-production-main-58; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2] efi/libstub: fix building loongarch32 without zboot enabled
Date: Thu, 26 Nov 2026 15:41:45 +0300
Message-ID: <20261126124145.876953-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel test robot has reported the following error observed on loongarch:

loongarch64-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L47':
__efistub_cmdline.c:(.init.text+0x258): undefined reference to `__efistub___ashldi3'
loongarch64-linux-ld: __efistub_cmdline.c:(.init.text+0x268): undefined reference to `__efistub___lshrdi3'

Following the approach introduced in commit a354b8de9ad6
("riscv: add platform-specific double word shifts for riscv32"),
define EFI stub aliases for __ashldi3() and __lshrdi3() for
loongarch32 as well, thus making the related EFI stub's Makefile
quirks redundant.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261122125352.gAcg5yLx-lkp@intel.com/
Fixes: 442082297e3d ("riscv: fix building compressed EFI image")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: define relevant EFI stubs in image-vars.h (Ard) 
---
 arch/loongarch/kernel/image-vars.h    | 2 ++
 drivers/firmware/efi/libstub/Makefile | 7 +------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e557ebd46c2b..19202f4f84c2 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -8,6 +8,8 @@
 #ifdef CONFIG_EFI_STUB
 
 __efistub_strcmp		= strcmp;
+__efistub___lshrdi3		= __lshrdi3;
+__efistub___ashldi3		= __ashldi3;
 __efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index bbab12b8eb4b..bcf2a5981678 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -96,12 +96,7 @@ zboot-obj-y			:= zboot-decompress-gzip.o
 CFLAGS_zboot-decompress-gzip.o	+= -I$(srctree)/lib/zlib_inflate
 zboot-obj-$(CONFIG_KERNEL_ZSTD)	:= zboot-decompress-zstd.o lib-xxhash.o
 CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
-
-zboot-riscv-obj-$(CONFIG_32BIT)	:= lib-ashldi3.o lib-lshrdi3.o
-zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
-zboot-loongarch-obj-$(CONFIG_32BIT) := lib-ashldi3.o lib-lshrdi3.o
-zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o $(zboot-loongarch-obj-y)
-lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
+lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
 
-- 
2.56.1

