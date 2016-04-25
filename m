From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 04/40] efi/arm64: Report unexpected errors when determining Secure Boot status
Date: Mon, 25 Apr 2016 21:06:36 +0100
Message-ID: <1461614832-17633-5-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Linn Crosetto <linn@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Linn Crosetto <linn@hpe.com>

Certain code in the boot path may require the ability to determine whether
UEFI Secure Boot is definitely enabled, for example printing status to the
console. Other code may need to know when UEFI Secure Boot is definitely
disabled, for example restricting use of kernel parameters.

If an unexpected error is returned from GetVariable() when querying the
status of UEFI Secure Boot, return an error to the caller. This allows the
caller to determine the definite state, and to take appropriate action if
an expected error is returned.

Signed-off-by: Linn Crosetto <linn@hpe.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/arm-stub.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 414deb85c2e5..07f967c4c567 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -20,7 +20,7 @@
 
 bool __nokaslr;
 
-static int efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
+static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
 	static efi_guid_t const var_guid = EFI_GLOBAL_VARIABLE_GUID;
 	static efi_char16_t const var_name[] = {
@@ -39,8 +39,12 @@ static int efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
 		return val;
 	case EFI_NOT_FOUND:
 		return 0;
+	case EFI_DEVICE_ERROR:
+		return -EIO;
+	case EFI_SECURITY_VIOLATION:
+		return -EACCES;
 	default:
-		return 1;
+		return -EINVAL;
 	}
 }
 
@@ -185,6 +189,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
+	int secure_boot = 0;
 
 	/* Check if we were booted by the EFI firmware */
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
@@ -250,12 +255,21 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (status != EFI_SUCCESS)
 		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
 
+	secure_boot = efi_get_secureboot(sys_table);
+	if (secure_boot > 0)
+		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
+
+	if (secure_boot < 0) {
+		pr_efi_err(sys_table,
+			"could not determine UEFI Secure Boot status.\n");
+	}
+
 	/*
 	 * Unauthenticated device tree data is a security hazard, so
 	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
 	 */
-	if (efi_secureboot_enabled(sys_table)) {
-		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
+	if (secure_boot != 0 && strstr(cmdline_ptr, "dtb=")) {
+		pr_efi(sys_table, "Ignoring DTB from command line.\n");
 	} else {
 		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
 					      "dtb=",
-- 
2.7.3
