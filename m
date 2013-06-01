From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] efi, pstore: Cocci spatch "memdup.spatch"
Date: Sat, 01 Jun 2013 11:40:02 +0200
Message-ID: <1370079602.29224.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -79,10 +79,9 @@ static int efi_pstore_read_func(struct e
 			   &entry->var.DataSize, entry->var.Data);
 	size = entry->var.DataSize;
 
-	*cb_data->buf = kmalloc(size, GFP_KERNEL);
+	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
 	if (*cb_data->buf == NULL)
 		return -ENOMEM;
-	memcpy(*cb_data->buf, entry->var.Data, size);
 	return size;
 }
 
