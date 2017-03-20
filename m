From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/libstub: arm/arm64: make debug prints dependent on efi=debug
Date: Mon, 20 Mar 2017 20:57:05 +0000
Message-ID: <1490043425-20118-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The EFI stub currently prints a number of diagnostic messages that do
not carry a lot of information. Since these prints are not controlled
by 'loglevel' or other command line parameters, and since they appear on
the EFI framebuffer as well (if enabled), it would be nice if we could
turn them off.

So let's only print them if 'efi=debug' is passed on the command line,
or when CONFIG_DEBUG_EFI is set in the kernel build configuration.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm32-stub.c      |  2 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 23 ++++++++++++++---------
 drivers/firmware/efi/libstub/efistub.h         |  9 +++++++++
 drivers/firmware/efi/libstub/secureboot.c      |  2 ++
 include/linux/efi.h                            |  3 ---
 5 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index e1f0b28e1dcb..fd07ab3378bd 100644
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
index 919822b7773d..1ef299b15458 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,13 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+static int __debug_enabled = IS_ENABLED(CONFIG_DEBUG_EFI);
+
+int __pure debug_enabled(void)
+{
+	return __debug_enabled;
+}
+
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
 struct file_info {
@@ -414,14 +421,6 @@ efi_status_t efi_parse_options(char *cmdline)
 	char *str;
 
 	/*
-	 * Currently, the only efi= option we look for is 'nochunk', which
-	 * is intended to work around known issues on certain x86 UEFI
-	 * versions. So ignore for now on other architectures.
-	 */
-	if (!IS_ENABLED(CONFIG_X86))
-		return EFI_SUCCESS;
-
-	/*
 	 * If no EFI parameters were specified on the cmdline we've got
 	 * nothing to do.
 	 */
@@ -437,13 +436,19 @@ efi_status_t efi_parse_options(char *cmdline)
 	 * skip over arguments we don't understand.
 	 */
 	while (*str) {
+		if (*str == ' ')
+			break;
+
 		if (!strncmp(str, "nochunk", 7)) {
 			str += strlen("nochunk");
 			__chunk_size = -1UL;
+		} else if (!strncmp(str, "debug", 5)) {
+			str += strlen("debug");
+			__debug_enabled = 1;
 		}
 
 		/* Group words together, delimited by "," */
-		while (*str && *str != ',')
+		while (*str && *str != ',' && *str != ' ')
 			str++;
 
 		if (*str == ',')
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 71c4d0e3c4ed..5ed16e6e166f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -24,6 +24,15 @@
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
+extern int __pure debug_enabled(void);
+
+#define pr_efi(sys_table, msg)		do {				\
+	if (debug_enabled()) efi_printk(sys_table, "EFI stub: "msg);	\
+} while (0)
+
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
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
index 94d34e0be24f..0a22c8ab5873 100644
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
2.7.4
