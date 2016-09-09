From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 10/29] efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
Date: Fri,  9 Sep 2016 16:18:32 +0100
Message-ID: <20160909151851.27577-11-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909151851.27577-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We can use the new efi_mem_reserve() API to mark the ESRT table as
reserved forever and save ourselves the trouble of copying the data
out into a kmalloc buffer.

The added advantage is that now the ESRT driver will work across
kexec reboot.

Tested-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> [kexec/kdump]
Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> [arm]
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/esrt.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 75feb3f5829b..b93cd11f9bcc 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -235,7 +235,7 @@ static struct attribute_group esrt_attr_group = {
 };
 
 /*
- * remap the table, copy it to kmalloced pages, and unmap it.
+ * remap the table, validate it, mark it reserved and unmap it.
  */
 void __init efi_esrt_init(void)
 {
@@ -335,7 +335,7 @@ void __init efi_esrt_init(void)
 
 	end = esrt_data + size;
 	pr_info("Reserving ESRT space from %pa to %pa.\n", &esrt_data, &end);
-	memblock_reserve(esrt_data, esrt_data_size);
+	efi_mem_reserve(esrt_data, esrt_data_size);
 
 	pr_debug("esrt-init: loaded.\n");
 err_memunmap:
@@ -382,28 +382,18 @@ static void cleanup_entry_list(void)
 static int __init esrt_sysfs_init(void)
 {
 	int error;
-	struct efi_system_resource_table __iomem *ioesrt;
 
 	pr_debug("esrt-sysfs: loading.\n");
 	if (!esrt_data || !esrt_data_size)
 		return -ENOSYS;
 
-	ioesrt = ioremap(esrt_data, esrt_data_size);
-	if (!ioesrt) {
+	esrt = ioremap(esrt_data, esrt_data_size);
+	if (!esrt) {
 		pr_err("ioremap(%pa, %zu) failed.\n", &esrt_data,
 		       esrt_data_size);
 		return -ENOMEM;
 	}
 
-	esrt = kmalloc(esrt_data_size, GFP_KERNEL);
-	if (!esrt) {
-		pr_err("kmalloc failed. (wanted %zu bytes)\n", esrt_data_size);
-		iounmap(ioesrt);
-		return -ENOMEM;
-	}
-
-	memcpy_fromio(esrt, ioesrt, esrt_data_size);
-
 	esrt_kobj = kobject_create_and_add("esrt", efi_kobj);
 	if (!esrt_kobj) {
 		pr_err("Firmware table registration failed.\n");
@@ -429,8 +419,6 @@ static int __init esrt_sysfs_init(void)
 	if (error)
 		goto err_cleanup_list;
 
-	memblock_remove(esrt_data, esrt_data_size);
-
 	pr_debug("esrt-sysfs: loaded.\n");
 
 	return 0;
-- 
2.9.3
