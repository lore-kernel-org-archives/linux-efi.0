From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/16] Restrict /dev/mem and /dev/kmem when the kernel is
 locked down
Date: Wed, 16 Nov 2016 21:48:57 +0000
Message-ID: <147933293772.19316.6635131764009392253.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
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
index 17e22cb2db14..5dcc205e8373 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -164,6 +164,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	if (p != *ppos)
 		return -EFBIG;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -516,6 +519,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	if (!pfn_valid(PFN_DOWN(p)))
 		return -EIO;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
