From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 19/70] efi/libstub/arm64: Set -fpie when building the EFI stub
Date: Mon, 26 Nov 2018 11:50:34 +0100
Message-ID: <20181126105048.681817537@linuxfoundation.org>
References: <20181126105046.722096341@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126105046.722096341@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-efi@vger.kernel.org

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 91ee5b21ee026c49e4e7483de69b55b8b47042be upstream.

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

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20170818194947.19347-5-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -10,7 +10,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__K
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
 				   -mno-mmx -mno-sse -DDISABLE_BRANCH_PROFILING
 
-cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
+cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -fpie
 cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
