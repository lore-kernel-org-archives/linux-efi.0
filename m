From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/2] efi: introduce EFI_NX_PE_DATA bit and set it from properties table
Date: Wed, 23 Sep 2015 07:29:34 -0700
Message-ID: <1443018574-21702-1-git-send-email-ard.biesheuvel@linaro.org>
References: <20150923141817.GF2867@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150923141817.GF2867-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI v2.5 introduces a runtime memory protection feature that splits
PE/COFF runtime images into separate code and data regions. Since this
may require special handling by the OS, allocate a EFI_xxx bit to
keep track of whether this feature is currently active or not.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

@Matt:
here's v2 of 2/2 only, with your comments addressed.

Thanks,
Ard.


 drivers/firmware/efi/efi.c | 18 ++++++++++++++++++
 include/linux/efi.h        |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5cbb8d31da33..8c81cd58f95f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -425,6 +425,24 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
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
index 5b4f3ac08053..61b5a5e1e9be 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -972,6 +972,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
+#define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
 
 #ifdef CONFIG_EFI
 /*
-- 
1.9.1
