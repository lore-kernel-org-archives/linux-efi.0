From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V9 2/5] x86: acpi: implement arch_apei_get_mem_attributes()
Date: Thu, 30 Jul 2015 14:35:06 -0700
Message-ID: <1438292109-4170-3-git-send-email-zjzhang@codeaurora.org>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
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
 arch/x86/kernel/acpi/apei.c | 19 +++++++++++++++++++
 include/acpi/apei.h         |  1 +
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
index c280df6b2aa2..675bd46c4e17 100644
--- a/arch/x86/kernel/acpi/apei.c
+++ b/arch/x86/kernel/acpi/apei.c
@@ -60,3 +60,22 @@ void arch_apei_flush_tlb_one(unsigned long addr)
 {
 	__flush_tlb_one(addr);
 }
+
+static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
+{
+
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
+	return __pgprot(PAGE_KERNEL);
+}
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 284801ac7042..64a12ce9880b 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -46,6 +46,7 @@ int erst_clear(u64 record_id);
 int arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data);
 void arch_apei_report_mem_error(int sev, struct cper_sec_mem_err *mem_err);
 void arch_apei_flush_tlb_one(unsigned long addr);
+pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr);
 
 #endif
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
