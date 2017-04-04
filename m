From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 10/12] efi/libstub: Unify command line param parsing
Date: Tue,  4 Apr 2017 17:09:08 +0100
Message-ID: <20170404160910.28115-1-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, roy.franz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eugene-VXdhtT5mjnY@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Merge the parsing of the command line carried out in arm-stub.c with
the handling in efi_parse_options. Note that this also fixes the
missing handling of CONFIG_CMDLINE_FORCE=y, in which case the builtin
command line should supersede the one passed by the firmware.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm-stub.c        | 24 +++++++-----------------
 drivers/firmware/efi/libstub/arm64-stub.c      |  4 +---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 19 +++++++++++--------
 drivers/firmware/efi/libstub/efistub.h         |  2 ++
 include/linux/efi.h                            |  2 +-
 5 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 02049ff25c6b..ac3222f6f805 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -18,8 +18,6 @@
 
 #include "efistub.h"
 
-bool __nokaslr;
-
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
 {
@@ -153,18 +151,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	/* check whether 'nokaslr' was passed on the command line */
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		static const u8 default_cmdline[] = CONFIG_CMDLINE;
-		const u8 *str, *cmdline = cmdline_ptr;
-
-		if (IS_ENABLED(CONFIG_CMDLINE_FORCE))
-			cmdline = default_cmdline;
-		str = strstr(cmdline, "nokaslr");
-		if (str == cmdline || (str > cmdline && *(str - 1) == ' '))
-			__nokaslr = true;
-	}
-
 	si = setup_graphics(sys_table);
 
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
@@ -176,9 +162,13 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
-	status = efi_parse_options(cmdline_ptr);
-	if (status != EFI_SUCCESS)
-		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
+	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
+	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
+	    cmdline_size == 0)
+		efi_parse_options(CONFIG_CMDLINE);
+
+	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline_size > 0)
+		efi_parse_options(cmdline_ptr);
 
 	secure_boot = efi_get_secureboot(sys_table);
 
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index eae693eb3e91..b4c2589d7c91 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -16,8 +16,6 @@
 
 #include "efistub.h"
 
-extern bool __nokaslr;
-
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	u64 tg;
@@ -52,7 +50,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 	u64 phys_seed = 0;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		if (!__nokaslr) {
+		if (!nokaslr()) {
 			status = efi_get_random_bytes(sys_table_arg,
 						      sizeof(phys_seed),
 						      (u8 *)&phys_seed);
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3290fae0b38f..2e17d2b8787c 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,13 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+static int __section(.data) __nokaslr;
+
+int __pure nokaslr(void)
+{
+	return __nokaslr;
+}
+
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
 struct file_info {
@@ -409,17 +416,13 @@ static efi_status_t efi_file_close(void *handle)
  * environments, first in the early boot environment of the EFI boot
  * stub, and subsequently during the kernel boot.
  */
-efi_status_t efi_parse_options(char *cmdline)
+efi_status_t efi_parse_options(char const *cmdline)
 {
 	char *str;
 
-	/*
-	 * Currently, the only efi= option we look for is 'nochunk', which
-	 * is intended to work around known issues on certain x86 UEFI
-	 * versions. So ignore for now on other architectures.
-	 */
-	if (!IS_ENABLED(CONFIG_X86))
-		return EFI_SUCCESS;
+	str = strstr(cmdline, "nokaslr");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__nokaslr = 1;
 
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 71c4d0e3c4ed..a7a2a2c3f199 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -24,6 +24,8 @@
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
+extern int __pure nokaslr(void);
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 94d34e0be24f..e485e87615d1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1471,7 +1471,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
-efi_status_t efi_parse_options(char *cmdline);
+efi_status_t efi_parse_options(char const *cmdline);
 
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   struct screen_info *si, efi_guid_t *proto,
-- 
2.9.3
