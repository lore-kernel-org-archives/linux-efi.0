From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/27] Restrict /dev/mem and /dev/kmem when the kernel is
 locked down
Date: Thu, 19 Oct 2017 15:51:02 +0100
Message-ID: <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

From: Matthew Garrett <matthew.garrett@nebula.com>

Allowing users to write to address space makes it possible for the kernel to
be subverted, avoiding module loading restrictions.  Prevent this when the
kernel has been locked down.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/mem.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 593a8818aca9..b7c36898b689 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -179,6 +179,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	if (p != *ppos)
 		return -EFBIG;
 
+	if (kernel_is_locked_down("/dev/mem"))
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -540,6 +543,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (kernel_is_locked_down("/dev/kmem"))
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
