From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 04/11] efi/arm64: Clean up efi_get_fdt_params() interface
Date: Mon, 12 Oct 2015 14:56:07 +0100
Message-ID: <1444658174-23378-5-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Mark Salter <msalter@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Leif Lindholm <leif.lindholm@linaro.org>

As we now have a common debug infrastructure between core and arm64 efi,
drop the bit of the interface passing verbose output flags around.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/arm64/kernel/efi.c    | 2 +-
 drivers/firmware/efi/efi.c | 6 ++----
 include/linux/efi.h        | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 612ad5ec1d2e..ab5eeb63e2ca 100644
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
index f0372a022c86..a0a0469e2869 100644
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
index 26ca9e2fd30e..4677d8a1bfd0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -902,7 +902,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
-extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
+extern int efi_get_fdt_params(struct efi_fdt_params *params);
 extern struct efi_memory_map memmap;
 extern struct kobject *efi_kobj;
 
-- 
2.1.0
