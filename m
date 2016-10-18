From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/arm: Fix absolute relocation detection for older toolchains
Date: Tue, 18 Oct 2016 16:53:11 +0100
Message-ID: <1476805991-7160-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1476805991-7160-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476805991-7160-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

When building the ARM kernel with CONFIG_EFI=y, the following build
error may occur when using a less recent version of binutils (2.23 or
older):

   STUBCPY drivers/firmware/efi/libstub/lib-sort.stub.o
 00000000 R_ARM_ABS32       sort
 00000004 R_ARM_ABS32       __ksymtab_strings
 drivers/firmware/efi/libstub/lib-sort.stub.o: absolute symbol references
 not allowed in the EFI stub

(and when building with debug symbols, the list above is much longer, and
contains all the internal references between the .debug sections and the
actual code)

This issue is caused by the fact that objcopy v2.23 or earlier does not
support wildcards in its -R and -j options, which means the following
line from the Makefile:

  STUBCOPY_FLAGS-y		:= -R .debug* -R *ksymtab* -R *kcrctab*

fails to take effect, leaving harmless absolute relocations in the binary
that are indistinguishable from relocations that may cause crashes at
runtime due to the fact that these relocations are resolved at link time
using the virtual address of the kernel, which is always different from
the address at which the EFI firmware loads and invokes the stub.

So, as a workaround, disable debug symbols explicitly when building the
stub for ARM, and strip the ksymtab and kcrctab symbols for the only
exported symbol we currently reuse in the stub, which is 'sort'.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Tested-by: Jon Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index c06945160a41..5e23e2d305e7 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -11,7 +11,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
 				   -mno-mmx -mno-sse
 
 cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
-cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
+cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -g0 \
 				   -fno-builtin -fpic -mno-single-pic-base
 
 cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
@@ -79,5 +79,6 @@ quiet_cmd_stubcopy = STUBCPY $@
 # decompressor. So move our .data to .data.efistub, which is preserved
 # explicitly by the decompressor linker script.
 #
-STUBCOPY_FLAGS-$(CONFIG_ARM)	+= --rename-section .data=.data.efistub
+STUBCOPY_FLAGS-$(CONFIG_ARM)	+= --rename-section .data=.data.efistub \
+				   -R ___ksymtab+sort -R ___kcrctab+sort
 STUBCOPY_RELOC-$(CONFIG_ARM)	:= R_ARM_ABS
-- 
2.7.4
