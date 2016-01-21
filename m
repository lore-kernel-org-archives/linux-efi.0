From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/4] x86/efi: print size and base in binary units in efi_print_memmap
Date: Thu, 21 Jan 2016 17:22:31 +0200
Message-ID: <1453389752-68175-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

From: Robert Elliott <elliott@hpe.com>

Print the base in the best-fit B, KiB, MiB, etc. units rather than
always MiB. This avoids rounding, which can be misleading.

Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
decimal units (KB, MB, etc.).

old:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e0846b5..3badc8a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -35,10 +35,12 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 #include <linux/time.h>
 #include <linux/io.h>
@@ -117,6 +119,14 @@ void efi_get_time(struct timespec *now)
 	now->tv_nsec = 0;
 }
 
+static char * __init efi_size_format(char *buf, size_t size, u64 bytes)
+{
+	unsigned long i = bytes ? __ffs64(bytes) / 10 : 0;
+
+	snprintf(buf, size, "%llu %s", bytes >> (i * 10), string_units_2[i]);
+	return buf;
+}
+
 void __init efi_find_mirror(void)
 {
 	void *p;
@@ -225,21 +235,20 @@ int __init efi_memblock_x86_reserve_range(void)
 void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
-	efi_memory_desc_t *md;
 	void *p;
 	int i;
 
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
-		char buf[64];
+		efi_memory_desc_t *md = p;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		char buf[64], buf3[32];
 
-		md = p;
-		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s)\n",
 			i, efi_md_typeattr_format(buf, sizeof(buf), md),
-			md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			md->phys_addr, md->phys_addr + size - 1,
+			efi_size_format(buf3, sizeof(buf3), size));
 	}
 #endif  /*  EFI_DEBUG  */
 }
-- 
2.7.0.rc3
