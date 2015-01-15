From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] efi: small leak on error
Date: Thu, 15 Jan 2015 12:21:21 +0300
Message-ID: <20150115092121.GA17976@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Dave Young <dyoung@redhat.com>
Cc: linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

The "> 0" here should ">= 0" so we free map_entries[0].

Fixes: 926172d46038 ('efi: Export EFI runtime memory mapping to sysfs')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 018c29a..87b8e3b 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -191,7 +191,7 @@ int __init efi_runtime_map_init(struct kobject *efi_kobj)
 
 	return 0;
 out_add_entry:
-	for (j = i - 1; j > 0; j--) {
+	for (j = i - 1; j >= 0; j--) {
 		entry = *(map_entries + j);
 		kobject_put(&entry->kobj);
 	}
