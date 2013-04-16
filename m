From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/28] Include missing linux/magic.h inclusions [RFC]
Date: Tue, 16 Apr 2013 19:25:58 +0100
Message-ID: <20130416182558.27773.22728.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-efi@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-efi@vger.kernel.org

Include missing linux/magic.h inclusions where the source file is currently
expecting to get magic numbers through linux/proc_fs.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-efi@vger.kernel.org
---

 drivers/firmware/efivars.c |    1 +
 fs/proc/inode.c            |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7acafb8..0f102601 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -80,6 +80,7 @@
 #include <linux/slab.h>
 #include <linux/pstore.h>
 #include <linux/ctype.h>
+#include <linux/magic.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index d50224c..bd2f764 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/mount.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 
