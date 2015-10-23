From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] efi: use correct type for struct efi_memory_map::phys_map
Date: Fri, 23 Oct 2015 11:48:16 +0200
Message-ID: <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
References: <20151023085011.GB21631@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151023085011.GB21631@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, izumi.taku@jp.fujitsu.com, matt.fleming@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

We have been getting away with using a void* for the physical
address of the UEFI memory map, since, even on 32-bit platforms
with 64-bit physical addresses, no truncation takes place if the
memory map has been allocated by the firmware (which only uses
1:1 virtually addressable memory), which is usually the case.

However, commit 0f96a99dab36 ("efi: Add "efi_fake_mem" boot option")
adds code that clones and modifies the UEFI memory map, and the
clone may live above 4 GB on 32-bit platforms. This means our use
of void* for struct efi_memory_map::phys_map has graduated from
'incorrect but working' to 'incorrect and broken', and we need to
fix it.

So redefine struct efi_memory_map::phys_map as phys_addr_t, and
get rid of a bunch of casts that are now unneeded.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/efi.c     | 4 ++--
 arch/x86/platform/efi/efi.c | 4 ++--
 drivers/firmware/efi/efi.c  | 8 ++++----
 include/linux/efi.h         | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 4b7df346e388..61eb1d17586a 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -208,7 +208,7 @@ void __init efi_init(void)
 
 	memblock_reserve(params.mmap & PAGE_MASK,
 			 PAGE_ALIGN(params.mmap_size + (params.mmap & ~PAGE_MASK)));
-	memmap.phys_map = (void *)params.mmap;
+	memmap.phys_map = params.mmap;
 	memmap.map = early_memremap(params.mmap, params.mmap_size);
 	memmap.map_end = memmap.map + params.mmap_size;
 	memmap.desc_size = params.desc_size;
@@ -282,7 +282,7 @@ static int __init arm64_enable_runtime_services(void)
 	pr_info("Remapping and enabling EFI services.\n");
 
 	mapsize = memmap.map_end - memmap.map;
-	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+	memmap.map = (__force void *)ioremap_cache(memmap.phys_map,
 						   mapsize);
 	if (!memmap.map) {
 		pr_err("Failed to remap EFI memory map\n");
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3e1d09e885c0..ad285404ea7f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -194,7 +194,7 @@ static void __init do_add_efi_memmap(void)
 int __init efi_memblock_x86_reserve_range(void)
 {
 	struct efi_info *e = &boot_params.efi_info;
-	unsigned long pmap;
+	phys_addr_t pmap;
 
 	if (efi_enabled(EFI_PARAVIRT))
 		return 0;
@@ -209,7 +209,7 @@ int __init efi_memblock_x86_reserve_range(void)
 #else
 	pmap = (e->efi_memmap |	((__u64)e->efi_memmap_hi << 32));
 #endif
-	memmap.phys_map		= (void *)pmap;
+	memmap.phys_map		= pmap;
 	memmap.nr_map		= e->efi_memmap_size /
 				  e->efi_memdesc_size;
 	memmap.desc_size	= e->efi_memdesc_size;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 31fc864eb037..027ca212179f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -254,7 +254,7 @@ subsys_initcall(efisubsys_init);
 int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 {
 	struct efi_memory_map *map = efi.memmap;
-	void *p, *e;
+	phys_addr_t p, e;
 
 	if (!efi_enabled(EFI_MEMMAP)) {
 		pr_err_once("EFI_MEMMAP is not enabled.\n");
@@ -286,10 +286,10 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 		 * So just always get our own virtual map on the CPU.
 		 *
 		 */
-		md = early_memremap((phys_addr_t)p, sizeof (*md));
+		md = early_memremap(p, sizeof (*md));
 		if (!md) {
-			pr_err_once("early_memremap(%p, %zu) failed.\n",
-				    p, sizeof (*md));
+			pr_err_once("early_memremap(%pa, %zu) failed.\n",
+				    &p, sizeof (*md));
 			return -ENOMEM;
 		}
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4d01c1033fce..569b5a866bb1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -680,7 +680,7 @@ typedef struct {
 } efi_system_table_t;
 
 struct efi_memory_map {
-	void *phys_map;
+	phys_addr_t phys_map;
 	void *map;
 	void *map_end;
 	int nr_map;
-- 
2.1.4
