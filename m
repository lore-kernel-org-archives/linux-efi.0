From: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] efi/efi_test: use memdup_user
Date: Sat, 29 Apr 2017 09:42:52 +0800
Message-ID: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Use memdup_user() helper instead of open-coding to simplify the code.

Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/test/efi_test.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 8cd578f..08129b7 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -71,18 +71,13 @@ copy_ucs2_from_user_len(efi_char16_t **dst, efi_char16_t __user *src,
 	if (!access_ok(VERIFY_READ, src, 1))
 		return -EFAULT;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf) {
+	buf = memdup_user(src, len);
+	if (IS_ERR(buf)) {
 		*dst = NULL;
-		return -ENOMEM;
+		return PTR_ERR(buf);
 	}
 	*dst = buf;
 
-	if (copy_from_user(*dst, src, len)) {
-		kfree(buf);
-		return -EFAULT;
-	}
-
 	return 0;
 }
 
-- 
2.9.3
