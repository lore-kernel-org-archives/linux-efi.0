From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 4/5] efi: efistub: refactor stub components
Date: Wed,  2 Jul 2014 14:54:42 +0200
Message-ID: <1404305683-26501-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1404305683-26501-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404305683-26501-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In order to move from the #include "../../../xxxxx.c" anti-pattern used by
both the x86 and arm64 versions of the stub to a static library linked into
either the kernel proper (arm64) or a separate boot executable (x86), there
is some prepatory work required.

This patch does the following:
- move forward declarations of functions shared between the arch specific and
  the generic parts of the stub to include/linux/efi.h
- move forward declarations of functions shared between various .c files of the
  generic stub code to a new local header file called "efistub.h"
- add #includes to all .c files which were formerly relying on the #includor to
  include the correct header files
- remove all static modifiers from functions which will need to be externally
  visible once we move to a static library

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c           | 29 ++++---------
 arch/x86/boot/compressed/eboot.c       | 13 +++---
 drivers/firmware/efi/arm-stub.c        | 32 +++++++++------
 drivers/firmware/efi/efi-stub-helper.c | 74 +++++++++++++++++-----------------
 drivers/firmware/efi/efistub.h         | 42 +++++++++++++++++++
 drivers/firmware/efi/fdt.c             | 20 +++++----
 include/linux/efi.h                    | 42 +++++++++++++++++++
 7 files changed, 164 insertions(+), 88 deletions(-)
 create mode 100644 drivers/firmware/efi/efistub.h

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 23cbde4324b1..e4999021b07d 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -11,36 +11,21 @@
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
-#include <linux/libfdt.h>
 #include <asm/sections.h>
 
-static void efi_char16_printk(efi_system_table_t *sys_table_arg,
-			      efi_char16_t *str);
-
-static efi_status_t efi_open_volume(efi_system_table_t *sys_table,
-				    void *__image, void **__fh);
-static efi_status_t efi_file_close(void *handle);
-
-static efi_status_t
-efi_file_read(void *handle, unsigned long *size, void *addr);
-
-static efi_status_t
-efi_file_size(efi_system_table_t *sys_table, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz);
-
 /* Include shared EFI stub code */
 #include "../../../drivers/firmware/efi/efi-stub-helper.c"
 #include "../../../drivers/firmware/efi/fdt.c"
 #include "../../../drivers/firmware/efi/arm-stub.c"
 
 
-static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
-					unsigned long *image_addr,
-					unsigned long *image_size,
-					unsigned long *reserve_addr,
-					unsigned long *reserve_size,
-					unsigned long dram_base,
-					efi_loaded_image_t *image)
+efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+				 unsigned long *image_addr,
+				 unsigned long *image_size,
+				 unsigned long *reserve_addr,
+				 unsigned long *reserve_size,
+				 unsigned long dram_base,
+				 efi_loaded_image_t *image)
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c066bc4e3051..916bbdd7dd28 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -45,8 +45,7 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
 
-static void efi_printk(efi_system_table_t *, char *);
-static void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
+void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 static efi_status_t
 __file_size32(void *__fh, efi_char16_t *filename_16,
@@ -153,7 +152,7 @@ grow:
 
 	return status;
 }
-static efi_status_t
+efi_status_t
 efi_file_size(efi_system_table_t *sys_table, void *__fh,
 	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
 {
@@ -163,7 +162,7 @@ efi_file_size(efi_system_table_t *sys_table, void *__fh,
 	return __file_size32(__fh, filename_16, handle, file_sz);
 }
 
-static inline efi_status_t
+efi_status_t
 efi_file_read(void *handle, unsigned long *size, void *addr)
 {
 	unsigned long func;
@@ -181,7 +180,7 @@ efi_file_read(void *handle, unsigned long *size, void *addr)
 	}
 }
 
-static inline efi_status_t efi_file_close(void *handle)
+efi_status_t efi_file_close(void *handle)
 {
 	if (efi_early->is64) {
 		efi_file_handle_64_t *fh = handle;
@@ -246,7 +245,7 @@ static inline efi_status_t __open_volume64(void *__image, void **__fh)
 	return status;
 }
 
-static inline efi_status_t
+efi_status_t
 efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 {
 	if (efi_early->is64)
@@ -255,7 +254,7 @@ efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 	return __open_volume32(__image, __fh);
 }
 
-static void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
+void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 {
 	unsigned long output_string;
 	size_t offset;
diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
index 41114ce03b01..480339b6b110 100644
--- a/drivers/firmware/efi/arm-stub.c
+++ b/drivers/firmware/efi/arm-stub.c
@@ -12,6 +12,11 @@
  *
  */
 
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
+
 static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
 {
 	static efi_guid_t const var_guid __initconst = EFI_GLOBAL_VARIABLE_GUID;
@@ -36,8 +41,8 @@ static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
 	}
 }
 
-static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
-				    void *__image, void **__fh)
+efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
+			     void *__image, void **__fh)
 {
 	efi_file_io_interface_t *io;
 	efi_loaded_image_t *image = __image;
@@ -60,14 +65,15 @@ static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 	*__fh = fh;
 	return status;
 }
-static efi_status_t efi_file_close(void *handle)
+
+efi_status_t efi_file_close(void *handle)
 {
 	efi_file_handle_t *fh = handle;
 
 	return fh->close(handle);
 }
 
-static efi_status_t
+efi_status_t
 efi_file_read(void *handle, unsigned long *size, void *addr)
 {
 	efi_file_handle_t *fh = handle;
@@ -76,7 +82,7 @@ efi_file_read(void *handle, unsigned long *size, void *addr)
 }
 
 
-static efi_status_t
+efi_status_t
 efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
 	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
 {
@@ -129,7 +135,7 @@ grow:
 
 
 
-static void efi_char16_printk(efi_system_table_t *sys_table_arg,
+void efi_char16_printk(efi_system_table_t *sys_table_arg,
 			      efi_char16_t *str)
 {
 	struct efi_simple_text_output_protocol *out;
@@ -145,13 +151,13 @@ static void efi_char16_printk(efi_system_table_t *sys_table_arg,
  * must be reserved. On failure it is required to free all
  * all allocations it has made.
  */
-static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
-					unsigned long *image_addr,
-					unsigned long *image_size,
-					unsigned long *reserve_addr,
-					unsigned long *reserve_size,
-					unsigned long dram_base,
-					efi_loaded_image_t *image);
+efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+				 unsigned long *image_addr,
+				 unsigned long *image_size,
+				 unsigned long *reserve_addr,
+				 unsigned long *reserve_size,
+				 unsigned long dram_base,
+				 efi_loaded_image_t *image);
 /*
  * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
  * that is described in the PE/COFF header.  Most of the code is the same
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index eb6d4be9e722..32d5cca30f49 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -9,18 +9,20 @@
  * under the terms of the GNU General Public License version 2.
  *
  */
-#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
-/* error code which can't be mistaken for valid address */
-#define EFI_ERROR	(~0UL)
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
 
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
 };
 
-static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
+void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 {
 	char *s8;
 
@@ -37,16 +39,12 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 	}
 }
 
-#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
-#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
-
-
-static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
-				       efi_memory_desc_t **map,
-				       unsigned long *map_size,
-				       unsigned long *desc_size,
-				       u32 *desc_ver,
-				       unsigned long *key_ptr)
+efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				efi_memory_desc_t **map,
+				unsigned long *map_size,
+				unsigned long *desc_size,
+				u32 *desc_ver,
+				unsigned long *key_ptr)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -88,7 +86,7 @@ fail:
 }
 
 
-static unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
+unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
 {
 	efi_status_t status;
 	unsigned long map_size;
@@ -116,9 +114,9 @@ static unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
-			       unsigned long size, unsigned long align,
-			       unsigned long *addr, unsigned long max)
+efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
+			    unsigned long size, unsigned long align,
+			    unsigned long *addr, unsigned long max)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -202,9 +200,9 @@ fail:
 /*
  * Allocate at the lowest possible address.
  */
-static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
-			      unsigned long size, unsigned long align,
-			      unsigned long *addr)
+efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			   unsigned long size, unsigned long align,
+			   unsigned long *addr)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -271,8 +269,8 @@ fail:
 	return status;
 }
 
-static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
-		     unsigned long addr)
+void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
+	      unsigned long addr)
 {
 	unsigned long nr_pages;
 
@@ -290,12 +288,12 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
  * We only support loading a file from the same filesystem as
  * the kernel image.
  */
-static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
-					 efi_loaded_image_t *image,
-					 char *cmd_line, char *option_string,
-					 unsigned long max_addr,
-					 unsigned long *load_addr,
-					 unsigned long *load_size)
+efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+				  efi_loaded_image_t *image,
+				  char *cmd_line, char *option_string,
+				  unsigned long max_addr,
+				  unsigned long *load_addr,
+				  unsigned long *load_size)
 {
 	struct file_info *files;
 	unsigned long file_addr;
@@ -477,12 +475,12 @@ fail:
  * address is not available the lowest available address will
  * be used.
  */
-static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
-					unsigned long *image_addr,
-					unsigned long image_size,
-					unsigned long alloc_size,
-					unsigned long preferred_addr,
-					unsigned long alignment)
+efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
+				 unsigned long *image_addr,
+				 unsigned long image_size,
+				 unsigned long alloc_size,
+				 unsigned long preferred_addr,
+				 unsigned long alignment)
 {
 	unsigned long cur_image_addr;
 	unsigned long new_addr = 0;
@@ -589,9 +587,9 @@ static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
  * Size of memory allocated return in *cmd_line_len.
  * Returns NULL on error.
  */
-static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
-				 efi_loaded_image_t *image,
-				 int *cmd_line_len)
+char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+			  efi_loaded_image_t *image,
+			  int *cmd_line_len)
 {
 	const u16 *s2;
 	u8 *s1 = NULL;
diff --git a/drivers/firmware/efi/efistub.h b/drivers/firmware/efi/efistub.h
new file mode 100644
index 000000000000..304ab295ca1a
--- /dev/null
+++ b/drivers/firmware/efi/efistub.h
@@ -0,0 +1,42 @@
+
+#ifndef _DRIVERS_FIRMWARE_EFI_EFISTUB_H
+#define _DRIVERS_FIRMWARE_EFI_EFISTUB_H
+
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
+
+efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
+			     void **__fh);
+
+efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
+			   efi_char16_t *filename_16, void **handle,
+			   u64 *file_sz);
+
+efi_status_t efi_file_read(void *handle, unsigned long *size, void *addr);
+
+efi_status_t efi_file_close(void *handle);
+
+unsigned long get_dram_base(efi_system_table_t *sys_table_arg);
+
+efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			unsigned long orig_fdt_size,
+			void *fdt, int new_fdt_size, char *cmdline_ptr,
+			u64 initrd_addr, u64 initrd_size,
+			efi_memory_desc_t *memory_map,
+			unsigned long map_size, unsigned long desc_size,
+			u32 desc_ver);
+
+efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
+					    void *handle,
+					    unsigned long *new_fdt_addr,
+					    unsigned long max_addr,
+					    u64 initrd_addr, u64 initrd_size,
+					    char *cmdline_ptr,
+					    unsigned long fdt_addr,
+					    unsigned long fdt_size);
+
+void *get_fdt(efi_system_table_t *sys_table);
+
+#endif
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 3aec36d7aae9..86d2934840e2 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -10,13 +10,17 @@
  *
  */
 
-static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
-			       unsigned long orig_fdt_size,
-			       void *fdt, int new_fdt_size, char *cmdline_ptr,
-			       u64 initrd_addr, u64 initrd_size,
-			       efi_memory_desc_t *memory_map,
-			       unsigned long map_size, unsigned long desc_size,
-			       u32 desc_ver)
+#include <linux/efi.h>
+#include <linux/libfdt.h>
+#include <asm/efi.h>
+
+efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			unsigned long orig_fdt_size,
+			void *fdt, int new_fdt_size, char *cmdline_ptr,
+			u64 initrd_addr, u64 initrd_size,
+			efi_memory_desc_t *memory_map,
+			unsigned long map_size, unsigned long desc_size,
+			u32 desc_ver)
 {
 	int node, prev;
 	int status;
@@ -255,7 +259,7 @@ fail:
 	return EFI_LOAD_ERROR;
 }
 
-static void *get_fdt(efi_system_table_t *sys_table)
+void *get_fdt(efi_system_table_t *sys_table)
 {
 	efi_guid_t fdt_guid = DEVICE_TREE_GUID;
 	efi_config_table_t *tables;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0ceb816bdfc2..3a64f2f85821 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1163,4 +1163,46 @@ static inline void
 efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
 #endif
 
+/* prototypes shared between arch specific and generic stub code */
+
+#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
+void efi_printk(efi_system_table_t *sys_table_arg, char *str);
+
+void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
+	      unsigned long addr);
+
+char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+			  efi_loaded_image_t *image, int *cmd_line_len);
+
+efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				efi_memory_desc_t **map,
+				unsigned long *map_size,
+				unsigned long *desc_size,
+				u32 *desc_ver,
+				unsigned long *key_ptr);
+
+efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			   unsigned long size, unsigned long align,
+			   unsigned long *addr);
+
+efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
+			    unsigned long size, unsigned long align,
+			    unsigned long *addr, unsigned long max);
+
+efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
+				 unsigned long *image_addr,
+				 unsigned long image_size,
+				 unsigned long alloc_size,
+				 unsigned long preferred_addr,
+				 unsigned long alignment);
+
+efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+				  efi_loaded_image_t *image,
+				  char *cmd_line, char *option_string,
+				  unsigned long max_addr,
+				  unsigned long *load_addr,
+				  unsigned long *load_size);
+
 #endif /* _LINUX_EFI_H */
-- 
1.8.3.2
