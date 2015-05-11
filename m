From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/8] of/fdt: split off FDT self reservation from memreserve processing
Date: Mon, 11 May 2015 08:41:53 +0200
Message-ID: <1431326520-17331-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1431326520-17331-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431326520-17331-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This splits off the reservation of the memory occupied by the FDT
binary itself from the processing of the memory reservations it
contains. This is necessary because the physical address of the FDT,
which is needed to perform the reservation, may not be known to the
FDT driver core, i.e., it may be mapped outside the linear direct
mapping, in which case __pa() returns a bogus value.

Cc: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/mm/init.c         |  1 +
 arch/arm64/mm/init.c       |  1 +
 arch/powerpc/kernel/prom.c |  1 +
 drivers/of/fdt.c           | 19 ++++++++++++++-----
 include/linux/of_fdt.h     |  2 ++
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index be92fa0f2f35..8a63b4cdc0f2 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -268,6 +268,7 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 	if (mdesc->reserve)
 		mdesc->reserve();
 
+	early_init_fdt_reserve_self();
 	early_init_fdt_scan_reserved_mem();
 
 	/* reserve memory for DMA contiguous allocations */
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 597831bdddf3..89a05f467ffb 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -170,6 +170,7 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
 
+	early_init_fdt_reserve_self();
 	early_init_fdt_scan_reserved_mem();
 
 	/* 4GB maximum for 32-bit only capable devices */
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 308c5e15676b..51ea36f79307 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -573,6 +573,7 @@ static void __init early_reserve_mem_dt(void)
 	int len;
 	const __be32 *prop;
 
+	early_init_fdt_reserve_self();
 	early_init_fdt_scan_reserved_mem();
 
 	dt_root = of_get_flat_dt_root();
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index cde35c5d0191..f2dd23a32267 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -580,11 +580,6 @@ void __init early_init_fdt_scan_reserved_mem(void)
 	if (!initial_boot_params)
 		return;
 
-	/* Reserve the dtb region */
-	early_init_dt_reserve_memory_arch(__pa(initial_boot_params),
-					  fdt_totalsize(initial_boot_params),
-					  0);
-
 	/* Process header /memreserve/ fields */
 	for (n = 0; ; n++) {
 		fdt_get_mem_rsv(initial_boot_params, n, &base, &size);
@@ -598,6 +593,20 @@ void __init early_init_fdt_scan_reserved_mem(void)
 }
 
 /**
+ * early_init_fdt_reserve_self() - reserve the memory used by the FDT blob
+ */
+void __init early_init_fdt_reserve_self(void)
+{
+	if (!initial_boot_params)
+		return;
+
+	/* Reserve the dtb region */
+	early_init_dt_reserve_memory_arch(__pa(initial_boot_params),
+					  fdt_totalsize(initial_boot_params),
+					  0);
+}
+
+/**
  * of_scan_flat_dt - scan flattened tree blob and call callback on each.
  * @it: callback function
  * @data: context data pointer
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 587ee507965d..fd627a58068f 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -64,6 +64,7 @@ extern int early_init_dt_scan_chosen(unsigned long node, const char *uname,
 extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_fdt_scan_reserved_mem(void);
+extern void early_init_fdt_reserve_self(void);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
 					     bool no_map);
@@ -91,6 +92,7 @@ extern u64 fdt_translate_address(const void *blob, int node_offset);
 extern void of_fdt_limit_memory(int limit);
 #else /* CONFIG_OF_FLATTREE */
 static inline void early_init_fdt_scan_reserved_mem(void) {}
+static inline void early_init_fdt_reserve_self(void) {}
 static inline const char *of_flat_dt_get_machine_name(void) { return NULL; }
 static inline void unflatten_device_tree(void) {}
 static inline void unflatten_and_copy_device_tree(void) {}
-- 
1.9.1
