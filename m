Received: from forward203b.mail.yandex.net (forward203b.mail.yandex.net [178.154.239.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF1F2045AD;
	Sat, 25 Apr 2026 18:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777143501; cv=none; b=tSuYL55uHU60LAEd9hLQtLGvj+5f+5+dMy6o1lqvOeBlouwe6y0lLIDqGrUqO7g9ecGGz9C1gyPew4HcqlPV03aLuBZpiNNzzkMx6za4Y0fG5X01HAgUYgkyzk47ehp9zvKMg/Nljh+OecVhevFYCmj/HLoBPRPgUh0VO4GbOfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777143501; c=relaxed/simple;
	bh=9oUT0ehFUywHm6MYoeYQq+ckEpa8D5XINl7wEqbVfXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jf7WVwJajLkRyD7FnZwO+BrqyzC60u/69tAEkzOtFj3SoQPxP7Bzldowf7O0Q0dGMWO4+ldrr7iNmVTA2QRlGcURL9PjT1YZd/aCbrb8jvUHe5rFGSL/0n7RYHDmT9GOHaBfvoBR8UC0rfU+nbEc08qvNr553cQ+Wwo6FKX/pWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Ag/7RrHW; arc=none smtp.client-ip=178.154.239.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Ag/7RrHW"
Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d102])
	by forward203b.mail.yandex.net (Yandex) with ESMTPS id 1317E80868;
	Sat, 25 Apr 2026 21:52:10 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:143b:0:640:90e9:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 0F350C0085;
	Sat, 25 Apr 2026 21:52:02 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (smtp) with ESMTPSA id upbkSmRSGOs0-ZwqoVVk9;
	Sat, 25 Apr 2026 21:52:01 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777143121; bh=01lkHnIGTQCNZziIzuPLK2QyjYXk+MREk3WbkX0vJZA=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Ag/7RrHWor3TH7UnmIQirbqPRpUn8JQPhy5nXZ0qw/zP5OCbL66aN4LWw5sPuYACa
	 3THQN5dBHpR/9q4bVmUf3gMiNuHYbazOen7F6xDPgpIhaXU0ThFlP5os1bEjJVzCLM
	 uxong1iwQkZ2aYy3ZXkVG62FmfTu6hKyjMHCiIqQ=
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
	Dmitry Antipov <dmantipov@yandex.ru>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v6 1/3] riscv: add platform-specific double word shifts for riscv32
Date: Sat, 25 Apr 2026 21:51:48 +0300
Message-ID: <20260425185151.477442-2-dmantipov@yandex.ru>
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

Add riscv32-specific '__ashldi3()', '__ashrdi3()', and '__lshrdi3()'.
Initially it was intended to fix the following link error observed
when building EFI-enabled kernel with CONFIG_EFI_STUB=y and
CONFIG_EFI_GENERIC_STUB=y:

riscv32-linux-gnu-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
__efistub_cmdline.c:(.init.text+0x1f2): undefined reference to `__efistub___ashldi3'
riscv32-linux-gnu-ld: __efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'

Reported at [1] trying to build https://patchew.org/linux/20260212164413.889625-1-dmantipov@yandex.ru,
tested with 'qemu-system-riscv32 -M virt' only.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603041925.KLKqpK6N-lkp@intel.com [1]
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v4 and upwards: bump version to match the series
v3: more tests by Charlie Jenkins
v2: adjust commit message
---
 arch/riscv/Kconfig             |  3 ---
 arch/riscv/kernel/image-vars.h |  7 +++++++
 arch/riscv/lib/Makefile        |  1 +
 arch/riscv/lib/ashldi3.S       | 36 +++++++++++++++++++++++++++++++++
 arch/riscv/lib/ashrdi3.S       | 37 ++++++++++++++++++++++++++++++++++
 arch/riscv/lib/lshrdi3.S       | 36 +++++++++++++++++++++++++++++++++
 6 files changed, 117 insertions(+), 3 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d235396c4514..b1198b41c486 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -404,9 +404,6 @@ config ARCH_RV32I
 	bool "RV32I"
 	depends on NONPORTABLE
 	select 32BIT
-	select GENERIC_LIB_ASHLDI3
-	select GENERIC_LIB_ASHRDI3
-	select GENERIC_LIB_LSHRDI3
 	select GENERIC_LIB_UCMPDI2
 
 config ARCH_RV64I
diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
index 3bd9d06a8b8f..d66e06daf13e 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -32,6 +32,13 @@ __efistub___init_text_end	= __init_text_end;
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
 
+/*
+ * These double-word integer shifts are used
+ * by the library code and so EFI stub as well.
+ */
+PROVIDE(__efistub___lshrdi3    = __lshrdi3);
+PROVIDE(__efistub___ashldi3    = __ashldi3);
+
 #endif
 
 #endif /* __RISCV_KERNEL_IMAGE_VARS_H */
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 6f767b2a349d..f668b98970bd 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -16,6 +16,7 @@ ifeq ($(CONFIG_MMU), y)
 lib-$(CONFIG_RISCV_ISA_V)	+= uaccess_vector.o
 endif
 lib-$(CONFIG_MMU)	+= uaccess.o
+lib-$(CONFIG_32BIT)	+= ashldi3.o ashrdi3.o lshrdi3.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
diff --git a/arch/riscv/lib/ashldi3.S b/arch/riscv/lib/ashldi3.S
new file mode 100644
index 000000000000..c3408862e2f6
--- /dev/null
+++ b/arch/riscv/lib/ashldi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/**
+ * Adopted for the Linux kernel from IPXE project, see
+ * https://github.com/ipxe/ipxe/blob/master/src/arch/riscv32/libgcc/llshift.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+/**
+ * Shift left
+ *
+ * @v a1:a0             Value to shift
+ * @v a2                Shift amount
+ * @ret a1:a0           Shifted value
+ */
+
+SYM_FUNC_START(__ashldi3)
+
+        /* Perform shift by 32 bits, if applicable */
+        li      t0, 32
+        sub     t1, t0, a2
+        bgtz    t1, 1f
+        mv      a1, a0
+        mv      a0, zero
+1:      /* Perform shift by modulo-32 bits, if applicable */
+        andi    a2, a2, 0x1f
+        beqz    a2, 2f
+        srl     t2, a0, t1
+        sll     a0, a0, a2
+        sll     a1, a1, a2
+        or      a1, a1, t2
+2:      ret
+
+SYM_FUNC_END(__ashldi3)
+EXPORT_SYMBOL(__ashldi3)
diff --git a/arch/riscv/lib/ashrdi3.S b/arch/riscv/lib/ashrdi3.S
new file mode 100644
index 000000000000..dd42b3cbb173
--- /dev/null
+++ b/arch/riscv/lib/ashrdi3.S
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/**
+ * Adopted for the Linux kernel from IPXE project, see
+ * https://github.com/ipxe/ipxe/blob/master/src/arch/riscv32/libgcc/llshift.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+/**
+ * Arithmetic shift right
+ *
+ * @v a1:a0             Value to shift
+ * @v a2                Shift amount
+ * @ret a1:a0           Shifted value
+ */
+
+SYM_FUNC_START(__ashrdi3)
+
+        /* Perform shift by 32 bits, if applicable */
+        li      t0, 32
+        sub     t1, t0, a2
+        bgtz    t1, 1f
+        mv      a0, a1
+        srai    a1, a1, 16
+        srai    a1, a1, 16
+1:      /* Perform shift by modulo-32 bits, if applicable */
+        andi    a2, a2, 0x1f
+        beqz    a2, 2f
+        sll     t2, a1, t1
+        sra     a1, a1, a2
+        srl     a0, a0, a2
+        or      a0, a0, t2
+2:      ret
+
+SYM_FUNC_END(__ashrdi3)
+EXPORT_SYMBOL(__ashrdi3)
diff --git a/arch/riscv/lib/lshrdi3.S b/arch/riscv/lib/lshrdi3.S
new file mode 100644
index 000000000000..1af03985ccb7
--- /dev/null
+++ b/arch/riscv/lib/lshrdi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/**
+ * Adopted for the Linux kernel from IPXE project, see
+ * https://github.com/ipxe/ipxe/blob/master/src/arch/riscv32/libgcc/llshift.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+/**
+ * Logical shift right
+ *
+ * @v a1:a0             Value to shift
+ * @v a2                Shift amount
+ * @ret a1:a0           Shifted value
+ */
+
+SYM_FUNC_START(__lshrdi3)
+
+        /* Perform shift by 32 bits, if applicable */
+        li      t0, 32
+        sub     t1, t0, a2
+        bgtz    t1, 1f
+        mv      a0, a1
+        mv      a1, zero
+1:      /* Perform shift by modulo-32 bits, if applicable */
+        andi    a2, a2, 0x1f
+        beqz    a2, 2f
+        sll     t2, a1, t1
+        srl     a1, a1, a2
+        srl     a0, a0, a2
+        or      a0, a0, t2
+2:      ret
+
+SYM_FUNC_END(__lshrdi3)
+EXPORT_SYMBOL(__lshrdi3)
-- 
2.53.0

