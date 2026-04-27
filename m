Received: from forward205d.mail.yandex.net (forward205d.mail.yandex.net [178.154.239.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702133AF672;
	Mon, 27 Apr 2026 09:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280845; cv=none; b=NGBqMuI6VOyLNU3/Xwi39j3VCT8rGzCkJLVhQE9Gh/W3BkEsYkmQ9DnK+8NyXukwL9536vTLabxxkTTRdbtQHJi6DUq6z3/cNYcBmOri29PCEr8lWp2zJA7yoNE5s5C8meNgNHdG0/QFRWMlXs0QVjfe0zmbQLj7FoCTWPcMtIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280845; c=relaxed/simple;
	bh=s7HRcC8pRnTfGNUBuga3UrQ9BMLCjcP+JgeRbvw4KBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDGjVaUcYMGwQ/vVKAAdgKk+SnsSxp/ifJ7QOJca77gFc51NssSpj39Z4Jh2FwcqPRLM+l1enmEpHr7e7NvLz5oIr9fL69vfmvnIMV0IATx8cCZ6Vq+wF0kvf+IJH5sYesdrZ9xinqDlAv7LtmKTLvArgjZ5ZGrs5m/6S8CCSPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=bgP1eI8m; arc=none smtp.client-ip=178.154.239.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="bgP1eI8m"
Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d101])
	by forward205d.mail.yandex.net (Yandex) with ESMTPS id CF64185031;
	Mon, 27 Apr 2026 12:01:46 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:ea2:0:640:ef77:0])
	by forward101d.mail.yandex.net (Yandex) with ESMTPS id 9212FC0099;
	Mon, 27 Apr 2026 12:01:38 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (smtp) with ESMTPSA id X1UMu7lR5a60-vBBmAnZ1;
	Mon, 27 Apr 2026 12:01:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1777280497; bh=SfPCgNzhDXjDmJVjxPAqvTk7bkZqDRTJfwJQWV27XB8=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=bgP1eI8mxQi4SZO2v3iPIUFi44crndhzQMrMRMqEVJz0qheKUnoaaEO0h/6D4ZHdc
	 l0EQ+jXe6yg3+Lv1TafdN//ivnOsVS0tLTMVd/UFFnD88ohXXEigqaXyprVq92Po8M
	 cSrRDE7OFr2o4ij1HR4r/Vk37c6QDGKlPUlXrJkc=
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
	Dmitry Antipov <dmantipov@yandex.ru>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v7 1/3] riscv: add platform-specific double word shifts for riscv32
Date: Mon, 27 Apr 2026 12:01:03 +0300
Message-ID: <20260427090105.705529-2-dmantipov@yandex.ru>
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
Assisted-by: gemini/gemini-3.1-pro-preview sashiko
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v7: export for stub and optimize '__ashrdi3()' (Sashiko)
v4, v5, v6: and upwards: bump version to match the series
v3: more tests by Charlie Jenkins
v2: adjust commit message
---
 arch/riscv/Kconfig             |  3 ---
 arch/riscv/kernel/image-vars.h |  9 +++++++++
 arch/riscv/lib/Makefile        |  1 +
 arch/riscv/lib/ashldi3.S       | 36 ++++++++++++++++++++++++++++++++++
 arch/riscv/lib/ashrdi3.S       | 36 ++++++++++++++++++++++++++++++++++
 arch/riscv/lib/lshrdi3.S       | 36 ++++++++++++++++++++++++++++++++++
 6 files changed, 118 insertions(+), 3 deletions(-)
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
index 3bd9d06a8b8f..7b44b94f1283 100644
--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -32,6 +32,15 @@ __efistub___init_text_end	= __init_text_end;
 __efistub_sysfb_primary_display	= sysfb_primary_display;
 #endif
 
+/*
+ * These double-word integer shifts are used by the library code, and
+ * the first two of them are required to link EFI stub. Note __ashrdi3()
+ * is not actually used by the stub but this may change in the future.
+ */
+PROVIDE(__efistub___lshrdi3	= __lshrdi3);
+PROVIDE(__efistub___ashldi3	= __ashldi3);
+PROVIDE(__efistub___ashrdi3	= __ashrdi3);
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
index 000000000000..426de0946606
--- /dev/null
+++ b/arch/riscv/lib/ashrdi3.S
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
+        srai    a1, a1, 31
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

