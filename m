From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] EFI: use nr_tables param directly in efi_config_init
Date: Thu, 12 Sep 2013 16:45:28 +0800
Message-ID: <20130912084528.GA13448@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

efi_config_init has the parameter nr_tables. Just use it instead of
dereference efi.systab->nr_tables.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -599,7 +599,7 @@ static int __init efi_config_init(u64 ta
 
 	tablep = config_tables;
 	pr_info("");
-	for (i = 0; i < efi.systab->nr_tables; i++) {
+	for (i = 0; i < nr_tables; i++) {
 		efi_guid_t guid;
 		unsigned long table;
 
@@ -612,8 +612,7 @@ static int __init efi_config_init(u64 ta
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
-					      efi.systab->nr_tables * sz);
+				early_iounmap(config_tables, nr_tables * sz);
 				return -EINVAL;
 			}
 #endif
@@ -648,7 +647,7 @@ static int __init efi_config_init(u64 ta
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_iounmap(config_tables, nr_tables * sz);
 	return 0;
 }
 
