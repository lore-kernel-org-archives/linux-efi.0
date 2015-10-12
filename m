From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 08/11] efi: Introduce EFI_NX_PE_DATA bit and set it from properties table
Date: Mon, 12 Oct 2015 14:56:11 +0100
Message-ID: <1444658174-23378-9-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

UEFI v2.5 introduces a runtime memory protection feature that splits
PE/COFF runtime images into separate code and data regions. Since this
may require special handling by the OS, allocate a EFI_xxx bit to
keep track of whether this feature is currently active or not.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/efi.c | 18 ++++++++++++++++++
 include/linux/efi.h        |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index c297d78f50fd..31fc864eb037 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -426,6 +426,24 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 	}
 	pr_cont("\n");
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
+	/* Parse the EFI Properties table if it exists */
+	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
+		efi_properties_table_t *tbl;
+
+		tbl = early_memremap(efi.properties_table, sizeof(*tbl));
+		if (tbl == NULL) {
+			pr_err("Could not map Properties table!\n");
+			return -ENOMEM;
+		}
+
+		if (tbl->memory_protection_attribute &
+		    EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA)
+			set_bit(EFI_NX_PE_DATA, &efi.flags);
+
+		early_memunmap(tbl, sizeof(*tbl));
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d6a9bee755f2..fa5106c2f9f5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -973,6 +973,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
+#define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
 
 #ifdef CONFIG_EFI
 /*
-- 
2.1.0
