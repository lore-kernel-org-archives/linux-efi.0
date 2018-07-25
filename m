From: Eric Richter <erichte@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ima: add support for KEXEC_ORIG_KERNEL_CHECK
Date: Wed, 25 Jul 2018 18:31:59 -0500
Message-ID: <20180725233200.761-4-erichte@linux.vnet.ibm.com>
References: <20180725233200.761-1-erichte@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725233200.761-1-erichte@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity <linux-integrity@vger.kernel.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Justin Forbes <jforbes@redhat.com>, Eric Richter <erichte@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

IMA can verify the signature of kernel images loaded with kexec_file_load,
but can not verify images loaded with the regular kexec_load syscall.
Therefore, the appraisal will automatically fail during kexec_load when an
appraise policy rule is set for func=KEXEC_KERNEL_CHECK. This can be used
to effectively disable the kexec_load syscall, while still allowing the
kexec_file_load to operate so long as the target kernel image is signed.

However, this conflicts with CONFIG_KEXEC_VERIFY_SIG. If that option is
enabled and there is an appraise rule set, then the target kernel would
have to be verifiable by both IMA and the architecture specific kernel
verification procedure.

This patch adds a new func= for IMA appraisal specifically for the original
kexec_load syscall. Therefore, the kexec_load syscall can be effectively
disabled via IMA policy, leaving the kexec_file_load syscall able to do its
own signature verification, and not require it to be signed via IMA. To
retain compatibility, the existing func=KEXEC_KERNEL_CHECK flag is
unchanged, and thus enables appraisal for both kexec syscalls.

Signed-off-by: Eric Richter <erichte@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/ima_policy | 1 +
 security/integrity/ima/ima.h         | 2 ++
 security/integrity/ima/ima_main.c    | 3 ++-
 security/integrity/ima/ima_policy.c  | 5 +++++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 74c6702de74..031417779ec 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -29,6 +29,7 @@ Description:
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
 				[FIRMWARE_CHECK]
 				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
+				[KEXEC_ORIG_KERNEL_CHECK]
 			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
 			       [[^]MAY_EXEC]
 			fsmagic:= hex value
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 6e5fa7c4280..c76e53c982b 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -181,6 +181,7 @@ static inline unsigned long ima_hash_key(u8 *digest)
 	hook(MODULE_CHECK)		\
 	hook(FIRMWARE_CHECK)		\
 	hook(KEXEC_KERNEL_CHECK)	\
+	hook(KEXEC_ORIG_KERNEL_CHECK)	\
 	hook(KEXEC_INITRAMFS_CHECK)	\
 	hook(POLICY_CHECK)		\
 	hook(MAX_CHECK)
@@ -233,6 +234,7 @@ int ima_policy_show(struct seq_file *m, void *v);
 #define IMA_APPRAISE_FIRMWARE	0x10
 #define IMA_APPRAISE_POLICY	0x20
 #define IMA_APPRAISE_KEXEC	0x40
+#define IMA_APPRAISE_ORIG_KEXEC	0x80
 
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(enum ima_hooks func,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index dce0a8a217b..a7b4220043d 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -512,7 +512,8 @@ int ima_load_data(enum kernel_load_data_id id)
 
 	switch (id) {
 	case LOADING_KEXEC_IMAGE:
-		if (ima_appraise & IMA_APPRAISE_KEXEC) {
+		if (ima_appraise &
+		    (IMA_APPRAISE_ORIG_KEXEC | IMA_APPRAISE_KEXEC)) {
 			pr_err("impossible to appraise a kernel image without a file descriptor; try using kexec_file_load syscall.\n");
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 402e5bd1093..7a33e3f6eca 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -475,6 +475,8 @@ static int ima_appraise_flag(enum ima_hooks func)
 		return IMA_APPRAISE_POLICY;
 	else if (func == KEXEC_KERNEL_CHECK)
 		return IMA_APPRAISE_KEXEC;
+	else if (func == KEXEC_ORIG_KERNEL_CHECK)
+		return IMA_APPRAISE_ORIG_KEXEC;
 	return 0;
 }
 
@@ -879,6 +881,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			else if (strcmp(args[0].from, "KEXEC_KERNEL_CHECK") ==
 				 0)
 				entry->func = KEXEC_KERNEL_CHECK;
+			else if (strcmp(args[0].from,
+				 "KEXEC_ORIG_KERNEL_CHECK") == 0)
+				entry->func = KEXEC_ORIG_KERNEL_CHECK;
 			else if (strcmp(args[0].from, "KEXEC_INITRAMFS_CHECK")
 				 == 0)
 				entry->func = KEXEC_INITRAMFS_CHECK;
-- 
2.14.4
