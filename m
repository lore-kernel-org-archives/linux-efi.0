From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/38] vfs: Convert efivarfs to fs_context
Date: Thu, 14 Mar 2019 16:12:19 +0000
Message-ID: <155257993926.13720.6895385326576657556.stgit@warthog.procyon.org.uk>
References: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Garrett <matthew.garrett@nebula.com>
cc: Jeremy Kerr <jk@ozlabs.org>
cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
cc: linux-efi@vger.kernel.org
---

 fs/efivarfs/super.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 5b68e4294faa..1ea25c7a329a 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -10,6 +10,7 @@
 #include <linux/ctype.h>
 #include <linux/efi.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/ucs2_string.h>
@@ -191,7 +192,7 @@ static int efivarfs_destroy(struct efivar_entry *entry, void *data)
 	return 0;
 }
 
-static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
+static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode = NULL;
 	struct dentry *root;
@@ -226,10 +227,19 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	return err;
 }
 
-static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-				    int flags, const char *dev_name, void *data)
+static int efivarfs_get_tree(struct fs_context *fc)
 {
-	return mount_single(fs_type, flags, data, efivarfs_fill_super);
+	return vfs_get_super(fc, vfs_get_single_super, efivarfs_fill_super);
+}
+
+static const struct fs_context_operations efivarfs_context_ops = {
+	.get_tree	= efivarfs_get_tree,
+};
+
+static int efivarfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &efivarfs_context_ops;
+	return 0;
 }
 
 static void efivarfs_kill_sb(struct super_block *sb)
@@ -244,7 +254,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 static struct file_system_type efivarfs_type = {
 	.owner   = THIS_MODULE,
 	.name    = "efivarfs",
-	.mount   = efivarfs_mount,
+	.init_fs_context = efivarfs_init_fs_context,
 	.kill_sb = efivarfs_kill_sb,
 };
 
