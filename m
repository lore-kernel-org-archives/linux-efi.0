From: Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 1/3] ima: add error mesage to kexec_load
Date: Mon, 19 Nov 2018 14:56:09 -0500
Message-ID: <1542657371-7019-2-git-send-email-zohar@linux.ibm.com>
References: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

Reject the kexec_load syscall with some indication of the problem.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 41e4771980d5..df0b2ee49fa2 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -513,8 +513,10 @@ int ima_load_data(enum kernel_load_data_id id)
 	switch (id) {
 	case LOADING_KEXEC_IMAGE:
 		if (IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG)
-		    && arch_ima_get_secureboot())
+		    && arch_ima_get_secureboot()) {
+			pr_err("impossible to appraise a kernel image without a file descriptor; try using kexec_file_load syscall.\n");
 			return -EACCES;
+		}
 
 		if (ima_enforce && (ima_appraise & IMA_APPRAISE_KEXEC)) {
 			pr_err("impossible to appraise a kernel image without a file descriptor; try using kexec_file_load syscall.\n");
-- 
2.7.5
