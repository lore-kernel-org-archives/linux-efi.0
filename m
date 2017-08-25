From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] efi: move efi_mem_type() to common code
Date: Fri, 25 Aug 2017 16:50:18 +0100
Message-ID: <20170825155019.6740-5-ard.biesheuvel@linaro.org>
References: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170825155019.6740-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>

This follows efi_mem_attributes(), as it's similarly generic. Drop
__weak from that one though (and don't introduce it for efi_mem_type()
in the first place) to make clear that other overrides to these
functions are really not intended.

Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 19 -------------------
 drivers/firmware/efi/efi.c  | 37 +++++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f084d8718ac4..928b6dceeca0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1032,25 +1032,6 @@ void __init efi_enter_virtual_mode(void)
 	efi_dump_pagetable();
 }
 
-/*
- * Convenience functions to obtain memory types and attributes
- */
-u32 efi_mem_type(unsigned long phys_addr)
-{
-	efi_memory_desc_t *md;
-
-	if (!efi_enabled(EFI_MEMMAP))
-		return 0;
-
-	for_each_efi_memory_desc(md) {
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->type;
-	}
-	return 0;
-}
-
 static int __init arch_parse_efi_cmdline(char *str)
 {
 	if (!str) {
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9e822906adcb..f97f272e16ee 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -792,19 +792,19 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 }
 
 /*
+ * IA64 has a funky EFI memory map that doesn't work the same way as
+ * other architectures.
+ */
+#ifndef CONFIG_IA64
+/*
  * efi_mem_attributes - lookup memmap attributes for physical address
  * @phys_addr: the physical address to lookup
  *
  * Search in the EFI memory map for the region covering
  * @phys_addr. Returns the EFI memory attributes if the region
  * was found in the memory map, 0 otherwise.
- *
- * Despite being marked __weak, most architectures should *not*
- * override this function. It is __weak solely for the benefit
- * of ia64 which has a funky EFI memory map that doesn't work
- * the same way as other architectures.
  */
-u64 __weak efi_mem_attributes(unsigned long phys_addr)
+u64 efi_mem_attributes(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
 
@@ -820,6 +820,31 @@ u64 __weak efi_mem_attributes(unsigned long phys_addr)
 	return 0;
 }
 
+/*
+ * efi_mem_type - lookup memmap type for physical address
+ * @phys_addr: the physical address to lookup
+ *
+ * Search in the EFI memory map for the region covering @phys_addr.
+ * Returns the EFI memory type if the region was found in the memory
+ * map, EFI_RESERVED_TYPE (zero) otherwise.
+ */
+u32 efi_mem_type(unsigned long phys_addr)
+{
+	const efi_memory_desc_t *md;
+
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
+	for_each_efi_memory_desc(md) {
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->type;
+	}
+	return EFI_RESERVED_TYPE;
+}
+#endif
+
 int efi_status_to_err(efi_status_t status)
 {
 	int err;
-- 
2.11.0
