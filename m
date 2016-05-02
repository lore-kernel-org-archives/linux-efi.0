From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efivarfs: make efivarfs_file_ioctl static.
Date: Mon,  2 May 2016 14:25:06 -0400
Message-ID: <1462213506-1860-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There are no callers except through the file_operations struct below
this, so it should be static like everything else here.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/efivarfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index d48e0d2..5f22e74 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -157,7 +157,7 @@ efivarfs_ioc_setxflags(struct file *file, void __user *arg)
 	return 0;
 }
 
-long
+static long
 efivarfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long p)
 {
 	void __user *arg = (void __user *)p;
-- 
2.5.5
