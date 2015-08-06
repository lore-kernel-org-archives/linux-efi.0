From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V10 1/5] efi: x86: rearrange efi_mem_attributes()
Date: Thu,  6 Aug 2015 06:40:30 -0700
Message-ID: <1438868434-28736-2-git-send-email-zjzhang@codeaurora.org>
References: <1438868434-28736-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438868434-28736-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, ying.huang@intel.com, fu.wei@linaro.org, al.stone@linaro.org, bp@alien8.de, rjw@rjwysocki.net, catalin.marinas@arm.com, will.deacon@arm.com, hanjun.guo@linaro.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

x86 and ia64 implement efi_mem_attributes() differently. This
function needs to be available for other arch (such as arm64)
as well, such as for the purpose of ACPI/APEI.

ia64 efi does not setup memmap variable and does not set
EFI_MEMMAP flag, so it needs to have its unique implementation
of efi_mem_attributes().

Move efi_mem_attributes() implementation from x86 to efi, and
declare it with __weak. It is recommended that other archs
should not override the default implementation.

Reviewed-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 arch/x86/platform/efi/efi.c | 18 ------------------
 drivers/firmware/efi/efi.c  | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cfba30f27392..1ea9cb05163b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -952,24 +952,6 @@ u32 efi_mem_type(unsigned long phys_addr)
 	return 0;
 }
 
-u64 efi_mem_attributes(unsigned long phys_addr)
-{
-	efi_memory_desc_t *md;
-	void *p;
-
-	if (!efi_enabled(EFI_MEMMAP))
-		return 0;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->attribute;
-	}
-	return 0;
-}
-
 static int __init arch_parse_efi_cmdline(char *str)
 {
 	if (parse_option_str(str, "old_map"))
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 46eb8a6e9393..713f92f6b254 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -602,3 +602,34 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 			 attr & EFI_MEMORY_UC      ? "UC"  : "");
 	return buf;
 }
+
+/*
+ * efi_mem_attributes - lookup memmap attributes for physical address
+ * @phys_addr: the physical address to lookup
+ *
+ * Search in the EFI memory map for the region covering
+ * @phys_addr. Returns the EFI memory attributes if the region
+ * was found in the memory map, 0 otherwise.
+ *
+ * Despite being marked __weak, most architectures should *not*
+ * override this function. It is __weak solely for the benefit
+ * of ia64 which has a funky EFI memory map that doesn't work
+ * the same way as other architectures.
+ */
+u64 __weak efi_mem_attributes(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+		    (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->attribute;
+	}
+	return 0;
+}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
