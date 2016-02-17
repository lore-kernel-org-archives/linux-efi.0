From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/2] ACPICA: Tables: Add function to remove ACPI tables
Date: Wed, 17 Feb 2016 15:45:09 +0000
Message-ID: <1455723910-16710-2-git-send-email-matt@codeblueprint.co.uk>
References: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, kexec@lists.infradead.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

There are existing internal functions that allow the removal of ACPI
tables, but they're not exposed to the OS in any useful way.

Introduce acpi_remove_table() which allows tables to be invalidated in
the global table list, resulting in failure of subsequent calls to
acpi_get_table() for those tables.

The rationale for this change is the ability to remove the BGRT table
during kexec boot. The BGRT table refers to memory regions that are no
longer reserved by the firmware once the kexec kernel boots, having
been released for general allocation by the previous kernel.

Cc: Dave Young <dyoung@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <kexec@lists.infradead.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/acpi/acpica/tbxface.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h         |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index 326df65decef..999eecd89601 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -480,3 +480,57 @@ cleanup:
 }
 
 ACPI_EXPORT_SYMBOL(acpi_remove_table_handler)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_remove_table
+ *
+ * PARAMETERS:  signature           - ACPI signature of needed table
+ *              instance            - Which instance (for SSDTs)
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Finds and removes an ACPI table.
+ *
+ ******************************************************************************/
+acpi_status acpi_remove_table(char *signature, u32 instance)
+{
+	struct acpi_table_desc *table_desc;
+	acpi_status status;
+	u32 i;
+	u32 j;
+
+	/* Parameter validation */
+	if (!signature) {
+		return (AE_BAD_PARAMETER);
+	}
+
+	/* Walk the root table list */
+
+	for (i = 0, j = 0; i < acpi_gbl_root_table_list.current_table_count;
+	     i++) {
+		if (!ACPI_COMPARE_NAME
+		    (&(acpi_gbl_root_table_list.tables[i].signature),
+		     signature)) {
+			continue;
+		}
+
+		if (++j < instance) {
+			continue;
+		}
+
+		table_desc = &acpi_gbl_root_table_list.tables[i];
+
+		status = acpi_tb_validate_table(table_desc);
+		if (ACPI_FAILURE(status)) {
+			return (status);
+		}
+
+		acpi_tb_uninstall_table(table_desc);
+		return (AE_OK);
+	}
+
+	return (AE_NOT_FOUND);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_remove_table);
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index c96621e87c19..47e51612293e 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -505,6 +505,9 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			     acpi_remove_table_handler(acpi_table_handler
 						       handler))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_remove_table(acpi_string signature,
+					       u32 instance))
 
 /*
  * Namespace and name interfaces
-- 
2.6.2
