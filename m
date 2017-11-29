From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] MODSIGN: load blacklist from MOKx
Date: Wed, 29 Nov 2017 22:11:38 +0800
Message-ID: <20171129141139.20088-4-jlee@suse.com>
References: <20171129141139.20088-1-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171129141139.20088-1-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch adds the logic to load the blacklisted hash and
certificates from MOKx which is maintained by shim bootloader.

Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Signed-off-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
---
 certs/load_uefi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/certs/load_uefi.c b/certs/load_uefi.c
index f2f372b..dc66a79 100644
--- a/certs/load_uefi.c
+++ b/certs/load_uefi.c
@@ -164,8 +164,8 @@ static int __init load_uefi_certs(void)
 {
 	efi_guid_t secure_var = EFI_IMAGE_SECURITY_DATABASE_GUID;
 	efi_guid_t mok_var = EFI_SHIM_LOCK_GUID;
-	void *db = NULL, *dbx = NULL, *mok = NULL;
-	unsigned long dbsize = 0, dbxsize = 0, moksize = 0;
+	void *db = NULL, *dbx = NULL, *mok = NULL, *mokx = NULL;
+	unsigned long dbsize = 0, dbxsize = 0, moksize = 0, mokxsize = 0;
 	int rc = 0;
 
 	if (!efi.get_variable)
@@ -195,7 +195,7 @@ static int __init load_uefi_certs(void)
 		kfree(dbx);
 	}
 
-	/* the MOK can not be trusted when secure boot is disabled */
+	/* the MOK and MOKx can not be trusted when secure boot is disabled */
 	if (!efi_enabled(EFI_SECURE_BOOT))
 		return 0;
 
@@ -208,6 +208,16 @@ static int __init load_uefi_certs(void)
 		kfree(mok);
 	}
 
+	mokx = get_cert_list(L"MokListXRT", &mok_var, &mokxsize);
+	if (mokx) {
+		rc = parse_efi_signature_list("UEFI:mokx",
+					      mokx, mokxsize,
+					      get_handler_for_dbx);
+		if (rc)
+			pr_err("Couldn't parse MokListXRT signatures: %d\n", rc);
+		kfree(mokx);
+	}
+
 	return rc;
 }
 late_initcall(load_uefi_certs);
-- 
2.10.2
