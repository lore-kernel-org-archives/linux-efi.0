From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/4] efi/libstub: arm/arm64: disable debug prints on 'quiet' cmdline arg
Date: Mon, 27 Mar 2017 18:17:02 +0100
Message-ID: <20170327171703.15489-4-ard.biesheuvel@linaro.org>
References: <20170327171703.15489-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170327171703.15489-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The EFI stub currently prints a number of diagnostic messages that do
not carry a lot of information. Since these prints are not controlled
by 'loglevel' or other command line parameters, and since they appear on
the EFI framebuffer as well (if enabled), it would be nice if we could
turn them off.

So let's add support for the 'quiet' command line parameter in the stub,
and disable the non-error prints if it is passed.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm-stub.c        | 20 ++++++++++----------
 drivers/firmware/efi/libstub/arm32-stub.c      |  2 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c |  9 +++++++++
 drivers/firmware/efi/libstub/efistub.h         |  7 +++++++
 drivers/firmware/efi/libstub/secureboot.c      |  2 ++
 include/linux/efi.h                            |  3 ---
 6 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index ac3222f6f805..657bb72c9e0b 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -116,8 +116,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
-	pr_efi(sys_table, "Booting Linux Kernel...\n");
-
 	status = check_platform_features(sys_table);
 	if (status != EFI_SUCCESS)
 		goto fail;
@@ -151,6 +149,16 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail;
 	}
 
+	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
+	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
+	    cmdline_size == 0)
+		efi_parse_options(CONFIG_CMDLINE);
+
+	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline_size > 0)
+		efi_parse_options(cmdline_ptr);
+
+	pr_efi(sys_table, "Booting Linux Kernel...\n");
+
 	si = setup_graphics(sys_table);
 
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
@@ -162,14 +170,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
-	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
-	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
-	    cmdline_size == 0)
-		efi_parse_options(CONFIG_CMDLINE);
-
-	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline_size > 0)
-		efi_parse_options(cmdline_ptr);
-
 	secure_boot = efi_get_secureboot(sys_table);
 
 	/*
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 18a8b5eb55e7..becbda445913 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -9,6 +9,8 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+#include "efistub.h"
+
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	int block;
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 2e17d2b8787c..b0184360efc6 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -33,11 +33,16 @@
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
 static int __section(.data) __nokaslr;
+static int __section(.data) __quiet;
 
 int __pure nokaslr(void)
 {
 	return __nokaslr;
 }
+int __pure is_quiet(void)
+{
+	return __quiet;
+}
 
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
@@ -424,6 +429,10 @@ efi_status_t efi_parse_options(char const *cmdline)
 	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
 		__nokaslr = 1;
 
+	str = strstr(cmdline, "quiet");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__quiet = 1;
+
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
 	 * nothing to do.
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index a7a2a2c3f199..83f268c05007 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -25,6 +25,13 @@
 #endif
 
 extern int __pure nokaslr(void);
+extern int __pure is_quiet(void);
+
+#define pr_efi(sys_table, msg)		do {				\
+	if (!is_quiet()) efi_printk(sys_table, "EFI stub: "msg);	\
+} while (0)
+
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
 
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 5da36e56b36a..8c34d50a4d80 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -12,6 +12,8 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+#include "efistub.h"
+
 /* BIOS variables */
 static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
 static const efi_char16_t const efi_SecureBoot_name[] = {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e485e87615d1..ec36f42a2add 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1435,9 +1435,6 @@ static inline int efi_runtime_map_copy(void *buf, size_t bufsz)
 
 /* prototypes shared between arch specific and generic stub code */
 
-#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
-#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
-
 void efi_printk(efi_system_table_t *sys_table_arg, char *str);
 
 void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
-- 
2.9.3
