From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 06/12] x86: Require CAP_COMPROMISE_KERNEL for IO port access
Date: Mon, 18 Mar 2013 17:32:27 -0400
Message-ID: <1363642353-30749-6-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO register
space. This would potentially permit root to trigger arbitrary DMA, so lock
it down by default.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/kernel/ioport.c | 4 ++--
 drivers/char/mem.c       | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 4ddaf66..f505995 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -28,7 +28,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL)))
 		return -EPERM;
 
 	/*
@@ -103,7 +103,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL))
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 2c644af..7eee4d8 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -597,6 +597,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	unsigned long i = *ppos;
 	const char __user *tmp = buf;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-- 
1.8.1.2
