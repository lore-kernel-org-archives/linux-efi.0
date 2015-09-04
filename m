From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/2] arm64: apei: Implement arch_apei_get_mem_attributes()
Date: Fri,  4 Sep 2015 14:11:41 +0100
Message-ID: <1441372302-23242-2-git-send-email-matt@codeblueprint.co.uk>
References: <1441372302-23242-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441372302-23242-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
memory types to MAIR attribute encodings for arm64.

If the physical address has memory attributes defined by EFI
memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
type according to the UEFI spec. Otherwise, return PAGE_KERNEL.

Reviewed-by: Matt Fleming <matt.fleming@intel.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/arm64/include/asm/acpi.h |  5 +++++
 arch/arm64/kernel/acpi.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 406485ed110a..5aa892a12a0d 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -92,4 +92,9 @@ static inline const char *acpi_get_enable_method(int cpu)
 {
 	return acpi_psci_present() ? "psci" : NULL;
 }
+
+#ifdef	CONFIG_ACPI_APEI
+pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr);
+#endif
+
 #endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 19de7537e7d3..9f083606e5bf 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -29,6 +29,11 @@
 #include <asm/cpu_ops.h>
 #include <asm/smp_plat.h>
 
+#ifdef CONFIG_ACPI_APEI
+#include <linux/efi.h>
+#include <asm/pgtable.h>
+#endif
+
 int acpi_noirq = 1;		/* skip ACPI IRQ initialization */
 int acpi_disabled = 1;
 EXPORT_SYMBOL(acpi_disabled);
@@ -230,3 +235,27 @@ void __init acpi_gic_init(void)
 
 	early_acpi_os_unmap_memory((char *)table, tbl_size);
 }
+
+#ifdef  CONFIG_ACPI_APEI
+pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
+{
+	/*
+	 * According to "Table 8 Map: EFI memory types to AArch64 memory
+	 * types" of UEFI 2.5 section 2.3.6.1, each EFI memory type is
+	 * mapped to a corresponding MAIR attribute encoding.
+	 * The EFI memory attribute advises all possible capabilities
+	 * of a memory region. We use the most efficient capability.
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
-- 
2.1.0
