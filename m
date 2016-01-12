From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1 1/2] lib/string_helpers: export string_units_{2,10} for others
Date: Tue, 12 Jan 2016 15:13:05 +0200
Message-ID: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There is one user coming which would like to use those string arrays. It might
be useful for any other user in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/string_helpers.h |  3 +++
 lib/string_helpers.c           | 21 ++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index dabe643..1d16240 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -10,6 +10,9 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
+extern const char *const string_units_10[];
+extern const char *const string_units_2[];
+
 void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 5939f63..3a4c812 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -13,6 +13,15 @@
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 
+const char * const string_units_10[] = {
+	"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB",
+};
+EXPORT_SYMBOL(string_units_10);
+const char * const string_units_2[] = {
+	"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
+};
+EXPORT_SYMBOL(string_units_2);
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted in blocks
@@ -29,15 +38,9 @@
 void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		     char *buf, int len)
 {
-	static const char *const units_10[] = {
-		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
-	};
-	static const char *const units_2[] = {
-		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"
-	};
 	static const char *const *const units_str[] = {
-		[STRING_UNITS_10] = units_10,
-		[STRING_UNITS_2] = units_2,
+		[STRING_UNITS_10] = string_units_10,
+		[STRING_UNITS_2] = string_units_2,
 	};
 	static const unsigned int divisor[] = {
 		[STRING_UNITS_10] = 1000,
@@ -92,7 +95,7 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 	}
 
  out:
-	if (i >= ARRAY_SIZE(units_2))
+	if (i >= ARRAY_SIZE(string_units_2))
 		unit = "UNK";
 	else
 		unit = units_str[units][i];
-- 
2.6.4
