From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V10 2/5] x86: acpi: implement arch_apei_get_mem_attributes()
Date: Thu,  6 Aug 2015 06:40:31 -0700
Message-ID: <1438868434-28736-3-git-send-email-zjzhang@codeaurora.org>
References: <1438868434-28736-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438868434-28736-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, ying.huang@intel.com, tony.luck@gmail.com, fu.wei@linaro.org, al.stone@linaro.org, bp@alien8.de, rjw@rjwysocki.net, catalin.marinas@arm.com, will.deacon@arm.com, hanjun.guo@linaro.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

... to allow arch specific implementation of getting page
protection type associated with a physical address.

On x86, we currently have no way to lookup the EFI memory map
attributes for a region in a consistent way because the
memmap is discarded after efi_free_boot_services(). So if
you call efi_mem_attributes() during boot and at runtime,
you could theoretically see different attributes.

Since we are yet to see any x86 platforms that require
anything other than PAGE_KERNEL (some arm64 platforms
require the equivalent of PAGE_KERNEL_NOCACHE), return that
until we know differently.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 arch/x86/include/asm/acpi.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 3a45668f6dc3..ffe22c6b17bd 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -32,6 +32,10 @@
 #include <asm/mpspec.h>
 #include <asm/realmode.h>
 
+#ifdef CONFIG_ACPI_APEI
+#include <asm/pgtable_types.h>
+#endif
+
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
@@ -147,4 +151,24 @@ extern int x86_acpi_numa_init(void);
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
 
+#ifdef CONFIG_ACPI_APEI
+static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
+{
+	/*
+	 * We currently have no way to lookup the EFI memory map
+	 * attributes for a region in a consistent way because the
+	 * memmap is discarded after efi_free_boot_services(). So if
+	 * you call efi_mem_attributes() during boot and at runtime,
+	 * you could theoretically see different attributes.
+	 *
+	 * Since we are yet to see any x86 platforms that require
+	 * anything other than PAGE_KERNEL (some arm64 platforms
+	 * require the equivalent of PAGE_KERNEL_NOCACHE), return that
+	 * until we know differently.
+	 */
+
+	 return PAGE_KERNEL;
+}
+#endif
+
 #endif /* _ASM_X86_ACPI_H */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
