From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 5/5] MODSIGN: check the attributes of db and mok
Date: Tue, 13 Mar 2018 18:38:03 +0800
Message-ID: <20180313103803.13388-6-jlee@suse.com>
References: <20180313103803.13388-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313103803.13388-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fs@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Josh Boyer <jwboyer@fedoraproject.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-efi@vger.kernel.org

That's better for checking the attributes of db and mok variables
before loading certificates to kernel keyring.

For db and dbx, both of them are authenticated variables. Which
means that they can only be modified by manufacturer's key. So
the kernel should checks EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS
attribute before we trust it.

For mok-rt and mokx-rt, both of them are created by shim boot loader
to forward the mok/mokx content to runtime. They must be runtime-volatile
variables. So kernel should checks that the attributes map did not set
EFI_VARIABLE_NON_VOLATILE bit before we trust it.

Cc: David Howells <dhowells@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 certs/load_uefi.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/certs/load_uefi.c b/certs/load_uefi.c
index dc66a79..52526bd 100644
--- a/certs/load_uefi.c
+++ b/certs/load_uefi.c
@@ -33,7 +33,8 @@ static __init bool uefi_check_ignore_db(void)
 	return status == EFI_SUCCESS;
 }
 
-static __init void print_get_fail(efi_char16_t *char16_str, efi_status_t status)
+static __init void print_get_fail(efi_char16_t *char16_str, efi_status_t status,
+				  u32 attr)
 {
 	char *utf8_str;
 	unsigned long utf8_size;
@@ -46,8 +47,8 @@ static __init void print_get_fail(efi_char16_t *char16_str, efi_status_t status)
 		return;
 	ucs2_as_utf8(utf8_str, char16_str, utf8_size);
 
-	pr_info("MODSIGN: Couldn't get UEFI %s: %s\n",
-		utf8_str, efi_status_to_str(status));
+	pr_info("MODSIGN: Couldn't get UEFI %s: %s    Attributes: 0x%016x\n",
+		utf8_str, efi_status_to_str(status), attr);
 	kfree(utf8_str);
 }
 
@@ -55,12 +56,13 @@ static __init void print_get_fail(efi_char16_t *char16_str, efi_status_t status)
  * Get a certificate list blob from the named EFI variable.
  */
 static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
-				  unsigned long *size)
+				  unsigned long *size, u32 pos_attr, u32 neg_attr)
 {
 	efi_status_t status;
 	unsigned long lsize = 4;
 	unsigned long tmpdb[4];
 	void *db;
+	u32 attr = 0;
 
 	status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
 	if (status != EFI_BUFFER_TOO_SMALL) {
@@ -75,17 +77,22 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
 		goto err;
 	}
 
-	status = efi.get_variable(name, guid, NULL, &lsize, db);
+	status = efi.get_variable(name, guid, &attr, &lsize, db);
 	if (status != EFI_SUCCESS) {
-		kfree(db);
 		pr_err("Error reading db var: 0x%lx\n", status);
-		goto err;
+		goto free;
 	}
+	/* must have positive attributes and no negative attributes */
+	if ((pos_attr && !(attr & pos_attr)) ||
+	    (neg_attr && (attr & neg_attr)))
+		goto free;
 
 	*size = lsize;
 	return db;
+free:
+	kfree(db);
 err:
-	print_get_fail(name, status);
+	print_get_fail(name, status, attr);
 	return NULL;
 }
 
@@ -175,7 +182,8 @@ static int __init load_uefi_certs(void)
 	 * an error if we can't get them.
 	 */
 	if (!uefi_check_ignore_db()) {
-		db = get_cert_list(L"db", &secure_var, &dbsize);
+		db = get_cert_list(L"db", &secure_var, &dbsize,
+			EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS, 0);
 		if (db) {
 			rc = parse_efi_signature_list("UEFI:db",
 						      db, dbsize, get_handler_for_db);
@@ -185,7 +193,8 @@ static int __init load_uefi_certs(void)
 		}
 	}
 
-	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
+	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize,
+		EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS, 0);
 	if (dbx) {
 		rc = parse_efi_signature_list("UEFI:dbx",
 					      dbx, dbxsize,
@@ -199,7 +208,8 @@ static int __init load_uefi_certs(void)
 	if (!efi_enabled(EFI_SECURE_BOOT))
 		return 0;
 
-	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
+	mok = get_cert_list(L"MokListRT", &mok_var, &moksize,
+				0, EFI_VARIABLE_NON_VOLATILE);
 	if (mok) {
 		rc = parse_efi_signature_list("UEFI:MokListRT",
 					      mok, moksize, get_handler_for_db);
@@ -208,7 +218,8 @@ static int __init load_uefi_certs(void)
 		kfree(mok);
 	}
 
-	mokx = get_cert_list(L"MokListXRT", &mok_var, &mokxsize);
+	mokx = get_cert_list(L"MokListXRT", &mok_var, &mokxsize,
+				0, EFI_VARIABLE_NON_VOLATILE);
 	if (mokx) {
 		rc = parse_efi_signature_list("UEFI:mokx",
 					      mokx, mokxsize,
-- 
2.10.2
