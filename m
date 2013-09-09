From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 04/12] x86: Lock down IO port access when securelevel is enabled
Date: Mon,  9 Sep 2013 11:49:38 -0400
Message-ID: <1378741786-18430-5-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO register
space. This would potentially permit root to trigger arbitrary DMA, so lock
it down when securelevel is set.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/kernel/ioport.c | 5 +++--
 drivers/char/mem.c       | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 4ddaf66..2a9ccd4 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/syscalls.h>
 #include <linux/bitmap.h>
+#include <linux/security.h>
 #include <asm/syscalls.h>
 
 /*
@@ -28,7 +29,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) || (get_securelevel() > 0)))
 		return -EPERM;
 
 	/*
@@ -103,7 +104,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) || (get_securelevel() > 0))
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f895a8c..741f536 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/aio.h>
+#include <linux/security.h>
 
 #include <asm/uaccess.h>
 
@@ -545,6 +546,9 @@ static ssize_t read_port(struct file *file, char __user *buf,
 	unsigned long i = *ppos;
 	char __user *tmp = buf;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
@@ -563,6 +567,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	unsigned long i = *ppos;
 	const char __user *tmp = buf;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-- 
1.8.3.1
