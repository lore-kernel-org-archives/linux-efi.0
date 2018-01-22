From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1] efi/apple-properties: Device core takes care of empty properties
Date: Mon, 22 Jan 2018 16:17:09 +0200
Message-ID: <20180122141709.41898-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There is no need to artificially supply a property length and fake data
if property has type of boolean.

Remove redundant piece of data and code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
