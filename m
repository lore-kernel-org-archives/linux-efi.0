From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 10/11] efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
Date: Thu, 23 Jun 2016 12:34:49 +0100
Message-ID: <1466681690-5850-11-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, Borislav Petkov <bp@alien8.de>, Mark Rutland <mark.rutland@arm.com>, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

We can use the new efi_mem_reserve() API to mark the ESRT table as
reserved forever and save ourselves the trouble of copying the data
out into a kmalloc buffer.

The added advantage is that now the ESRT driver will work across
kexec reboot.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
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
2.7.3
