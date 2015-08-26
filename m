From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 3/3] efi/arm64: clean up efi_get_fdt_params() interface
Date: Wed, 26 Aug 2015 14:24:58 +0100
Message-ID: <1440595498-30630-4-git-send-email-leif.lindholm@linaro.org>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

As we now have a common debug infrastructure between core and arm64 efi,
drop the bit of the interface passing verbose output flags around.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm64/kernel/efi.c    | 2 +-
 drivers/firmware/efi/efi.c | 6 ++----
 include/linux/efi.h        | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 612ad5e..ab5eeb6 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -201,7 +201,7 @@ void __init efi_init(void)
 	struct efi_fdt_params params;
 
 	/* Grab UEFI information placed in FDT by stub */
-	if (!efi_get_fdt_params(&params, efi_enabled(EFI_DBG)))
+	if (!efi_get_fdt_params(&params))
 		return;
 
 	efi_system_table = params.system_table;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 78de0bd..aca6aaf 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -492,7 +492,6 @@ static __initdata struct {
 };
 
 struct param_info {
-	int verbose;
 	int found;
 	void *params;
 };
@@ -523,21 +522,20 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 		else
 			*(u64 *)dest = val;
 
-		if (info->verbose)
+		if (efi_enabled(EFI_DBG))
 			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
 				dt_params[i].size * 2, val);
 	}
 	return 1;
 }
 
-int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
+int __init efi_get_fdt_params(struct efi_fdt_params *params)
 {
 	struct param_info info;
 	int ret;
 
 	pr_info("Getting EFI parameters from FDT:\n");
 
-	info.verbose = verbose;
 	info.found = 0;
 	info.params = params;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 85ef051..b1a5b74 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -901,7 +901,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
-extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
+extern int efi_get_fdt_params(struct efi_fdt_params *params);
 extern struct efi_memory_map memmap;
 extern struct kobject *efi_kobj;
 
-- 
2.1.4
