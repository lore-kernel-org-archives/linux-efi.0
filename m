From: Eric Richter <erichte@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ima: add support for external setting of ima_appraise
Date: Wed, 25 Jul 2018 18:31:58 -0500
Message-ID: <20180725233200.761-3-erichte@linux.vnet.ibm.com>
References: <20180725233200.761-1-erichte@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725233200.761-1-erichte@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity <linux-integrity@vger.kernel.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Justin Forbes <jforbes@redhat.com>, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

From: Nayna Jain <nayna@linux.vnet.ibm.com>

The "ima_appraise" mode defaults to enforcing, unless configured to
allow the boot command line "ima_appraise" option. This patch allows
the "ima_appraise" mode to be defined based on the arch setting.

Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h          |  5 +++++
 security/integrity/ima/ima_appraise.c | 11 +++++++++--
 security/integrity/ima/ima_policy.c   |  5 ++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 588e4813370..6e5fa7c4280 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -248,6 +248,7 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 				 int xattr_len);
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value);
+void set_ima_appraise(char *str);
 
 #else
 static inline int ima_appraise_measurement(enum ima_hooks func,
@@ -290,6 +291,10 @@ static inline int ima_read_xattr(struct dentry *dentry,
 	return 0;
 }
 
+static inline void set_ima_appraise(char *str)
+{
+}
+
 #endif /* CONFIG_IMA_APPRAISE */
 
 /* LSM based policy rules require audit */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 8bd7a0733e5..e061613bcb8 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -18,15 +18,22 @@
 
 #include "ima.h"
 
-static int __init default_appraise_setup(char *str)
+void set_ima_appraise(char *str)
 {
-#ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
 	if (strncmp(str, "off", 3) == 0)
 		ima_appraise = 0;
 	else if (strncmp(str, "log", 3) == 0)
 		ima_appraise = IMA_APPRAISE_LOG;
 	else if (strncmp(str, "fix", 3) == 0)
 		ima_appraise = IMA_APPRAISE_FIX;
+	else if (strncmp(str, "enforce", 7) == 0)
+		ima_appraise = IMA_APPRAISE_ENFORCE;
+}
+
+static int __init default_appraise_setup(char *str)
+{
+#ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
+	set_ima_appraise(str);
 #endif
 	return 1;
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b47db4d7fea..402e5bd1093 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -573,8 +573,11 @@ void __init ima_init_policy(void)
 	 * (Highest priority)
 	 */
 	arch_policy_entries = ima_init_arch_policy();
-	if (arch_policy_entries > 0)
+	if (arch_policy_entries > 0) {
 		pr_info("Adding %d architecture policy rules.\n", arch_policy_entries);
+		set_ima_appraise("enforce");
+	}
+
 	for (i = 0; i < arch_policy_entries; i++) {
 		struct ima_rule_entry *entry;
 
-- 
2.14.4
