From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: libstub: add strnlen() implementation
Date: Tue, 16 Feb 2016 16:29:19 +0100
Message-ID: <1455636559-7542-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 91feabc2e224 ("scripts/dtc: Update to upstream commit
b06e55c88b9b") introduces references to the strnlen() string function,
which is not currently defined in the EFI stub. So add it to our string.c

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/string.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/firmware/efi/libstub/string.c b/drivers/firmware/efi/libstub/string.c
index 09d5a0894343..d4055ab80116 100644
--- a/drivers/firmware/efi/libstub/string.c
+++ b/drivers/firmware/efi/libstub/string.c
@@ -55,3 +55,19 @@ int strncmp(const char *cs, const char *ct, size_t count)
 	return 0;
 }
 #endif
+
+#ifndef __HAVE_ARCH_STRNLEN
+/**
+ * strnlen - Find the length of a length-limited string
+ * @s: The string to be sized
+ * @count: The maximum number of bytes to search
+ */
+size_t strnlen(const char *s, size_t count)
+{
+	const char *sc;
+
+	for (sc = s; count-- && *sc != '\0'; ++sc)
+		/* nothing */;
+	return sc - s;
+}
+#endif
-- 
2.5.0
