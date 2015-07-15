From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V5 2/4] x86: acpi: implement arch_apei_get_mem_attributes()
Date: Tue, 14 Jul 2015 17:31:54 -0700
Message-ID: <1436920316-18127-3-git-send-email-zjzhang@codeaurora.org>
References: <1436920316-18127-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436920316-18127-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, ying.huang@intel.com, fu.wei@linaro.org, al.stone@linaro.org, bp@alien8.de, rjw@rjwysocki.net, lenb@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linaro-acpi@lists.linaro.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

... to allow arch specific implementation of getting page
protection type associated with a physical address.

If the physical address has memory attributes defined by EFI
memmap as EFI_MEMORY_UC, the page protection type is
PAGE_KENERL_NOCACHE. Otherwise, the page protection type is
PAGE_KERNEL.

Change-Id: Ia06d809c4dca05b68cbc9a94eea00c3f549a92e5
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 arch/x86/kernel/acpi/apei.c | 10 ++++++++++
 include/acpi/apei.h         |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
index c280df6b2aa2..cfcde9142b94 100644
--- a/arch/x86/kernel/acpi/apei.c
+++ b/arch/x86/kernel/acpi/apei.c
@@ -14,6 +14,8 @@
 
 #include <acpi/apei.h>
 
+#include <linux/efi.h>
+
 #include <asm/mce.h>
 #include <asm/tlbflush.h>
 
@@ -60,3 +62,11 @@ void arch_apei_flush_tlb_one(unsigned long addr)
 {
 	__flush_tlb_one(addr);
 }
+
+pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
+{
+	if (efi_mem_attributes(addr) & EFI_MEMORY_UC)
+		return PAGE_KERNEL_NOCACHE;
+	else
+		return PAGE_KERNEL;
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
