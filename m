From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 09/12] Require CAP_COMPROMISE_KERNEL for /dev/mem and /dev/kmem access
Date: Mon, 18 Mar 2013 17:32:30 -0400
Message-ID: <1363642353-30749-9-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Allowing users to write to address space makes it possible for the kernel
to be subverted. Restrict this when we need to protect the kernel.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 7eee4d8..772ee2b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -158,6 +158,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -530,6 +533,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-- 
1.8.1.2

