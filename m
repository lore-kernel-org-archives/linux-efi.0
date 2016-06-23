From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 08/11] efi: Allow drivers to reserve boot services forever
Date: Thu, 23 Jun 2016 12:34:47 +0100
Message-ID: <1466681690-5850-9-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, Borislav Petkov <bp@alien8.de>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-efi@vger.kernel.org

Today, it is not possible for drivers to reserve EFI boot services for
access after efi_free_boot_services() has been called on x86. For
ARM/arm64 it can be done simply by calling memblock_reserve().

Having this ability for all three architectures is desirable for a
couple of reasons,

  1) It saves drivers copying data out of those regions
  2) kexec reboot can now make use of things like ESRT

Instead of using the standard memblock_reserve() which is insufficient
to reserve the region on x86 (see efi_reserve_boot_services()), a new
API is introduced in this patch; efi_mem_reserve().

efi.memmap now always represents which EFI memory regions are
available. On x86 the EFI boot services regions that have not been
reserved via efi_mem_reserve() will be removed from efi.memmap during
efi_free_boot_services().

This has implications for kexec, since it is not possible for a newly
kexec'd kernel to access the same boot services regions that the
initial boot kernel had access to unless they are reserved by every
kexec kernel in the chain.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/quirks.c | 121 +++++++++++++++++++++++++++++++++++++----
 drivers/firmware/efi/efi.c     |  30 ++++++++++
 include/linux/efi.h            |   1 +
 3 files changed, 141 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 570c33683a26..3dae771266a6 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -164,6 +164,71 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
 
 /*
+ * The UEFI specification makes it clear that the operating system is
+ * free to do whatever it wants with boot services code after
+ * ExitBootServices() has been called. Ignoring this recommendation a
+ * significant bunch of EFI implementations continue calling into boot
+ * services code (SetVirtualAddressMap). In order to work around such
+ * buggy implementations we reserve boot services region during EFI
+ * init and make sure it stays executable. Then, after
+ * SetVirtualAddressMap(), it is discarded.
+ *
+ * However, some boot services regions contain data that is required
+ * by drivers, so we need to track which memory ranges can never be
+ * freed. This is done by tagging those regions with the
+ * EFI_MEMORY_RUNTIME attribute.
+ *
+ * Any driver that wants to mark a region as reserved must use
+ * efi_mem_reserve() which will insert a new EFI memory descriptor
+ * into efi.memmap (splitting existing regions if necessary) and tag
+ * it with EFI_MEMORY_RUNTIME.
+ */
+void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
+{
+	phys_addr_t new_phys, new_size;
+	struct efi_mem_range mr;
+	efi_memory_desc_t md;
+	int num_entries;
+	void *new;
+
+	if (efi_mem_desc_lookup(addr, &md)) {
+		pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);
+		return;
+	}
+
+	if (addr + size > md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT)) {
+		pr_err("Region spans EFI memory descriptors, %pa\n", &addr);
+		return;
+	}
+
+	mr.range.start = addr;
+	mr.range.end = addr + size;
+	mr.attribute = md.attribute | EFI_MEMORY_RUNTIME;
+
+	num_entries = efi_memmap_split_count(&md, &mr.range);
+	num_entries += efi.memmap.nr_map;
+
+	new_size = efi.memmap.desc_size * num_entries;
+
+	new_phys = memblock_alloc(new_size, 0);
+	if (!new_phys) {
+		pr_err("Could not allocate boot services memmap\n");
+		return;
+	}
+
+	new = early_memremap(new_phys, new_size);
+	if (!new) {
+		pr_err("Failed to map new boot services memmap\n");
+		return;
+	}
+
+	efi_memmap_insert(&efi.memmap, new, &mr);
+	early_memunmap(new, new_size);
+
+	efi_memmap_install(new_phys, num_entries);
+}
+
+/*
  * Helper function for efi_reserve_boot_services() to figure out if we
  * can free regions in efi_free_boot_services().
  *
@@ -184,15 +249,6 @@ static bool can_free_region(u64 start, u64 size)
 	return true;
 }
 
-/*
- * The UEFI specification makes it clear that the operating system is free to do
- * whatever it wants with boot services code after ExitBootServices() has been
- * called. Ignoring this recommendation a significant bunch of EFI implementations 
- * continue calling into boot services code (SetVirtualAddressMap). In order to 
- * work around such buggy implementations we reserve boot services region during 
- * EFI init and make sure it stays executable. Then, after SetVirtualAddressMap(), it
-* is discarded.
-*/
 void __init efi_reserve_boot_services(void)
 {
 	efi_memory_desc_t *md;
@@ -249,22 +305,65 @@ void __init efi_reserve_boot_services(void)
 
 void __init efi_free_boot_services(void)
 {
+	phys_addr_t new_phys, new_size;
 	efi_memory_desc_t *md;
+	int num_entries = 0;
+	void *new, *new_md;
 
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		    md->type != EFI_BOOT_SERVICES_DATA) {
+			num_entries++;
 			continue;
+		}
 
 		/* Do not free, someone else owns it: */
-		if (md->attribute & EFI_MEMORY_RUNTIME)
+		if (md->attribute & EFI_MEMORY_RUNTIME) {
+			num_entries++;
 			continue;
+		}
 
 		free_bootmem_late(start, size);
 	}
+
+	new_size = efi.memmap.desc_size * num_entries;
+	new_phys = memblock_alloc(new_size, 0);
+	if (!new_phys) {
+		pr_err("Failed to allocate new EFI memmap\n");
+		return;
+	}
+
+	new = memremap(new_phys, new_size, MEMREMAP_WB);
+	if (!new) {
+		pr_err("Failed to map new EFI memmap\n");
+		return;
+	}
+
+	/*
+	 * Build a new EFI memmap that excludes any boot services
+	 * regions that are not tagged EFI_MEMORY_RUNTIME, since those
+	 * regions have now been freed.
+	 */
+	new_md = new;
+	for_each_efi_memory_desc(md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    (md->type == EFI_BOOT_SERVICES_CODE ||
+		     md->type == EFI_BOOT_SERVICES_DATA))
+			continue;
+
+		memcpy(new_md, md, efi.memmap.desc_size);
+		new_md += efi.memmap.desc_size;
+	}
+
+	memunmap(new);
+
+	if (efi_memmap_install(new_phys, num_entries)) {
+		pr_err("Could not install new EFI memmap\n");
+		return;
+	}
 }
 
 /*
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d9c41a434462..ccd0095b91a1 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -24,6 +24,7 @@
 #include <linux/of_fdt.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/memblock.h>
 
 #include <asm/early_ioremap.h>
 
@@ -300,6 +301,35 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
 	return end;
 }
 
+void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
+
+/**
+ * efi_mem_reserve - Reserve an EFI memory region
+ * @addr: Physical address to reserve
+ * @size: Size of reservation
+ *
+ * Mark a region as reserved from general kernel allocation and
+ * prevent it being released by efi_free_boot_services().
+ *
+ * This function should be called drivers once they've parsed EFI
+ * configuration tables to figure out where their data lives, e.g.
+ * efi_esrt_init().
+ */
+void __init efi_mem_reserve(phys_addr_t addr, u64 size)
+{
+	if (!memblock_is_region_reserved(addr, size))
+		memblock_reserve(addr, size);
+
+	/*
+	 * Some architectures (x86) reserve all boot services ranges
+	 * until efi_free_boot_services() because of buggy firmware
+	 * implementations. This means the above memblock_reserve() is
+	 * superfluous on x86 and instead what it needs to do is
+	 * ensure the @start, @size is not freed.
+	 */
+	efi_arch_mem_reserve(addr, size);
+}
+
 static __initdata efi_config_table_type_t common_tables[] = {
 	{ACPI_20_TABLE_GUID, "ACPI 2.0", &efi.acpi20},
 	{ACPI_TABLE_GUID, "ACPI", &efi.acpi},
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9fb390d56fbe..9f955dab9f77 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1017,6 +1017,7 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern u64 efi_mem_desc_end(efi_memory_desc_t *md);
 extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
+extern void efi_mem_reserve(phys_addr_t addr, u64 size);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
-- 
2.7.3
