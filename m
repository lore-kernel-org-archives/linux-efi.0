From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 05/40] efi/arm64: Check SetupMode when determining Secure Boot status
Date: Mon, 25 Apr 2016 21:06:37 +0100
Message-ID: <1461614832-17633-6-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Linn Crosetto <linn@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Linn Crosetto <linn@hpe.com>

According to the UEFI specification (version 2.5 Errata A, page 87):

    The platform firmware is operating in secure boot mode if the value of
    the SetupMode variable is 0 and the SecureBoot variable is set to 1. A
    platform cannot operate in secure boot mode if the SetupMode variable
    is set to 1.

Check the value of the SetupMode variable when determining the state of
Secure Boot. Minor cleanup, change sizeof to match kernel style guidelines.

Signed-off-by: Linn Crosetto <linn@hpe.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/arm-stub.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 07f967c4c567..128632508fc6 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -22,21 +22,39 @@ bool __nokaslr;
 
 static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
-	static efi_guid_t const var_guid = EFI_GLOBAL_VARIABLE_GUID;
-	static efi_char16_t const var_name[] = {
+	static efi_char16_t const sb_var_name[] = {
 		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
+	static efi_char16_t const sm_var_name[] = {
+		'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
 
+	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
 	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
-	unsigned long size = sizeof(u8);
-	efi_status_t status;
 	u8 val;
+	unsigned long size = sizeof(val);
+	efi_status_t status;
 
-	status = f_getvar((efi_char16_t *)var_name, (efi_guid_t *)&var_guid,
+	status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
 			  NULL, &size, &val);
 
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	if (val == 0)
+		return 0;
+
+	status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
+			  NULL, &size, &val);
+
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	if (val == 1)
+		return 0;
+
+	return 1;
+
+out_efi_err:
 	switch (status) {
-	case EFI_SUCCESS:
-		return val;
 	case EFI_NOT_FOUND:
 		return 0;
 	case EFI_DEVICE_ERROR:
-- 
2.7.3
