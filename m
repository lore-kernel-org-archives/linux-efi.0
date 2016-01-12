From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1 2/2] x86/efi: print size and base in binary units in efi_print_memmap
Date: Tue, 12 Jan 2016 15:13:06 +0200
Message-ID: <1452604386-13673-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452604386-13673-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>

Print the base address for each range in decimal alongside the size.
Use a "(size @ base)" format similar to the fake_memmap kernel parameter.

Print the range and base in the best-fit B, KiB, MiB, etc. units rather than
always MiB. This avoids rounding, which can be misleading.

Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
decimal units (KB, MB, etc.).

old:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB @ 34 GiB)

Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e0846b5..e762969 100644
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
@@ -222,6 +224,19 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
+static char * __init efi_size_format(char *buf, size_t size, u64 bytes)
+{
+	unsigned long i;
+
+	if (bytes)
+		i = __ffs64(bytes) / 10;
+	else
+		i = 0;
+
+	snprintf(buf, size, "%llu%s", bytes >> (i * 10), string_units_2[i]);
+	return buf;
+}
+
 void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
@@ -232,14 +247,16 @@ void __init efi_print_memmap(void)
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
-		char buf[64];
+		char buf[64], buf2[32], buf3[32];
 
 		md = p;
-		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s @ %s)\n",
 			i, efi_md_typeattr_format(buf, sizeof(buf), md),
 			md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			efi_size_format(buf3, sizeof(buf3),
+				md->num_pages << EFI_PAGE_SHIFT),
+			efi_size_format(buf2, sizeof(buf2), md->phys_addr));
 	}
 #endif  /*  EFI_DEBUG  */
 }
-- 
2.6.4
