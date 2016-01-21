From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/4] lib/string_helpers: export string_units_{2,10} for others
Date: Thu, 21 Jan 2016 17:22:29 +0200
Message-ID: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

There is one user coming which would like to use those string arrays. It might
be useful for any other user in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/string_helpers.h |  6 ++++++
 lib/string_helpers.c           | 21 ++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index dabe643..a55c9cc 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -10,6 +10,12 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
+#define STRING_UNITS_10_NUM	9
+#define STRING_UNITS_2_NUM	9
+
+extern const char *const string_units_10[STRING_UNITS_10_NUM];
+extern const char *const string_units_2[STRING_UNITS_2_NUM];
+
 void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 5939f63..7ee4644 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -13,6 +13,15 @@
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 
+const char * const string_units_10[STRING_UNITS_10_NUM] = {
+	"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB",
+};
+EXPORT_SYMBOL(string_units_10);
+const char * const string_units_2[STRING_UNITS_2_NUM] = {
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
+	if (i >= STRING_UNITS_2_NUM)
 		unit = "UNK";
 	else
 		unit = units_str[units][i];
-- 
2.7.0.rc3
