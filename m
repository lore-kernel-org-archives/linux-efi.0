From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v11 1/5] x86/boot: Add efi_get_rsdp_addr() to dig out RSDP from EFI table
Date: Mon, 12 Nov 2018 17:46:41 +0800
Message-ID: <20181112094645.4879-2-fanc.fnst@cn.fujitsu.com>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, fanc.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

In order to parse SRAT table and get memory information, RSDP pointer
should be found. In kernel, there are three methods to get RSDP:
EFI condition, BIOS condition and KEXEC condition. The first works
for EFI condition.

Imitate ACPI code and EFI code to dig RSDP pointer from EFI tables.
Process: boot_param->systab->efi_config_table->RSDP.
Based on efi_init(), efi_config_init(), efi_config_parse_tables().

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/acpitb.c | 96 +++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 arch/x86/boot/compressed/acpitb.c

diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
new file mode 100644
index 000000000000..56b54b0e0889
--- /dev/null
+++ b/arch/x86/boot/compressed/acpitb.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+#define BOOT_CTYPE_H
+#include "misc.h"
+#include "error.h"
+
+#include <linux/efi.h>
+#include <asm/efi.h>
+#include <linux/numa.h>
+#include <linux/acpi.h>
+
+/* Search EFI table for RSDP table. */
+static void efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
+{
+#ifdef CONFIG_EFI
+	efi_system_table_t *systab;
+	bool efi_64 = false;
+	void *config_tables;
+	struct efi_info *e;
+	char *sig;
+	int size;
+	int i;
+
+	e = &boot_params->efi_info;
+	sig = (char *)&e->efi_loader_signature;
+
+	if (!strncmp(sig, EFI64_LOADER_SIGNATURE, 4))
+		efi_64 = true;
+	else if (!strncmp(sig, EFI32_LOADER_SIGNATURE, 4))
+		efi_64 = false;
+	else {
+		debug_putstr("Wrong EFI loader signature.\n");
+		return;
+	}
+
+	/* Get systab from boot params. Based on efi_init(). */
+#ifdef CONFIG_X86_64
+	systab = (efi_system_table_t *)(
+			e->efi_systab | ((__u64)e->efi_systab_hi<<32));
+#else
+	if (e->efi_systab_hi || e->efi_memmap_hi) {
+		debug_putstr("Table located above 4GB. EFI should be disabled.\n");
+		return;
+	}
+	systab = (efi_system_table_t *)e->efi_systab;
+#endif
+
+	if (!systab)
+		return;
+
+	/*
+	 * Get EFI tables from systab. Based on efi_config_init() and
+	 * efi_config_parse_tables(). Only dig out the config_table.
+	 */
+	size = efi_64 ? sizeof(efi_config_table_64_t) :
+			sizeof(efi_config_table_32_t);
+
+	for (i = 0; i < systab->nr_tables; i++) {
+		efi_guid_t guid;
+		unsigned long table;
+
+		config_tables = (void *)(systab->tables + size * i);
+		if (efi_64) {
+			efi_config_table_64_t *tmp_table;
+
+			tmp_table = (efi_config_table_64_t *)config_tables;
+			guid = tmp_table->guid;
+			table = tmp_table->table;
+#ifndef CONFIG_64BIT
+			if (table >> 32) {
+				debug_putstr("Table located above 4G. EFI should be disabled.\n");
+				return;
+			}
+#endif
+		} else {
+			efi_config_table_32_t *tmp_table;
+
+			tmp_table = (efi_config_table_32_t *)config_tables;
+			guid = tmp_table->guid;
+			table = tmp_table->table;
+		}
+
+		/*
+		 * Get RSDP from EFI tables.
+		 * If ACPI20 table found, use it.
+		 * If ACPI20 table not found, but ACPI table found,
+		 * use the ACPI table.
+		 */
+		if (!(efi_guidcmp(guid, ACPI_TABLE_GUID))) {
+			*rsdp_addr = (acpi_physical_address)table;
+		} else if (!(efi_guidcmp(guid, ACPI_20_TABLE_GUID))) {
+			*rsdp_addr = (acpi_physical_address)table;
+			return;
+		}
+	}
+#endif
+}
-- 
2.19.1
