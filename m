From: David Howells <dhowells@redhat.com>
Subject: [PATCH 9/9] MODSIGN: Allow the "db" UEFI variable to be suppressed
Date: Wed, 16 Nov 2016 18:11:49 +0000
Message-ID: <147931990959.16460.3038875071067540418.stgit@warthog.procyon.org.uk>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

If a user tells shim to not use the certs/hashes in the UEFI db variable
for verification purposes, shim will set a UEFI variable called
MokIgnoreDB.  Have the uefi import code look for this and ignore the db
variable if it is found.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 certs/load_uefi.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/certs/load_uefi.c b/certs/load_uefi.c
index b44e464c3ff4..3d8845986019 100644
--- a/certs/load_uefi.c
+++ b/certs/load_uefi.c
@@ -13,6 +13,26 @@ static __initdata efi_guid_t efi_cert_x509_sha256_guid = EFI_CERT_X509_SHA256_GU
 static __initdata efi_guid_t efi_cert_sha256_guid = EFI_CERT_SHA256_GUID;
 
 /*
+ * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
+ * it does.
+ *
+ * This UEFI variable is set by the shim if a user tells the shim to not use
+ * the certs/hashes in the UEFI db variable for verification purposes.  If it
+ * is set, we should ignore the db variable also and the true return indicates
+ * this.
+ */
+static __init bool uefi_check_ignore_db(void)
+{
+	efi_status_t status;
+	unsigned int db = 0;
+	unsigned long size = sizeof(db);
+	efi_guid_t guid = EFI_SHIM_LOCK_GUID;
+
+	status = efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
+	return status == EFI_SUCCESS;
+}
+
+/*
  * Get a certificate list blob from the named EFI variable.
  */
 static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
@@ -113,7 +133,9 @@ static __init efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_ty
 }
 
 /*
- * Load the certs contained in the UEFI databases
+ * Load the certs contained in the UEFI databases into the secondary trusted
+ * keyring and the UEFI blacklisted X.509 cert SHA256 hashes into the blacklist
+ * keyring.
  */
 static int __init load_uefi_certs(void)
 {
@@ -129,15 +151,17 @@ static int __init load_uefi_certs(void)
 	/* Get db, MokListRT, and dbx.  They might not exist, so it isn't
 	 * an error if we can't get them.
 	 */
-	db = get_cert_list(L"db", &secure_var, &dbsize);
-	if (!db) {
-		pr_err("MODSIGN: Couldn't get UEFI db list\n");
-	} else {
-		rc = parse_efi_signature_list("UEFI:db",
-					      db, dbsize, get_handler_for_db);
-		if (rc)
-			pr_err("Couldn't parse db signatures: %d\n", rc);
-		kfree(db);
+	if (!uefi_check_ignore_db()) {
+		db = get_cert_list(L"db", &secure_var, &dbsize);
+		if (!db) {
+			pr_err("MODSIGN: Couldn't get UEFI db list\n");
+		} else {
+			rc = parse_efi_signature_list("UEFI:db",
+						      db, dbsize, get_handler_for_db);
+			if (rc)
+				pr_err("Couldn't parse db signatures: %d\n", rc);
+			kfree(db);
+		}
 	}
 
 	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);

