From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 04/14] efi/libstub: arm64: set -fpie when building the EFI stub
Date: Fri, 18 Aug 2017 20:49:37 +0100
Message-ID: <20170818194947.19347-5-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
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

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 37e24f525162..cf81e6cf5ae8 100644
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
2.11.0
