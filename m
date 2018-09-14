From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v2 2/6] ima: prevent kexec_load syscall based on runtime secureboot flag
Date: Fri, 14 Sep 2018 13:30:01 +0530
Message-ID: <20180914080005.6138-3-nayna@linux.vnet.ibm.com>
References: <20180914080005.6138-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914080005.6138-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

When CONFIG_KEXEC_VERIFY_SIG is enabled, the kexec_file_load syscall
requires the kexec'd kernel image to be signed. Distros are concerned
about totally disabling the kexec_load syscall. As a compromise, the
kexec_load syscall will only be disabled when CONFIG_KEXEC_VERIFY_SIG
is configured and the system is booted with secureboot enabled.

This patch disables the kexec_load syscall only for systems booted with
secureboot enabled.

Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index dce0a8a217bb..bdb6e5563d05 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -505,20 +505,24 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
  */
 int ima_load_data(enum kernel_load_data_id id)
 {
-	bool sig_enforce;
+	bool ima_enforce, sig_enforce;
 
-	if ((ima_appraise & IMA_APPRAISE_ENFORCE) != IMA_APPRAISE_ENFORCE)
-		return 0;
+	ima_enforce =
+		(ima_appraise & IMA_APPRAISE_ENFORCE) == IMA_APPRAISE_ENFORCE;
 
 	switch (id) {
 	case LOADING_KEXEC_IMAGE:
-		if (ima_appraise & IMA_APPRAISE_KEXEC) {
+#ifdef CONFIG_KEXEC_VERIFY_SIG
+		if (arch_ima_get_secureboot())
+			return -EACCES;
+#endif
+		if (ima_enforce && (ima_appraise & IMA_APPRAISE_KEXEC)) {
 			pr_err("impossible to appraise a kernel image without a file descriptor; try using kexec_file_load syscall.\n");
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		}
 		break;
 	case LOADING_FIRMWARE:
-		if (ima_appraise & IMA_APPRAISE_FIRMWARE) {
+		if (ima_enforce && (ima_appraise & IMA_APPRAISE_FIRMWARE)) {
 			pr_err("Prevent firmware sysfs fallback loading.\n");
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		}
@@ -526,7 +530,8 @@ int ima_load_data(enum kernel_load_data_id id)
 	case LOADING_MODULE:
 		sig_enforce = is_module_sig_enforced();
 
-		if (!sig_enforce && (ima_appraise & IMA_APPRAISE_MODULES)) {
+		if (ima_enforce && (!sig_enforce
+				    && (ima_appraise & IMA_APPRAISE_MODULES))) {
 			pr_err("impossible to appraise a module without a file descriptor. sig_enforce kernel parameter might help\n");
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		}
-- 
2.13.6
