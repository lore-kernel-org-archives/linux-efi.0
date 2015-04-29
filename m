From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [RFC 1/3] sysfs,kernfs: add flush operation
Date: Wed, 29 Apr 2015 16:09:45 -0700
Message-ID: <1430348985.2189.39.camel@HansenPartnership.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430348859.2189.37.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>

This is necessary to allow sysfs operations to return error in close (we are
using close to initiate and return a possible error from a transaction).

Signed-off-by: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
---
 fs/kernfs/file.c       | 16 ++++++++++++++++
 fs/sysfs/file.c        | 16 ++++++++++++++++
 include/linux/kernfs.h |  2 ++
 include/linux/sysfs.h  |  2 ++
 4 files changed, 36 insertions(+)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 2bacb99..d9bc8d7 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -802,6 +802,21 @@ static unsigned int kernfs_fop_poll(struct file *filp, poll_table *wait)
 	return DEFAULT_POLLMASK|POLLERR|POLLPRI;
 }
 
+static int kernfs_fop_flush(struct file *file, fl_owner_t id)
+{
+	struct kernfs_open_file *of = kernfs_of(file);
+	const struct kernfs_ops *ops;
+	int rc = 0;
+
+	mutex_lock(&of->mutex);
+	ops = kernfs_ops(of->kn);
+	if (ops->flush)
+		rc = ops->flush(of, id);
+	mutex_unlock(&of->mutex);
+
+	return rc;
+}
+
 static void kernfs_notify_workfn(struct work_struct *work)
 {
 	struct kernfs_node *kn;
@@ -891,6 +906,7 @@ const struct file_operations kernfs_file_fops = {
 	.open		= kernfs_fop_open,
 	.release	= kernfs_fop_release,
 	.poll		= kernfs_fop_poll,
+	.flush		= kernfs_fop_flush,
 };
 
 /**
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 7c2867b..188639f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -162,6 +162,19 @@ static int sysfs_kf_bin_mmap(struct kernfs_open_file *of,
 	return battr->mmap(of->file, kobj, battr, vma);
 }
 
+static int sysfs_kf_bin_flush(struct kernfs_open_file *of,
+			      fl_owner_t id)
+{
+	struct bin_attribute *battr = of->kn->priv;
+	struct kobject *kobj = of->kn->parent->priv;
+	int rc = 0;
+
+	if (battr->flush)
+		rc = battr->flush(of->file, kobj, battr, id);
+
+	return rc;
+}
+
 void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr)
 {
 	struct kernfs_node *kn = kobj->sd, *tmp;
@@ -222,17 +235,20 @@ static const struct kernfs_ops sysfs_bin_kfops_ro = {
 
 static const struct kernfs_ops sysfs_bin_kfops_wo = {
 	.write		= sysfs_kf_bin_write,
+	.flush		= sysfs_kf_bin_flush,
 };
 
 static const struct kernfs_ops sysfs_bin_kfops_rw = {
 	.read		= sysfs_kf_bin_read,
 	.write		= sysfs_kf_bin_write,
+	.flush		= sysfs_kf_bin_flush,
 };
 
 static const struct kernfs_ops sysfs_bin_kfops_mmap = {
 	.read		= sysfs_kf_bin_read,
 	.write		= sysfs_kf_bin_write,
 	.mmap		= sysfs_kf_bin_mmap,
+	.flush		= sysfs_kf_bin_flush,
 };
 
 int sysfs_add_file_mode_ns(struct kernfs_node *parent,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 71ecdab..ead781c 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/lockdep.h>
 #include <linux/rbtree.h>
@@ -225,6 +226,7 @@ struct kernfs_ops {
 			 loff_t off);
 
 	int (*mmap)(struct kernfs_open_file *of, struct vm_area_struct *vma);
+	int (*flush) (struct kernfs_open_file *of, fl_owner_t id);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	lockdep_key;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 99382c0..391da13 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -152,6 +152,8 @@ struct bin_attribute {
 			 char *, loff_t, size_t);
 	int (*mmap)(struct file *, struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
+	int (*flush)(struct file *, struct kobject *,
+		     struct bin_attribute *attr, fl_owner_t id);
 };
 
 /**
-- 
2.1.4
