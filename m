From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/10] x86: Lock down IO port access when module security is enabled
Date: Mon, 19 Aug 2013 12:10:12 -0400
Message-ID: <1376928619-3775-3-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376928619-3775-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO register
space. This would potentially permit root to trigger arbitrary DMA, so lock
it down by default.

Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/ioport.c | 5 +++--
 drivers/char/mem.c       | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 4ddaf66..00b4403 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/syscalls.h>
 #include <linux/bitmap.h>
+#include <linux/module.h>
 #include <asm/syscalls.h>
 
 /*
@@ -28,7 +29,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) || secure_modules()))
 		return -EPERM;
 
 	/*
@@ -103,7 +104,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) || secure_modules())
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f895a8c..1af8664 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/aio.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
@@ -563,6 +564,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	unsigned long i = *ppos;
 	const char __user *tmp = buf;
 
+	if (secure_modules())
+		return -EPERM;
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-- 
1.8.3.1
