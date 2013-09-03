From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V3 08/11] kexec: Disable at runtime if the kernel enforces module loading restrictions
Date: Tue,  3 Sep 2013 19:50:15 -0400
Message-ID: <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

kexec permits the loading and execution of arbitrary code in ring 0, which
is something that module signing enforcement is meant to prevent. It makes
sense to disable kexec in this situation.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/kexec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..3e2b63a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -943,6 +944,13 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		return -EPERM;
 
 	/*
+	 * kexec can be used to circumvent module loading restrictions, so
+	 * prevent loading in that case
+	 */
+	if (secure_modules())
+		return -EPERM;
+
+	/*
 	 * Verify we have a legal set of flags
 	 * This leaves us room for future extensions.
 	 */
-- 
1.8.3.1
