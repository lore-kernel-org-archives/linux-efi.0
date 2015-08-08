From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V11 1/5] efi: x86: rearrange efi_mem_attributes()
Date: Sat,  8 Aug 2015 10:18:49 -0700
Message-ID: <1439054333-21766-2-git-send-email-zjzhang@codeaurora.org>
References: <1439054333-21766-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439054333-21766-1-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

x86 and ia64 implement efi_mem_attributes() differently. This
function needs to be available for other arch (such as arm64)
as well, such as for the purpose of ACPI/APEI.

ia64 efi does not setup memmap variable and does not set
EFI_MEMMAP flag, so it needs to have its unique implementation
of efi_mem_attributes().

Move efi_mem_attributes() implementation from x86 to efi, and
declare it with __weak. It is recommended that other archs
should not override the default implementation.

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 18 ------------------
 drivers/firmware/efi/efi.c  | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dbc8627a5cdf..88b3ebaeb72f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -917,24 +917,6 @@ u32 efi_mem_type(unsigned long phys_addr)
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
index 3061bb8629dc..bf4190a4f3f5 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -517,3 +517,34 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
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
