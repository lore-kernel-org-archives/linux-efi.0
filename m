From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/10] efi: libstub: Preserve .debug sections after absolute relocation check
Date: Tue, 31 Jan 2017 13:21:42 +0000
Message-ID: <1485868902-20401-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

The build commands for the ARM and arm64 EFI stubs strip the .debug
sections and other sections that may legally contain absolute relocations,
in order to inspect the remaining sections for the presence of such
relocations.

This leaves us without debugging symbols in the stub for no good reason,
considering that these sections are omitted from the kernel binary anyway,
and that these relocations are thus only consumed by users of the ELF
binary, such as debuggers.

So move to 'strip' for performing the relocation check, and if it succeeds,
invoke objcopy as before, but leaving the .debug sections in place. Note
that these sections may refer to ksymtab/kcrctab contents, so leave those
in place as well.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/Makefile | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d564d25df8ab..33e0e2f1a730 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -11,7 +11,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
 				   -mno-mmx -mno-sse
 
 cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
-cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -g0 \
+cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
 cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
@@ -60,7 +60,7 @@ CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 extra-$(CONFIG_EFI_ARMSTUB)	:= $(lib-y)
 lib-$(CONFIG_EFI_ARMSTUB)	:= $(patsubst %.o,%.stub.o,$(lib-y))
 
-STUBCOPY_FLAGS-y		:= -R .debug* -R *ksymtab* -R *kcrctab*
+STUBCOPY_RM-y			:= -R *ksymtab* -R *kcrctab*
 STUBCOPY_FLAGS-$(CONFIG_ARM64)	+= --prefix-alloc-sections=.init \
 				   --prefix-symbols=__efistub_
 STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
@@ -68,17 +68,25 @@ STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
 $(obj)/%.stub.o: $(obj)/%.o FORCE
 	$(call if_changed,stubcopy)
 
+#
+# Strip debug sections and some other sections that may legally contain
+# absolute relocations, so that we can inspect the remaining sections for
+# such relocations. If none are found, regenerate the output object, but
+# this time, use objcopy and leave all sections in place.
+#
 quiet_cmd_stubcopy = STUBCPY $@
-      cmd_stubcopy = if $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; then	\
-		     $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y)	\
-		     && (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
-			 rm -f $@; /bin/false); else /bin/false; fi
+      cmd_stubcopy = if $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<; \
+		     then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); \
+		     then (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
+			   rm -f $@; /bin/false); 			  \
+		     else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi	  \
+		     else /bin/false; fi
 
 #
 # ARM discards the .data section because it disallows r/w data in the
 # decompressor. So move our .data to .data.efistub, which is preserved
 # explicitly by the decompressor linker script.
 #
-STUBCOPY_FLAGS-$(CONFIG_ARM)	+= --rename-section .data=.data.efistub \
-				   -R ___ksymtab+sort -R ___kcrctab+sort
+STUBCOPY_FLAGS-$(CONFIG_ARM)	+= --rename-section .data=.data.efistub
+STUBCOPY_RM-$(CONFIG_ARM)	+= -R ___ksymtab+sort -R ___kcrctab+sort
 STUBCOPY_RELOC-$(CONFIG_ARM)	:= R_ARM_ABS
-- 
2.7.4
