From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 11/12] efi/apple-properties: Use memremap() instead of ioremap()
Date: Thu,  8 Mar 2018 08:00:19 +0000
Message-ID: <20180308080020.22828-12-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

The memory we are accessing through virtual address has no IO side
effects. Moreover, for IO memory we have to use special accessors,
which we don't use.

Due to above, convert the driver to use memremap() instead of ioremap().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/apple-properties.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index b9602e0d7b50..adaa9a3714b9 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -19,6 +19,7 @@
 
 #include <linux/bootmem.h>
 #include <linux/efi.h>
+#include <linux/io.h>
 #include <linux/platform_data/x86/apple.h>
 #include <linux/property.h>
 #include <linux/slab.h>
@@ -189,7 +190,7 @@ static int __init map_properties(void)
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = ioremap(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
 		if (!data) {
 			pr_err("cannot map setup_data header\n");
 			return -ENOMEM;
@@ -197,14 +198,14 @@ static int __init map_properties(void)
 
 		if (data->type != SETUP_APPLE_PROPERTIES) {
 			pa_data = data->next;
-			iounmap(data);
+			memunmap(data);
 			continue;
 		}
 
 		data_len = data->len;
-		iounmap(data);
+		memunmap(data);
 
-		data = ioremap(pa_data, sizeof(*data) + data_len);
+		data = memremap(pa_data, sizeof(*data) + data_len, MEMREMAP_WB);
 		if (!data) {
 			pr_err("cannot map setup_data payload\n");
 			return -ENOMEM;
@@ -229,7 +230,7 @@ static int __init map_properties(void)
 		 * to avoid breaking the chain of ->next pointers.
 		 */
 		data->len = 0;
-		iounmap(data);
+		memunmap(data);
 		free_bootmem_late(pa_data + sizeof(*data), data_len);
 
 		return ret;
-- 
2.15.1
