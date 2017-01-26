From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 1/2] efi: libstub: Preserve .debug sections after absolute
 relocation check
Date: Thu, 26 Jan 2017 19:24:45 +0000
Message-ID: <1485458686-32544-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1485458686-32544-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1485458686-32544-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com
Cc: leif.lindholm@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
 drivers/firmware/efi/libstub/Makefile | 24 +++++++++++++-------
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
