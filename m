From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH 2/4] efi/runtime-wrappers, kasan: don't sanitize runtime wrappers.
Date: Wed, 26 Aug 2015 19:15:05 +0300
Message-ID: <1440605707-8325-3-git-send-email-ryabinin.a.a@gmail.com>
References: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>
List-Id: linux-efi@vger.kernel.org

ARM64 maps efi runtime services in userspace addresses
which don't have KASAN shadow. So dereferencing these addresses
in efi_call_virt() will cause crash if this code instrumented.

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 drivers/firmware/efi/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 6fd3da9..413fcf2 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,6 +1,14 @@
 #
 # Makefile for linux kernel
 #
+
+#
+# ARM64 maps efi runtime services in userspace addresses
+# which don't have KASAN shadow. So dereference of these addresses
+# in efi_call_virt() will cause crash if this code instrumented.
+#
+KASAN_SANITIZE_runtime-wrappers.o	:= n
+
 obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
-- 
2.4.6
