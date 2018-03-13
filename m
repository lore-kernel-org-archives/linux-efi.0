From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 3/5] MODSIGN: load blacklist from MOKx
Date: Tue, 13 Mar 2018 18:38:01 +0800
Message-ID: <20180313103803.13388-4-jlee@suse.com>
References: <20180313103803.13388-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313103803.13388-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fs@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Josh Boyer <jwboyer@fedoraproject.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-efi@vger.kernel.org

This patch adds the logic to load the blacklisted hash and
certificates from MOKx which is maintained by shim bootloader.

Cc: David Howells <dhowells@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
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
