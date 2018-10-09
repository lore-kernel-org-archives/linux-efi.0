From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v6 3/5] ima: refactor ima_init_policy()
Date: Tue,  9 Oct 2018 23:00:35 +0530
Message-ID: <20181009173037.32630-4-nayna@linux.vnet.ibm.com>
References: <20181009173037.32630-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009173037.32630-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, pjones@redhat.com, vgoyal@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

From: Nayna Jain <nayna@linux.ibm.com>

This patch removes the code duplication in ima_init_policy() by defining
a new function named add_rules(). The new function adds the rules to the
initial IMA policy, the custom policy or both based on the policy mask
(IMA_DEFAULT_POLICY, IMA_CUSTOM_POLICY).

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
---
 security/integrity/ima/ima_policy.c | 97 +++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 41 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 8c9499867c91..1e30d09a56db 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -58,6 +58,8 @@ enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
 
 enum policy_types { ORIGINAL_TCB = 1, DEFAULT_TCB };
 
+enum policy_rule_list { IMA_DEFAULT_POLICY = 1, IMA_CUSTOM_POLICY };
+
 struct ima_rule_entry {
 	struct list_head list;
 	int action;
@@ -473,6 +475,32 @@ static int ima_appraise_flag(enum ima_hooks func)
 	return 0;
 }
 
+static void add_rules(struct ima_rule_entry *entries, int count,
+		      enum policy_rule_list policy_rule)
+{
+	int i = 0;
+
+	for (i = 0; i < count; i++) {
+		struct ima_rule_entry *entry;
+
+		if (policy_rule & IMA_DEFAULT_POLICY)
+			list_add_tail(&entries[i].list, &ima_default_rules);
+
+		if (policy_rule & IMA_CUSTOM_POLICY) {
+			entry = kmemdup(&entries[i], sizeof(*entry),
+					GFP_KERNEL);
+			if (!entry)
+				continue;
+
+			list_add_tail(&entry->list, &ima_policy_rules);
+		}
+		if (entries[i].action == APPRAISE)
+			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
+		if (entries[i].func == POLICY_CHECK)
+			temp_ima_appraise |= IMA_APPRAISE_POLICY;
+	}
+}
+
 /**
  * ima_init_policy - initialize the default measure rules.
  *
@@ -481,28 +509,23 @@ static int ima_appraise_flag(enum ima_hooks func)
  */
 void __init ima_init_policy(void)
 {
-	int i, measure_entries, appraise_entries, secure_boot_entries;
-
-	/* if !ima_policy set entries = 0 so we load NO default rules */
-	measure_entries = ima_policy ? ARRAY_SIZE(dont_measure_rules) : 0;
-	appraise_entries = ima_use_appraise_tcb ?
-			 ARRAY_SIZE(default_appraise_rules) : 0;
-	secure_boot_entries = ima_use_secure_boot ?
-			ARRAY_SIZE(secure_boot_rules) : 0;
+	int build_appraise_entries;
 
-	for (i = 0; i < measure_entries; i++)
-		list_add_tail(&dont_measure_rules[i].list, &ima_default_rules);
+	/* if !ima_policy, we load NO default rules */
+	if (ima_policy)
+		add_rules(dont_measure_rules, ARRAY_SIZE(dont_measure_rules),
+			  IMA_DEFAULT_POLICY);
 
 	switch (ima_policy) {
 	case ORIGINAL_TCB:
-		for (i = 0; i < ARRAY_SIZE(original_measurement_rules); i++)
-			list_add_tail(&original_measurement_rules[i].list,
-				      &ima_default_rules);
+		add_rules(original_measurement_rules,
+			  ARRAY_SIZE(original_measurement_rules),
+			  IMA_DEFAULT_POLICY);
 		break;
 	case DEFAULT_TCB:
-		for (i = 0; i < ARRAY_SIZE(default_measurement_rules); i++)
-			list_add_tail(&default_measurement_rules[i].list,
-				      &ima_default_rules);
+		add_rules(default_measurement_rules,
+			  ARRAY_SIZE(default_measurement_rules),
+			  IMA_DEFAULT_POLICY);
 	default:
 		break;
 	}
@@ -511,38 +534,30 @@ void __init ima_init_policy(void)
 	 * Insert the builtin "secure_boot" policy rules requiring file
 	 * signatures, prior to any other appraise rules.
 	 */
-	for (i = 0; i < secure_boot_entries; i++) {
-		list_add_tail(&secure_boot_rules[i].list, &ima_default_rules);
-		temp_ima_appraise |=
-		    ima_appraise_flag(secure_boot_rules[i].func);
-	}
+	if (ima_use_secure_boot)
+		add_rules(secure_boot_rules, ARRAY_SIZE(secure_boot_rules),
+			  IMA_DEFAULT_POLICY);
 
 	/*
 	 * Insert the build time appraise rules requiring file signatures
 	 * for both the initial and custom policies, prior to other appraise
-	 * rules.
+	 * rules. As the secure boot rules includes all of the build time
+	 * rules, include either one or the other set of rules, but not both.
 	 */
-	for (i = 0; i < ARRAY_SIZE(build_appraise_rules); i++) {
-		struct ima_rule_entry *entry;
-
-		if (!secure_boot_entries)
-			list_add_tail(&build_appraise_rules[i].list,
-				      &ima_default_rules);
-
-		entry = kmemdup(&build_appraise_rules[i], sizeof(*entry),
-				GFP_KERNEL);
-		if (entry)
-			list_add_tail(&entry->list, &ima_policy_rules);
-		build_ima_appraise |=
-			ima_appraise_flag(build_appraise_rules[i].func);
+	build_appraise_entries = ARRAY_SIZE(build_appraise_rules);
+	if (build_appraise_entries) {
+		if (ima_use_secure_boot)
+			add_rules(build_appraise_rules, build_appraise_entries,
+				  IMA_CUSTOM_POLICY);
+		else
+			add_rules(build_appraise_rules, build_appraise_entries,
+				  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
 	}
 
-	for (i = 0; i < appraise_entries; i++) {
-		list_add_tail(&default_appraise_rules[i].list,
-			      &ima_default_rules);
-		if (default_appraise_rules[i].func == POLICY_CHECK)
-			temp_ima_appraise |= IMA_APPRAISE_POLICY;
-	}
+	if (ima_use_appraise_tcb)
+		add_rules(default_appraise_rules,
+			  ARRAY_SIZE(default_appraise_rules),
+			  IMA_DEFAULT_POLICY);
 
 	ima_rules = &ima_default_rules;
 	ima_update_policy_flag();
-- 
2.13.6
