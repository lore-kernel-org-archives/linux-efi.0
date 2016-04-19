From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH v2 02/10] acpi: decouple initrd table install from CONFIG_ACPI_INITRD_TABLE_OVERRIDE
Date: Wed, 20 Apr 2016 01:39:00 +0300
Message-ID: <1461105548-20618-3-git-send-email-octavian.purdila@intel.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

The ACPI override and overlay functionality is different, with the
latter being more then a debug option. Allow loading of ACPI tables from
initrd even if CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not selected.

The patch also switches to using TAINT_OVERLAY_ACPI_TABLE and adds
documentation about how to load SSDT tables from initrd.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/acpi/ssdt-overlays.txt | 26 ++++++++++++
 arch/x86/kernel/setup.c              |  2 +-
 drivers/acpi/osl.c                   | 80 +++++++++++++++++++-----------------
 include/linux/acpi.h                 |  8 +---
 4 files changed, 71 insertions(+), 45 deletions(-)

diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-overlays.txt
index 54ee74a..c328f6a 100644
--- a/Documentation/acpi/ssdt-overlays.txt
+++ b/Documentation/acpi/ssdt-overlays.txt
@@ -62,3 +62,29 @@ AML Output:    minnowmax.aml - 165 bytes, 6 named objects, 1 executable opcodes
 
 The resulting AML code can then be loaded by the kernel using one of the methods
 below.
+
+== Loading ACPI SSDTs from initrd ==
+
+This option allows loading of user defined SSDTs from initrd and it is useful
+when the system does not support EFI or when there is not enough EFI storage.
+
+It works in a similar way with initrd based ACPI tables overrides: SSDT aml code
+must be placed in the first, uncompressed, initrd under the
+"kernel/firmware/acpi" path. Multiple files can be used and this will translate
+in loading multiple tables. Only SSDT and OEM tables are allowed.
+
+Here is an example:
+
+# Add the raw ACPI tables to an uncompressed cpio archive.
+# They must be put into a /kernel/firmware/acpi directory inside the
+# cpio archive.
+# The uncompressed cpio archive must be the first.
+# Other, typically compressed cpio archives, must be
+# concatenated on top of the uncompressed one.
+mkdir -p kernel/firmware/acpi
+cp ssdt.aml kernel/firmware/acpi
+
+# Create the uncompressed cpio archive and concatenate the original initrd
+# on top:
+find kernel | cpio -H newc --create > /boot/instrumented_initrd
+cat /boot/initrd >>/boot/instrumented_initrd
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2367ae0..1908668 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1139,7 +1139,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_initrd();
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_BLK_DEV_INITRD)
-	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
+	acpi_table_initrd_init((void *)initrd_start, initrd_end - initrd_start);
 #endif
 
 	vsmp_init();
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 814d5f8..dcc99b4 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -602,15 +602,24 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
 	return AE_OK;
 }
 
-static void acpi_table_taint(struct acpi_table_header *table)
+static void acpi_table_taint(struct acpi_table_header *table, bool override)
 {
-	pr_warn(PREFIX
-		"Override [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
-		table->signature, table->oem_table_id);
-	add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, LOCKDEP_NOW_UNRELIABLE);
+	enum lockdep_ok lockdep_ok;
+	unsigned int taint;
+
+	if (override) {
+		pr_warn(PREFIX "Override [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
+			table->signature, table->oem_table_id);
+		lockdep_ok = false;
+		taint = TAINT_OVERRIDDEN_ACPI_TABLE;
+	} else {
+		lockdep_ok = true;
+		taint = TAINT_OVERLAY_ACPI_TABLE;
+	}
+
+	add_taint(taint, lockdep_ok);
 }
 
-#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
 #include <linux/earlycpio.h>
 #include <linux/memblock.h>
 
@@ -642,13 +651,13 @@ static const char * const table_sigs[] = {
 
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
-#define ACPI_OVERRIDE_TABLES 64
-static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
-static DECLARE_BITMAP(acpi_initrd_installed, ACPI_OVERRIDE_TABLES);
+#define ACPI_INITRD_TABLES 64
+static struct cpio_data acpi_initrd_files[ACPI_INITRD_TABLES] __initdata;
+static DECLARE_BITMAP(acpi_initrd_installed, ACPI_INITRD_TABLES);
 
 #define MAP_CHUNK_SIZE   (NR_FIX_BTMAPS << PAGE_SHIFT)
 
-void __init acpi_initrd_override(void *data, size_t size)
+void __init acpi_table_initrd_init(void *data, size_t size)
 {
 	int sig, no, table_nr = 0, total_offset = 0;
 	long offset = 0;
@@ -659,7 +668,7 @@ void __init acpi_initrd_override(void *data, size_t size)
 	if (data == NULL || size == 0)
 		return;
 
-	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
+	for (no = 0; no < ACPI_INITRD_TABLES; no++) {
 		file = find_cpio_data(cpio_path, data, size, &offset);
 		if (!file.data)
 			break;
@@ -668,8 +677,8 @@ void __init acpi_initrd_override(void *data, size_t size)
 		size -= offset;
 
 		if (file.size < sizeof(struct acpi_table_header)) {
-			pr_err("ACPI OVERRIDE: Table smaller than ACPI header [%s%s]\n",
-				cpio_path, file.name);
+			pr_err(PREFIX "initrd: Table smaller than ACPI header [%s%s]\n",
+			       cpio_path, file.name);
 			continue;
 		}
 
@@ -680,18 +689,18 @@ void __init acpi_initrd_override(void *data, size_t size)
 				break;
 
 		if (!table_sigs[sig]) {
-			pr_err("ACPI OVERRIDE: Unknown signature [%s%s]\n",
-				cpio_path, file.name);
+			pr_err(PREFIX "initrd: Unknown signature [%s%s]\n",
+			       cpio_path, file.name);
 			continue;
 		}
 		if (file.size != table->length) {
-			pr_err("ACPI OVERRIDE: File length does not match table length [%s%s]\n",
-				cpio_path, file.name);
+			pr_err(PREFIX "initrd: File length does not match table length [%s%s]\n",
+			       cpio_path, file.name);
 			continue;
 		}
 		if (acpi_table_checksum(file.data, table->length)) {
-			pr_err("ACPI OVERRIDE: Bad table checksum [%s%s]\n",
-				cpio_path, file.name);
+			pr_err(PREFIX "initrd: Bad table checksum [%s%s]\n",
+			       cpio_path, file.name);
 			continue;
 		}
 
@@ -756,6 +765,7 @@ void __init acpi_initrd_override(void *data, size_t size)
 	}
 }
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
 acpi_status
 acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 				acpi_physical_address *address, u32 *length)
@@ -792,7 +802,7 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 
 		*length = table_length;
 		*address = acpi_tables_addr + table_offset;
-		acpi_table_taint(existing_table);
+		acpi_table_taint(existing_table, true);
 		acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
 		set_bit(table_index, acpi_initrd_installed);
 		break;
@@ -803,6 +813,17 @@ next_table:
 	}
 	return AE_OK;
 }
+#else
+acpi_status
+acpi_os_physical_table_override(struct acpi_table_header *existing_table,
+				acpi_physical_address *address,
+				u32 *table_length)
+{
+	*table_length = 0;
+	*address = 0;
+	return AE_OK;
+}
+#endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
 
 void __init acpi_initrd_initialize_tables(void)
 {
@@ -833,7 +854,7 @@ void __init acpi_initrd_initialize_tables(void)
 			goto next_table;
 		}
 
-		acpi_table_taint(table);
+		acpi_table_taint(table, false);
 		acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
 		acpi_install_table(acpi_tables_addr + table_offset, TRUE);
 		set_bit(table_index, acpi_initrd_installed);
@@ -842,21 +863,6 @@ next_table:
 		table_index++;
 	}
 }
-#else
-acpi_status
-acpi_os_physical_table_override(struct acpi_table_header *existing_table,
-				acpi_physical_address *address,
-				u32 *table_length)
-{
-	*table_length = 0;
-	*address = 0;
-	return AE_OK;
-}
-
-void __init acpi_initrd_initialize_tables(void)
-{
-}
-#endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
 
 acpi_status
 acpi_os_table_override(struct acpi_table_header *existing_table,
@@ -872,7 +878,7 @@ acpi_os_table_override(struct acpi_table_header *existing_table,
 		*new_table = (struct acpi_table_header *)AmlCode;
 #endif
 	if (*new_table != NULL)
-		acpi_table_taint(existing_table);
+		acpi_table_taint(existing_table, true);
 	return AE_OK;
 }
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 06ed7e5..d4a3cb2 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -190,13 +190,7 @@ static inline int acpi_debugger_notify_command_complete(void)
 }
 #endif
 
-#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
-void acpi_initrd_override(void *data, size_t size);
-#else
-static inline void acpi_initrd_override(void *data, size_t size)
-{
-}
-#endif
+void acpi_table_initrd_init(void *data, size_t size);
 
 #define BAD_MADT_ENTRY(entry, end) (					    \
 		(!entry) || (unsigned long)entry + sizeof(*entry) > end ||  \
-- 
1.9.1

