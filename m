From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] acpi: bgrt: parse BGRT to obtain BMP address before it
 gets clobbered
Date: Tue, 29 Jan 2019 17:00:52 +0100
Message-ID: <20190129160052.2058-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-acpi@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com, graeme.gregory@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Jones <pjones@redhat.com>, rjw@rjwysocki.net, leif.lindholm@linaro.org, astone@redhat.com, linux-efi@vger.kernel.org, michael.d.kinney@intel.com, harry.l.hsiung@intel.com, linux-arm-kernel@lists.infradead.org, lenb@kernel.org
List-Id: linux-efi@vger.kernel.org

The bitmap left in the framebuffer by the firmware is described by an
ACPI table called "BGRT", which describes the size, pixel format and
the address of a BMP image in memory. While the BGRT ACPI table is
guaranteed to reside in a "ACPI reclaim" memory region, which is
never touched by Linux. The BMP image, however, typically resides
in EFI Boot Services Memory, which may have been overwritten by the
time the BGRT discovery routine runs.

So instead, drop the handling from the ACPI init code, and call the
BGRT parsing code immediately after going over the EFI configuration
table array, at which time no memory has been touched yet except for
the .data/.bss regions covered by the static kernel image.

Unfortunately, this involves a non-trivial amount of ACPI entry
point and root table parsing, but we cannot rely on the normal
ACPI infrastructure yet this early in the boot.

Also note that we cannot take the 'acpi_disabled' global variable
into account, since it may not have assumed the correct value yet
(on arm64, the default value is '1' which is overridden to '0' if
no DT description has been made available by the firmware)

Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2:
- Reshuffle the code a bit so we never leave things mapped on an error.
  This should fix the two issues spotted by Lorenzo.
- use R/O mappings for all the tables

There was some discussion regarding parsing the status field, but that
is a separate change in any case, so I have ignored that for now.

If there are no further concerns, I intend to get this queued for
v5.1 by the end of the week.

 arch/arm64/kernel/acpi.c        |  2 -
 arch/x86/kernel/acpi/boot.c     |  2 -
 drivers/acpi/bgrt.c             |  6 --
 drivers/firmware/efi/efi-bgrt.c | 84 ++++++++++++++++++--
 drivers/firmware/efi/efi.c      | 13 +++
 include/linux/efi-bgrt.h        |  4 +-
 6 files changed, 92 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 44e3c351e1ea..7429a811f76d 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -230,8 +230,6 @@ void __init acpi_boot_table_init(void)
 			early_init_dt_scan_chosen_stdout();
 	} else {
 		acpi_parse_spcr(earlycon_acpi_spcr_enable, true);
-		if (IS_ENABLED(CONFIG_ACPI_BGRT))
-			acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);
 	}
 }
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2624de16cd7a..2d3535b62752 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1633,8 +1633,6 @@ int __init acpi_boot_init(void)
 	acpi_process_madt();
 
 	acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);
-	if (IS_ENABLED(CONFIG_ACPI_BGRT))
-		acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);
 
 	if (!acpi_noirq)
 		x86_init.pci.init = pci_acpi_init;
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 75af78361ce5..048413e06898 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -81,12 +81,6 @@ static const struct attribute_group bgrt_attribute_group = {
 	.bin_attrs = bgrt_bin_attributes,
 };
 
-int __init acpi_parse_bgrt(struct acpi_table_header *table)
-{
-	efi_bgrt_init(table);
-	return 0;
-}
-
 static int __init bgrt_init(void)
 {
 	int ret;
diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index b22ccfb0c991..b2d98e16c7bf 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -27,24 +27,94 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
-void __init efi_bgrt_init(struct acpi_table_header *table)
+void __init efi_bgrt_init(unsigned long rsdp_phys)
 {
 	void *image;
 	struct bmp_header bmp_header;
 	struct acpi_table_bgrt *bgrt = &bgrt_tab;
+	struct acpi_table_bgrt *table = NULL;
+	struct acpi_table_rsdp *rsdp;
+	struct acpi_table_header *hdr;
+	u64 xsdt_phys = 0;
+	u32 rsdt_phys = 0;
+	unsigned long len;
 
-	if (acpi_disabled)
+	if (!efi_enabled(EFI_MEMMAP))
 		return;
 
-	if (!efi_enabled(EFI_MEMMAP))
+	/* map the root pointer table to find the xsdt/rsdt values */
+	rsdp = early_memremap_ro(rsdp_phys, sizeof(*rsdp));
+	if (rsdp) {
+		if (ACPI_VALIDATE_RSDP_SIG(rsdp->signature)) {
+			xsdt_phys = rsdp->xsdt_physical_address;
+			rsdt_phys = rsdp->rsdt_physical_address;
+		}
+		early_memunmap(rsdp, sizeof(*rsdp));
+	}
+
+	if (WARN_ON(!xsdt_phys && !rsdt_phys))
 		return;
 
-	if (table->length < sizeof(bgrt_tab)) {
-		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
-		       table->length, sizeof(bgrt_tab));
+	/* obtain the length of whichever table we will be using */
+	hdr = early_memremap_ro(xsdt_phys ?: rsdt_phys, sizeof(*hdr));
+	if (WARN_ON(!hdr))
+		return;
+	len = hdr->length;
+	early_memunmap(hdr, sizeof(*hdr));
+
+	/* remap with the correct length */
+	hdr = early_memremap_ro(xsdt_phys ?: rsdt_phys, len);
+	if (WARN_ON(!hdr))
+		return;
+
+	if (xsdt_phys) {
+		struct acpi_table_xsdt *xsdt = (void *)hdr;
+		int i;
+
+		for (i = 0; i < (len - sizeof(*hdr)) / sizeof(u64); i++) {
+			table = early_memremap_ro(xsdt->table_offset_entry[i],
+						  sizeof(*table));
+			if (WARN_ON(!table))
+				break;
+
+			if (ACPI_COMPARE_NAME(table->header.signature,
+					      ACPI_SIG_BGRT))
+				break;
+			early_memunmap(table, sizeof(*table));
+			table = NULL;
+		}
+	} else if (rsdt_phys) {
+		struct acpi_table_rsdt *rsdt = (void *)hdr;
+		int i;
+
+		for (i = 0; i < (len - sizeof(*hdr)) / sizeof(u32); i++) {
+			table = early_memremap_ro(rsdt->table_offset_entry[i],
+						  sizeof(*table));
+			if (WARN_ON(!table))
+				break;
+
+			if (ACPI_COMPARE_NAME(table->header.signature,
+					      ACPI_SIG_BGRT))
+				break;
+			early_memunmap(table, sizeof(*table));
+			table = NULL;
+		}
+	}
+	early_memunmap(hdr, len);
+
+	if (!table)
 		return;
+
+	len = table->header.length;
+	memcpy(bgrt, table, min(len, sizeof(bgrt_tab)));
+	early_memunmap(table, sizeof(*table));
+
+	if (len < sizeof(bgrt_tab)) {
+		pr_notice("Ignoring BGRT: invalid length %lu (expected %zu)\n",
+		       len, sizeof(bgrt_tab));
+		goto out;
 	}
-	*bgrt = *(struct acpi_table_bgrt *)table;
+
 	if (bgrt->version != 1) {
 		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
 		       bgrt->version);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4c46ff6f2242..e5ef5c0eacc1 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/efi-bgrt.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/io.h>
@@ -592,6 +593,18 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		early_memunmap(tbl, sizeof(*tbl));
 	}
+
+	/*
+	 * We need to parse the BGRT table (which is an ACPI table not a UEFI
+	 * configuration table) by hand and figure out where the bitmap it
+	 * describes lives in memory so we can reserve it early on. Otherwise,
+	 * it may be clobbered by the time we get to it during the ordinary ACPI
+	 * table init sequence.
+	 */
+	if (IS_ENABLED(CONFIG_ACPI_BGRT) &&
+	    efi.acpi20 != EFI_INVALID_TABLE_ADDR)
+		efi_bgrt_init(efi.acpi20);
+
 	return 0;
 }
 
diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
index e6cd51005633..528ea62d99ec 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -6,7 +6,7 @@
 
 #ifdef CONFIG_ACPI_BGRT
 
-void efi_bgrt_init(struct acpi_table_header *table);
+void efi_bgrt_init(unsigned long rsdp_phys);
 int __init acpi_parse_bgrt(struct acpi_table_header *table);
 
 /* The BGRT data itself; only valid if bgrt_image != NULL. */
@@ -15,7 +15,7 @@ extern struct acpi_table_bgrt bgrt_tab;
 
 #else /* !CONFIG_ACPI_BGRT */
 
-static inline void efi_bgrt_init(struct acpi_table_header *table) {}
+static inline void efi_bgrt_init(unsigned long rsdp_phys) {}
 static inline int __init acpi_parse_bgrt(struct acpi_table_header *table)
 {
 	return 0;
-- 
2.20.1
