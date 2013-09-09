From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 05/12] Restrict /dev/mem and /dev/kmem when securelevel is set.
Date: Mon,  9 Sep 2013 11:49:39 -0400
Message-ID: <1378741786-18430-6-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Allowing users to write to address space provides mechanisms that may permit
modification of the kernel at runtime. Prevent this if securelevel has been
set.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 741f536..91d1cff 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -159,6 +159,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -497,6 +500,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-- 
1.8.3.1
