From: duwe@lst.de (Torsten Duwe)
Subject: [PATCH v8 2/5] arm64: replace -pg with CC_FLAGS_FTRACE in efi Makefiles
Date: Fri,  8 Feb 2019 16:10:11 +0100 (CET)
Message-ID: <20190208151011.0807668DD3@newverein.lst.de>
References: <20190208150826.44EBC68DD2@newverein.lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208150826.44EBC68DD2@newverein.lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

  In preparation for arm64 supporting ftrace built on other compiler
  options, let's have makefiles remove the $(CC_FLAGS_FTRACE)
  flags, whatever these may be, rather than assuming '-pg'.
  While at it, fix arm32 as well.

  There should be no functional change as a result of this patch.

Signed-off-by: Torsten Duwe <duwe@suse.de>

---
 drivers/firmware/efi/libstub/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -16,9 +16,9 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__K
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -fpie \
-				   $(DISABLE_STACKLEAK_PLUGIN)
-cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
+cflags-$(CONFIG_ARM64)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
+				   -fpie $(DISABLE_STACKLEAK_PLUGIN)
+cflags-$(CONFIG_ARM)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic \
 				   $(call cc-option,-mno-single-pic-base)
 
