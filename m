From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Thu, 08 Dec 2016 12:30:45 +0000
Message-ID: <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
References: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Get the firmware's secure-boot status in the kernel boot wrapper and stash
it somewhere that the main kernel image can find.

The efi_get_secureboot() function is extracted from the arm stub and (a)
generalised so that it can be called from x86 and (b) made to use
efi_call_runtime() so that it can be run in mixed-mode.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/x86/zero-page.txt           |    2 +
 arch/x86/boot/compressed/eboot.c          |    2 +
 arch/x86/boot/compressed/head_32.S        |    1 
 arch/x86/boot/compressed/head_64.S        |    1 
 arch/x86/include/asm/bootparam_utils.h    |    5 +-
 arch/x86/include/uapi/asm/bootparam.h     |    3 +
 arch/x86/kernel/asm-offsets.c             |    1 
 drivers/firmware/efi/libstub/Makefile     |    2 -
 drivers/firmware/efi/libstub/arm-stub.c   |   63 +++--------------------------
 drivers/firmware/efi/libstub/secureboot.c |   63 +++++++++++++++++++++++++++++
 include/linux/efi.h                       |    8 ++++
 11 files changed, 90 insertions(+), 61 deletions(-)
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
index c8c32ebcdfdb..5b151c262ac2 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1158,6 +1158,8 @@ struct boot_params *efi_main(struct efi_config *c,
 	else
 		setup_boot_services32(efi_early);
 
+	boot_params->secure_boot = efi_get_secureboot(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index d85b9625e836..c635f7e32f5c 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -61,6 +61,7 @@
 
 	__HEAD
 ENTRY(startup_32)
+	movb	$0, BP_secure_boot(%esi)
 #ifdef CONFIG_EFI_STUB
 	jmp	preferred_addr
 
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index beab8322f72a..ccd2c7461b7f 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -244,6 +244,7 @@ ENTRY(startup_64)
 	 * that maps our entire kernel(text+data+bss+brk), zero page
 	 * and command line.
 	 */
+	movb	$0, BP_secure_boot(%rsi)
 #ifdef CONFIG_EFI_STUB
 	/*
 	 * The entry point for the PE/COFF executable is efi_pe_entry, so
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 4a8cb8d7cbd5..7e16d53ff6a3 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -38,9 +38,10 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 		memset(&boot_params->ext_ramdisk_image, 0,
 		       (char *)&boot_params->efi_info -
 			(char *)&boot_params->ext_ramdisk_image);
-		memset(&boot_params->kbd_status, 0,
+		boot_params->kbd_status = 0;
+		memset(&boot_params->_pad5, 0,
 		       (char *)&boot_params->hdr -
-		       (char *)&boot_params->kbd_status);
+		       (char *)&boot_params->_pad5);
 		memset(&boot_params->_pad7[0], 0,
 		       (char *)&boot_params->edd_mbr_sig_buffer[0] -
 			(char *)&boot_params->_pad7[0]);
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
index 6621b13c370f..9af966863612 100644
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
index b4f7d78f9e8b..9984d0442442 100644
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
@@ -226,7 +180,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
-	int secure_boot = 0;
+	enum efi_secureboot_mode secure_boot;
 	struct screen_info *si;
 
 	/* Check if we were booted by the EFI firmware */
@@ -296,19 +250,14 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
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
index c7904556d7a8..92e23f03045e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1477,6 +1477,14 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
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
