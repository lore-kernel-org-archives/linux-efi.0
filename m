From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V3 09/11] uswsusp: Disable when module loading is restricted
Date: Tue,  3 Sep 2013 19:50:16 -0400
Message-ID: <1378252218-18798-10-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

uswsusp allows a user process to dump and then restore kernel state, which
makes it possible to avoid module loading restrictions. Prevent this when
any restrictions have been imposed on loading modules.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/power/user.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4ed81e7..15cb72f 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
@@ -48,6 +49,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	struct snapshot_data *data;
 	int error;
 
+	if (secure_modules())
+		return -EPERM;
+
 	lock_system_sleep();
 
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
-- 
1.8.3.1
