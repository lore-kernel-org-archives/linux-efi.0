From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 2/2 v2] efi: print appropriate status message when loading certificates
Date: Sun, 24 Mar 2019 08:26:21 +0800
Message-ID: <20190324002621.3551-2-jlee@suse.com>
References: <20190324002621.3551-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190324002621.3551-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Nayna Jain <nayna@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

When loading certificates list from UEFI variable, the original error
message direct shows the efi status code from UEFI firmware. It looks
ugly:

[    2.335031] Couldn't get size: 0x800000000000000e
[    2.335032] Couldn't get UEFI MokListRT
[    2.339985] Couldn't get size: 0x800000000000000e
[    2.339987] Couldn't get UEFI dbx list

So, this patch shows the status string instead of status code.

On the other hand, the "Couldn't get UEFI" message doesn't need
to be exposed when db/dbx/mok variable do not exist. So, this
patch set the message level to debug.

v2.
Setting the MODSIGN messagse level to debug.

Link: https://forums.opensuse.org/showthread.php/535324-MODSIGN-Couldn-t-get-UEFI-db-list?p=2897516#post2897516
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn" <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 security/integrity/platform_certs/load_uefi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index 81b19c52832b..e65244b31f04 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -48,7 +48,9 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
 
 	status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
 	if (status != EFI_BUFFER_TOO_SMALL) {
-		pr_err("Couldn't get size: 0x%lx\n", status);
+		if (status != EFI_NOT_FOUND)
+			pr_err("Couldn't get size: %s\n",
+				efi_status_to_str(status));
 		return NULL;
 	}
 
@@ -59,7 +61,8 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
 	status = efi.get_variable(name, guid, NULL, &lsize, db);
 	if (status != EFI_SUCCESS) {
 		kfree(db);
-		pr_err("Error reading db var: 0x%lx\n", status);
+		pr_err("Error reading db var: %s\n",
+			efi_status_to_str(status));
 		return NULL;
 	}
 
@@ -155,7 +158,7 @@ static int __init load_uefi_certs(void)
 	if (!uefi_check_ignore_db()) {
 		db = get_cert_list(L"db", &secure_var, &dbsize);
 		if (!db) {
-			pr_err("MODSIGN: Couldn't get UEFI db list\n");
+			pr_debug("MODSIGN: Couldn't get UEFI db list\n");
 		} else {
 			rc = parse_efi_signature_list("UEFI:db",
 					db, dbsize, get_handler_for_db);
@@ -168,7 +171,7 @@ static int __init load_uefi_certs(void)
 
 	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
 	if (!mok) {
-		pr_info("Couldn't get UEFI MokListRT\n");
+		pr_debug("Couldn't get UEFI MokListRT\n");
 	} else {
 		rc = parse_efi_signature_list("UEFI:MokListRT",
 					      mok, moksize, get_handler_for_db);
@@ -179,7 +182,7 @@ static int __init load_uefi_certs(void)
 
 	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
 	if (!dbx) {
-		pr_info("Couldn't get UEFI dbx list\n");
+		pr_debug("Couldn't get UEFI dbx list\n");
 	} else {
 		rc = parse_efi_signature_list("UEFI:dbx",
 					      dbx, dbxsize,
-- 
2.16.4
