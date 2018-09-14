From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v2 5/6] ima: add support for external setting of ima_appraise
Date: Fri, 14 Sep 2018 13:30:04 +0530
Message-ID: <20180914080005.6138-6-nayna@linux.vnet.ibm.com>
References: <20180914080005.6138-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914080005.6138-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

The "ima_appraise" mode defaults to enforcing, unless configured to allow
the boot command line "ima_appraise" option. This patch explicitly sets the
"ima_appraise" mode for the arch specific policy setting.

Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h          |  5 +++++
 security/integrity/ima/ima_appraise.c | 11 +++++++++--
 security/integrity/ima/ima_policy.c   |  5 ++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 588e4813370c..6e5fa7c42809 100644
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
index 8bd7a0733e51..e061613bcb87 100644
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
index 23f3aa214016..c574841bcc9a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -585,9 +585,12 @@ void __init ima_init_policy(void)
 	arch_entries = ima_init_arch_policy();
 	if (!arch_entries)
 		pr_info("No architecture policies found\n");
-	else
+	else {
 		add_rules(arch_policy_entry, arch_entries,
 			  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
+		if (temp_ima_appraise)
+			set_ima_appraise("enforce");
+	}
 
 	/*
 	 * Insert the builtin "secure_boot" policy rules requiring file
-- 
2.13.6
