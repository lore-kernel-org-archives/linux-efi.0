From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 05/12] Restrict /dev/mem and /dev/kmem when trusted_kernel is true
Date: Wed, 26 Feb 2014 15:11:06 -0500
Message-ID: <1393445473-15068-6-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Allowing users to write to address space provides mechanisms that may permit
modification of the kernel at runtime. Prevent this if trusted_kernel is
true.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 15331a8..2cecab9 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -158,6 +158,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -496,6 +499,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-- 
1.8.5.3
