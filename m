From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 5/5] efi: efistub: convert into static library
Date: Wed,  2 Jul 2014 14:54:43 +0200
Message-ID: <1404305683-26501-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1404305683-26501-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404305683-26501-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch changes both x86 and arm64 efistub implementations from #including
shared .c files under drivers/firmware/efi to building the shared code as a
static library.

The x86 code uses a stub built into the boot executable which uncompresses the
kernel at boot time. In this case, the library is linked into the decompressor.

In the arm64 case, the stub is part of the kernel proper so the library is
linked into the kernel proper as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/Kconfig                                 |  5 +++++
 arch/arm64/Makefile                                |  1 +
 arch/arm64/kernel/efi-stub.c                       |  6 -----
 arch/x86/boot/compressed/Makefile                  |  3 ++-
 arch/x86/boot/compressed/eboot.c                   |  2 --
 drivers/firmware/efi/Kconfig                       |  3 +++
 drivers/firmware/efi/Makefile                      |  1 +
 drivers/firmware/efi/libstub/Makefile              | 26 ++++++++++++++++++++++
 drivers/firmware/efi/{ => libstub}/arm-stub.c      |  0
 .../firmware/efi/{ => libstub}/efi-stub-helper.c   |  0
 drivers/firmware/efi/{ => libstub}/efistub.h       |  0
 drivers/firmware/efi/{ => libstub}/fdt.c           |  0
 12 files changed, 38 insertions(+), 9 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/Makefile
 rename drivers/firmware/efi/{ => libstub}/arm-stub.c (100%)
 rename drivers/firmware/efi/{ => libstub}/efi-stub-helper.c (100%)
 rename drivers/firmware/efi/{ => libstub}/efistub.h (100%)
 rename drivers/firmware/efi/{ => libstub}/fdt.c (100%)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2cc14cef01bd..3a0a4ce4c751 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -292,6 +292,9 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI_STUB
+	bool
+
 config EFI
 	bool "UEFI runtime support"
 	depends on OF && !CPU_BIG_ENDIAN
@@ -299,6 +302,8 @@ config EFI
 	select UCS2_STRING
 	select EFI_PARAMS_FROM_FDT
 	select EFI_RUNTIME_WRAPPERS
+	select EFI_STUB
+	select EFI_ARMSTUB
 	default y
 	help
 	  This option provides support for runtime services provided
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 8185a913c5ed..5836717d2f66 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -48,6 +48,7 @@ core-$(CONFIG_XEN) += arch/arm64/xen/
 core-$(CONFIG_CRYPTO) += arch/arm64/crypto/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
+libs-$(CONFIG_EFI_STUB) += drivers/firmware/efi/libstub/
 
 # Default target when executing plain make
 KBUILD_IMAGE	:= Image.gz
diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index e4999021b07d..1317fef8dde9 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -13,12 +13,6 @@
 #include <asm/efi.h>
 #include <asm/sections.h>
 
-/* Include shared EFI stub code */
-#include "../../../drivers/firmware/efi/efi-stub-helper.c"
-#include "../../../drivers/firmware/efi/fdt.c"
-#include "../../../drivers/firmware/efi/arm-stub.c"
-
-
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
 				 unsigned long *image_size,
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0fcd9133790c..7a801a310e37 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -33,7 +33,8 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
-	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
+	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
+				$(objtree)/drivers/firmware/efi/libstub/lib.a
 endif
 
 $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 916bbdd7dd28..3b5c66c8f749 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -280,8 +280,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 	}
 }
 
-#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
-
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
 	u8 first, len;
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 588dc47e7075..f712d47f30d8 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -57,6 +57,9 @@ config EFI_PARAMS_FROM_FDT
 config EFI_RUNTIME_WRAPPERS
 	bool
 
+config EFI_ARMSTUB
+	bool
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index e1096539eedb..a204d1474cec 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
+obj-$(CONFIG_EFI_STUB)			+= libstub/
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
new file mode 100644
index 000000000000..b14bc2b9fb4d
--- /dev/null
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -0,0 +1,26 @@
+#
+# The stub may be linked into the kernel proper or into a separate boot binary,
+# but in either case, it executes before the kernel does (with MMU disabled) so
+# things like ftrace and stack-protector are likely to cause trouble if left
+# enabled, even if doing so doesn't break the build.
+#
+cflags-$(CONFIG_X86_32)		:= -march=i386
+cflags-$(CONFIG_X86_64)		:= -mcmodel=small
+cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
+				   -fPIC -fno-strict-aliasing -mno-red-zone \
+				   -mno-mmx -mno-sse -DDISABLE_BRANCH_PROFILING
+
+cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
+cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
+				   -fno-builtin -fpic -mno-single-pic-base
+
+KBUILD_CFLAGS			:= $(cflags-y) \
+				   $(call cc-option,-ffreestanding) \
+				   $(call cc-option,-fno-stack-protector)
+
+GCOV_PROFILE			:= n
+
+lib-y				:= efi-stub-helper.o
+lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
+
+CFLAGS_fdt.o			+= -I$(srctree)/scripts/dtc/libfdt/
diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
similarity index 100%
rename from drivers/firmware/efi/arm-stub.c
rename to drivers/firmware/efi/libstub/arm-stub.c
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
similarity index 100%
rename from drivers/firmware/efi/efi-stub-helper.c
rename to drivers/firmware/efi/libstub/efi-stub-helper.c
diff --git a/drivers/firmware/efi/efistub.h b/drivers/firmware/efi/libstub/efistub.h
similarity index 100%
rename from drivers/firmware/efi/efistub.h
rename to drivers/firmware/efi/libstub/efistub.h
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/libstub/fdt.c
similarity index 100%
rename from drivers/firmware/efi/fdt.c
rename to drivers/firmware/efi/libstub/fdt.c
-- 
1.8.3.2
