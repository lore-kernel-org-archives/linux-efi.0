From: Nayna Jain <nayna@linux.ibm.com>
Subject: [PATCH v2 7/7] ima: Support platform keyring for kernel appraisal
Date: Sun,  9 Dec 2018 01:57:05 +0530
Message-ID: <20181208202705.18673-8-nayna@linux.ibm.com>
References: <20181208202705.18673-1-nayna@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181208202705.18673-1-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On secure boot enabled systems, the bootloader verifies the kernel
image and possibly the initramfs signatures based on a set of keys. A
soft reboot(kexec) of the system, with the same kernel image and
initramfs, requires access to the original keys to verify the
signatures.

This patch allows IMA-appraisal access to those original keys, now
loaded on the platform keyring, needed for verifying the kernel image
and initramfs signatures.

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
- replace 'rc' with 'xattr_len' when calling integrity_digsig_verify()
with INTEGRITY_KEYRING_IMA for readability
Suggested-by: Serge Hallyn <serge@hallyn.com>
---
Changelog:

v2:
- replace 'rc' with 'xattr_len' when calling integrity_digsig_verify()
with INTEGRITY_KEYRING_IMA for readability

 security/integrity/ima/ima_appraise.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index deec1804a00a..e8f520450895 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -289,12 +289,21 @@ int ima_appraise_measurement(enum ima_hooks func,
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-					     (const char *)xattr_value, rc,
+					     (const char *)xattr_value,
+					     xattr_len,
 					     iint->ima_hash->digest,
 					     iint->ima_hash->length);
 		if (rc == -EOPNOTSUPP) {
 			status = INTEGRITY_UNKNOWN;
-		} else if (rc) {
+			break;
+		}
+		if (rc && func == KEXEC_KERNEL_CHECK)
+			rc = integrity_digsig_verify(INTEGRITY_KEYRING_PLATFORM,
+						     (const char *)xattr_value,
+						     xattr_len,
+						     iint->ima_hash->digest,
+						     iint->ima_hash->length);
+		if (rc) {
 			cause = "invalid-signature";
 			status = INTEGRITY_FAIL;
 		} else {
-- 
2.13.6
