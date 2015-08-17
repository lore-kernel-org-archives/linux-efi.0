From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V3 1/2] arm64: apei: implement arch_apei_get_mem_attributes()
Date: Mon, 17 Aug 2015 14:08:40 -0700
Message-ID: <1439845721-30196-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
memory types to MAIR attribute encodings for arm64.

If the physical address has memory attributes defined by EFI
memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
type according to the UEFI spec. Otherwise, return PAGE_KERNEL.

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
---
V3: Updated Reviewed-by.
V2: Changed arm64's implementation of arch_apei_get_mem_attributes()
    from inline function to out of line function, based on Ingo's
    feedback.

 arch/arm64/include/asm/acpi.h |  5 +++++
 arch/arm64/kernel/acpi.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 406485ed110a..8084f3640006 100644
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
