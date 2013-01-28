From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 11/15] Add EFI signature data types
Date: Mon, 28 Jan 2013 11:42:35 -0500
Message-ID: <1359391359-25783-12-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, Dave Howells <dhowells@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Dave Howells <dhowells@redhat.com>

Add the data types that are used for containing hashes, keys and certificates
for cryptographic verification.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/efi.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1ae16b6..de7021d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -388,6 +388,12 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define EFI_FILE_SYSTEM_GUID \
     EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#define EFI_CERT_SHA256_GUID \
+    EFI_GUID(  0xc1c41626, 0x504c, 0x4092, 0xac, 0xa9, 0x41, 0xf9, 0x36, 0x93, 0x43, 0x28 )
+
+#define EFI_CERT_X509_GUID \
+    EFI_GUID(  0xa5c059a1, 0x94e4, 0x4aa7, 0x87, 0xb5, 0xab, 0x15, 0x5c, 0x2b, 0xf0, 0x72 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -523,6 +529,20 @@ typedef struct {
 
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
+typedef struct  {
+	efi_guid_t signature_owner;
+	u8 signature_data[];
+} efi_signature_data_t;
+
+typedef struct {
+	efi_guid_t signature_type;
+	u32 signature_list_size;
+	u32 signature_header_size;
+	u32 signature_size;
+	u8 signature_header[];
+	/* efi_signature_data_t signatures[][] */
+} efi_signature_list_t;
+
 /*
  * All runtime access to EFI goes through this structure:
  */
-- 
1.8.0.2

