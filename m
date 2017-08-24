From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 1/2] EFI: move efi_mem_type() to common code
Date: Thu, 24 Aug 2017 03:11:42 -0600
Message-ID: <599EB46E02000078001730B1@prv-mh.provo.novell.com>
References: <599EB46E02000078001730B1@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This follows efi_mem_attributes(), as it's similarly generic.

Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |   19 -------------------
 drivers/firmware/efi/efi.c  |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 19 deletions(-)

--- 4.13-rc6-EFI.orig/arch/x86/platform/efi/efi.c
+++ 4.13-rc6-EFI/arch/x86/platform/efi/efi.c
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
--- 4.13-rc6-EFI.orig/drivers/firmware/efi/efi.c
+++ 4.13-rc6-EFI/drivers/firmware/efi/efi.c
@@ -819,6 +819,35 @@ u64 __weak efi_mem_attributes(unsigned l
 	return 0;
 }
 
+/*
+ * efi_mem_type - lookup memmap type for physical address
+ * @phys_addr: the physical address to lookup
+ *
+ * Search in the EFI memory map for the region covering @phys_addr.
+ * Returns the EFI memory type if the region was found in the memory
+ * map, EFI_RESERVED_TYPE (zero) otherwise.
+ *
+ * Despite being marked __weak, most architectures should *not*
+ * override this function. It is __weak solely for the benefit
+ * of ia64 which has a funky EFI memory map that doesn't work
+ * the same way as other architectures.
+ */
+u32 __weak efi_mem_type(unsigned long phys_addr)
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
+
 int efi_status_to_err(efi_status_t status)
 {
 	int err;
