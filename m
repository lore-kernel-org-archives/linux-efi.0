From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 5/6] uuid: Kill uapi/uuid.h
Date: Wed, 19 Jul 2017 21:28:56 +0300
Message-ID: <20170719182857.73693-6-andriy.shevchenko@linux.intel.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

There is no more users for uapi/uuid.h. Remove it for good.

Anyone needs it in user space better to use libuuid.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h      | 20 +++++++++++++++++++-
 include/uapi/linux/uuid.h | 42 ------------------------------------------
 scripts/mod/file2alias.c  |  4 ++--
 3 files changed, 21 insertions(+), 45 deletions(-)
 delete mode 100644 include/uapi/linux/uuid.h

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 2251e1925ea4..3bc3e88c9fbd 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -16,7 +16,19 @@
 #ifndef _LINUX_UUID_H_
 #define _LINUX_UUID_H_
 
-#include <uapi/linux/uuid.h>
+#include <linux/types.h>
+#include <linux/string.h>
+
+typedef struct {
+	__u8 b[16];
+} guid_t;
+
+#define GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+((guid_t)								\
+{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
+   (b) & 0xff, ((b) >> 8) & 0xff,					\
+   (c) & 0xff, ((c) >> 8) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
 #define UUID_SIZE 16
 
@@ -84,12 +96,18 @@ int guid_parse(const char *uuid, guid_t *u);
 int uuid_parse(const char *uuid, uuid_t *u);
 
 /* backwards compatibility, don't use in new code */
+typedef guid_t uuid_le;
 typedef uuid_t uuid_be;
 #define UUID_BE(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7) \
 	UUID_INIT(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7)
+#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+	GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
 #define NULL_UUID_BE 							\
 	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
 	     0x00, 0x00, 0x00, 0x00)
+#define NULL_UUID_LE							\
+	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	     0x00, 0x00, 0x00, 0x00)
 
 #define uuid_le_gen(u)		guid_gen(u)
 #define uuid_be_gen(u)		uuid_gen(u)
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
deleted file mode 100644
index 8ef82f433877..000000000000
--- a/include/uapi/linux/uuid.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * UUID/GUID definition
- *
- * Copyright (C) 2010, Intel Corp.
- *	Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation;
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef _UAPI_LINUX_UUID_H_
-#define _UAPI_LINUX_UUID_H_
-
-#include <linux/types.h>
-#include <linux/string.h>
-
-typedef struct {
-	__u8 b[16];
-} guid_t;
-
-#define GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
-((guid_t)								\
-{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
-   (b) & 0xff, ((b) >> 8) & 0xff,					\
-   (c) & 0xff, ((c) >> 8) & 0xff,					\
-   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
-
-/* backwards compatibility, don't use in new code */
-typedef guid_t uuid_le;
-#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-	GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
-#define NULL_UUID_LE							\
-	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-	     0x00, 0x00, 0x00, 0x00)
-
-#endif /* _UAPI_LINUX_UUID_H_ */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 29d6699d5a06..1c68709123aa 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -36,7 +36,7 @@ typedef uint16_t	__u16;
 typedef unsigned char	__u8;
 typedef struct {
 	__u8 b[16];
-} uuid_le;
+} guid_t;
 
 /* Big exception to the "don't include kernel headers into userspace, which
  * even potentially has different endianness and word sizes, since
@@ -134,7 +134,7 @@ static inline void add_wildcard(char *str)
 		strcat(str + len, "*");
 }
 
-static inline void add_uuid(char *str, uuid_le uuid)
+static inline void add_uuid(char *str, guid_t uuid)
 {
 	int len = strlen(str);
 
-- 
2.11.0
