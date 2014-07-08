From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] efi: fdt: Do not report an error during boot if UEFI is not available
Date: Tue,  8 Jul 2014 16:54:18 +0100
Message-ID: <1404834858-10706-1-git-send-email-catalin.marinas@arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <Leif.Lindholm-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently, fdt_find_uefi_params() reports an error if no EFI parameters
are found in the DT. This is however a valid case for non-UEFI kernel
booting. This patch checks changes the error reporting to a
pr_info("UEFI not found") when no EFI parameters are found in the DT.

Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index eff1a2f22f09..dc79346689e6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -346,6 +346,7 @@ static __initdata struct {
 
 struct param_info {
 	int verbose;
+	int found;
 	void *params;
 };
 
@@ -362,16 +363,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
 		return 0;
 
-	pr_info("Getting parameters from FDT:\n");
-
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
-		if (!prop) {
-			pr_err("Can't find %s in device tree!\n",
-			       dt_params[i].name);
+		if (!prop)
 			return 0;
-		}
 		dest = info->params + dt_params[i].offset;
+		info->found++;
 
 		val = of_read_number(prop, len / sizeof(u32));
 
@@ -390,10 +387,21 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
 {
 	struct param_info info;
+	int ret;
+
+	pr_info("Getting EFI parameters from FDT:\n");
 
 	info.verbose = verbose;
+	info.found = 0;
 	info.params = params;
 
-	return of_scan_flat_dt(fdt_find_uefi_params, &info);
+	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
+	if (!info.found)
+		pr_info("UEFI not found.\n");
+	else if (!ret)
+		pr_err("Can't find '%s' in device tree!\n",
+		       dt_params[info.found].name);
+
+	return ret;
 }
 #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
