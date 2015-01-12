From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64/efi: efistub: apply __init annotation
Date: Mon, 12 Jan 2015 13:29:51 +0000
Message-ID: <1421069391-6902-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This ensures all stub component are freed when the kernel proper is
done booting, by prefixing the names of all ELF sections that have
the SHF_ALLOC attribute with ".init". This approach ensures that even
implicitly emitted allocated data (like initializer values and string
literals) are covered.

At the same time, remove some __init annotations in the stub that have
now become redundant, and add the __init annotation to handle_kernel_image
which will trigger a section mismatch without it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c                   | 14 +++++++-------
 drivers/firmware/efi/libstub/Makefile          | 15 +++++++++++++++
 drivers/firmware/efi/libstub/arm-stub.c        |  8 ++++----
 drivers/firmware/efi/libstub/efi-stub-helper.c |  2 +-
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index d27dd982ff26..f5374065ad53 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -13,13 +13,13 @@
 #include <asm/efi.h>
 #include <asm/sections.h>
 
-efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
-				 unsigned long *image_addr,
-				 unsigned long *image_size,
-				 unsigned long *reserve_addr,
-				 unsigned long *reserve_size,
-				 unsigned long dram_base,
-				 efi_loaded_image_t *image)
+efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table,
+					unsigned long *image_addr,
+					unsigned long *image_size,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size,
+					unsigned long dram_base,
+					efi_loaded_image_t *image)
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index b14bc2b9fb4d..4e7de244c663 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -24,3 +24,18 @@ lib-y				:= efi-stub-helper.o
 lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
 
 CFLAGS_fdt.o			+= -I$(srctree)/scripts/dtc/libfdt/
+
+#
+# arm64 puts the stub in the kernel proper, which will unnecessarily retain all
+# code indefinitely unless it is annotated as __init/__initdata/__initconst etc.
+# So let's apply the __init annotations at the section level, by prefixing
+# the section names directly. This will ensure that even all the inline string
+# literals are covered.
+#
+lib-$(CONFIG_ARM64)		:= $(addsuffix .init,$(lib-y))
+
+OBJCOPYFLAGS := --prefix-alloc-sections=.init
+$(obj)/%.o.init: $(obj)/%.o FORCE
+	$(call if_changed,objcopy)
+
+.PRECIOUS: $(obj)/%.o
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index e2432b39b6df..dcae482a9a17 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -17,10 +17,10 @@
 
 #include "efistub.h"
 
-static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
+static int efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
 {
-	static efi_guid_t const var_guid __initconst = EFI_GLOBAL_VARIABLE_GUID;
-	static efi_char16_t const var_name[] __initconst = {
+	static efi_guid_t const var_guid = EFI_GLOBAL_VARIABLE_GUID;
+	static efi_char16_t const var_name[] = {
 		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
 
 	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
@@ -164,7 +164,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
  * for both archictectures, with the arch-specific code provided in the
  * handle_kernel_image() function.
  */
-unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
+unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 			       unsigned long *image_addr)
 {
 	efi_loaded_image_t *image;
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index e766df60fbfb..2fe195002021 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -110,7 +110,7 @@ fail:
 }
 
 
-unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
+unsigned long get_dram_base(efi_system_table_t *sys_table_arg)
 {
 	efi_status_t status;
 	unsigned long map_size;
-- 
1.8.3.2
