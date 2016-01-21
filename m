From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 2/4] lib/string_helpers: fix indentation in few places
Date: Thu, 21 Jan 2016 17:22:30 +0200
Message-ID: <1453389752-68175-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453389752-68175-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fix the indentation of label and put snprintf() to one line.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 lib/string_helpers.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 7ee4644..51fcea2 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -94,14 +94,13 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		tmp[j+1] = '\0';
 	}
 
- out:
+out:
 	if (i >= STRING_UNITS_2_NUM)
 		unit = "UNK";
 	else
 		unit = units_str[units][i];
 
-	snprintf(buf, len, "%u%s %s", (u32)size,
-		 tmp, unit);
+	snprintf(buf, len, "%u%s %s", (u32)size, tmp, unit);
 }
 EXPORT_SYMBOL(string_get_size);
 
-- 
2.7.0.rc3
