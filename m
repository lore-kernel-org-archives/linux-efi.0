From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] Add ucs2 -> utf8 helper functions
Date: Wed,  3 Feb 2016 11:43:50 -0500
Message-ID: <1454517834-13736-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds ucs2_utf8size(), which tells us how big our ucs2 string is in
bytes, and ucs2_as_utf8, which translates from ucs2 to utf8..
---
 include/linux/ucs2_string.h |  4 +++
 lib/ucs2_string.c           | 62 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/linux/ucs2_string.h b/include/linux/ucs2_string.h
index cbb20af..bb679b4 100644
--- a/include/linux/ucs2_string.h
+++ b/include/linux/ucs2_string.h
@@ -11,4 +11,8 @@ unsigned long ucs2_strlen(const ucs2_char_t *s);
 unsigned long ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength);
 int ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len);
 
+unsigned long ucs2_utf8size(const ucs2_char_t *src);
+unsigned long ucs2_as_utf8(u8 *dest, const ucs2_char_t *src,
+			   unsigned long maxlength);
+
 #endif /* _LINUX_UCS2_STRING_H_ */
diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
index 6f500ef..17dd74e 100644
--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -49,3 +49,65 @@ ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len)
         }
 }
 EXPORT_SYMBOL(ucs2_strncmp);
+
+unsigned long
+ucs2_utf8size(const ucs2_char_t *src)
+{
+	unsigned long i;
+	unsigned long j = 0;
+
+	for (i = 0; i < ucs2_strlen(src); i++) {
+		u16 c = src[i];
+
+		if (c > 0x800)
+			j += 3;
+		else if (c > 0x80)
+			j += 2;
+		else
+			j += 1;
+	}
+
+	return j;
+}
+EXPORT_SYMBOL(ucs2_utf8size);
+
+/*
+ * copy at most maxlength bytes of whole utf8 characters to dest from the
+ * ucs2 string src.
+ *
+ * The return value is the number of characters copied, not including the
+ * final NUL character.
+ */
+unsigned long
+ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
+{
+	unsigned int i;
+	unsigned long j = 0;
+	unsigned long limit = ucs2_strnlen(src, maxlength);
+
+	for (i = 0; maxlength && i < limit; i++) {
+		u16 c = src[i];
+
+		if (c > 0x800) {
+			if (maxlength < 3)
+				break;
+			maxlength -= 3;
+			dest[j++] = 0xe0 | (c & 0xf000) >> 12;
+			dest[j++] = 0x80 | (c & 0x0fc0) >> 8;
+			dest[j++] = 0x80 | (c & 0x003f);
+		} else if (c > 0x80) {
+			if (maxlength < 2)
+				break;
+			maxlength -= 2;
+			dest[j++] = 0xc0 | (c & 0xfe0) >> 5;
+			dest[j++] = 0x80 | (c & 0x01f);
+		} else {
+			maxlength -= 1;
+			dest[j++] = c & 0x7f;
+		}
+	}
+	if (maxlength)
+		dest[j] = '\0';
+	return j;
+}
+EXPORT_SYMBOL(ucs2_as_utf8);
-- 
2.5.0
