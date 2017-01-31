From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/7] efi: Get the secure boot status [ver #7]
Date: Tue, 31 Jan 2017 15:13:49 +0000
Message-ID: <148587562967.4026.18171897997650345605.stgit@warthog.procyon.org.uk>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Get the firmware's secure-boot status in the kernel boot wrapper and stash
it somewhere that the main kernel image can find.

The efi_get_secureboot() function is extracted from the arm stub and (a)
generalised so that it can be called from x86 and (b) made to use
efi_call_runtime() so that it can be run in mixed-mode.

For x86, it is stored in boot_params and can be overridden by the boot
loader or kexec.  This allows secure-boot mode to be passed on to a new
kernel.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/x86/zero-page.txt           |    2 +
 arch/x86/boot/compressed/eboot.c          |    6 +++
 arch/x86/include/uapi/asm/bootparam.h     |    3 +
 arch/x86/kernel/asm-offsets.c             |    1 
 drivers/firmware/efi/libstub/Makefile     |    2 -
 drivers/firmware/efi/libstub/arm-stub.c   |   63 +++--------------------------
 drivers/firmware/efi/libstub/secureboot.c |   63 +++++++++++++++++++++++++++++
 include/linux/efi.h                       |    8 ++++
 8 files changed, 89 insertions(+), 59 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index 95a4d34af3fd..b8527c6b7646 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -31,6 +31,8 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EB/001	ALL     kbd_status      Numlock is enabled
+1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
 1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f99978db6b6f..57c2c9c71e53 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -988,6 +988,12 @@ struct boot_params *efi_main(struct efi_config *c,
 	else
 		setup_boot_services32(efi_early);
 
+	/* If the boot loader gave us a value for secure_boot then we use that,
+	 * otherwise we ask the BIOS.
+	 */
+	if (boot_params->secure_boot == efi_secureboot_mode_unset)
+		boot_params->secure_boot = efi_get_secureboot(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index b10bf319ed20..5138dacf8bb8 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -135,7 +135,8 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad5[3];					/* 0x1ec */
+	__u8  secure_boot;				/* 0x1ec */
+	__u8  _pad5[2];					/* 0x1ed */
 	/*
 	 * The sentinel is set to a nonzero value (0xff) in header.S.
 	 *
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index c62e015b126c..de827d6ac8c2 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -81,6 +81,7 @@ void common(void) {
 
 	BLANK();
 	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_secure_boot, boot_params, secure_boot);
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 33e0e2f1a730..f7425960f6a5 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -28,7 +28,7 @@ OBJECT_FILES_NON_STANDARD	:= y
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT			:= n
 
-lib-y				:= efi-stub-helper.o gop.o
+lib-y				:= efi-stub-helper.o gop.o secureboot.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 6fca48c9e054..d4056c6be1ec 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -20,52 +20,6 @@
 
 bool __nokaslr;
 
-static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
-{
-	static efi_char16_t const sb_var_name[] = {
-		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
-	static efi_char16_t const sm_var_name[] = {
-		'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
-
-	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
-	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
-	u8 val;
-	unsigned long size = sizeof(val);
-	efi_status_t status;
-
-	status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
-			  NULL, &size, &val);
-
-	if (status != EFI_SUCCESS)
-		goto out_efi_err;
-
-	if (val == 0)
-		return 0;
-
-	status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
-			  NULL, &size, &val);
-
-	if (status != EFI_SUCCESS)
-		goto out_efi_err;
-
-	if (val == 1)
-		return 0;
-
-	return 1;
-
-out_efi_err:
-	switch (status) {
-	case EFI_NOT_FOUND:
-		return 0;
-	case EFI_DEVICE_ERROR:
-		return -EIO;
-	case EFI_SECURITY_VIOLATION:
-		return -EACCES;
-	default:
-		return -EINVAL;
-	}
-}
-
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
 {
@@ -157,7 +111,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
-	int secure_boot = 0;
+	enum efi_secureboot_mode secure_boot;
 	struct screen_info *si;
 
 	/* Check if we were booted by the EFI firmware */
@@ -227,19 +181,14 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
 
 	secure_boot = efi_get_secureboot(sys_table);
-	if (secure_boot > 0)
-		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
-
-	if (secure_boot < 0) {
-		pr_efi_err(sys_table,
-			"could not determine UEFI Secure Boot status.\n");
-	}
 
 	/*
-	 * Unauthenticated device tree data is a security hazard, so
-	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
+	 * Unauthenticated device tree data is a security hazard, so ignore
+	 * 'dtb=' unless UEFI Secure Boot is disabled.  We assume that secure
+	 * boot is enabled if we can't determine its state.
 	 */
-	if (secure_boot != 0 && strstr(cmdline_ptr, "dtb=")) {
+	if (secure_boot != efi_secureboot_mode_disabled &&
+	    strstr(cmdline_ptr, "dtb=")) {
 		pr_efi(sys_table, "Ignoring DTB from command line.\n");
 	} else {
 		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
new file mode 100644
index 000000000000..62d6904da800
--- /dev/null
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -0,0 +1,63 @@
+/*
+ * Secure boot handling.
+ *
+ * Copyright (C) 2013,2014 Linaro Limited
+ *     Roy Franz <roy.franz@linaro.org
+ * Copyright (C) 2013 Red Hat, Inc.
+ *     Mark Salter <msalter@redhat.com>
+ *
+ * This file is part of the Linux kernel, and is made available under the
+ * terms of the GNU General Public License version 2.
+ *
+ */
+
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+/* BIOS variables */
+static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
+static const efi_char16_t const efi_SecureBoot_name[] = {
+	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
+};
+static const efi_char16_t const efi_SetupMode_name[] = {
+	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
+};
+
+#define get_efi_var(name, vendor, ...) \
+	efi_call_runtime(get_variable, \
+			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
+			 __VA_ARGS__);
+
+/*
+ * Determine whether we're in secure boot mode.
+ */
+enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
+{
+	u8 secboot, setupmode;
+	unsigned long size;
+	efi_status_t status;
+
+	size = sizeof(secboot);
+	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
+			     NULL, &size, &secboot);
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	size = sizeof(setupmode);
+	status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
+			     NULL, &size, &setupmode);
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	if (secboot == 0 || setupmode == 1)
+		return efi_secureboot_mode_disabled;
+
+	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
+	return efi_secureboot_mode_enabled;
+
+out_efi_err:
+	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
+	return efi_secureboot_mode_unknown;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 58c9dd48f42a..1c200cdbdc05 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1480,6 +1480,14 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 bool efi_runtime_disabled(void);
 extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
 
+enum efi_secureboot_mode {
+	efi_secureboot_mode_unset,
+	efi_secureboot_mode_unknown,
+	efi_secureboot_mode_disabled,
+	efi_secureboot_mode_enabled,
+};
+enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table);
+
 /*
  * Arch code can implement the following three template macros, avoiding
  * reptition for the void/non-void return cases of {__,}efi_call_virt():

