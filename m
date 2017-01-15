From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI fixes
Date: Sun, 15 Jan 2017 10:53:11 +0100
Message-ID: <20170115095310.GA30496@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: 0100a3e67a9cef64d72cd3a1da86f3ddbee50363 efi/x86: Prune invalid memory map entries and fix boot regression

A number of regression fixes:

 - Fix a boot hang on machines that have somewhat unusual memory map entries of
   phys_addr=0x0 num_pages=0, which broke due to a recent commit. This commit got 
   cherry-picked from the v4.11 queue because the bug is affecting real machines.

 - Fix a boot hang also reported by KASAN, caused by incorrect init ordering 
   introduced by a recent optimization.

 - Fix a recent robustification fix to allocate_new_fdt_and_exit_boot() that
   introduced an invalid assumption. Neither bugs were seen in the wild AFAIK.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (1):
      efi/libstub/arm*: Pass latest memory map to the kernel

Nicolai Stange (1):
      x86/efi: Don't allocate memmap through memblock after mm_init()

Peter Jones (1):
      efi/x86: Prune invalid memory map entries and fix boot regression


 arch/x86/platform/efi/efi.c            | 66 ++++++++++++++++++++++++++
 arch/x86/platform/efi/quirks.c         |  4 +-
 drivers/firmware/efi/fake_mem.c        |  3 +-
 drivers/firmware/efi/libstub/efistub.h |  8 ----
 drivers/firmware/efi/libstub/fdt.c     | 87 ++++++++++++++++++++++------------
 drivers/firmware/efi/memmap.c          | 38 +++++++++++++++
 include/linux/efi.h                    |  2 +
 7 files changed, 165 insertions(+), 43 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 936a488d6cf6..274dfc481849 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -210,6 +210,70 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
+#define OVERFLOW_ADDR_SHIFT	(64 - EFI_PAGE_SHIFT)
+#define OVERFLOW_ADDR_MASK	(U64_MAX << OVERFLOW_ADDR_SHIFT)
+#define U64_HIGH_BIT		(~(U64_MAX >> 1))
+
+static bool __init efi_memmap_entry_valid(const efi_memory_desc_t *md, int i)
+{
+	u64 end = (md->num_pages << EFI_PAGE_SHIFT) + md->phys_addr - 1;
+	u64 end_hi = 0;
+	char buf[64];
+
+	if (md->num_pages == 0) {
+		end = 0;
+	} else if (md->num_pages > EFI_PAGES_MAX ||
+		   EFI_PAGES_MAX - md->num_pages <
+		   (md->phys_addr >> EFI_PAGE_SHIFT)) {
+		end_hi = (md->num_pages & OVERFLOW_ADDR_MASK)
+			>> OVERFLOW_ADDR_SHIFT;
+
+		if ((md->phys_addr & U64_HIGH_BIT) && !(end & U64_HIGH_BIT))
+			end_hi += 1;
+	} else {
+		return true;
+	}
+
+	pr_warn_once(FW_BUG "Invalid EFI memory map entries:\n");
+
+	if (end_hi) {
+		pr_warn("mem%02u: %s range=[0x%016llx-0x%llx%016llx] (invalid)\n",
+			i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			md->phys_addr, end_hi, end);
+	} else {
+		pr_warn("mem%02u: %s range=[0x%016llx-0x%016llx] (invalid)\n",
+			i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			md->phys_addr, end);
+	}
+	return false;
+}
+
+static void __init efi_clean_memmap(void)
+{
+	efi_memory_desc_t *out = efi.memmap.map;
+	const efi_memory_desc_t *in = out;
+	const efi_memory_desc_t *end = efi.memmap.map_end;
+	int i, n_removal;
+
+	for (i = n_removal = 0; in < end; i++) {
+		if (efi_memmap_entry_valid(in, i)) {
+			if (out != in)
+				memcpy(out, in, efi.memmap.desc_size);
+			out = (void *)out + efi.memmap.desc_size;
+		} else {
+			n_removal++;
+		}
+		in = (void *)in + efi.memmap.desc_size;
+	}
+
+	if (n_removal > 0) {
+		u64 size = efi.memmap.nr_map - n_removal;
+
+		pr_warn("Removing %d invalid memory map entries.\n", n_removal);
+		efi_memmap_install(efi.memmap.phys_map, size);
+	}
+}
+
 void __init efi_print_memmap(void)
 {
 	efi_memory_desc_t *md;
@@ -472,6 +536,8 @@ void __init efi_init(void)
 		}
 	}
 
+	efi_clean_memmap();
+
 	if (efi_enabled(EFI_DBG))
 		efi_print_memmap();
 }
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
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 520a40e5e0e4..6c7d60c239b5 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -71,8 +71,7 @@ void __init efi_fake_memmap(void)
 	}
 
 	/* allocate memory for new EFI memmap */
-	new_memmap_phy = memblock_alloc(efi.memmap.desc_size * new_nr_map,
-					PAGE_SIZE);
+	new_memmap_phy = efi_memmap_alloc(new_nr_map);
 	if (!new_memmap_phy)
 		return;
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index b98824e3800a..0e2a96b12cb3 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -39,14 +39,6 @@ efi_status_t efi_file_close(void *handle);
 
 unsigned long get_dram_base(efi_system_table_t *sys_table_arg);
 
-efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
-			unsigned long orig_fdt_size,
-			void *fdt, int new_fdt_size, char *cmdline_ptr,
-			u64 initrd_addr, u64 initrd_size,
-			efi_memory_desc_t *memory_map,
-			unsigned long map_size, unsigned long desc_size,
-			u32 desc_ver);
-
 efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 					    void *handle,
 					    unsigned long *new_fdt_addr,
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a6a93116a8f0..921dfa047202 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -16,13 +16,10 @@
 
 #include "efistub.h"
 
-efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
-			unsigned long orig_fdt_size,
-			void *fdt, int new_fdt_size, char *cmdline_ptr,
-			u64 initrd_addr, u64 initrd_size,
-			efi_memory_desc_t *memory_map,
-			unsigned long map_size, unsigned long desc_size,
-			u32 desc_ver)
+static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			       unsigned long orig_fdt_size,
+			       void *fdt, int new_fdt_size, char *cmdline_ptr,
+			       u64 initrd_addr, u64 initrd_size)
 {
 	int node, num_rsv;
 	int status;
@@ -101,25 +98,23 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	if (status)
 		goto fdt_set_fail;
 
-	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
+	fdt_val64 = U64_MAX; /* placeholder */
 	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
 			     &fdt_val64,  sizeof(fdt_val64));
 	if (status)
 		goto fdt_set_fail;
 
-	fdt_val32 = cpu_to_fdt32(map_size);
+	fdt_val32 = U32_MAX; /* placeholder */
 	status = fdt_setprop(fdt, node, "linux,uefi-mmap-size",
 			     &fdt_val32,  sizeof(fdt_val32));
 	if (status)
 		goto fdt_set_fail;
 
-	fdt_val32 = cpu_to_fdt32(desc_size);
 	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-size",
 			     &fdt_val32, sizeof(fdt_val32));
 	if (status)
 		goto fdt_set_fail;
 
-	fdt_val32 = cpu_to_fdt32(desc_ver);
 	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-ver",
 			     &fdt_val32, sizeof(fdt_val32));
 	if (status)
@@ -148,6 +143,43 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	return EFI_LOAD_ERROR;
 }
 
+static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
+{
+	int node = fdt_path_offset(fdt, "/chosen");
+	u64 fdt_val64;
+	u32 fdt_val32;
+	int err;
+
+	if (node < 0)
+		return EFI_LOAD_ERROR;
+
+	fdt_val64 = cpu_to_fdt64((unsigned long)*map->map);
+	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
+				  &fdt_val64, sizeof(fdt_val64));
+	if (err)
+		return EFI_LOAD_ERROR;
+
+	fdt_val32 = cpu_to_fdt32(*map->map_size);
+	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-size",
+				  &fdt_val32, sizeof(fdt_val32));
+	if (err)
+		return EFI_LOAD_ERROR;
+
+	fdt_val32 = cpu_to_fdt32(*map->desc_size);
+	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-desc-size",
+				  &fdt_val32, sizeof(fdt_val32));
+	if (err)
+		return EFI_LOAD_ERROR;
+
+	fdt_val32 = cpu_to_fdt32(*map->desc_ver);
+	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-desc-ver",
+				  &fdt_val32, sizeof(fdt_val32));
+	if (err)
+		return EFI_LOAD_ERROR;
+
+	return EFI_SUCCESS;
+}
+
 #ifndef EFI_FDT_ALIGN
 #define EFI_FDT_ALIGN EFI_PAGE_SIZE
 #endif
@@ -243,20 +275,10 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 			goto fail;
 		}
 
-		/*
-		 * Now that we have done our final memory allocation (and free)
-		 * we can get the memory map key  needed for
-		 * exit_boot_services().
-		 */
-		status = efi_get_memory_map(sys_table, &map);
-		if (status != EFI_SUCCESS)
-			goto fail_free_new_fdt;
-
 		status = update_fdt(sys_table,
 				    (void *)fdt_addr, fdt_size,
 				    (void *)*new_fdt_addr, new_fdt_size,
-				    cmdline_ptr, initrd_addr, initrd_size,
-				    memory_map, map_size, desc_size, desc_ver);
+				    cmdline_ptr, initrd_addr, initrd_size);
 
 		/* Succeeding the first time is the expected case. */
 		if (status == EFI_SUCCESS)
@@ -266,20 +288,16 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 			/*
 			 * We need to allocate more space for the new
 			 * device tree, so free existing buffer that is
-			 * too small.  Also free memory map, as we will need
-			 * to get new one that reflects the free/alloc we do
-			 * on the device tree buffer.
+			 * too small.
 			 */
 			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
-			sys_table->boottime->free_pool(memory_map);
 			new_fdt_size += EFI_PAGE_SIZE;
 		} else {
 			pr_efi_err(sys_table, "Unable to construct new device tree.\n");
-			goto fail_free_mmap;
+			goto fail_free_new_fdt;
 		}
 	}
 
-	sys_table->boottime->free_pool(memory_map);
 	priv.runtime_map = runtime_map;
 	priv.runtime_entry_count = &runtime_entry_count;
 	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
@@ -288,6 +306,16 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
 
+		status = update_fdt_memmap((void *)*new_fdt_addr, &map);
+		if (status != EFI_SUCCESS) {
+			/*
+			 * The kernel won't get far without the memory map, but
+			 * may still be able to print something meaningful so
+			 * return success here.
+			 */
+			return EFI_SUCCESS;
+		}
+
 		/* Install the new virtual address map */
 		svam = sys_table->runtime->set_virtual_address_map;
 		status = svam(runtime_entry_count * desc_size, desc_size,
@@ -319,9 +347,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 
 	pr_efi_err(sys_table, "Exit boot services failed.\n");
 
-fail_free_mmap:
-	sys_table->boottime->free_pool(memory_map);
-
 fail_free_new_fdt:
 	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
 
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
index a07a476178cd..5b1af30ece55 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -103,6 +103,7 @@ typedef	struct {
 
 #define EFI_PAGE_SHIFT		12
 #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
+#define EFI_PAGES_MAX		(U64_MAX >> EFI_PAGE_SHIFT)
 
 typedef struct {
 	u32 type;
@@ -950,6 +951,7 @@ static inline efi_status_t efi_query_variable_store(u32 attributes,
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 
+extern phys_addr_t __init efi_memmap_alloc(unsigned int num_entries);
 extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
 extern int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size);
 extern void __init efi_memmap_unmap(void);
