From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 29/68] vfs: Convert efivarfs to use the new mount API
Date: Wed, 27 Mar 2019 23:44:11 +0000
Message-ID: <155373025163.7602.14229854994527411731.stgit@warthog.procyon.org.uk>
References: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-efi@vger.kernel.org

Convert the efivarfs filesystem to the new internal mount API as the old
one will be obsoleted and removed.  This allows greater flexibility in
communication of mount parameters between userspace, the VFS and the
filesystem.

See Documentation/filesystems/mount_api.txt for more information.

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
 
