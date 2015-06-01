From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V2 1/3] efi: arch, x86: arch, ia64: move efi_mem_attributes()
Date: Mon,  1 Jun 2015 12:12:18 -0700
Message-ID: <1433185940-24770-2-git-send-email-zjzhang@codeaurora.org>
References: <1433185940-24770-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433185940-24770-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, leif.lindholm@linaro.org, al.stone@linaro.org, fu.wei@linaro.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

Both x86 and ia64 implemented efi_mem_attributs(), which is architecture
agnositc. This function is moved from arch/x86 and arch/ia64 to
drivers/firmware/efi.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 arch/ia64/kernel/efi.c      | 11 -----------
 arch/x86/platform/efi/efi.c | 18 ------------------
 drivers/firmware/efi/efi.c  | 18 ++++++++++++++++++
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index c52d7540dc05..ef20ec784b04 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -771,17 +771,6 @@ efi_mem_type (unsigned long phys_addr)
 }
 
 u64
-efi_mem_attributes (unsigned long phys_addr)
-{
-	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
-
-	if (md)
-		return md->attribute;
-	return 0;
-}
-EXPORT_SYMBOL(efi_mem_attributes);
-
-u64
 efi_mem_attribute (unsigned long phys_addr, unsigned long size)
 {
 	unsigned long end = phys_addr + size;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 02744df576d5..10bd5289c593 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -926,24 +926,6 @@ u32 efi_mem_type(unsigned long phys_addr)
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
index 3061bb8629dc..86da85368778 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -517,3 +517,21 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 			 attr & EFI_MEMORY_UC      ? "UC"  : "");
 	return buf;
 }
+
+u64 efi_mem_attributes(unsigned long phys_addr)
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
