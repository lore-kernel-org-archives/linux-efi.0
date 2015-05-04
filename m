From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 1/2] efi: arch, x86: arch, ia64: rearrange EFI memmap related functions
Date: Mon,  4 May 2015 14:02:14 -0700
Message-ID: <1430773335-22897-2-git-send-email-zjzhang@codeaurora.org>
References: <1430773335-22897-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430773335-22897-1-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Both x86 and ia64 implemented efi_mem_attributs function, which is architecture
agnositc. This function is moved to efi subsystem.

efi_remap() function is added. If EFI memmap feature is enabled, and if a
memory region has attribute of EFI_MEMORY_UC, map it as uncached.

---
This patch was tested on an arm64 platform. It was built on x86 platform.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/ia64/kernel/efi.c      | 11 -----------
 arch/x86/platform/efi/efi.c | 18 ------------------
 drivers/firmware/efi/efi.c  | 27 +++++++++++++++++++++++++++
 include/linux/efi.h         |  1 +
 4 files changed, 28 insertions(+), 29 deletions(-)

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
index 3061bb8629dc..5b42bb6d1fde 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -517,3 +517,30 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
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
+
+void __iomem *efi_remap(phys_addr_t phys_addr, size_t size)
+{
+	if (efi_enabled(EFI_MEMMAP) &&
+	    (efi_mem_attributes(phys_addr) & EFI_MEMORY_UC))
+		return ioremap(phys_addr, size);
+	else
+		return ioremap_cache(phys_addr, size);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cf7e431cbc73..3279b5acea11 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -891,6 +891,7 @@ extern struct efi_memory_map memmap;
 
 extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
+extern void __iomem *efi_remap(phys_addr_t phys_addr, size_t size);
 
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc(m, md)					   \
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
