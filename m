From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH 1/4] x86, efi, kasan: #undef memset/memcpy/memmove per arch.
Date: Wed, 26 Aug 2015 19:15:04 +0300
Message-ID: <1440605707-8325-2-git-send-email-ryabinin.a.a@gmail.com>
References: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

In not-instrumented code KASAN replaces instrumented
memset/memcpy/memmove with not-instrumented analogues
__memset/__memcpy/__memove.
However, on x86 EFI stub is not linked with kernel.
It uses not-instrumented mem*() functions from
arch/x86/boot/compressed/string.c
So we don't replace them with __mem*() variants in EFI stub.

In ARM64 EFI stub is linked with the kernel, so we should
replace mem*() functions with __mem*(), because EFI stub
runs before KASAN setup early shadow.

So let's move these #undef mem* into arch's asm/efi.h which is
also included by EFI stub.

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/x86/include/asm/efi.h             | 8 ++++++++
 drivers/firmware/efi/libstub/efistub.h | 4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 155162e..d821ce2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -25,6 +25,14 @@
 #define EFI32_LOADER_SIGNATURE	"EL32"
 #define EFI64_LOADER_SIGNATURE	"EL64"
 
+/*
+ * Use memcpy/memset from arch/x86/boot/compressed/string.c
+ * for EFI stub.
+ */
+#undef memcpy
+#undef memset
+#undef memmove
+
 #ifdef CONFIG_X86_32
 
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index e334a01..6b6548f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -5,10 +5,6 @@
 /* error code which can't be mistaken for valid address */
 #define EFI_ERROR	(~0UL)
 
-#undef memcpy
-#undef memset
-#undef memmove
-
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
-- 
2.4.6
