From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 5/5] efivarfs: Make efivarfs_file_ioctl static
Date: Fri,  6 May 2016 22:39:31 +0100
Message-ID: <1462570771-13324-6-git-send-email-matt@codeblueprint.co.uk>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462570771-13324-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

There are no callers except through the file_operations struct below
this, so it should be static like everything else here.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 fs/efivarfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index d48e0d261d78..5f22e74bbade 100644
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
2.7.3
