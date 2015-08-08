From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V11 2/5] x86: acpi: implement arch_apei_get_mem_attributes()
Date: Sat,  8 Aug 2015 10:18:50 -0700
Message-ID: <1439054333-21766-3-git-send-email-zjzhang@codeaurora.org>
References: <1439054333-21766-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439054333-21766-1-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

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

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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
