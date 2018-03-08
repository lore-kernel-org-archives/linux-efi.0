From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/12] efi/apple-properties: Device core takes care of empty properties
Date: Thu,  8 Mar 2018 08:00:10 +0000
Message-ID: <20180308080020.22828-3-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

There is no need to artificially supply a property length and fake data
if property has type of boolean.

Remove redundant piece of data and code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/apple-properties.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 9f6bcf173b0e..b9602e0d7b50 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -52,8 +52,6 @@ struct properties_header {
 	struct dev_header dev_header[0];
 };
 
-static u8 one __initdata = 1;
-
 static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
 					     struct device *dev, void *ptr,
 					     struct property_entry entry[])
@@ -95,14 +93,9 @@ static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
 			     key_len - sizeof(key_len));
 
 		entry[i].name = key;
-		entry[i].is_array = true;
 		entry[i].length = val_len - sizeof(val_len);
+		entry[i].is_array = !!entry[i].length;
 		entry[i].pointer.raw_data = ptr + key_len + sizeof(val_len);
-		if (!entry[i].length) {
-			/* driver core doesn't accept empty properties */
-			entry[i].length = 1;
-			entry[i].pointer.raw_data = &one;
-		}
 
 		if (dump_properties) {
 			dev_info(dev, "property: %s\n", entry[i].name);
-- 
2.15.1
