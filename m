From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/4] lib/string_helpers: fix indentation in few places
Date: Sat, 23 Jan 2016 16:55:11 +0200
Message-ID: <1453560913-134672-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

Fix the indentation of label and put snprintf() to one line.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/string_helpers.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 86124c9..2ebd724 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -94,14 +94,13 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		tmp[j+1] = '\0';
 	}
 
- out:
+out:
 	if (i >= ARRAY_SIZE(string_units_2))
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
