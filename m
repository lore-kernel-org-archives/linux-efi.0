From: Robert Richter <rrichter@caviumnetworks.com>
Subject: [PATCH v4 4/6] arm64/efi: move EFI /chosen node parsing before early
 FDT processing
Date: Tue, 9 Feb 2016 14:53:44 +0100
Message-ID: <1455026026-11571-5-git-send-email-rrichter@caviumnetworks.com>
References: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Robert Richter <rrichter@cavium.com>, Mark Salter <msalter@redhat.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The early FDT processing is responsible for enumerating the
DT memory nodes and installing them as memblocks. This should
only be done if we are not booting via EFI, but at this point,
we don't know yet if that is the case or not.

So move part of the EFI init to before the early FDT processing. This
involves making some changes to the way EFI discovers the locations of
the EFI system table and the memory map, since those values are retrieved
from the FDT as well. Instead the of_scan infrastructure, it now uses
libfdt directly to access the /chosen node.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Message-Id: <1442881288-13962-5-git-send-email-ard.biesheuvel@linaro.org>
[ rric: Ported to v4.5-rc1 ]
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/include/asm/efi.h    |  2 ++
 arch/arm64/kernel/setup.c       |  3 ++
 drivers/firmware/efi/arm-init.c | 34 ++++++++++++-------
 drivers/firmware/efi/efi-fdt.c  | 72 ++++++++++++++++-------------------------
 include/linux/efi.h             |  2 +-
 5 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8e88a696c9cb..acc7f65cef47 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -8,8 +8,10 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
+extern void efi_parse_fdt(void *fdt);
 #else
 #define efi_init()
+#define efi_parse_fdt(x)
 #endif
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 8119479147db..3f5723329173 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -181,6 +181,9 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
 	void *dt_virt = fixmap_remap_fdt(dt_phys);
 
+	if (dt_virt)
+		efi_parse_fdt(dt_virt);
+
 	if (!dt_virt || !early_init_dt_scan(dt_virt)) {
 		pr_crit("\n"
 			"Error: invalid device tree blob at physical address %pa (virtual address 0x%p)\n"
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 9e15d571b53c..9fe04648d4d3 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -170,22 +170,35 @@ static __init void reserve_regions(void)
 		if (efi_enabled(EFI_DBG))
 			pr_cont("\n");
 	}
-
-	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
-void __init efi_init(void)
+void __init efi_parse_fdt(void *fdt)
 {
 	struct efi_fdt_params params;
 
 	/* Grab UEFI information placed in FDT by stub */
-	if (!efi_get_fdt_params(&params))
+	if (!efi_get_fdt_params(fdt, &params))
 		return;
 
 	efi_system_table = params.system_table;
 
 	memmap.phys_map = params.mmap;
-	memmap.map = early_memremap(params.mmap, params.mmap_size);
+	memmap.desc_size = params.desc_size;
+	memmap.desc_version = params.desc_ver;
+	memmap.nr_map = params.mmap_size / params.desc_size;
+
+	set_bit(EFI_MEMMAP, &efi.flags);
+}
+
+void __init efi_init(void)
+{
+	int mmap_size = memmap.nr_map * memmap.desc_size;
+	u64 phys_map  = memmap.phys_map;
+
+	if (!efi_enabled(EFI_MEMMAP))
+		return;
+
+	memmap.map = early_memremap(phys_map, mmap_size);
 	if (memmap.map == NULL) {
 		/*
 		* If we are booting via UEFI, the UEFI memory map is the only
@@ -194,16 +207,13 @@ void __init efi_init(void)
 		*/
 		panic("Unable to map EFI memory map.\n");
 	}
-	memmap.map_end = memmap.map + params.mmap_size;
-	memmap.desc_size = params.desc_size;
-	memmap.desc_version = params.desc_ver;
+	memmap.map_end = memmap.map + mmap_size;
 
 	if (uefi_init() < 0)
 		return;
 
 	reserve_regions();
-	early_memunmap(memmap.map, params.mmap_size);
-	memblock_mark_nomap(params.mmap & PAGE_MASK,
-			    PAGE_ALIGN(params.mmap_size +
-				       (params.mmap & ~PAGE_MASK)));
+	early_memunmap(memmap.map, mmap_size);
+	memblock_mark_nomap(phys_map & PAGE_MASK,
+			    PAGE_ALIGN(mmap_size + (phys_map & ~PAGE_MASK)));
 }
diff --git a/drivers/firmware/efi/efi-fdt.c b/drivers/firmware/efi/efi-fdt.c
index 8f3ce66e2b02..e6622d3182ae 100644
--- a/drivers/firmware/efi/efi-fdt.c
+++ b/drivers/firmware/efi/efi-fdt.c
@@ -8,8 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/efi.h>
-#include <linux/of.h>
-#include <linux/of_fdt.h>
+#include <linux/libfdt.h>
 
 #define UEFI_PARAM(name, prop, field)			   \
 	{						   \
@@ -32,60 +31,43 @@ static __initdata struct {
 	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
 };
 
-struct param_info {
-	int found;
-	void *params;
-};
-
-static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
-				       int depth, void *data)
+int __init efi_get_fdt_params(void *fdt, struct efi_fdt_params *params)
 {
-	struct param_info *info = data;
 	const void *prop;
-	void *dest;
-	u64 val;
-	int i, len;
+	int node, i;
+
+	pr_info("Getting EFI parameters from FDT:\n");
 
-	if (depth != 1 || strcmp(uname, "chosen") != 0)
-		return 0;
+	node = fdt_path_offset(fdt, "/chosen");
+	if (node < 0) {
+		pr_err("/chosen node not found!\n");
+		return false;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
-		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
-		if (!prop)
-			return 0;
-		dest = info->params + dt_params[i].offset;
-		info->found++;
+		void *dest;
+		int len;
+		u64 val;
 
-		val = of_read_number(prop, len / sizeof(u32));
+		prop = fdt_getprop(fdt, node, dt_params[i].propname, &len);
+		if (!prop || len != dt_params[i].size)
+			goto not_found;
+		dest = (void *)params + dt_params[i].offset;
 
 		if (dt_params[i].size == sizeof(u32))
-			*(u32 *)dest = val;
+			val = *(u32 *)dest = be32_to_cpup(prop);
 		else
-			*(u64 *)dest = val;
+			val = *(u64 *)dest = be64_to_cpup(prop);
 
-		if (efi_enabled(EFI_DBG))
-			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
-				dt_params[i].size * 2, val);
+		pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
+			dt_params[i].size * 2, val);
 	}
-	return 1;
-}
+	return true;
 
-int __init efi_get_fdt_params(struct efi_fdt_params *params)
-{
-	struct param_info info;
-	int ret;
-
-	pr_info("Getting EFI parameters from FDT:\n");
-
-	info.found = 0;
-	info.params = params;
-
-	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
-	if (!info.found)
+not_found:
+	if (i == 0)
 		pr_info("UEFI not found.\n");
-	else if (!ret)
-		pr_err("Can't find '%s' in device tree!\n",
-		       dt_params[info.found].name);
-
-	return ret;
+	else
+		pr_err("Can't find '%s' in device tree!\n", dt_params[i].name);
+	return false;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a866bb1..ede2c21c651b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -915,7 +915,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
-extern int efi_get_fdt_params(struct efi_fdt_params *params);
+extern int efi_get_fdt_params(void *fdt, struct efi_fdt_params *params);
 extern struct efi_memory_map memmap;
 extern struct kobject *efi_kobj;
 
-- 
2.7.0.rc3
