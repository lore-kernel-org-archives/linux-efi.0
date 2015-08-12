From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/2] arm64: apei: implement arch_apei_get_mem_attributes()
Date: Wed, 12 Aug 2015 17:17:13 +0100
Message-ID: <1439396234-22863-2-git-send-email-matt@codeblueprint.co.uk>
References: <1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
memory types to MAIR attribute encodings for arm64.

If the physical address has memory attributes defined by EFI
memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
type according to the UEFI spec. Otherwise, return PAGE_KERNEL.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/arm64/include/asm/acpi.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 406485ed110a..1cbad43e561d 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -19,6 +19,11 @@
 #include <asm/psci.h>
 #include <asm/smp_plat.h>
 
+#ifdef CONFIG_ACPI_APEI
+#include <linux/efi.h>
+#include <asm/pgtable.h>
+#endif
+
 /* Macros for consistency checks of the GICC subtable of MADT */
 #define ACPI_MADT_GICC_LENGTH	\
 	(acpi_gbl_FADT.header.revision < 6 ? 76 : 80)
@@ -92,4 +97,29 @@ static inline const char *acpi_get_enable_method(int cpu)
 {
 	return acpi_psci_present() ? "psci" : NULL;
 }
+
+#ifdef	CONFIG_ACPI_APEI
+static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
+{
+	/*
+	 * According to "Table 8 Map: EFI memory types to AArch64 memory types"
+	 * of UEFI 2.5 section 2.3.6.1, each EFI memory type is mapped to
+	 * corresponding MAIR attribute encoding.
+	 * The EFI memory attribute advises all possible capabilities of a
+	 * memory region. We use the most efficient capability.
+	 */
+
+	u64 attr;
+
+	attr = efi_mem_attributes(addr);
+	if (attr & EFI_MEMORY_WB)
+		return PAGE_KERNEL;
+	if (attr & EFI_MEMORY_WT)
+		return __pgprot(PROT_NORMAL_WT);
+	if (attr & EFI_MEMORY_WC)
+		return __pgprot(PROT_NORMAL_NC);
+	return __pgprot(PROT_DEVICE_nGnRnE);
+}
+#endif
+
 #endif /*_ASM_ACPI_H*/
-- 
2.1.0
