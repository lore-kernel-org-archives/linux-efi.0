From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/15] x86: Lock down IO port access in secure boot environments
Date: Mon, 28 Jan 2013 11:42:30 -0500
Message-ID: <1359391359-25783-7-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO register
space. This would potentially permit root to trigger arbitrary DMA, so lock
it down by default.

Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/ioport.c | 4 ++--
 drivers/char/mem.c       | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8c96897..a2578c4 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -28,7 +28,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL)))
 		return -EPERM;
 
 	/*
@@ -102,7 +102,7 @@ long sys_iopl(unsigned int level, struct pt_regs *regs)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL))
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index c6fa3bc..fc28099 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -597,6 +597,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	unsigned long i = *ppos;
 	const char __user * tmp = buf;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-- 
1.8.0.2
