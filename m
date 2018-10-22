From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v10 6/7] x86/boot: Dig out SRAT table from RSDP and find immovable memory
Date: Mon, 22 Oct 2018 17:37:19 +0800
Message-ID: <20181022093720.21426-7-fanc.fnst@cn.fujitsu.com>
References: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, fanc.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

To avoid KASLR extracting kernel on movable memory, and slove the
conflict between KASLR and movable_node feature, dig the SRAT tables
from RSDP pointer. Walk the SRAT tables and store the immovable
memory regions in immovable_mem[].

The code is imitated from ACPI code, based on acpi_os_get_root_pointer().
Process: RSDP->RSDT/XSDT->ACPI root table->SRAT.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/Makefile |   4 +
 arch/x86/boot/compressed/acpitb.c | 127 ++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/kaslr.c  |   4 -
 arch/x86/boot/compressed/misc.h   |  15 ++++
 4 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 28764dacf018..0f631c5613d7 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -83,6 +83,10 @@ ifdef CONFIG_X86_64
 	vmlinux-objs-y += $(obj)/pgtable_64.o
 endif
 
+#if (defined CONFIG_MEMORY_HOTREMOVE) && (defined CONFIG_RANDOMIZE_BASE)
+vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/acpitb.o
+#endif
+
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
 vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
index fa63a584d7ec..a9dbd42e5ab9 100644
--- a/arch/x86/boot/compressed/acpitb.c
+++ b/arch/x86/boot/compressed/acpitb.c
@@ -11,6 +11,11 @@
 #define STATIC
 #include <linux/decompress/mm.h>
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/* Store the immovable memory regions */
+struct mem_vector immovable_mem[MAX_NUMNODES*2];
+#endif
+
 /* Search EFI table for RSDP table. */
 static void efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
 {
@@ -223,3 +228,125 @@ static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
 	}
 #endif
 }
+
+/*
+ * Used to dig RSDP table from EFI table or BIOS.
+ * If RSDP table found in EFI table, use it. Or search BIOS.
+ * Based on acpi_os_get_root_pointer().
+ */
+static acpi_physical_address get_rsdp_addr(void)
+{
+	acpi_physical_address pa = 0;
+
+	get_acpi_rsdp(&pa);
+
+	if (!pa)
+		efi_get_rsdp_addr(&pa);
+
+	if (!pa)
+		bios_get_rsdp_addr(&pa);
+
+	return pa;
+}
+
+static struct acpi_table_header *get_acpi_srat_table(void)
+{
+	acpi_physical_address acpi_table;
+	acpi_physical_address root_table;
+	struct acpi_table_header *header;
+	struct acpi_table_rsdp *rsdp;
+	char *signature;
+	u8 *entry;
+	u32 count;
+	u32 size;
+	int i, j;
+	u32 len;
+
+	rsdp = (struct acpi_table_rsdp *)get_rsdp_addr();
+	if (!rsdp)
+		return NULL;
+
+	/* Get RSDT or XSDT from RSDP. */
+	if (!cmdline_find_option_arg("acpi", "rsdt", 4) &&
+	    rsdp->xsdt_physical_address && rsdp->revision > 1) {
+		root_table = rsdp->xsdt_physical_address;
+		size = ACPI_XSDT_ENTRY_SIZE;
+	} else {
+		root_table = rsdp->rsdt_physical_address;
+		size = ACPI_RSDT_ENTRY_SIZE;
+	}
+
+	/* Get ACPI root table from RSDT or XSDT.*/
+	header = (struct acpi_table_header *)root_table;
+	len = header->length;
+	count = (u32)((len - sizeof(struct acpi_table_header)) / size);
+	entry = ACPI_ADD_PTR(u8, header, sizeof(struct acpi_table_header));
+
+	for (i = 0; i < count; i++) {
+		u64 address64;
+
+		if (size == ACPI_RSDT_ENTRY_SIZE)
+			acpi_table = ((acpi_physical_address)
+				      (*ACPI_CAST_PTR(u32, entry)));
+		else {
+			*(u64 *)(void *)&address64 = *(u64 *)(void *)entry;
+			acpi_table = (acpi_physical_address) address64;
+		}
+
+		if (acpi_table) {
+			header = (struct acpi_table_header *)acpi_table;
+			signature = header->signature;
+
+			if (ACPI_COMPARE_NAME(header->signature, ACPI_SIG_SRAT))
+				return header;
+		}
+		entry += size;
+	}
+	return NULL;
+}
+
+/*
+ * According to ACPI table, filter the immvoable memory regions
+ * and store them in immovable_mem[].
+ */
+void get_immovable_mem(void)
+{
+	struct acpi_table_header *table_header;
+	struct acpi_subtable_header *table;
+	struct acpi_srat_mem_affinity *ma;
+	unsigned long table_end;
+	int i = 0;
+
+	if (!cmdline_find_option_bool("movable_node") ||
+	    cmdline_find_option_arg("acpi", "off", 3))
+		return;
+
+	table_header = get_acpi_srat_table();
+	if (!table_header)
+		return;
+
+	table_end = (unsigned long)table_header + table_header->length;
+
+	table = (struct acpi_subtable_header *)
+		((unsigned long)table_header + sizeof(struct acpi_table_srat));
+
+	while (((unsigned long)table) +
+		       sizeof(struct acpi_subtable_header) < table_end) {
+		if (table->type == ACPI_SRAT_TYPE_MEMORY_AFFINITY) {
+			ma = (struct acpi_srat_mem_affinity *)table;
+			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
+				immovable_mem[i].start = ma->base_address;
+				immovable_mem[i].size = ma->length;
+				i++;
+			}
+
+			if (i >= MAX_NUMNODES*2) {
+				debug_putstr("Too many immovable memory regions, aborted.\n");
+				break;
+			}
+		}
+		table = (struct acpi_subtable_header *)
+			((unsigned long)table + table->length);
+	}
+	num_immovable_mem = i;
+}
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 9ed9709d9947..b251572e77af 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -87,10 +87,6 @@ static unsigned long get_boot_seed(void)
 #define KASLR_COMPRESSED_BOOT
 #include "../../lib/kaslr.c"
 
-struct mem_vector {
-	unsigned long long start;
-	unsigned long long size;
-};
 
 /* Only supporting at most 4 unusable memmap regions with kaslr */
 #define MAX_MEMMAP_REGIONS	4
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 40378408d980..83075b9c6eea 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -82,6 +82,11 @@ void choose_random_location(unsigned long input,
 			    unsigned long *output,
 			    unsigned long output_size,
 			    unsigned long *virt_addr);
+struct mem_vector {
+	unsigned long long start;
+	unsigned long long size;
+};
+
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
@@ -121,3 +126,13 @@ static inline void console_init(void)
 void set_sev_encryption_mask(void);
 
 #endif
+
+/* acpitb.c */
+#ifdef CONFIG_RANDOMIZE_BASE
+int num_immovable_mem;
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/* Store the amount of immovable memory regions */
+#define ACPI_MAX_TABLES                128
+void get_immovable_mem(void);
+#endif
+#endif
-- 
2.17.2
