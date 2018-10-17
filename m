From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v9 4/8] x86/boot: Add bios_get_rsdp_addr() to search RSDP in memory
Date: Wed, 17 Oct 2018 18:20:08 +0800
Message-ID: <20181017102012.872-5-fanc.fnst@cn.fujitsu.com>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, fanc.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Imitate acpi_find_root_pointer() and acpi_tb_scan_memory_for_rsdp()
to search RSDP table pointer in memory. This function only works
when RSDP not found in EFI table.

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/acpitb.c | 106 ++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
index 56b54b0e0889..50fa65cf824d 100644
--- a/arch/x86/boot/compressed/acpitb.c
+++ b/arch/x86/boot/compressed/acpitb.c
@@ -94,3 +94,109 @@ static void efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
 	}
 #endif
 }
+
+static u8 compute_checksum(u8 *buffer, u32 length)
+{
+	u8 sum = 0;
+	u8 *end = buffer + length;
+
+	while (buffer < end)
+		sum = (u8)(sum + *(buffer++));
+
+	return sum;
+}
+
+/*
+ * Used to search a block of memory for the RSDP signature.
+ * Return Pointer to the RSDP if found, otherwise NULL.
+ * Based on acpi_tb_scan_memory_for_rsdp().
+ */
+static u8 *scan_mem_for_rsdp(u8 *start, u32 length)
+{
+	struct acpi_table_rsdp *rsdp;
+	u8 *end;
+	u8 *rover;
+
+	end = start + length;
+
+	/* Search from given start address for the requested length */
+	for (rover = start; rover < end; rover += ACPI_RSDP_SCAN_STEP) {
+		/*
+		 * The RSDP signature and checksum must both be correct
+		 * Note: Sometimes there exists more than one RSDP in memory;
+		 * the valid RSDP has a valid checksum, all others have an
+		 * invalid checksum.
+		 */
+		rsdp = (struct acpi_table_rsdp *)rover;
+
+		/* Nope, BAD Signature */
+		if (!ACPI_VALIDATE_RSDP_SIG(rsdp->signature))
+			continue;
+
+		/* Check the standard checksum */
+		if (compute_checksum((u8 *) rsdp, ACPI_RSDP_CHECKSUM_LENGTH))
+			continue;
+
+		/* Check extended checksum if table version >= 2 */
+		if ((rsdp->revision >= 2) &&
+		    (compute_checksum((u8 *) rsdp, ACPI_RSDP_XCHECKSUM_LENGTH)))
+			continue;
+
+		/* Sig and checksum valid, we have found a real RSDP */
+		return rover;
+	}
+	return NULL;
+}
+
+/*
+ * Used to search RSDP physical address.
+ * Based on acpi_find_root_pointer(). Since only use physical address
+ * in this period, so there is no need to do the memory map jobs.
+ */
+static void bios_get_rsdp_addr(acpi_physical_address *rsdp_addr)
+{
+	struct acpi_table_rsdp *rsdp;
+	u8 *table_ptr;
+	u8 *mem_rover;
+	u32 address;
+
+	/*
+	 * Get the location of the Extended BIOS Data Area (EBDA)
+	 * Since we use physical address directely, so
+	 * acpi_os_map_memory() and acpi_os_unmap_memory() are
+	 * not needed here.
+	 */
+	table_ptr = (u8 *)ACPI_EBDA_PTR_LOCATION;
+	*(u32 *)(void *)&address = *(u16 *)(void *)table_ptr;
+	address <<= 4;
+	table_ptr = (u8 *)address;
+
+	/*
+	 * Search EBDA paragraphs (EBDA is required to be a minimum of
+	 * 1K length)
+	 */
+	if (address > 0x400) {
+		mem_rover = scan_mem_for_rsdp(table_ptr, ACPI_EBDA_WINDOW_SIZE);
+
+		if (mem_rover) {
+			address += (u32)ACPI_PTR_DIFF(mem_rover, table_ptr);
+			*rsdp_addr = (acpi_physical_address)address;
+			return;
+		}
+	}
+
+	table_ptr = (u8 *)ACPI_HI_RSDP_WINDOW_BASE;
+	mem_rover = scan_mem_for_rsdp(table_ptr, ACPI_HI_RSDP_WINDOW_SIZE);
+
+	/*
+	 * Search upper memory: 16-byte boundaries in E0000h-FFFFFh
+	 * Since we use physical address directely, so
+	 * acpi_os_map_memory() and acpi_os_unmap_memory() are
+	 * not needed here.
+	 */
+	if (mem_rover) {
+		address = (u32)(ACPI_HI_RSDP_WINDOW_BASE +
+				ACPI_PTR_DIFF(mem_rover, table_ptr));
+		*rsdp_addr = (acpi_physical_address)address;
+	}
+}
-- 
2.17.2
