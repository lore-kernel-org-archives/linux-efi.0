From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] lib/ucs2_string: Speed up ucs2_utf8size()
Date: Wed, 3 Aug 2016 10:16:02 +0200
Message-ID: <c45b75bbb1bd486429ab993d66167f22f14cf415.1470211796.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

No need to calculate the string length on every loop iteration.

Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 lib/ucs2_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index f0b323a..ae8d249 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -56,7 +56,7 @@ ucs2_utf8size(const ucs2_char_t *src)
 	unsigned long i;
 	unsigned long j = 0;
 
-	for (i = 0; i < ucs2_strlen(src); i++) {
+	for (i = 0; src[i]; i++) {
 		u16 c = src[i];
 
 		if (c >= 0x800)
-- 
2.8.1
