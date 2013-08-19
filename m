From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V2 09/10] x86: Restrict MSR access when module loading is restricted
Date: Mon, 19 Aug 2013 13:26:10 -0400
Message-ID: <1376933171-9854-10-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Writing to MSRs should not be allowed if module loading is restricted,
since it could lead to execution of arbitrary code in kernel mode. Based
on a patch by Kees Cook.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/kernel/msr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 88458fa..d08f7e3 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -103,6 +103,9 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
+	if (secure_modules())
+		return -EPERM;
+
 	if (count % 8)
 		return -EINVAL;	/* Invalid chunk size */
 
@@ -150,6 +153,10 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 			err = -EBADF;
 			break;
 		}
+		if (secure_modules()) {
+			err = -EPERM;
+			break;
+		}
 		if (copy_from_user(&regs, uregs, sizeof regs)) {
 			err = -EFAULT;
 			break;
-- 
1.8.3.1
