From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] efi: introduce EFI_NX_PE_DATA bit and set it from properties table
Date: Wed,  9 Sep 2015 10:08:16 +0200
Message-ID: <1441786096-8514-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1441786096-8514-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441786096-8514-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI v2.5 introduces a runtime memory protection feature that splits
PE/COFF runtime images into separate code and data regions. Since this
may require special handling by the OS, allocate a EFI_xxx bit to
keep track of whether this feature is currently active or not.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 15 +++++++++++++++
 include/linux/efi.h        |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5cbb8d31da33..8befd0b53472 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -425,6 +425,21 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 	}
 	pr_cont("\n");
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
+	/* parse the EFI Properties table if it exists */
+	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
+		efi_properties_table_t *tbl;
+
+		tbl = early_memremap(efi.properties_table, sizeof (*tbl));
+		if (tbl == NULL) {
+			pr_err("Could not map Properties table!\n");
+			return -ENOMEM;
+		}
+		if (tbl->memory_protection_attribute &
+		    EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA)
+			set_bit(EFI_NX_PE_DATA, &efi.flags);
+		early_memunmap(tbl, sizeof(*tbl));
+	}
 	return 0;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5b4f3ac08053..4f2ab71e1b8a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -972,6 +972,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
+#define EFI_NX_PE_DATA		9	/* whether PE/COFF images are split */
 
 #ifdef CONFIG_EFI
 /*
-- 
1.9.1
