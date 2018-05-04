From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/17] efi/cper: Remove the INDENT_SP silliness
Date: Fri,  4 May 2018 07:59:48 +0200
Message-ID: <20180504060003.19618-3-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

A separate define just to print a space character is silly and
completely unneeded. Remove it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/cper-arm.c | 6 ++----
 drivers/firmware/efi/cper.c     | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
index 698e5c8e0c8d..502811344e81 100644
--- a/drivers/firmware/efi/cper-arm.c
+++ b/drivers/firmware/efi/cper-arm.c
@@ -30,8 +30,6 @@
 #include <acpi/ghes.h>
 #include <ras/ras_event.h>
 
-#define INDENT_SP	" "
-
 static const char * const arm_reg_ctx_strs[] = {
 	"AArch32 general purpose registers",
 	"AArch32 EL1 context registers",
@@ -283,7 +281,7 @@ void cper_print_proc_arm(const char *pfx,
 			pfx, proc->psci_state);
 	}
 
-	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+	snprintf(newpfx, sizeof(newpfx), "%s ", pfx);
 
 	err_info = (struct cper_arm_err_info *)(proc + 1);
 	for (i = 0; i < proc->err_info_num; i++) {
@@ -310,7 +308,7 @@ void cper_print_proc_arm(const char *pfx,
 		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO) {
 			printk("%serror_info: 0x%016llx\n", newpfx,
 			       err_info->error_info);
-			snprintf(infopfx, sizeof(infopfx), "%s%s", newpfx, INDENT_SP);
+			snprintf(infopfx, sizeof(infopfx), "%s ", newpfx);
 			cper_print_arm_err_info(infopfx, err_info->type,
 						err_info->error_info);
 		}
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index c165933ebf38..ab21f1614007 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -37,8 +37,6 @@
 #include <acpi/ghes.h>
 #include <ras/ras_event.h>
 
-#define INDENT_SP	" "
-
 static char rcd_decode_str[CPER_REC_LEN];
 
 /*
@@ -433,7 +431,7 @@ cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
 		printk("%s""fru_text: %.20s\n", pfx, gdata->fru_text);
 
-	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+	snprintf(newpfx, sizeof(newpfx), "%s ", pfx);
 	if (guid_equal(sec_type, &CPER_SEC_PROC_GENERIC)) {
 		struct cper_sec_proc_generic *proc_err = acpi_hest_get_payload(gdata);
 
@@ -500,7 +498,7 @@ void cper_estatus_print(const char *pfx,
 		       "It has been corrected by h/w "
 		       "and requires no further action");
 	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
-	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+	snprintf(newpfx, sizeof(newpfx), "%s ", pfx);
 
 	apei_estatus_for_each_section(estatus, gdata) {
 		cper_estatus_print_section(newpfx, gdata, sec_no);
-- 
2.17.0
