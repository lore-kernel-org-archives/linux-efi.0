From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/9] efi: Add EFI signature data types
Date: Wed, 16 Nov 2016 18:11:28 +0000
Message-ID: <147931988803.16460.18213104388363289832.stgit@warthog.procyon.org.uk>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Dave Howells <dhowells@redhat.com>

Add the data types that are used for containing hashes, keys and
certificates for cryptographic verification along with their corresponding
type GUIDs.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/efi.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index acfdea8381de..6fb50bafedc7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -594,6 +594,9 @@ void efi_native_runtime_setup(void);
 
 #define EFI_IMAGE_SECURITY_DATABASE_GUID	EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596, 0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
 #define EFI_SHIM_LOCK_GUID			EFI_GUID(0x605dab50, 0xe046, 0x4300, 0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
+#define EFI_CERT_SHA256_GUID			EFI_GUID(0xc1c41626, 0x504c, 0x4092, 0xac, 0xa9, 0x41, 0xf9, 0x36, 0x93, 0x43, 0x28 )
+#define EFI_CERT_X509_GUID			EFI_GUID(0xa5c059a1, 0x94e4, 0x4aa7, 0x87, 0xb5, 0xab, 0x15, 0x5c, 0x2b, 0xf0, 0x72 )
+#define EFI_CERT_X509_SHA256_GUID		EFI_GUID(0x3bd2a492, 0x96c0, 0x4079, 0xb4, 0x20, 0xfc, 0xf9, 0x8e, 0xf1, 0x03, 0xed );
 
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
@@ -853,6 +856,27 @@ typedef struct {
 	efi_memory_desc_t entry[0];
 } efi_memory_attributes_table_t;
 
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
+typedef u8 efi_sha256_hash_t[32];
+
+typedef struct {
+	efi_sha256_hash_t to_be_signed_hash;
+	efi_time_t time_of_revocation;
+} efi_cert_x509_sha256_t;
+
 /*
  * All runtime access to EFI goes through this structure:
  */

