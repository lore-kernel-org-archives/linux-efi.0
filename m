From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] efi/libstub: arm64: set -fpie when building the EFI stub
Date: Thu, 18 May 2017 10:09:53 +0100
Message-ID: <20170518090953.32628-4-ard.biesheuvel@linaro.org>
References: <20170518090953.32628-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518090953.32628-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Clang may emit absolute symbol references when building in non-PIC mode,
even when using the default 'small' code model, which is already mostly
position independent to begin with, due to its use of adrp/add pairs
that have a relative range of +/- 4 GB. The remedy is to pass the -fpie
flag, which can be done safely now that the code has been updated to avoid
GOT indirections (which may be emitted due to the compiler assuming that
the PIC/PIE code may end up in a shared library that is subject to ELF
symbol preemption)

Passing -fpie when building code that needs to execute at an a priori
unknown offset is arguably an improvement in any case, and given that
the recent visibility changes allow the PIC build to pass with GCC as
well, let's add -fpie for all arm64 builds rather than only for Clang.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index f7425960f6a5..e078390ba477 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -10,7 +10,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
 				   -mno-mmx -mno-sse
 
-cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
+cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -fpie
 cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
-- 
2.9.3
