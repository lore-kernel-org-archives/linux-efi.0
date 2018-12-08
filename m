From: Nayna Jain <nayna@linux.ibm.com>
Subject: [PATCH v2 2/7] integrity: Load certs to the platform keyring
Date: Sun,  9 Dec 2018 01:57:00 +0530
Message-ID: <20181208202705.18673-3-nayna@linux.ibm.com>
References: <20181208202705.18673-1-nayna@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181208202705.18673-1-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

The patch refactors integrity_load_x509(), making it a wrapper for a new
function named integrity_add_key(). This patch also defines a new
function named integrity_load_cert() for loading the platform keys.

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
---
 security/integrity/digsig.c                        | 71 ++++++++++++++--------
 security/integrity/integrity.h                     | 20 ++++++
 .../integrity/platform_certs/platform_keyring.c    | 23 +++++++
 3 files changed, 90 insertions(+), 24 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index b5b180ff1434..4ba167255225 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -82,8 +82,7 @@ static int __integrity_init_keyring(const unsigned int id, key_perm_t perm,
 
 	keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
 				    KGIDT_INIT(0), cred, perm,
-				    KEY_ALLOC_NOT_IN_QUOTA,
-				    restriction, NULL);
+				    KEY_ALLOC_NOT_IN_QUOTA, restriction, NULL);
 	if (IS_ERR(keyring[id])) {
 		err = PTR_ERR(keyring[id]);
 		pr_info("Can't allocate %s keyring (%d)\n",
@@ -124,16 +123,38 @@ int __init integrity_init_keyring(const unsigned int id)
 	return err;
 }
 
-int __init integrity_load_x509(const unsigned int id, const char *path)
+int __init integrity_add_key(const unsigned int id, const void *data,
+			     off_t size, key_perm_t perm)
 {
 	key_ref_t key;
-	void *data;
-	loff_t size;
-	int rc;
+	int rc = 0;
 
 	if (!keyring[id])
 		return -EINVAL;
 
+	key = key_create_or_update(make_key_ref(keyring[id], 1), "asymmetric",
+				   NULL, data, size, perm,
+				   KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(key)) {
+		rc = PTR_ERR(key);
+		pr_err("Problem loading X.509 certificate %d\n", rc);
+	} else {
+		pr_notice("Loaded X.509 cert '%s'\n",
+			  key_ref_to_ptr(key)->description);
+		key_ref_put(key);
+	}
+
+	return rc;
+
+}
+
+int __init integrity_load_x509(const unsigned int id, const char *path)
+{
+	void *data;
+	loff_t size;
+	int rc;
+	key_perm_t perm;
+
 	rc = kernel_read_file_from_path(path, &data, &size, 0,
 					READING_X509_CERTIFICATE);
 	if (rc < 0) {
@@ -141,23 +162,25 @@ int __init integrity_load_x509(const unsigned int id, const char *path)
 		return rc;
 	}
 
-	key = key_create_or_update(make_key_ref(keyring[id], 1),
-				   "asymmetric",
-				   NULL,
-				   data,
-				   size,
-				   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
-				    KEY_USR_VIEW | KEY_USR_READ),
-				   KEY_ALLOC_NOT_IN_QUOTA);
-	if (IS_ERR(key)) {
-		rc = PTR_ERR(key);
-		pr_err("Problem loading X.509 certificate (%d): %s\n",
-		       rc, path);
-	} else {
-		pr_notice("Loaded X.509 cert '%s': %s\n",
-			  key_ref_to_ptr(key)->description, path);
-		key_ref_put(key);
-	}
+	perm = (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW | KEY_USR_READ;
+
+	pr_info("Loading X.509 certificate: %s\n", path);
+	rc = integrity_add_key(id, (const void *)data, size, perm);
+
 	vfree(data);
-	return 0;
+	return rc;
+}
+
+int __init integrity_load_cert(const unsigned int id, const char *source,
+			       const void *data, size_t len, key_perm_t perm)
+{
+	int rc;
+
+	if (!data)
+		return -EINVAL;
+
+	pr_info("Loading X.509 certificate: %s\n", source);
+	rc = integrity_add_key(id, data, len, perm);
+
+	return rc;
 }
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index c2332a44799e..3517d2852a07 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -154,6 +154,8 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 
 int __init integrity_init_keyring(const unsigned int id);
 int __init integrity_load_x509(const unsigned int id, const char *path);
+int __init integrity_load_cert(const unsigned int id, const char *source,
+			       const void *data, size_t len, key_perm_t perm);
 #else
 
 static inline int integrity_digsig_verify(const unsigned int id,
@@ -167,6 +169,14 @@ static inline int integrity_init_keyring(const unsigned int id)
 {
 	return 0;
 }
+
+static inline int __init integrity_load_cert(const unsigned int id,
+					     const char *source,
+					     const void *data, size_t len,
+					     key_perm_t perm)
+{
+	return 0;
+}
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
@@ -223,3 +233,13 @@ integrity_audit_log_start(struct audit_context *ctx, gfp_t gfp_mask, int type)
 }
 
 #endif
+
+#ifdef CONFIG_INTEGRITY_PLATFORM_KEYRING
+void __init add_to_platform_keyring(const char *source, const void *data,
+				    size_t len);
+#else
+static inline void __init add_to_platform_keyring(const char *source,
+						  const void *data, size_t len)
+{
+}
+#endif
diff --git a/security/integrity/platform_certs/platform_keyring.c b/security/integrity/platform_certs/platform_keyring.c
index dfc206bbe2ff..dc49b3b02697 100644
--- a/security/integrity/platform_certs/platform_keyring.c
+++ b/security/integrity/platform_certs/platform_keyring.c
@@ -18,6 +18,29 @@
 #include <linux/slab.h>
 #include "../integrity.h"
 
+/**
+ * add_to_platform_keyring - Add to platform keyring without validation.
+ * @source: Source of key
+ * @data: The blob holding the key
+ * @len: The length of the data blob
+ *
+ * Add a key to the platform keyring without checking its trust chain.  This
+ * is available only during kernel initialisation.
+ */
+void __init add_to_platform_keyring(const char *source, const void *data,
+				    size_t len)
+{
+	key_perm_t perm;
+	int rc;
+
+	perm = (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW;
+
+	rc = integrity_load_cert(INTEGRITY_KEYRING_PLATFORM, source, data, len,
+				 perm);
+	if (rc)
+		pr_info("Error adding keys to platform keyring %s\n", source);
+}
+
 /*
  * Create the trusted keyrings.
  */
-- 
2.13.6
