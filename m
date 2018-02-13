From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] efi/apple-properties: Delete an error message for a failed
 memory allocation in unmarshal_devices()
Date: Tue, 13 Feb 2018 18:00:26 +0100
Message-ID: <145f8fac-9297-b362-d89f-886632e2507f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 13 Feb 2018 17:52:10 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/firmware/efi/apple-properties.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 9f6bcf173b0e..f5f3159df4d5 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -158,10 +158,8 @@ static int __init unmarshal_devices(struct properties_header *properties)
 
 		entry = kcalloc(dev_header->prop_count + 1, sizeof(*entry),
 				GFP_KERNEL);
-		if (!entry) {
-			dev_err(dev, "cannot allocate properties\n");
+		if (!entry)
 			goto skip_device;
-		}
 
 		unmarshal_key_value_pairs(dev_header, dev, ptr, entry);
 		if (!entry[0].name)
-- 
2.16.1
