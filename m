From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/30] debugfs: Disallow use of debugfs files when the kernel is locked down
Date: Thu,  9 Nov 2017 17:33:41 +0000
Message-ID: <151024882152.28329.13943595155704545862.stgit@warthog.procyon.org.uk>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, dhowells@redhat.com, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Disallow opening of debugfs files when the kernel is locked down as various
drivers give raw access to hardware through debugfs.

Accesses to tracefs should use /sys/kernel/tracing/ rather than
/sys/kernel/debug/tracing/.  Possibly a symlink should be emplaced.

Normal device interaction should be done through configfs or a miscdev, not
debugfs.

Note that this makes it unnecessary to specifically lock down show_dsts(),
show_devs() and show_call() in the asus-wmi driver.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: acpi4asus-user@lists.sourceforge.net
cc: platform-driver-x86@vger.kernel.org
cc: Matthew Garrett <matthew.garrett@nebula.com>
cc: Thomas Gleixner <tglx@linutronix.de>
---

 fs/debugfs/file.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 6dabc4a10396..32b5168a7e91 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -103,6 +103,9 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 	const struct file_operations *real_fops = NULL;
 	int srcu_idx, r;
 
+	if (kernel_is_locked_down("debugfs"))
+		return -EPERM;
+
 	r = debugfs_use_file_start(dentry, &srcu_idx);
 	if (r) {
 		r = -ENOENT;
@@ -232,6 +235,9 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 	struct file_operations *proxy_fops = NULL;
 	int srcu_idx, r;
 
+	if (kernel_is_locked_down("debugfs"))
+		return -EPERM;
+
 	r = debugfs_use_file_start(dentry, &srcu_idx);
 	if (r) {
 		r = -ENOENT;
