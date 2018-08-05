From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 5/6] key: add EFI secure key as a master key type
Date: Sun,  5 Aug 2018 11:21:18 +0800
Message-ID: <20180805032119.20485-6-jlee@suse.com>
References: <20180805032119.20485-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180805032119.20485-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

EFI secure key can be a new master key type that it's used for
generate encrypted key.

Compared with trusted key or user key, the advantage of using
EFI master key is that it doesn't need TPM or password from user
space.

As other master key types, keyctl can be used to create new encrypted
key by EFI secure key. Using the "efi:" prefix string with master
key name:

e.g. keyctl add encrypted evm-key "new efi:kmk-efi 32" @u

Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Ryan Chen <yu.chen.surf@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 drivers/firmware/efi/efi-secure-key.c    | 21 +++++++++++++++++++++
 include/keys/efi-type.h                  |  7 +++++++
 security/keys/encrypted-keys/encrypted.c | 10 ++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/firmware/efi/efi-secure-key.c b/drivers/firmware/efi/efi-secure-key.c
index 5e72a8c9e13e..aa422ee87f70 100644
--- a/drivers/firmware/efi/efi-secure-key.c
+++ b/drivers/firmware/efi/efi-secure-key.c
@@ -676,6 +676,27 @@ struct key_type key_type_efi = {
 };
 EXPORT_SYMBOL_GPL(key_type_efi);
 
+/*
+ * request_efi_key - request the efi key
+ */
+struct key *request_efi_key(const char *master_desc,
+			    const u8 **master_key, size_t *master_keylen)
+{
+	struct efi_key_payload *epayload;
+	struct key *ekey;
+
+	ekey = request_key(&key_type_efi, master_desc, NULL);
+	if (IS_ERR(ekey))
+		goto error;
+
+	down_read(&ekey->sem);
+	epayload = ekey->payload.data[0];
+	*master_key = epayload->key;
+	*master_keylen = epayload->key_len;
+error:
+	return ekey;
+}
+
 static int __init init_efi_secure_key(void)
 {
 	int ret;
diff --git a/include/keys/efi-type.h b/include/keys/efi-type.h
index 57524b22d42f..bbe649f3eec0 100644
--- a/include/keys/efi-type.h
+++ b/include/keys/efi-type.h
@@ -39,12 +39,19 @@ extern struct key_type key_type_efi;
 #if defined(CONFIG_EFI_SECURE_KEY)
 extern long efi_read_blob(const struct key *key, char __user *buffer,
 			  char *kbuffer, size_t buflen);
+extern struct key *request_efi_key(const char *master_desc,
+			const u8 **master_key, size_t *master_keylen);
 #else
 inline long efi_read_blob(const struct key *key, char __user *buffer,
 			  char *kbuffer, size_t buflen)
 {
 	return 0;
 }
+static inline struct key *request_efi_key(const char *master_desc,
+			const u8 **master_key, size_t *master_keylen)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif
 
 #endif /* _KEYS_EFI_TYPE_H */
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index d92cbf9687c3..b396506afdfc 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -24,6 +24,7 @@
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
+#include <keys/efi-type.h>
 #include <linux/key-type.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
@@ -40,6 +41,7 @@
 
 static const char KEY_TRUSTED_PREFIX[] = "trusted:";
 static const char KEY_USER_PREFIX[] = "user:";
+static const char KEY_EFI_PREFIX[] = "efi:";
 static const char hash_alg[] = "sha256";
 static const char hmac_alg[] = "hmac(sha256)";
 static const char blkcipher_alg[] = "cbc(aes)";
@@ -50,6 +52,7 @@ static int blksize;
 
 #define KEY_TRUSTED_PREFIX_LEN (sizeof (KEY_TRUSTED_PREFIX) - 1)
 #define KEY_USER_PREFIX_LEN (sizeof (KEY_USER_PREFIX) - 1)
+#define KEY_EFI_PREFIX_LEN (sizeof (KEY_EFI_PREFIX) - 1)
 #define KEY_ECRYPTFS_DESC_LEN 16
 #define HASH_SIZE SHA256_DIGEST_SIZE
 #define MAX_DATA_SIZE 4096
@@ -142,6 +145,8 @@ static int valid_master_desc(const char *new_desc, const char *orig_desc)
 		prefix_len = KEY_TRUSTED_PREFIX_LEN;
 	else if (!strncmp(new_desc, KEY_USER_PREFIX, KEY_USER_PREFIX_LEN))
 		prefix_len = KEY_USER_PREFIX_LEN;
+	else if (!strncmp(new_desc, KEY_EFI_PREFIX, KEY_EFI_PREFIX_LEN))
+		prefix_len = KEY_EFI_PREFIX_LEN;
 	else
 		return -EINVAL;
 
@@ -434,6 +439,11 @@ static struct key *request_master_key(struct encrypted_key_payload *epayload,
 		mkey = request_user_key(epayload->master_desc +
 					KEY_USER_PREFIX_LEN,
 					master_key, master_keylen);
+	} else if (!strncmp(epayload->master_desc, KEY_EFI_PREFIX,
+			    KEY_EFI_PREFIX_LEN)) {
+		mkey = request_efi_key(epayload->master_desc +
+					KEY_EFI_PREFIX_LEN,
+					master_key, master_keylen);
 	} else
 		goto out;
 
-- 
2.13.6
