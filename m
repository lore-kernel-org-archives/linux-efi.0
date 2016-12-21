From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] x86/efi: don't allocate memmap through memblock after mm_init()
Date: Wed, 21 Dec 2016 19:28:45 +0100
Message-ID: <20161221182846.2968-1-nicstange@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

With commit 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid
copying image data"), efi_bgrt_init() calls into the memblock allocator
through efi_mem_reserve() => efi_arch_mem_reserve() *after* mm_init()
has been called.

Indeed, KASAN reports a bad read access later on in
efi_free_boot_services():

  BUG: KASAN: use-after-free in efi_free_boot_services+0xae/0x24c
            at addr ffff88022de12740
  Read of size 4 by task swapper/0/0
  page:ffffea0008b78480 count:0 mapcount:-127
  mapping:          (null) index:0x1 flags: 0x5fff8000000000()
  [...]
  Call Trace:
   dump_stack+0x68/0x9f
   kasan_report_error+0x4c8/0x500
   kasan_report+0x58/0x60
   __asan_load4+0x61/0x80
   efi_free_boot_services+0xae/0x24c
   start_kernel+0x527/0x562
   x86_64_start_reservations+0x24/0x26
   x86_64_start_kernel+0x157/0x17a
   start_cpu+0x5/0x14

The instruction at the given address is the first read from the memmap's
memory, i.e. the read of md->type in efi_free_boot_services().

Note that the writes earlier in efi_arch_mem_reserve() don't splat because
they're done through early_memremap()ed addresses.

So, after memblock is gone, allocations should be done through the "normal"
page allocator. Introduce a helper, efi_memmap_alloc() for this. Use
it from efi_arch_mem_reserve() and from efi_free_boot_services() as well.

Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c |  4 ++--
 drivers/firmware/efi/memmap.c  | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |  1 +
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 10aca63a50d7..30031d5293c4 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -214,7 +214,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 
 	new_size = efi.memmap.desc_size * num_entries;
 
-	new_phys = memblock_alloc(new_size, 0);
+	new_phys = efi_memmap_alloc(num_entries);
 	if (!new_phys) {
 		pr_err("Could not allocate boot services memmap\n");
 		return;
@@ -355,7 +355,7 @@ void __init efi_free_boot_services(void)
 	}
 
 	new_size = efi.memmap.desc_size * num_entries;
-	new_phys = memblock_alloc(new_size, 0);
+	new_phys = efi_memmap_alloc(num_entries);
 	if (!new_phys) {
 		pr_err("Failed to allocate new EFI memmap\n");
 		return;
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index f03ddecd232b..78686443cb37 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -9,6 +9,44 @@
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <asm/early_ioremap.h>
+#include <linux/memblock.h>
+#include <linux/slab.h>
+
+static phys_addr_t __init __efi_memmap_alloc_early(unsigned long size)
+{
+	return memblock_alloc(size, 0);
+}
+
+static phys_addr_t __init __efi_memmap_alloc_late(unsigned long size)
+{
+	unsigned int order = get_order(size);
+	struct page *p = alloc_pages(GFP_KERNEL, order);
+
+	if (!p)
+		return 0;
+
+	return PFN_PHYS(page_to_pfn(p));
+}
+
+/**
+ * efi_memmap_alloc - Allocate memory for the EFI memory map
+ * @num_entries: Number of entries in the allocated map.
+ *
+ * Depending on whether mm_init() has already been invoked or not,
+ * either memblock or "normal" page allocation is used.
+ *
+ * Returns the physical address of the allocated memory map on
+ * success, zero on failure.
+ */
+phys_addr_t __init efi_memmap_alloc(unsigned int num_entries)
+{
+	unsigned long size = num_entries * efi.memmap.desc_size;
+
+	if (slab_is_available())
+		return __efi_memmap_alloc_late(size);
+
+	return __efi_memmap_alloc_early(size);
+}
 
 /**
  * __efi_memmap_init - Common code for mapping the EFI memory map
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a07a476178cd..0c5420208c40 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -950,6 +950,7 @@ static inline efi_status_t efi_query_variable_store(u32 attributes,
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 
+extern phys_addr_t __init efi_memmap_alloc(unsigned int num_entries);
 extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
 extern int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size);
 extern void __init efi_memmap_unmap(void);
-- 
2.11.0
